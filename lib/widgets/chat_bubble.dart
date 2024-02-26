
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {

  final String message;
  final bool isCurrentUser;
  final String timestamp;
  const ChatBubble({super.key, required this.message, required this.isCurrentUser, required this.timestamp});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width/1.5, // Set your desired maximum width
      ),
      margin: EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      padding: EdgeInsets.all(9),
      decoration: BoxDecoration(
          color: isCurrentUser ?  Colors.green.shade500 : Colors.grey.shade300,
          borderRadius:  isCurrentUser ? BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10)
          ) : BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomRight : Radius.circular(10))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(message, style: TextStyle(fontSize: 16, color: isCurrentUser ? Colors.white : Colors.black), ),
          Text(timestamp, style: TextStyle(fontSize: 10, color: isCurrentUser ? Colors.white : Colors.black),),
        ],
      ),

    );
  }
}