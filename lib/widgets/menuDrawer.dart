import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scalp_smart/colors.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../auth/authServices.dart';
import '../screens/about_us.dart';

class CustomMenuDrawer extends StatefulWidget {
  final String profile_pic;
  final String userName;

  const CustomMenuDrawer({super.key, required this.profile_pic, required this.userName});

  @override
  State<CustomMenuDrawer> createState() => _CustomMenuDrawerState();
}

class _CustomMenuDrawerState extends State<CustomMenuDrawer> {

  File? profile_pic;
  String image_url = "";
  bool Isloading = false;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;


  getProfilePic() async
  {
    Isloading = true;
    final docSnapshot = await firestore.collection("Users").doc(auth.currentUser!.uid).get();

    if(docSnapshot.exists)
      {
        image_url = docSnapshot.data()?["profile_pic"]?? widget.profile_pic;
      }
    Isloading = false;

    setState(() {

    });
  }



  Future<void> pickImage() async {
    setState(() {
    });

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {

      File file = File(result.files.single.path!);
      print(result.files.single.path!);

      String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference refDirImages = referenceRoot.child("images");
      Reference RefimageToUpload = refDirImages.child(uniqueFileName);

      try {

        await RefimageToUpload.putFile(file);

        image_url = await RefimageToUpload.getDownloadURL();
        await firestore.collection("Users").doc(auth.currentUser!.uid).update(
          {
            "profile_pic" : image_url,
          }
        );

        // showDialog(context: context, builder: (context)=>AlertDialog(
        //   content: Text("Photo Updated"),
        // ));

      } on Exception catch (e) {

      }
      setState(() {
        profile_pic = file;
      });
    } else {
      setState(() {
      });
    }
  }

  void logout() async
  {
    final authService = AuthService();
    try
    {
      authService.logout();
    }
    catch(e)
    {
      print(e.toString());
    }
  }

  void resetPassword()
  {
    FirebaseAuth.instance.sendPasswordResetEmail(email: widget.userName);
  }

  @override
  void initState() {
    getProfilePic();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Drawer(
      backgroundColor: Colors.grey[300],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(

                  child: Column(
                children: [
                  image_url == "" ?
                  InkWell(
                    onTap: pickImage,
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                          color: Colors.blueAccent,
                          image:  DecorationImage(
                              image: NetworkImage(widget.profile_pic),
                            fit: BoxFit.cover
                          )),

                    ),
                  ) : InkWell(
                    onTap: pickImage,
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.blueAccent,
                          image:  DecorationImage(
                              image: NetworkImage(image_url),
                              fit: BoxFit.cover
                          )),

                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                   Text(
                    widget.userName,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  )
                ],
              )),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                    child: ListTile(
                      onTap: ()
                      {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AboutUsPage()));
                      },
                      leading: const Icon(
                        Icons.groups,
                        color: appBarColor,
                      ),
                      title: const Text("T E A M",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: ListTile(
                      onTap: () async
                      {
                        await FirebaseAuth.instance.sendPasswordResetEmail(email: widget.userName);
                      },
                      leading: const Icon(
                        Icons.settings,
                        color: appBarColor,
                      ),
                      title: const Text("P A S S W O R D",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: ListTile(
              onTap: logout,
              leading: const Icon(
                Icons.logout,
                color: appBarColor,
              ),
              title: const Text("L O G O U T",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }
}
