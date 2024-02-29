import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scalp_smart/colors.dart';
import 'package:scalp_smart/widgets/chat_bubble.dart';
import 'package:scalp_smart/widgets/widget_support.dart';
import 'package:http/http.dart' as http;

import '../../widgets/customTextField.dart';
import '../../widgets/loadingScreen.dart';



class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  String chatbotResponse = "";
  bool _isLoading = false;



  Future<void> fetchChatHistory() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(_auth.currentUser!.uid)
        .get();

    if (snapshot.exists) {
      List<dynamic> historyFromFirestore =
          snapshot.data()?['chat_bot_history'] ?? [];

      chat_history.addAll(
        historyFromFirestore
            .map((item) {
          Map<String, String> map = {};
          (item as Map<String, dynamic>).forEach((key, value) {
            map[key] = value.toString();
          });
          return map;
        })
            .toList(),
      );

      setState(() {

      });
    } else {
      // If the document doesn't exist or chat_bot_history is not available, initialize chat_history as an empty list
      chat_history = [];

    }
  }


  @override
  void initState() {
    fetchChatHistory();
    super.initState();
  }


  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> chat_history = [];


  TextEditingController textEditingController = TextEditingController();

  Future<void> sendPromptToChatBot(String prompt) async {
    Uri url = Uri.parse("https://pblproject-ljlp.onrender.com/flutter/chatbot/prompt");
    final Timestamp timestamp = Timestamp.now();

    String jsonBody = jsonEncode({'prompt': prompt});
    print(prompt);
    _isLoading = true;
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      print(response.body);
      final ChatBotData = jsonDecode(response.body);
      print(ChatBotData["response"]);
      chatbotResponse = ChatBotData["response"];

      chat_history.add({
        "prompt": prompt,
        "response": chatbotResponse,
        "timestamp" : timestamp
      });

      String userid = _auth.currentUser!.uid;

      _firestore.collection("Users").doc(userid).update(
          {"chat_bot_history" : chat_history});

      print(chat_history);

      setState(() {_isLoading = false;
        textEditingController.clear();
      });
    } else {
      print(response.statusCode);

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Scalp Smart Chatbot",
            style: AppWidget.headlineTextStyle(),
          ),
        ),
        body: Column(
          children: [
            Visibility(
              visible: _isLoading,
              child: LinearProgressIndicator(
                color: appBarColor,
              ),
            ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  itemCount: chat_history.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: ChatBubble(
                            message: chat_history[index]["prompt"]!,
                            isCurrentUser: true,
                            timestamp: '',
                          ),
                        ),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: ChatBubble(
                              message: chat_history[index]["response"]!,
                              isCurrentUser: false,
                              timestamp: '',
                            )),
                      ],
                    );
                  },
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 20, bottom: 30),
                    child: CustomTextField(
                      hintText: "Message",
                      icon: Icon(Icons.message_outlined),
                      obscureText: false,
                      textEditingController: textEditingController,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      margin: EdgeInsets.only(bottom: 30, left: 20, right: 20),
                      child: IconButton(
                        icon: Icon(
                          Icons.send,
                          size: 30,
                        ),
                        onPressed: () {
                          sendPromptToChatBot(
                              textEditingController.text.toString());
                        },
                      )),
                )
              ],
            ),
          ],
        ));
  }
}
