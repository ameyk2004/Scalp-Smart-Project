import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scalp_smart/colors.dart';
import 'package:scalp_smart/widgets/widget_support.dart';

import 'imageThreadObject.dart';

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
