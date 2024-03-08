import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scalp_smart/colors.dart';
import 'package:scalp_smart/screens/chat_page.dart';
import 'package:scalp_smart/screens/patient_screens/shop_page.dart';
import 'package:scalp_smart/widgets/widget_support.dart';

import '../../services/firebase_service/database.dart';
import 'google_map_screen.dart';

class DoctorDetailsPage extends StatefulWidget {
  const DoctorDetailsPage({super.key});

  @override
  State<DoctorDetailsPage> createState() => _DoctorDetailsPageState();
}

class _DoctorDetailsPageState extends State<DoctorDetailsPage> {

  TextEditingController dateController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController nameController = TextEditingController();


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

  Widget buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(
              width: 1.5,
              color: appBarColor,
            ),
          ),
          hintText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(
              width: 1,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
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

              if (!historyFromFirestore.contains(_auth.currentUser!.uid)) {
                patient_list = historyFromFirestore;
                patient_list.add(_auth.currentUser!.uid);

                await _firestore.collection("Users")
                    .doc(documentSnapshot.id)
                    .update(
                    {'assigned_patients': patient_list});
              }
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

              trailing: IconButton(icon : Icon(Icons.report_outlined, size: 30,), onPressed: () {



                showDialog(context: context, builder: (context)=>AlertDialog(
                  title: Text("Report Doctor", style: AppWidget.boldTextStyle(),),
                  backgroundColor: dialogboxColor,
                  contentPadding: EdgeInsets.all(16.0),
                  content: SingleChildScrollView(
                    child: Column(
                      children: [
                        buildTextField("Your Name", nameController),
                        buildTextField("Date of Incident", dateController),
                        buildTextField("Description of Issue", descriptionController, maxLines: 3),
                      ],
                    ),
                  ),
                  actions: [
                    InkWell(
                      onTap: () async
                      {
                        await _firestore.collection("Reported Doctors").doc(documentSnapshot["uid"]).set({
                          "name" : documentSnapshot["name"],
                          "image" :  documentSnapshot["image"],
                          "uid" :  documentSnapshot["uid"],
                        });

                        await _firestore.collection("Reported Doctors").doc(documentSnapshot["uid"]).collection("Reports").doc().set({
                          "date" : dateController.text,
                          "report" : descriptionController.text,
                          "reported by" : _auth.currentUser!.email,
                          "name" : nameController.text,
                        });

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Report Submitted")));


                      },
                      child: Container(
                        height: 40,
                        width: 100,
                        padding: EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: appBarColor
                        ),
                        child: Center(child: Text("Submit", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),)),
                      ),
                    ),
                  ],
                ));

              },),


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
                Navigator.push(context, MaterialPageRoute(builder: (context)=>GoogleMapScreen()));
              },
              icon: const Icon(
                Icons.location_on_outlined,
                color: appBarColor,
                size: 35,
              )),
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
