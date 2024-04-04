import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scalp_smart/colors.dart';
import 'answer_card.dart';
import '';

class QuestionCard extends StatefulWidget {
  QuestionCard({
    super.key,
    required this.questions,
    required this.answers,
    required this.index,
  });

  final List questions;
  final List answers;
  final int index;

  @override
  State<QuestionCard> createState() => _QuestionCardState();

}

class _QuestionCardState extends State<QuestionCard> {
  String selectedAns = "";
  String reason = "";
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  late List<Map<String, bool>> form_data;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: dialogboxColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text("Q. ${widget.questions[widget.index]["question"]}", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
          SizedBox(height: 30,),
          Column(
              children: [
                for(int i=0; i<widget.answers.length; i++)
                  InkWell(
                    onTap: () async
                    {
                      reason = widget.questions[widget.index]["reason"];
                      selectedAns =  widget.answers[i]["text"];
                      await firestore.collection("Users").doc(auth.currentUser!.uid).update({
                        "form_data.$reason" : selectedAns,
                      });
                      print(selectedAns);
                      setState(() {});
                    },
                    child: AnswerWidget(widget: widget, selectedAns: selectedAns, index: i, reason: reason,),
                  ),
              ]
          )
        ],
      ),
    );
  }
}
