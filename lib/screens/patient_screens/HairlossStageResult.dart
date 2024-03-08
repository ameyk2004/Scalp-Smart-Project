import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/widgets.dart' as pdfLib;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scalp_smart/colors.dart';
import 'package:scalp_smart/screens/patient_screens/stage_info_page.dart';
import 'package:scalp_smart/services/details/stage_info_details.dart';
import 'package:scalp_smart/widgets/widget_support.dart';
class ImageResulPage extends StatefulWidget {
  const ImageResulPage({super.key, required this.annotatedImage, required this.stage, required this.ImageString});
  final Image annotatedImage;
  final String ImageString;
  final String stage;

  @override
  State<ImageResulPage> createState() => _ImageResulPageState();
}

class _ImageResulPageState extends State<ImageResulPage> {

  String? ResultDescription;




  Future<void> generatePDF() async {

    pdfLib.Image image1 = pdfLib.Image(pdfLib.MemoryImage(base64Decode(widget.ImageString)));

    final pdf = pdfLib.Document();

    pdf.addPage(
      pdfLib.Page(
        build: (context) {
          return pdfLib.Column(
            children: [
              pdfLib.Text('Your Test Results', style: pdfLib.TextStyle(fontSize: 18, fontWeight: pdfLib.FontWeight.bold)),
              pdfLib.SizedBox(height: 20),
              pdfLib.Container(
          alignment: pdfLib.Alignment.center,
          height: 340,
          width: 340,
          child: image1,
          ),
              pdfLib.SizedBox(height: 20),
              pdfLib.Text(ResultDescription ?? "", style: pdfLib.TextStyle(fontSize: 16)),
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
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Test Results", style: AppWidget.headlineTextStyle(),),

        actions: [
          IconButton(onPressed: generatePDF, icon: Icon(Icons.download))
        ],
      ),
      body:    Align(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            children: [
              InkWell(
                    child: Container(
                                      height: 340,
                                      width: 340,
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

              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                padding: EdgeInsets.all(7),
                decoration: BoxDecoration(
                  border: Border.all(width: 1),
                  borderRadius: BorderRadius.circular(15)

                ),
                child: Text(ResultDescription!,  style: TextStyle(fontSize: 16)),
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
