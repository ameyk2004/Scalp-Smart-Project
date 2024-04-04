import 'package:flutter/material.dart';
import 'package:scalp_smart/colors.dart';
import 'package:scalp_smart/screens/patient_screens/login_page.dart';
import 'package:scalp_smart/services/chat_service/push_notifications.dart';
import 'package:scalp_smart/widgets/content_model.dart';
import 'package:scalp_smart/widgets/widget_support.dart';

class Onboard extends StatefulWidget {
  const Onboard({super.key});

  @override
  State<Onboard> createState() => _OnboardState();
}

class _OnboardState extends State<Onboard> {
  int currentIndex = 0;
  late PageController _controller;
  PushNotifications notifications = PushNotifications();

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    notifications.requestpermission();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
                controller: _controller,
                itemCount: contents.length,
                onPageChanged: (int index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (_, i) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Image(
                            image: NetworkImage(contents[i].image,),
                            height:  MediaQuery.of(context).size.height/2,
                            width: MediaQuery.of(context).size.width ,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(
                            height: 40.0,
                          ),
                          Text(
                            contents[i].title,
                            style: AppWidget.headlineTextStyle(),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            contents[i].description,
                            style: AppWidget.lightTextStyle(),
                          )
                        ],
                      ),
                    ),
                  );
                }),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                contents.length,
                    (index) => buildDot(index, context),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (currentIndex == contents.length - 1) {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => const LoginPage()));
              }
              _controller.nextPage(
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.bounceIn);
            },
            child: Container(
              decoration: BoxDecoration(color: appBarColor, borderRadius: BorderRadius.circular(20)),
              height: 60,
              margin: const EdgeInsets.all(40),
              width: double.infinity,
              child: Center(
                child: Text(
                  currentIndex == contents.length - 1?"Start": "Next",
                  style: const TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10.0,
      width: currentIndex == index ? 18 : 7,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6), color: Colors.black38),
    );
  }
}
