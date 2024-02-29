import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scalp_smart/colors.dart';
import 'package:scalp_smart/widgets/widget_support.dart';

class ImageThreadScreen extends StatefulWidget {
  final String patientId;
  const ImageThreadScreen({super.key, required this.patientId});

  @override
  State<ImageThreadScreen> createState() => _ImageThreadScreenState();
}



class _ImageThreadScreenState extends State<ImageThreadScreen> {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List imageThread = [];

  getImageList() async
  {
    final snapshot = await firestore.collection("Users").doc(widget.patientId).get();
    if(snapshot.exists)
      {
        final ImageHistoryFirebase = await snapshot.data()?["image_history"] ?? [];
        imageThread = ImageHistoryFirebase;
        print("Uploaded images : ${imageThread.length}");
      }

    setState(() {
    });
  }

  @override
  void initState() {
    getImageList();
    super.initState();
  }


  Widget buildImageThread()
  {
    return ListView.separated(
      itemCount: imageThread.length,
        itemBuilder: (context, index){

      return ImageThreadObject(imageUrl: imageThread[index]['image'], stage:  imageThread[index]['stage'], date: imageThread[index]['date'] ,);

    }, separatorBuilder: (BuildContext context, int index) {
        return SizedBox(height: 40);
    },);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : Text("Image Thread", style: AppWidget.headlineTextStyle(),)
      ),

      body: buildImageThread()

    );
  }
}

class ImageThreadObject extends StatelessWidget {
  final String imageUrl;
  final String stage;
  final String date;
  const ImageThreadObject({
    super.key, required this.imageUrl, required this.stage, required this.date,
  });

  @override
  Widget build(BuildContext context) {
    
    final threadImage = Image.network(imageUrl);
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 35),
      padding: EdgeInsets.symmetric(vertical: 20),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: buttonColor,
        border: Border.all(width: 1),
        borderRadius: BorderRadius.circular(30),
      ),

      child: Column(
        children: [
          Center(
            child: Container(
      height: 320,
        width: 320,
        decoration: BoxDecoration(

          border: Border.all(width: 1),
          borderRadius: BorderRadius.circular(30),

        ),

        child: ClipRRect( // Use ClipRRect to apply rounded corners to the child
          borderRadius: BorderRadius.circular(30),
          child: FittedBox(
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            child: threadImage,
          ),
        ),
      ),
            ),
          SizedBox(height: 10,),
          Text("Stage - $stage", style: AppWidget.boldTextStyle().copyWith(color: Colors.white),),
          SizedBox(height: 5,),
          Text("Date - $date", style: AppWidget.boldTextStyle().copyWith(color: Colors.white),),
        ],
      ),
    );
  }
}
