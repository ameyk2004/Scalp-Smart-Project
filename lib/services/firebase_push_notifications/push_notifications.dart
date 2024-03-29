import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async
{
  print('Title : ${message.notification?.title}');
  print('Body : ${message.notification?.body}');
  print('Payload : ${message.data}');
}

class FirebasePushNotifications{
  final firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initMessaging() async {
    await firebaseMessaging.requestPermission();
    final FcmToken = await firebaseMessaging.getToken();
    print("Messaging Token : $FcmToken");
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}