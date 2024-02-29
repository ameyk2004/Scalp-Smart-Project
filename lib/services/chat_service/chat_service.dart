import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scalp_smart/auth/authServices.dart';

import 'message.dart';

class ChatService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // sendMessage

  Future<String> sendMessage(String recieverId, String message) async {
    final String senderId = _auth.currentUser!.uid!;
    final String senderEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
        senderId: senderId,
        senderEmail: senderEmail,
        recieverId: recieverId,
        timestamp: timestamp,
        message: message);

    List<String> userIds = [senderId, recieverId];
    userIds.sort();
    String chatRoomId = userIds.join("_");

    DocumentReference messageRef = await _firestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .add(newMessage.toMap());

    return messageRef.id;
  }


  //getMessage
  Stream<QuerySnapshot> getMessages(String userId,String otherId)
  {
    List<String> ids = [userId, otherId];
    ids.sort();
    String chatroomId = ids.join('_');
    return _firestore.collection("chat_rooms").doc(chatroomId).collection("messages").orderBy("timestamp", descending: false).snapshots();
  }

  Future<void> updateMessage(String recieverId, String messageId, String updatedMessage) async {

    final String senderId = _auth.currentUser!.uid;
    List<String> ids = [senderId, recieverId];
    ids.sort();
    String chatroomId = ids.join('_');

    await _firestore
        .collection("chat_rooms")
        .doc(chatroomId)
        .collection("messages")
        .doc(messageId)
        .update({
      'message': updatedMessage,
      'timestamp': Timestamp.now(), // Update timestamp to indicate the latest modification time
    });
  }

}
