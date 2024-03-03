import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scalp_smart/colors.dart';
import 'package:scalp_smart/widgets/widget_support.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsDetailsCard extends StatelessWidget {
  final String imageSrc;
  final String description;
  final String role;
  final String name;
  final String InstagramUrl;
  final String LinkedinUrl;
  final String GithubUrl;
  const AboutUsDetailsCard({super.key, required this.imageSrc, required this.description, required this.role, required this.name, required this.InstagramUrl, required this.LinkedinUrl, required this.GithubUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height/3 - 40,
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


                Stack(
                  children: [
                    Container(
                      margin:
                      EdgeInsets.only(top: MediaQuery.of(context).size.height / 5.0, left: 30, right: 30),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height/1.75,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1),
                          image: DecorationImage(image: AssetImage(imageSrc), fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(40)),
                    ),

                    Positioned(
                      bottom: 10,
                      left: 50,
                      child: Container(
                        height: 50, // Set the color as needed

                        child: Row(
                          children: [
                            InkWell(
                              onTap: ()
                              {
                                launchUrl(Uri.parse(InstagramUrl), mode: LaunchMode.externalApplication);
                              },
                              child: Container(
                                child: Image(image: NetworkImage("https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/Instagram_icon.png/600px-Instagram_icon.png"),),
                              ),
                            ),
                            SizedBox(width: 20,),
                            InkWell(
                              onTap: ()
                              {
                                launchUrl(Uri.parse(LinkedinUrl), mode: LaunchMode.externalApplication);
                              },
                              child: Container(
                                child: Image(image: NetworkImage("https://static-00.iconduck.com/assets.00/linkedin-icon-1024x1024-net2o24e.png"),),
                              ),
                            ),
                            SizedBox(width: 20,),
                            InkWell(
                              onTap: ()
                              {
                                launchUrl(Uri.parse(GithubUrl), mode: LaunchMode.externalApplication);
                              },
                              child: Container(
                                child: Image(image: NetworkImage("https://cdn.pixabay.com/photo/2022/01/30/13/33/github-6980894_1280.png"),),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
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

            Container(

              margin: EdgeInsets.symmetric(horizontal: 18),

              child: Text(description, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),

            ),

            SizedBox(height: 20,),

            Container(
              height: 2,
              width: double.infinity,
              color: Colors.black,
            ),

            SizedBox(height: 20,),
          ],

            ),
      ),
    );
  }
}
