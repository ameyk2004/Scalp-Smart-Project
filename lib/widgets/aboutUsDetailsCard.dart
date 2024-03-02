import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scalp_smart/colors.dart';
import 'package:scalp_smart/widgets/widget_support.dart';

class AboutUsDetailsCard extends StatelessWidget {
  final String imageSrc;
  final String description;
  final String role;
  final String name;
  const AboutUsDetailsCard({super.key, required this.imageSrc, required this.description, required this.role, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height/3,
                  width:  MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [appBarColor, buttonColor]),
                  ),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(name, style: AppWidget.headlineTextStyle().copyWith(fontSize: 32, color: Colors.white),),
                      Text(role, style: AppWidget.lightTextStyle().copyWith(fontSize: 19, color: Colors.white60),)
                    ],
                  )
                ),


                Container(

                  margin:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 4.5, left: 30, right: 30),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height/1.75,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      image: DecorationImage(image: AssetImage(imageSrc), fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(40)),
                  // child: Image(image:AssetImage("assets/images/tirthraj.jpeg") ,),
                ),
              ],
            ),
            SizedBox(height: 20,),

            Container(
              height: 2,
              width: double.infinity,
              color: Colors.black,
            ),

            SizedBox(height: 20,),

            Padding(
              padding: EdgeInsets.only(bottom: 80),
              child: Container(

                margin: EdgeInsets.symmetric(horizontal: 18),

                child: Text(description, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),

              ),
            )
          ],

            ),
      ),
    );
  }
}
