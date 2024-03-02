import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../colors.dart';
import '../../widgets/widget_support.dart';

class ImageThreadObject extends StatelessWidget {
  final Uint8List imageUrl;
  final String stage;
  final String date;
  const ImageThreadObject({
    super.key, required this.imageUrl, required this.stage, required this.date,
  });

  @override
  Widget build(BuildContext context) {

    final threadImage = Image.memory(imageUrl);

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
