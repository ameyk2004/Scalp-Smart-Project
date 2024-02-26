import 'package:flutter/material.dart';
import 'package:scalp_smart/colors.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screens/login_page.dart';
import '../widgets/customTextField.dart';
import '../widgets/widget_support.dart';

class DoctorRegistrationPage extends StatefulWidget {

  @override
  State<DoctorRegistrationPage> createState() => _DoctorRegistrationPageState();
}

class _DoctorRegistrationPageState extends State<DoctorRegistrationPage> {
  TextEditingController nameController = TextEditingController();

  TextEditingController qualificationContoller = TextEditingController();

  TextEditingController experienceController = TextEditingController();

  TextEditingController locationController = TextEditingController();


  _sendMail() async {
    // Android and iOS
    final uri =
        'mailto:sn2204amey@gmail.com?subject=Doctor Onboarding Request&body=Hello%20Team Scalp Smart\nBelow are my details : \n\nName : ${nameController.text}\nQualification : ${qualificationContoller.text} \nExpirience : ${experienceController.text}\nLocation : ${locationController.text}';
    final url = Uri.parse(uri);
    await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.5,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          appBarColor,
                          Colors.cyan,
                        ])),
              ),
              Container(
                margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height/1.5,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40))),
                child: Text(""),
              ),

              Container(
                margin: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Image.asset("assets/images/logo.png",
                    //     width: MediaQuery.of(context).size.width/1.3),

                    Container(
                      width: MediaQuery.of(context).size.width/1.3,
                      margin: EdgeInsets.only(top: 30),
                      alignment: Alignment.center,

                      child: Text("Scalp Smart", style: AppWidget.headlineTextStyle().copyWith(fontSize: 30),),
                    ),
                    SizedBox(height: 20,),
                    Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(20),
                        height: 500,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                        ),

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text("Doctor Registration", style: AppWidget.headlineTextStyle(),),
                                SizedBox(height: 30,),
                                CustomTextField(hintText: "Name", icon: Icon(Icons.person_outline), obscureText: false, textEditingController: nameController, ),
                                SizedBox(height: 15,),
                                CustomTextField(hintText: "Qualification", icon: Icon(Icons.school_outlined), obscureText: false, textEditingController: qualificationContoller,),
                                SizedBox(height: 15,),
                                CustomTextField(hintText: "Experience", icon: Icon(Icons.work_history_outlined), obscureText: false, textEditingController: experienceController,),
                                SizedBox(height: 15,),
                                CustomTextField(hintText: "Location", icon: Icon(Icons.location_on_outlined), obscureText: false, textEditingController: locationController,),

                              ],
                            ),


                            Material(
                              elevation: 5,
                              borderRadius: BorderRadius.circular(20),

                              child: InkWell(
                                onTap: _sendMail,
                                child: Container(

                                  padding: EdgeInsets.symmetric(horizontal: 70, vertical: 10),
                                  decoration: BoxDecoration(
                                      color: appBarColor,
                                      borderRadius: BorderRadius.circular(20)
                                  ),
                                  child: Text("Send Mail", style: AppWidget.boldTextStyle().copyWith(color: Colors.white,),),

                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 50,),



                    Row(

                      children: [

                        Text("Doctor Onboarding Instructions  ", style: TextStyle(fontSize: 18,), textAlign: TextAlign.center,),

                        GestureDetector(
                            onTap: ()
                            {
                              showModalBottomSheet(context: context, builder: (ctx)=>InstuctionContainer());
                            },
                            child: Container(
                              child: Icon(Icons.info_outline),
                            )
                        ),
                      ],
                    ),

                    SizedBox(height: 20,),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(

                        children: [
                          Text("Aldready Have an Account ?", style: TextStyle(fontSize: 18), textAlign: TextAlign.center,),
                          GestureDetector(
                              onTap: ()
                              {
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>LoginPage()));
                              },
                              child: Text("  Login Now", style: TextStyle(fontSize: 18, color: appBarColor))),
                        ],
                      ),
                    ),

                    SizedBox(height: 50,),



                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InstuctionContainer extends StatelessWidget {
  const InstuctionContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.white, // Setting container background color
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Instructions:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
              color: Colors.black, // Setting text color
              fontFamily: 'Roboto', // Using Roboto font
            ),
          ),
          SizedBox(height: 15.0),
          Text(
            'If you want to register on Scalp Smart, please send us an email at pblgroupproject@gmail.com and provide the following details:',
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.black, // Setting text color
              fontFamily: 'Roboto', // Using Roboto font
            ),
          ),
          SizedBox(height: 15.0),
          Text(
            '- Degree certificate',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'Roboto',
            ),
          ),
          Text(
            '- Qualification',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'Roboto',
            ),
          ),
          Text(
            '- Experience',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'Roboto',
            ),
          ),
          Text(
            '- Location of clinic',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'Roboto',
            ),
          ),
        ],
      ),
    );
  }
}