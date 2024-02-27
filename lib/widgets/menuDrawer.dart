import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:scalp_smart/colors.dart';

import '../auth/authServices.dart';

class CustomMenuDrawer extends StatefulWidget {
  final String profile_pic;
  final String userName;

  const CustomMenuDrawer({super.key, required this.profile_pic, required this.userName});

  @override
  State<CustomMenuDrawer> createState() => _CustomMenuDrawerState();
}

class _CustomMenuDrawerState extends State<CustomMenuDrawer> {

  File? profile_pic;
  Future<void> pickImage() async {
    setState(() {
    });

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      File file = File(result.files.single.path!);
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
                  profile_pic == null ?
                  InkWell(
                    onTap: pickImage,
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                          color: Colors.lime,
                          image:  DecorationImage(
                              image: NetworkImage(widget.profile_pic),
                            fit: BoxFit.cover
                          )),

                    ),
                  ) : Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.lime,
                        image:  DecorationImage(
                            image: FileImage(profile_pic!),
                            fit: BoxFit.cover
                        )),

                  ),
                  SizedBox(
                    height: 8,
                  ),
                   Text(
                    widget.userName,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  )
                ],
              )),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: ListTile(
              onTap: logout,
              leading: Icon(
                Icons.logout,
                color: appBarColor,
              ),
              title: Text("L O G O U T",
                  style: TextStyle(fontWeight: FontWeight.bold)),

            ),
          )
        ],
      ),
    );
  }
}
