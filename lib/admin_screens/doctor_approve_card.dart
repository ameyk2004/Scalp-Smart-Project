import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../auth/authServices.dart';
import '../widgets/widget_support.dart';

class DoctorCard extends StatelessWidget {
  String email;
  String name;
  String qualification;
  String experience;
  String location;
  String id;

  AuthService authService = AuthService();

  DoctorCard({
    super.key,
    required this.id,
    required this.name,
    required this.email,
    required this.qualification,
    required this.experience,
    required this.location,
  });


  approveDoctor(String email, String name, String qualification,
      String location, String experience) async {
    try {
      print("Pending id : $id");

      UserCredential userCredential = await authService.createNewDoctor(
          email, name, qualification, location, experience);
      await authService.loginEmailPassword("admin@scalpsmart.com", "Admin1234");
      await FirebaseFirestore.instance.collection("Pending_Approvals")
          .doc(id)
          .delete();

    } catch (e) {
      print("Error approving doctor: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 210,
        color: Colors.grey.shade200,
        child: Stack(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 130,
                          width: 130,
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                              image: NetworkImage(
                                "https://santevitahospital.com/img/vector_design_male_11zon.webp",
                              ),
                              // Assuming _image is a File
                              fit: BoxFit.cover,
                              alignment: Alignment
                                  .topCenter,
                            ),
                            border: Border.all(width: 1),
                            borderRadius: BorderRadius.circular(30),
                          ),
                        )),
                    SizedBox(
                      width: 30,
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                name,
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                                style: AppWidget.boldTextStyle(),
                              ),
                              Text(
                                qualification,
                                style: TextStyle(fontSize: 17),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              Text("Exp : $experience",
                                  style: TextStyle(fontSize: 17)),
                              Text(location, style: TextStyle(fontSize: 17)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  height: 70,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: ()
                          {
                            HapticFeedback.mediumImpact();
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 20),
                            height: 40,
                            width: MediaQuery.of(context).size.width / 2 - 50,

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.red,
                            ),
                            child: Align(alignment: Alignment.center, child: Text("Reject", style: AppWidget.boldTextStyle().copyWith(fontSize: 17, color: Colors.white),)),
                          )),


                      InkWell(
                          onTap: () async {
                            HapticFeedback.mediumImpact();
                            await approveDoctor(email, name, qualification,
                                location, experience);
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 20),
                            height: 40,
                            width: MediaQuery.of(context).size.width / 2 - 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.green,
                            ),
                            child: Align(alignment: Alignment.center, child: Text("Approve", style: AppWidget.boldTextStyle().copyWith(fontSize: 17, color: Colors.white),)),))
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
