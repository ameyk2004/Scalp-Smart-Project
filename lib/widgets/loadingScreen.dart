import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../colors.dart';

void showLoadingScreen(BuildContext context, String loadingMessage, int time) {
  showDialog(

      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
            elevation: 10,
            backgroundColor: dialogboxColor,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(buttonColor),
                ),
                const SizedBox(height: 20),
                Text(loadingMessage,style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),

                SizedBox(height: 20,),

                FittedBox(
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: LinearPercentIndicator(
                      width: MediaQuery.of(context).size.width - 50,
                      animation: true,
                      lineHeight: 30.0,
                      animationDuration: time,
                      percent: 0.9,
                      barRadius: Radius.circular(15),
                      progressColor: appBarColor,
                    ),
                  ),
                ),
              ],
            ));
      });
}