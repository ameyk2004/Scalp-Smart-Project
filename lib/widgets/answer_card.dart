import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scalp_smart/colors.dart';
import 'package:scalp_smart/widgets/question_card.dart';

class AnswerWidget extends StatefulWidget {
  AnswerWidget({
    super.key,
    required this.index,
    required this.widget,
    required this.selectedAns,
    required this. reason,
  });

  final QuestionCard widget;
  final String selectedAns;
  int index;
  String reason;

  @override
  State<AnswerWidget> createState() => _AnswerWidgetState();
}

class _AnswerWidgetState extends State<AnswerWidget> {
  var form_data = {};

  getSelectedAnswer()
  async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    form_data = data["form_data"] ?? {};
  }

  @override
  void initState() {
    getSelectedAnswer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: (widget.widget.answers[widget.index]["text"] == widget.selectedAns)? appBarColor : Colors.white,
      ),
      child: Text(widget.widget.answers[widget.index]["text"], style: TextStyle(
          color: widget.widget.answers[widget.index]["text"] == widget.selectedAns ? Colors.white : Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w600
      ),),
    );
  }
}