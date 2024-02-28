import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../admin_screens/admin_home_page.dart';
import '../doctor_screens/doc_home_screen.dart';
import '../firebase_service/database.dart';
import '../screens/home_page.dart';
import '../screens/onboard.dart';

class AuthWrapper extends StatefulWidget {
  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData)
        {

          return FutureBuilder(
            future: DatabaseMethods().UserRole(snapshot.data) ,
            builder: (context, AsyncSnapshot roleSnapshot) {

              if (roleSnapshot.connectionState == ConnectionState.waiting)
              {
                return Scaffold(
                  backgroundColor: Colors.white,
                  body: Center(child: CircularProgressIndicator()),
                );

              }

              else if (roleSnapshot.hasError)
              {
                return Text('Error: ${roleSnapshot.error}');
              }

              else {

                if (roleSnapshot.data == "Patient") {
                  return HomePage(); // User is a patient
                } else if(roleSnapshot.data == "Doctor"){
                  return DoctorHomePage();
                }
                else
                  {
                    return AdminPage();
                  }
              }
            },
          );

        }

        else {
          return Onboard();
        }
      },
    );
  }
}
