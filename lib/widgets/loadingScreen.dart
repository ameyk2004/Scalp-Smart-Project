import 'package:flutter/material.dart';

import '../colors.dart';

void showLoadingScreen(BuildContext context, String loadingMessage) {
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
                const SizedBox(height: 16),
                Text(loadingMessage,style: const TextStyle(fontWeight: FontWeight.bold),),
              ],
            ));
      });
}