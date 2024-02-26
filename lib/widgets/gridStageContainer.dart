

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scalp_smart/screens/stage_info_page.dart';

import '../colors.dart';

class gridStageContainer extends StatelessWidget {
  final String imagePath;
  final String stageName;
  final String stageInfo;

  const gridStageContainer({
    Key? key,
    required this.imagePath,
    required this.stageName,
    required this.stageInfo,
  }) : super(key: key);

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
          // color: appBarColor.withAlpha(494),
          gradient: RadialGradient(
              colors: [appBarColor.withAlpha(494), appBarColor.withAlpha(494), buttonColor,]),

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
            SizedBox(height: 10,),
            Container(
              padding: const EdgeInsets.all(8.0),

              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),),
                // gradient: LinearGradient(colors: [Colors.cyan, Colors.teal]),
                color: Colors.cyan

              ),
              child: Text(
                stageName,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}