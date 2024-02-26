import 'package:flutter/material.dart';

import '../colors.dart';

class StageInfoPage extends StatelessWidget {

  final String stage;
  final String imageAddr;
  final String stageInfo;

  const StageInfoPage({super.key, required this.stageInfo, required this.stage,required this.imageAddr});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Scalp Smart",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                color: appBarColor,
                size: 35,
              )),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.person_outline,
                color: appBarColor,
                size: 35,
              )),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.shopping_cart_outlined,
                color: appBarColor,
                size: 35,
              )),
        ],
        bottom: const PreferredSize(
          preferredSize: Size(0, 40),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              height: 45,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'What are you Looking for ?',
                  prefixIcon: Icon(Icons.search_outlined, color: appBarColor),
                  suffixIcon: Icon(Icons.mic_none, color: appBarColor),
                  enabledBorder:
                  OutlineInputBorder(borderSide: BorderSide(width: 1)),
                  focusedBorder:
                  OutlineInputBorder(borderSide: BorderSide(width: 1)),
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ),
      ),


      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(


            children: [
              const SizedBox(height: 15,),

               SizedBox(
                width: double.infinity,
                  child: Text("Hairloss Stage : $stage", style: const TextStyle(fontSize: 25, fontWeight : FontWeight.bold), textAlign: TextAlign.center,)),
              const SizedBox(height: 10),
              Hero(tag: stage,
                  transitionOnUserGestures: true,
              child: Image(image: AssetImage(imageAddr), height: 200,)),
              const SizedBox(height: 10),

              Container(

                margin: const EdgeInsets.symmetric(vertical : 20),
                padding: const EdgeInsets.all(14),
                width: double.infinity,
                height: 400,


                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(width: 1)

                )
                ,

                child: SingleChildScrollView(

                  child: Text(stageInfo,

                    style: const TextStyle(fontSize: 18),

                  ),
                ),





              ),

            ],
          ),
        ),
      ),


    );
  }
}
