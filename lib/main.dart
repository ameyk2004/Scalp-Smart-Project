
import 'package:camera/camera.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scalp_smart/auth/authServices.dart';
import 'package:showcaseview/showcaseview.dart';
import 'auth/authWrapper.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        StreamProvider(
            create: (context) =>
            context.watch()<AuthService>().authStateChanges,
            initialData: null)
      ],
      child: MaterialApp(
        title: 'Scalp Smart',
        theme: ThemeData(
            useMaterial3: true,
            appBarTheme: AppBarTheme(
                backgroundColor: Colors.white
            ),
            scaffoldBackgroundColor: Colors.white
        ),
        home:
        ShowCaseWidget( builder : Builder( builder : (_) => AuthWrapper(tutorial: false,))),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}