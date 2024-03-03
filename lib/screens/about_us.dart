import 'package:flutter/material.dart';
import 'package:scalp_smart/services/details/aboutUsDetails.dart';
import 'package:scalp_smart/widgets/widget_support.dart';

import '../widgets/aboutUsHomeCard.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Our Team", style: AppWidget.headlineTextStyle(),),
      ),

      body: ListView.separated(
        itemCount: aboutUsDetails.length,
        itemBuilder: (context, index){


            return AboutUsHomeCard(name: aboutUsDetails[index]["name"]! , role: aboutUsDetails[index]["role"]!, age: 20, ImageSrc:aboutUsDetails[index]["image"]!, description:aboutUsDetails[index]["description"]!, InstaUrl: aboutUsDetails[index]["instagram"]!, LinkedinUrl: aboutUsDetails[index]["linkedin"]!, GithubUrl: aboutUsDetails[index]["github"]!,);

      }, separatorBuilder: (BuildContext context, int index) {
          return SizedBox(height: 20,);
      },
      ),
    );
  }
}
