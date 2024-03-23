import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scalp_smart/colors.dart';
import 'package:scalp_smart/services/details/api_key.dart';
import 'package:scalp_smart/services/firebase_service/database.dart';
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
   String userRole = "";

  getImageThread(user_id) async
  {
    final response = await http.get(Uri.parse("$DOMAIN/api/images/$user_id/all?api_key=$APP_API_KEY"));
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

   String formatDate(String inputDate) {
     String datePart = inputDate.split('+')[0].trim();
     DateTime date = DateTime.parse(datePart);

     // Define arrays for ordinal suffixes and months
     List<String> ordinalSuffix = ['th', 'st', 'nd', 'rd'];
     List<String> months = [
       'January',
       'February',
       'March',
       'April',
       'May',
       'June',
       'July',
       'August',
       'September',
       'October',
       'November',
       'December'
     ];

     int day = date.day;
     int month = date.month;
     int year = date.year;
     int hours = date.hour;
     int minutes = date.minute;

     String ampm = hours >= 12 ? 'pm' : 'am';
     int formattedHours = hours % 12 == 0 ? 12 : hours % 12;

     // Construct the formatted date string
     String formattedDate =
         '$day ${months[month - 1]} $year, ${formattedHours}:${minutes.toString().padLeft(2, '0')} $ampm';

     print(formattedDate);
     return formattedDate;
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
          title : Text("Image Thread", style: AppWidget.headlineTextStyle().copyWith(color: Colors.white),),
        backgroundColor: buttonColor,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image(image: AssetImage("assets/images/chatWallpaper.jpg"),
            fit: BoxFit.cover,

          ),
          FutureBuilder(
            future: imageThreadFuture,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting)
                {
                  return Center(child: CircularProgressIndicator());
                }
              else{

                return ListView.builder(
                    itemCount: image_history.length,
                    itemBuilder: (context, index){

                      annotatedImage = base64Decode(image_history[index]["image_data"]);

                      String timestampStr = image_history[index]["upload_time"];
                      print(timestampStr);

                      DateTime timestampObj = DateTime.parse(timestampStr);

                      String formattedDate = formatDate(timestampStr);



                      return ImageThreadObject(imageUrl : annotatedImage, stage: image_history[index]["stage"], date: formattedDate,);

                    }
                );

              }
            },
          ),
        ],
      ),
    );
  }
}
