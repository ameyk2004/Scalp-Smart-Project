import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:scalp_smart/auth/authServices.dart';
import 'package:scalp_smart/widgets/widget_support.dart';
import '../colors.dart';
import '../firebase_service/database.dart';
import '../widgets/menuDrawer.dart';
import '../screens/chat_page.dart';

class DoctorHomePage extends StatefulWidget {
  const DoctorHomePage({super.key});

  @override
  State<DoctorHomePage> createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends State<DoctorHomePage> {

  final AuthService _auth = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String profile_pic = "https://media.istockphoto.com/id/177373093/photo/indian-male-doctor.jpg?s=612x612&w=0&k=20&c=5FkfKdCYERkAg65cQtdqeO_D0JMv6vrEdPw3mX1Lkfg=";

  final AuthService authService = AuthService();

  int selectedPage = 0;

  navigateTo(int index) {
    setState(() {
      selectedPage = index;
    });
  }

  final List<Widget> pages = [
    DoctorPageBody(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                  image: DecorationImage(image: NetworkImage(profile_pic), fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            );
          },

        ),

        title: Text(
          "Scalp Smart",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: MediaQuery
              .sizeOf(context)
              .width * 0.055),
        ),
        centerTitle: false,
        actions: [
        ],
      ),

      drawer: CustomMenuDrawer(profile_pic: profile_pic, userName: authService.getCurrentUser()!.email!,),

      body: pages[selectedPage],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedPage,
        backgroundColor: Colors.grey.shade300,
        onTap: navigateTo,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(Icons.home, size: 30,),
          ),
          BottomNavigationBarItem(
            label: "Message",
            icon:  Icon(Icons.message_outlined,size: 30,)
          ),
        ],
      ),
    );
  }
}

class DoctorPageBody extends StatefulWidget {
  const DoctorPageBody({
    super.key,
  });

  @override
  State<DoctorPageBody> createState() => _DoctorPageBodyState();
}


class _DoctorPageBodyState extends State<DoctorPageBody> {


  Stream<QuerySnapshot>? userStream;
  List assigned_patients = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _refresh() async {
    await getAssignedPatients();
    return await Future.delayed(Duration(seconds: 2));
  }

  getOnLooad() async{
    userStream = await DatabaseMethods().getUserDetails();
    setState(() {
    });
  }



  getAssignedPatients() async
  {
    final docSnapshot = await _firestore.collection("Users").doc(_auth.currentUser!.uid).get();
    if (docSnapshot.exists) {
      assigned_patients = docSnapshot.data()?["assigned_patients"] ?? [];

    }

    setState(() {
    });
  }

  Widget allUserDetails()
  {
    return StreamBuilder(stream: userStream , builder: (context, AsyncSnapshot snapshot)
    {
      Image? annotatedImage;

      if (snapshot.hasData) {
        List<DocumentSnapshot> documents = snapshot.data.docs;

        return Padding(
          padding: const EdgeInsets.only(top:20),
          child: LiquidPullToRefresh(
            onRefresh: _refresh,
            height: 250,
            animSpeedFactor: 1.5,
            color: appBarColor,
            child: ListView.separated(
            itemCount: documents.length,
              itemBuilder: (context, index){

                DocumentSnapshot documentSnapshot = snapshot.data.docs[index];


                if(documentSnapshot["image"] !="")
                  {
                    annotatedImage = Image.network(documentSnapshot["image"]);
                  }
                else
                  {
                    annotatedImage = null;
                  }

                if(assigned_patients.contains(documentSnapshot["uid"])) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (
                          context) =>
                          ChatPage(receiver: documentSnapshot["name"],
                              recieverId: documentSnapshot.id)));
                    },
                    child: Container(
                      height: 130,
                      color: Colors.grey.shade200,
                      child: Stack(
                        children: [
                          Row(
                            children: [
                              Visibility(
                                visible: annotatedImage == null,
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      height: 130,
                                      width: 130,
                                      decoration: BoxDecoration(
                                        image: const DecorationImage(
                                          image: NetworkImage(
                                            "https://static.vecteezy.com/system/resources/previews/014/489/917/non_2x/man-avatar-icon-flat-vector.jpg",),
                                          // Assuming _image is a File
                                          fit: BoxFit.cover,
                                          // Cover the container while maintaining aspect ratio
                                          alignment: Alignment
                                              .topCenter, // Align the top of the image within the container
                                        ),
                                        border: Border.all(width: 1),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    )
                                ),
                              ),


                              Visibility(
                                visible: annotatedImage != null,
                                child: Align(
                                    alignment: Alignment.center,
                                    child: annotatedImage != null
                                        ? Container(
                                      height: 130,
                                      width: 130,
                                      decoration: BoxDecoration(

                                        border: Border.all(width: 1),
                                        borderRadius: BorderRadius.circular(30),
                                      ),

                                      child: ClipRRect( // Use ClipRRect to apply rounded corners to the child
                                        borderRadius: BorderRadius.circular(30),
                                        child: FittedBox(
                                          fit: BoxFit.cover,
                                          alignment: Alignment.topCenter,
                                          child: annotatedImage,
                                        ),
                                      ),
                                    )
                                        : const SizedBox.shrink()
                                ),
                              ),

                              SizedBox(width: 20,),

                              Expanded(
                                child: Container(

                                  padding: EdgeInsets.all(8),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        Text(documentSnapshot["name"],
                                          style: AppWidget.boldTextStyle(),),
                                        Text(documentSnapshot["email"],
                                          style: TextStyle(fontSize: 17),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,),
                                        Text("Age : 20",
                                            style: TextStyle(fontSize: 17)),
                                        Text("Stage -  normal",
                                            style: TextStyle(fontSize: 17)),
                                      ],

                                    ),
                                  ),
                                ),
                              ),


                            ],
                          ),

                          Visibility(
                            visible: documentSnapshot["online"],
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                alignment: Alignment.topRight,

                                margin: EdgeInsets.only(right: 10, top: 18),

                                height: 15,
                                width: 15,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ),
                        ],

                      ),
                    ),
                  );
                }
                else
                  {
                    return SizedBox.shrink();
                  }

                  }, separatorBuilder: (BuildContext context, int index) {
              return SizedBox(height: 10,);
            },),
          ),
        );
      } else {
        return Container();
      }
    });
  }



@override
  void initState() {
    getOnLooad();
    getAssignedPatients();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
        child: allUserDetails());
  }



}

