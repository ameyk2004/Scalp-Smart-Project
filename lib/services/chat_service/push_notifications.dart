import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotifications{
  static final firebaseMessaging = FirebaseMessaging.instance;

   Future requestpermission() async
  {

    NotificationSettings settings = await firebaseMessaging.requestPermission(
         alert : true,
         announcement : true,
         badge : true,
         carPlay : false,
         criticalAlert : false,
         provisional : false,
         sound : true
    );

    if(settings.authorizationStatus == AuthorizationStatus.authorized)
      {
        print("authorised");
      }


  }

  Future<String> getToken() async
  {
    final deviceToken = await firebaseMessaging.getToken();
    return deviceToken ?? "";
  }





}