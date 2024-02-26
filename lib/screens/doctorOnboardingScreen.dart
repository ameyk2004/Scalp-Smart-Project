import 'package:flutter/material.dart';

class DoctorOnBoarding extends StatefulWidget {
  const DoctorOnBoarding({super.key});

  @override
  State<DoctorOnBoarding> createState() => _DoctorOnBoardingState();
}

class _DoctorOnBoardingState extends State<DoctorOnBoarding> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          Text("Send Us Mail on pblproject@gmail.com")
        ],
      ),
    );
  }
}
