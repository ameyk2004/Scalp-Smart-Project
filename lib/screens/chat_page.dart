import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scalp_smart/colors.dart';
import 'package:scalp_smart/screens/doctor_screens/image_thread_screen.dart';
import 'package:scalp_smart/screens/doctor_screens/image_thread_sql.dart';
import 'package:scalp_smart/services/firebase_service/database.dart';
import 'package:scalp_smart/widgets/chat_bubble.dart';
import 'package:intl/intl.dart';
import 'package:scalp_smart/widgets/widget_support.dart';

import '../services/chat_service/chat_service.dart';
import '../widgets/customTextField.dart';

class ChatPage extends StatefulWidget {
  final String receiver;
  final String recieverId;
  const ChatPage({super.key, required this.receiver, required this.recieverId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  ChatService chatService = ChatService();
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController messageController = TextEditingController();
  String userRole = "";

  void sendMessage() async
  {
    if(messageController.text.isNotEmpty)
    {
      await chatService.sendMessage(widget.recieverId, messageController.text);
      messageController.clear();
    }

  }

  void getUserRole() async
  {
    userRole = (await DatabaseMethods().getUserRole())!;
    setState(() {

    });
  }

  @override
  void initState() {
    getUserRole();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          backgroundColor: buttonColor,
          scrolledUnderElevation: 0.0,
          toolbarHeight: MediaQuery.of(context).size.height*0.17,
          title: Column(
            children: [
              Align(
                child: CircleAvatar(
                  backgroundImage: userRole == "Doctor" ? NetworkImage("https://i.pinimg.com/736x/8b/16/7a/8b167af653c2399dd93b952a48740620.jpg") : NetworkImage("https://santevitahospital.com/img/vector_design_male_11zon.webp"),
                  radius: MediaQuery.of(context).size.height*0.055 ,
                ),
              ),
              SizedBox(height: 10,),
              Text(widget.receiver, style: AppWidget.boldTextStyle().copyWith(fontSize: MediaQuery.of(context).size.height*0.028, color: Colors.white))
            ],
          ),
          leading: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back_ios_new, size: 30),
              )
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () {
                    print(userRole);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ImageThreadSQL(uid: userRole == "Doctor" ? widget.recieverId : auth.currentUser!.uid)),
                    );
                  },
                  icon: const Icon(Icons.image_search, size: 35, color: Colors.white60,),
                ),
              ),
            ),
          ],
        ),

        body: Column(
          children: [
            Expanded(
              child: _buildMessageList(),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 20,bottom: 30),
                    child: CustomTextField(
                      hintText: "Message",
                      icon: const Icon(Icons.message_outlined),
                      obscureText: false,
                      textEditingController: messageController,
                    ),
                  ),
                ),

                Container(
                    margin: const EdgeInsets.only(bottom: 30, left: 20, right: 20),
                    child: IconButton(icon:const Icon(Icons.send, size: 30,), onPressed: sendMessage,
                    ))],
            ),
          ],
        ),


    );
  }

  Widget _buildMessageList() {
    String senderId = auth.currentUser!.uid;
    ScrollController _scrollController = ScrollController();


    return StreamBuilder<QuerySnapshot>(
      stream: chatService.getMessages(widget.recieverId, senderId),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          List<DocumentSnapshot> documents = snapshot.data!.docs;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
          });


          return ListView(
            controller: _scrollController,
            children: documents.map((doc) => _buildMessageListItem(doc)).toList(),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildMessageListItem(DocumentSnapshot doc)
  {
    Map<String, dynamic>data = doc.data() as Map<String, dynamic>;

    bool isCurrentUser = data['senderId']== auth.currentUser!.uid;
    DateTime time = data['timestamp'].toDate();
    String amPm = DateFormat('a').format(time);
    String timeStamp = "${time.hour}:${time.minute} $amPm";

    final alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    return Container(
        alignment: alignment,
        child: ChatBubble(message: data["message"], isCurrentUser: isCurrentUser, timestamp: timeStamp,));

  }

}

