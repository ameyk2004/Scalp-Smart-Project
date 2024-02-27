import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scalp_smart/auth/authServices.dart';
import 'package:scalp_smart/auth/authWrapper.dart';
import 'package:scalp_smart/colors.dart';
import 'package:scalp_smart/firebase_service/database.dart';
import 'package:scalp_smart/widgets/loadingScreen.dart';
import 'package:scalp_smart/widgets/widget_support.dart';

import '../widgets/menuDrawer.dart';
import 'doctor_approve_card.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  String profile_pic =
      "https://static.vecteezy.com/system/resources/previews/020/429/953/original/admin-icon-vector.jpg";
  Stream? pendingdoctorStream;

  AuthService authService = AuthService();

  Future<void> getPendingDoctors() async {
    pendingdoctorStream = await DatabaseMethods().getPendingRequests();
    setState(() {});
  }

  @override
  void initState() {
    getPendingDoctors();
    super.initState();
  }

  Widget buildPendingDoctors() {
    return StreamBuilder(
      stream: pendingdoctorStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<DocumentSnapshot> documents = snapshot.data!.docs;

          return Padding(
            padding: EdgeInsets.only(top: 10, left: 15, right: 15),
            child: ListView.separated(
              itemCount: documents.length,
              itemBuilder: (BuildContext context, int index) {
                DocumentSnapshot documentSnapshot = documents[index];
                return DoctorCard(
                  id : documentSnapshot.id,
                  name: documentSnapshot["name"],
                  qualification: documentSnapshot["qualification"],
                  location: documentSnapshot["location"],
                  experience: documentSnapshot["experience"],
                  email: documentSnapshot["email"],
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(height: 30);
              },
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leadingWidth: 90,
          leading: Builder(
            builder: (BuildContext context) {
              return InkWell(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: Container(
                  width: 5,
                  margin: EdgeInsets.only(left: 30),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(profile_pic), fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              );
            },
          ),
          title: Text(
            "Scalp Smart Admin",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.sizeOf(context).width * 0.055),
          ),
          centerTitle: false,
          actions: [],
        ),
        drawer: CustomMenuDrawer(
          profile_pic: profile_pic,
          userName: "Scalp Smart Admin",
        ),
        body: buildPendingDoctors());
  }
}
