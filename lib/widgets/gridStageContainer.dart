

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scalp_smart/screens/patient_screens/stage_info_page.dart';

import '../colors.dart';

class gridStageContainer extends StatelessWidget {
  final String imagePath;
  final String stageName;
  final String stageInfo;

  const gridStageContainer({
    super.key,
    required this.imagePath,
    required this.stageName,
    required this.stageInfo,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: (){
        HapticFeedback.vibrate();
      },
      onTap: () {
        HapticFeedback.mediumImpact();
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => StageInfoPage(
            stageInfo: stageInfo,
            imageAddr: imagePath,
            stage: stageName,
          ),
        ));
      },
      child: Container(
        decoration: BoxDecoration(
          color: appBarColor.withAlpha(494),
          gradient: LinearGradient(
            colors: [
              appBarColor, Colors.cyan,

            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          // gradient: RadialGradient(
          //     colors: [appBarColor.withAlpha(450), appBarColor.withAlpha(450), buttonColor,]),

          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Hero(
                  transitionOnUserGestures: true,
                  tag: stageName,
                  child: Image(
                    image: AssetImage(imagePath),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),

              decoration:  BoxDecoration(

                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),),
                // gradient: LinearGradient(colors: [Colors.cyan, Colors.teal]),
                color: appBarColor.withAlpha(420)

              ),
              child: Text(
                stageName,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color.fromRGBO(242, 242, 242, 1)),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}