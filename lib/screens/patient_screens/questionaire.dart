import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:scalp_smart/colors.dart';
import 'package:scalp_smart/services/details/questions.dart';

import '../../screens/patient_screens/home_page.dart';
import '../../widgets/question_card.dart';
import '../../widgets/widget_support.dart';


class QuestionairePage extends StatefulWidget {
  @override
  _QuestionairePageState createState() => _QuestionairePageState();
}
class _QuestionairePageState extends State<QuestionairePage> {

  late Map<String, dynamic> quizData;
  late String quizName;
  late List<dynamic> questions;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  PageController _pageController = PageController(initialPage: 0);


  @override
  void initState() {
    super.initState();
    quizData = jsonQuizData;
    questions = quizData['questions'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: appBarColor,
        scrolledUnderElevation: 0.0,
        centerTitle: true,
        toolbarHeight: MediaQuery.of(context).size.height*0.17,
        title: Column(
          children: [
            Align(
              child: CircleAvatar(
                backgroundImage: NetworkImage("https://play-lh.googleusercontent.com/8Y475Bo9AA8ntQZ_fOdnvaIeO-gUFwBidSXm2FGJhSOHqsUshkWVv5oCz5vruxRp-g"),
                radius: MediaQuery.of(context).size.height*0.055 ,
              ),
            ),
            SizedBox(height: 10,),
            Text("Hair loss Quiz", style: AppWidget.boldTextStyle().copyWith(fontSize: MediaQuery.of(context).size.height*0.028, color: Colors.white))
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30),
            SizedBox(
              height: 300,
              child: PageView.builder(
                controller: _pageController,
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  List answers = questions[index]['answers'] as List<dynamic>;
                  return QuestionCard(questions: questions, answers: answers, index : index);
                },
              ),
            ),
            GestureDetector(
              onTap: ()
              {
                if (_pageController.page! < questions.length - 1) {
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.ease,
                  );
                }
                else
                  {
                    showDialog(context: context, builder: (context)=>AlertDialog(title: Text("Submitted", textAlign: TextAlign.center,),));
                  }
              },
              child: Container(
                decoration: BoxDecoration(color: appBarColor, borderRadius: BorderRadius.circular(20)),
                height: 60,
                margin: const EdgeInsets.all(40),
                width: double.infinity,
                child: Center(
                  child: Text(
                    "Next",
                    style: const TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

