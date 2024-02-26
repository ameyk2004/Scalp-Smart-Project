import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scalp_smart/chat_service/chat_service.dart';
import 'package:scalp_smart/colors.dart';
import 'package:scalp_smart/widgets/chat_bubble.dart';
import 'package:intl/intl.dart';
import 'package:scalp_smart/widgets/widget_support.dart';

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

  void sendMessage() async
  {
    if(messageController.text.isNotEmpty)
    {
      await chatService.sendMessage(widget.recieverId, messageController.text);
      messageController.clear();
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(widget.receiver, style: AppWidget.headlineTextStyle(),),
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
                  margin: EdgeInsets.only(left: 20,bottom: 30),
                  child: CustomTextField(
                    hintText: "Message",
                    icon: Icon(Icons.message_outlined),
                    obscureText: false,
                    textEditingController: messageController,
                  ),
                ),
              ),
              
              Container(
                margin: EdgeInsets.only(bottom: 30, left: 20, right: 20),
                  child: IconButton(icon:Icon(Icons.send, size: 30,), onPressed: sendMessage,
    ))],
          ),
        ],
      )

    );
  }

  Widget _buildMessageList() {
    String senderId = auth.currentUser!.uid;
    return StreamBuilder<QuerySnapshot>(
      stream: chatService.getMessages(widget.recieverId, senderId),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          List<DocumentSnapshot> documents = snapshot.data!.docs;
          return ListView(
            children: documents.map((doc) => _buildMessageListItem(doc)).toList(),
          );
        } else {
          return Center(
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

