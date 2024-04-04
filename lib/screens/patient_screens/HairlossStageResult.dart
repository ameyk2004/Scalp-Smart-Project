import 'dart:convert';
import 'dart:io';

import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/widgets.dart' as pdfLib;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scalp_smart/colors.dart';
import 'package:scalp_smart/screens/patient_screens/questionaire.dart';
import 'package:scalp_smart/screens/patient_screens/stage_info_page.dart';
import 'package:scalp_smart/services/details/accordian_details.dart';
import 'package:scalp_smart/services/details/stage_info_details.dart';
import 'package:scalp_smart/widgets/widget_support.dart';

class ImageResulPage extends StatefulWidget {
  const ImageResulPage(
      {super.key,
      required this.annotatedImage,
      required this.stage,
      required this.ImageString});
  final Image annotatedImage;
  final String ImageString;
  final String stage;

  @override
  State<ImageResulPage> createState() => _ImageResulPageState();
}

class _ImageResulPageState extends State<ImageResulPage> {
  List reasons = [
    "dieting",
    "flaking",
    "stress",
    "iron deficiency",
    "thyroid deficiency",
    "rash",
    "heredity"
  ];

  Map form_data = {};

  getFormData() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    final data = doc.data() as Map;
    form_data = data["form_data"] ?? {};
    print(form_data);
    setState(() {});
  }

  String? ResultDescription;

  Future<void> generatePDF() async {
    pdfLib.Image image1 =
        pdfLib.Image(pdfLib.MemoryImage(base64Decode(widget.ImageString)));

    final pdf = pdfLib.Document();

    pdf.addPage(
      pdfLib.Page(
        build: (context) {
          return pdfLib.Column(
            children: [
              pdfLib.Text('Your Test Results',
                  style: pdfLib.TextStyle(
                      fontSize: 18, fontWeight: pdfLib.FontWeight.bold)),
              pdfLib.SizedBox(height: 20),
              pdfLib.Container(
                alignment: pdfLib.Alignment.center,
                height: 340,
                width: 340,
                child: image1,
              ),
              pdfLib.SizedBox(height: 20),
              pdfLib.Text(ResultDescription ?? "",
                  style: pdfLib.TextStyle(fontSize: 16)),
              pdfLib.SizedBox(height: 20),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/results.pdf');
    print('${output.path}/results.pdf');
    await file.writeAsBytes(await pdf.save());

    OpenFile.open(file.path);
  }

  @override
  void initState() {
    super.initState();
    ResultDescription = stage_info[widget.stage]?["description"] ?? "";
    getFormData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Your Test Results",
            style: AppWidget.headlineTextStyle(),
          ),
          actions: [
            IconButton(onPressed: generatePDF, icon: Icon(Icons.download))
          ],
        ),
        body: Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(children: [
                InkWell(
                  child: Container(
                    height: 340,
                    width: 340,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: ClipRRect(
                      // Use ClipRRect to apply rounded corners to the child
                      borderRadius: BorderRadius.circular(30),
                      child: FittedBox(
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                        child: widget.annotatedImage,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StageInfoPage(
                                  stageInfo:
                                      stage_info[widget.stage]!["description"]!,
                                  stage: stage_info[widget.stage]!["stage"]!,
                                  imageAddr: stage_info[widget.stage]![
                                      "imageAddr"]!)));
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.grey[400]!),
                    ),
                    tileColor: Colors.white,
                    trailing: IconButton(
                      icon: Icon(Icons.arrow_forward_ios_outlined),
                      onPressed: () {
                        // Add your onPressed logic here
                      },
                    ),
                    title: Text(
                      (widget.stage).toUpperCase(),
                      style: AppWidget.boldTextStyle().copyWith(
                        fontSize: 17,
                        color: Colors.black,
                      ),
                    ),
                    subtitle: const Text(
                      "View Info",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  form_data.isNotEmpty ? "Your probable hair loss reasons" : "Your Form Data not available",
                  style: TextStyle(fontSize: 22),
                ),
                Visibility(
                  visible: form_data.isEmpty,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>QuestionairePage()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: appBarColor,
                          borderRadius: BorderRadius.circular(20)),
                      height: 60,
                      margin: const EdgeInsets.all(40),
                      width: double.infinity,
                      child: Center(
                        child: Text(
                          "Fill out the Form",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Accordion(
                    headerBackgroundColor: Colors.grey,
                    headerBackgroundColorOpened: appBarColor,
                    contentBackgroundColor: Colors.white,
                    contentBorderColor: appBarColor,
                    contentBorderWidth: 3,
                    contentHorizontalPadding: 10,
                    scaleWhenAnimating: true,
                    openAndCloseAnimation: true,
                    headerPadding:
                        const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                    sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
                    sectionClosingHapticFeedback: SectionHapticFeedback.light,
                    children: [
                      for (int i = 0; i < reasons.length; i++)
                        if (form_data[reasons[i]] == "Yes")
                          AccordionSection(
                            contentVerticalPadding: 10,
                            leftIcon: const Icon(Icons.medical_services,
                                color: Colors.white),
                            header: Text((reasons[i]),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
                            content: Text(
                              reasonDetails[reasons[i]]!["description"]
                                  as String,
                              style: TextStyle(color: Colors.blueAccent),
                            ),
                          ),
                    ],
                  ),
                ),
              ]),
            )));
  }
}
