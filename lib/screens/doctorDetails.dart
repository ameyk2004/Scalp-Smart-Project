import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scalp_smart/colors.dart';
import 'package:scalp_smart/screens/chat_page.dart';
import 'package:scalp_smart/screens/shop_page.dart';
import 'package:scalp_smart/widgets/widget_support.dart';

import '../services/firebase_service/database.dart';


class DoctorDetailsPage extends StatefulWidget {
  const DoctorDetailsPage({super.key});

  @override
  State<DoctorDetailsPage> createState() => _DoctorDetailsPageState();
}

class _DoctorDetailsPageState extends State<DoctorDetailsPage> {


  Stream<QuerySnapshot>? doctorStream;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;


  getOnLooad() async{
    doctorStream = await DatabaseMethods().getDoctorDetails();
    setState(() {

    });
  }

  @override
  void initState() {
    getOnLooad();
    super.initState();
  }

  Widget allDoctorDetails()
  {
    var patient_list = [];
    return StreamBuilder(stream: doctorStream, builder: (context, AsyncSnapshot snapshot){
      return snapshot.hasData ? ListView.separated(itemBuilder: (context, index){
        DocumentSnapshot documentSnapshot = snapshot.data.docs[index];

        return InkWell(
          onTap: () async{
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ChatPage(receiver: documentSnapshot["name"], recieverId: documentSnapshot.id,)));
            final  docSnapshot = await  _firestore.collection("Users").doc(documentSnapshot.id).get();
            if (docSnapshot.exists) {
              List<dynamic> historyFromFirestore = docSnapshot.data()?['assigned_patients'] ?? [];

              patient_list = historyFromFirestore;
              patient_list.add(_auth.currentUser!.uid);

              await  _firestore.collection("Users").doc(documentSnapshot.id).update(
                  {'assigned_patients' : patient_list});
            }

          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20)),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image(
                    image: NetworkImage(documentSnapshot["image"])),
              ),
              title: Text(
                documentSnapshot["name"],
                style: AppWidget.boldTextStyle(),
              ),
              subtitle: Column(
                crossAxisAlignment:  CrossAxisAlignment.start,
                children: [
                  Text("Experience : ${documentSnapshot["experience"]}"),
                  Text("Location : ${documentSnapshot["location"]}"),

                  Visibility(
                    visible: documentSnapshot["online"],
                    child: Row(
                      children: [
                        Text("Online", style: TextStyle(color : Colors.green),)
                      ],
                    ),
                  )
                ],
              ),


            ),
          ),
        );


      }, itemCount: snapshot.data.docs.length, separatorBuilder: (BuildContext context, int index) {
        return SizedBox(height: 10,);
      }, ): Container();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(
            "Connect to Doctors",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: MediaQuery
              .sizeOf(context)
              .width * 0.055),
        ),
        centerTitle: false,
        actions: [
          IconButton(
              onPressed: () {

              },
              icon: const Icon(
                Icons.logout,
                color: appBarColor,
                size: 35,
              )),
        ],
      ),

      body: allDoctorDetails(),
    );
  }
}
