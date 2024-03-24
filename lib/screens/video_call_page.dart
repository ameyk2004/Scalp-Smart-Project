import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallPage extends StatelessWidget {
  CallPage({Key? key, required this.callID}) : super(key: key);
  final String callID;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {

    return ZegoUIKitPrebuiltCall(
      appID: 696623010, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
      appSign: "43c238e1721a0ccb87542858ef4f6b2aadc4ee98d356a6f334b1a767990562db", // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
      userID: _auth.currentUser!.uid,
      userName: _auth.currentUser!.email!,
      callID: callID,
      // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
    );
  }
}
