import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scalp_smart/colors.dart';
import 'package:scalp_smart/screens/patient_screens/stage_info_page.dart';
import 'package:scalp_smart/services/details/stage_info_details.dart';
import 'package:scalp_smart/widgets/widget_support.dart';
import 'package:http/http.dart' as http;
class ImageResulPage extends StatefulWidget {
  const ImageResulPage({super.key, required this.annotatedImage, required this.stage});
  final Image annotatedImage;
  final String stage;

  @override
  State<ImageResulPage> createState() => _ImageResulPageState();
}

class _ImageResulPageState extends State<ImageResulPage> {

  String chatbotResponse = "";

  Future<void> sendPromptToChatBot(String prompt) async {
    Uri url = Uri.parse(
        "https://pblproject-ljlp.onrender.com/flutter/chatbot/prompt");

    String jsonBody = jsonEncode({'prompt': prompt});
    print(prompt);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonBody,
    );
    chatbotResponse = jsonDecode(response.body)["response"];
    print(response.body);
    setState(() {

    });
  }
  @override
  void initState() {
    sendPromptToChatBot("My Current Hairloss product is ${widget.stage}, what should I do ?");
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Hairloss Test Results", style: AppWidget.headlineTextStyle(),),
      ),
      body:    Align(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            children: [
              InkWell(
                    child: Container(
                                      height: 360,
                                      width: 360,
                                      decoration: BoxDecoration(
          
                    border: Border.all(width: 1),
                    borderRadius: BorderRadius.circular(30),
          
                                      ),
          
                                      child: ClipRRect( // Use ClipRRect to apply rounded corners to the child
                    borderRadius: BorderRadius.circular(30),
                    child: FittedBox(
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      child: widget.annotatedImage,
                    ),
                                      ),
                    ),
                  ),
          
              SizedBox(height: 20,),
              
              Text("Your hairloss stage : ${widget.stage}", style: AppWidget.boldTextStyle(),),
          
              Visibility(
                visible: chatbotResponse != "",
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  padding: EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1),
                    borderRadius: BorderRadius.circular(15)

                  ),
                  child: Text(chatbotResponse,  style: TextStyle(fontSize: 16)),
                ),
              ),
          
              SizedBox(height: 10,),
          
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ListTile(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>StageInfoPage(stageInfo: stage_info[widget.stage]!["description"]!, stage: stage_info[widget.stage]!["stage"]!, imageAddr: stage_info[widget.stage]!["imageAddr"]!)));
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
              SizedBox(height: 20,),
          
          
              InkWell(
                onTap: ()
                {
                  print("No Product Screen");
                },
                child: Container(
          
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 20,),
          
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    color: appBarColor,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Text("View Products for ${widget.stage}", style: TextStyle(color : Colors.white, fontSize: 17, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
          
                ),
              )
          
          
            ],
          ),
        )
      ),
    );
  }
}
