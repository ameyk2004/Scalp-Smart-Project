import 'dart:convert';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scalp_smart/screens/patient_screens/HairlossStageResult.dart';
import 'package:scalp_smart/screens/patient_screens/stage_info_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:scalp_smart/services/details/api_key.dart';
import 'package:scalp_smart/widgets/widget_support.dart';
import '../../colors.dart';
import '../../services/details/stage_info_details.dart';
import '../../widgets/loadingScreen.dart';

class SelfAssessmentPage extends StatefulWidget {
  const SelfAssessmentPage({Key? key}) : super(key: key);

  @override
  State<SelfAssessmentPage> createState() => _SelfAssessmentPageState();
}

class _SelfAssessmentPageState extends State<SelfAssessmentPage> {
  File? _image;
  String message = 'Upload Your Image Below';
  Image? annotatedImage;
  String? finalStage;
  String? imgStr;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _refresh() async {
    annotatedImage = null;
    _image = null;
    setState(() {
      message = "Upload your Image Below";
    });

    return await Future.delayed(Duration(seconds: 2));
  }

  Future<void> pickImage() async {
    setState(() {});

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      final orSize = await file.length();
      print('Size of picked image: ${orSize} bytes');
      Uint8List bytes = await file.readAsBytes();
      Uint8List uint8List = Uint8List.fromList(bytes);
      img.Image? originalImage = img.decodeImage(uint8List);

      if (originalImage != null) {
        int newWidth = 150;
        int newHeight = ((originalImage.height * newWidth) / originalImage.width).round();

        img.Image resizedImage = img.copyResize(originalImage, width: newWidth, height: newHeight);
        Uint8List compressedBytes = img.encodeJpg(resizedImage);

        print('Size of compressed image: ${compressedBytes.length} bytes');

        File resizedFile = File(file.path.replaceAll('.jpg', '_resized.jpg'));

        if (compressedBytes.length < orSize) {
          await resizedFile.writeAsBytes(compressedBytes);
          setState(() {
            _image = resizedFile;
            message = 'Image picked and resized successfully!';
            annotatedImage = null;
          });
        } else {
          // If compression does not reduce size, use original image
          setState(() {
            _image = file;
            message = 'Image picked and resized successfully!';
            annotatedImage = null;
          });
        }
      }
    } else {
      setState(() {});
    }
  }

  Future<void> captureImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
      imageQuality: 100,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        message = "Uploaded Successfully !";
        annotatedImage = null;
      });

      print("Original image size: ${_image!.lengthSync()} bytes");

      // Read the image file
      Uint8List imageBytes = await _image!.readAsBytes();
      img.Image? originalImage = img.decodeImage(imageBytes);

      if (originalImage != null) {
        // Calculate height while preserving aspect ratio
        int newWidth = 150; // Desired width
        int newHeight = (originalImage.height * newWidth / originalImage.width)
            .round();

        // Compress the image
        img.Image compressedImage = img.copyResize(
            originalImage, width: newWidth, height: newHeight);

        // Save the compressed image
        File compressedFile = File(
            _image!.path.replaceAll('.jpg', '_compressed.jpg'));
        await compressedFile.writeAsBytes(img.encodeJpg(compressedImage));

        setState(() {
          _image = compressedFile;
        });

        print("Compressed image size: ${_image!.lengthSync()} bytes");
      }

      print("Update successful!");
    }
  }

  Future<void> sendImage() async {
    if (_image == null) return; // Check if an image is selected

    setState(() {});

    var url = Uri.parse('$UPLOAD_IMAGE_URL${_auth.currentUser!.uid}');
    var request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath('image', _image!.path));
    var response = await request.send();

    if (response.statusCode == 200) {
      message = 'Image Sent Successfully !!';
      print(message);
    } else {
      message = 'Error: ${response.statusCode}';
      print(message);
    }

    setState(() {});
  }

  Future getAnnotedImage() async {
    print("Running command");
    var url = '$PREDICT_URL${_auth.currentUser!.uid}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);

      message = data["stage"]; // get image base64
      String annotedImageFile = data["file"];

      if (annotedImageFile != null) {
        try {
          await FirebaseFirestore.instance
              .collection("Users")
              .doc(_auth.currentUser!.uid)
              .update({
            "stage" : message,
            "image": annotedImageFile,
          });
        }
        on Exception catch (e) {
          print(e.toString());
        }

        annotatedImage = Image.memory(base64Decode(annotedImageFile));

        setState(() {
          annotatedImage = Image.memory(base64Decode(annotedImageFile));
          imgStr = data["file"];
          finalStage = data["stage"];
        });
      }
    }
  }

  generateResults() async
  {
      if(annotatedImage!=null)
        {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>ImageResulPage(annotatedImage: annotatedImage!, stage: finalStage!, ImageString: imgStr!,)));
        }
      else
        {
          showDialog(context: context, builder: (context)=>AlertDialog(
            title : Text("Image not Predicted"),
            backgroundColor: dialogboxColor,
            actions: [
              InkWell(
                onTap: () async
                  {
                    await _refresh();
                    Navigator.of(context).pop();
                  },
                  child: Container(child: Text("Try Again ?"),)
              ),
            ],
          ));
        }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      body: LiquidPullToRefresh(
        onRefresh: _refresh,
        height: 250,
        animSpeedFactor: 1.5,
        color: appBarColor,
        child: SingleChildScrollView(

          child: Column(
            children: [
             Container(
               width: MediaQuery.of(context).size.width,
               height: MediaQuery.of(context).size.height/4,
               decoration: BoxDecoration(
                 image: DecorationImage(image: NetworkImage("https://media.post.rvohealth.io/wp-content/uploads/2021/10/man-hands-on-head-hair-1200-628-facebook-1200x628.jpg"), fit: BoxFit.cover)
               ),
             ),

              SizedBox(height: 15,),

              Text("Upload or take a Photo", style: AppWidget.headlineTextStyle(),),
              SizedBox(height: 10,),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),

                  child: Text("Your face must be clearly visible in the Photo. It will not be shared with anyone", textAlign: TextAlign.center, style: TextStyle(fontSize: 15))),
              SizedBox(height: 15,),

              Align(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () async {
                    showLoadingScreen(context, "Getting Image Picker", 1000);
                    await pickImage();
                    Navigator.of(context).pop();
                  },
                  child: _image != null
                      ? Container(
                    height: 280,
                    width: 280,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(_image!), // Assuming _image is a File
                        fit: BoxFit.cover, // Cover the container while maintaining aspect ratio
                        alignment: Alignment.topCenter, // Align the top of the image within the container
                      ),
                      border: Border.all(width: 1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  )

                    : Container(
                    height: 280,
                    width: 280,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage("assets/images/Upload Image.jpeg"),
                        fit: BoxFit.fill
                      ),
                      border: Border.all(width: 1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),

              SizedBox( height: 20,),

              Visibility(
                visible: _image == null,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () async
                        {
                            showLoadingScreen(context, "Getting Image Picker", 1000);
                            await pickImage();
                            Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(
                            color: buttonColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text("Upload From Gallery", style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.039, fontWeight: FontWeight.bold, color: Colors.white),),
                        ),
                      ),
                      InkWell(
                        onTap: captureImage,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(
                            color: CupertinoColors.systemGrey4,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text("Capture Image", style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.039, fontWeight: FontWeight.bold, color: buttonColor),),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Visibility(
                visible: _image !=null,
                child: InkWell(
                  onTap: () async{
                    showLoadingScreen(context, "Sending Image to Server", 3000);

                    HapticFeedback.heavyImpact();

                    await sendImage();
                    Navigator.of(context).pop();
                    if(!message.contains("Error"))
                      {
                        showLoadingScreen(context, "Analysing Scalp", 10000);
                        await getAnnotedImage();
                        Navigator.of(context).pop();
                        HapticFeedback.vibrate();
                      }
                    generateResults();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemGrey4,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text("Get Hairloss Stage", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: buttonColor),),
                  ),
                ),
              ),

              SizedBox(height: 20,),

              Container(height: 200,)

            ],
          ),
        ),
      ),
    );
  }

}
