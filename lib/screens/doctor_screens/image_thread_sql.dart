import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scalp_smart/colors.dart';
import 'package:scalp_smart/screens/doctor_screens/image_thread_screen.dart';
import 'package:scalp_smart/widgets/widget_support.dart';
import 'package:http/http.dart' as http;

import 'imageThreadObject.dart';


class ImageThreadSQL extends StatefulWidget {
  final String uid;
  const ImageThreadSQL({super.key, required this.uid});

  @override
  State<ImageThreadSQL> createState() => _ImageThreadSQLState();
}



class _ImageThreadSQLState extends State<ImageThreadSQL> {

   List image_history = [];
   dynamic annotatedImage;
   late Future<dynamic> imageThreadFuture;

  getImageThread(user_id) async
  {
    final response = await http.get(Uri.parse("https://pblproject-ljlp.onrender.com/api/images/$user_id"));
    if(response.statusCode == 200)
    {
      final data =  jsonDecode(response.body);
      image_history = data["images"];
      setState(() {

      });
    }
    else{
      print(response.statusCode);
    }

  }

  @override
  void initState() {
    super.initState();
    imageThreadFuture = getImageThread(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    print(image_history.length);
    return Scaffold(
      appBar: AppBar(
          title : Text("Image Thread", style: AppWidget.headlineTextStyle(),)
      ),
      body: FutureBuilder(
        future: imageThreadFuture,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          print("Image Thread of ${widget.uid}");
          if(snapshot.connectionState == ConnectionState.waiting)
            {
              return Center(child: CircularProgressIndicator());
            }
          else{

            return ListView.separated(
                itemCount: image_history.length,
                itemBuilder: (context, index){

                  annotatedImage = base64Decode(image_history[index]["image_data"]);

                  String timestampStr = image_history[index]["upload_time"];

                  DateTime timestampObj = DateTime.parse(timestampStr);

                  String formattedDate = "${timestampObj.day.toString().padLeft(2, '0')}/"
                      "${timestampObj.month.toString().padLeft(2, '0')}/"
                      "${timestampObj.year}";

                  String formattedTime = "${(timestampObj.hour % 12).toString().padLeft(2, '0')}:"
                      "${timestampObj.minute.toString().padLeft(2, '0')} "
                      "${timestampObj.hour < 12 ? 'AM' : 'PM'}";


                  return ImageThreadObject(imageUrl : annotatedImage, stage: image_history[index]["stage"], date: formattedDate, time : formattedTime);

                }, separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: 20,);
            },);

          }
        },
      ),
    );
  }
}
