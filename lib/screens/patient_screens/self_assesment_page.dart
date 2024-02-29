import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:scalp_smart/screens/patient_screens/stage_info_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'dart:io';
import 'package:flutter/services.dart';
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
  List imageHistory = [];
  final List months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _refresh() async{

    annotatedImage = null;
    _image = null;
    setState(() {
      message = "Upload your Image Below";
    });

    return await Future.delayed(Duration(seconds: 2));
    
  }

  Future<void> pickImage() async {
    setState(() {
    });

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      // String base64String = base64Encode(file.readAsBytesSync());
      // await FirebaseFirestore.instance
      //     .collection("Users")
      //     .doc(_auth.currentUser!.uid)
      //     .update({
      //   "image": base64String,
      // });
      setState(() {
        _image = file;
        message = 'Image picked successfully!';
        annotatedImage = null;

      });
    } else {
      setState(() {
      });
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

        if (_image != null) {
          List<int> imageBytes = _image!.readAsBytesSync();
          String base64Image = base64Encode(imageBytes);

          // await FirebaseFirestore.instance
          //     .collection("Users")
          //     .doc(_auth.currentUser!.uid)
          //     .update({
          //   "image": base64Image,
          // });

        }
      });

      print("Update successful!");
    }
  }

  Future<void> sendImage() async {
    if (_image == null) return; // Check if an image is selected

    setState(() {
    });

    var url = Uri.parse(
        'https://pblproject-ljlp.onrender.com/flutter/upload');

    // var url = Uri.parse(
    //     'http://127.0.0.1:5000/flutter/upload');

    var request = http.MultipartRequest('POST', url);
    // Attach the image file to the request
    request.files.add(await http.MultipartFile.fromPath('image', _image!.path));
    var response = await request.send();

    if (response.statusCode == 200) {
      message = 'Image Sent Successfully !!';
    } else {
      message = 'Error: ${response.statusCode}';
    }

    setState(() {
    });
  }

  Future getAnnotedImage() async {
    print("Running command");
    var url = 'https://pblproject-ljlp.onrender.com/flutter/predict';
    // var url = 'http://127.0.0.1:5000/flutter/predict';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);
      DateTime dateTime = DateTime.now();

      // print(response.body);

      message = data["stage"]; // get image base64
      String annotedImageFile = data["file"];

      List<int> imageBytes = base64Decode(annotedImageFile);

      String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference refDirImages = referenceRoot.child("results");
      Reference RefimageToUpload = refDirImages.child(uniqueFileName);

      await RefimageToUpload.putData(Uint8List.fromList(imageBytes));

      String image_url = await RefimageToUpload.getDownloadURL();
      print(image_url);

      if (annotedImageFile!= null) {
        try {
          await FirebaseFirestore.instance
              .collection("Users")
              .doc(_auth.currentUser!.uid)
              .update({
            "image": image_url,
          });

          annotatedImage = Image.memory(base64Decode(annotedImageFile));

          final userSnapshot = await FirebaseFirestore.instance.collection("Users").doc(_auth.currentUser!.uid).get();
          if(userSnapshot.exists)
          {
            print("exists");
            try {
              final historyfromfirestore = userSnapshot.data()?["image_history"] ?? [];
              imageHistory = historyfromfirestore;
              imageHistory.add({
                "image" : image_url,
                "date" : "${dateTime.day} ${months[dateTime.month-1]}",
                "stage" : data["stage"]
              });

              await _firestore.collection("Users").doc(_auth.currentUser!.uid).update(
                {
                  "image_history" : imageHistory,
                }
              );
              print("image_array updated");
            } on Exception catch (e) {
              print("Error");
            }
          }
          print("Update successful!");
        } catch (e) {
          print("Error updating document: $e");
        }
      } else {
        print("annotedImageFile is null. Skipping update.");
      }

      setState(() {
        annotatedImage =Image.memory(base64Decode(annotedImageFile));
        finalStage = data["stage"];
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: LiquidPullToRefresh(
          onRefresh: _refresh,
          height: 250,
          animSpeedFactor: 1.5,
          color: appBarColor,
          child: SingleChildScrollView(

            child: Column(
              children: [
                const SizedBox(height: 10,),
                Align(
                  alignment: Alignment.center,
                  child:

                      message != null ? Text(message, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)) :

                  const Text("Upload your Image Below", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),)
                ),
                const SizedBox(height: 10,),
                Visibility(
                  visible: annotatedImage == null,
                  child: Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      onDoubleTap: () async {
                        showLoadingScreen(context, "Sending Image to Server");
                        // Make the API call
                        await sendImage();
                        Navigator.of(context).pop();

                      },
                      onTap: () async {
                        showLoadingScreen(context, "Getting Image Picker");
                        // Make the API call
                        await pickImage();
                        // Remove loading screen after the API call is complete
                        Navigator.of(context).pop();

                      },
                      child: _image != null
                          ? Container(
                        height: 360,
                        width: 360,
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
                        height: 360,
                        width: 360,
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
                ),

                Visibility(
                  visible: annotatedImage!=null,
                  child: Align(
                    alignment: Alignment.center,
                    child: annotatedImage != null
                        ? InkWell(
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
                            child: annotatedImage,
                          ),
                                            ),
                                          ),
                        )

                        : const SizedBox.shrink()
                  ),
                ),

                const SizedBox(height: 10),

                Visibility(
                  visible: annotatedImage == null,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 13),
                    child: TextButton(onPressed: () async{

                      showLoadingScreen(context, "Sending Image to Server");

                      HapticFeedback.heavyImpact();

                      await sendImage();
                      Navigator.of(context).pop();
                      showLoadingScreen(context, "Analysing Scalp");
                      await getAnnotedImage();
                      Navigator.of(context).pop();
                      HapticFeedback.vibrate();
                    },

                      style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(const Size(double.infinity,45)),
                          backgroundColor: MaterialStateProperty.all(buttonColor),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
                      ), child: const Text("Get Stage", style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),),
                    ),
                  ),
                ),

                Visibility(
                  visible: annotatedImage!=null,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: TextButton(onPressed: () {


                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => StageInfoPage(stageInfo: stage_info[finalStage!]!["description"]!, stage: finalStage!, imageAddr: stage_info[finalStage!]!["imageAddr"]!)));

                    },

                      style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(const Size(double.infinity,45)),
                          backgroundColor: MaterialStateProperty.all(buttonColor),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
                      ), child: const Text("View Info", style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),),
                    ),
                  ),
                ),

                Container(height: 300, color: Colors.white,),

              ],
            ),
          ),
        ),

      ),

      floatingActionButton: FloatingActionButton(
        onPressed: captureImage ,
        backgroundColor: buttonColor,
        foregroundColor: Colors.white,
        child: const Icon(Icons.camera_alt),
      ),

    );
  }

}
