import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotifications{
  static final firebaseMessaging = FirebaseMessaging.instance;

  //request messaging
  static Future initialize() async
  {

    await firebaseMessaging.requestPermission(
         alert : true,
         announcement : true,
         badge : true,
         carPlay : false,
         criticalAlert : false,
         provisional : false,
         sound : true
    );

      final deviceToken = await firebaseMessaging.getToken();
      await FirebaseMessaging.instance.getAPNSToken();
      print("Device Token : $deviceToken");




  }



}