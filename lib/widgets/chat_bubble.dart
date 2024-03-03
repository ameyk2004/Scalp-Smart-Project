
import 'package:flutter/material.dart';
import 'package:scalp_smart/colors.dart';

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
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
          color: isCurrentUser ?  appBarColor : Colors.grey.shade300,
          borderRadius:  isCurrentUser ? const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10)
          ) : const BorderRadius.only(
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