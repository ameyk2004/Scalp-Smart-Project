import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:scalp_smart/auth/authServices.dart';
import 'package:scalp_smart/colors.dart';
import 'package:scalp_smart/details/caraouselVideoLinks.dart';
import 'package:scalp_smart/details/stage_info_details.dart';
import 'package:scalp_smart/screens/chat_bot_screen.dart';
import 'package:scalp_smart/screens/login_page.dart';
import 'package:scalp_smart/screens/shop_page.dart';
import 'package:scalp_smart/screens/self_assesment_page.dart';
import 'package:scalp_smart/widgets/loadingScreen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../details/userInfo.dart';
import '../widgets/gridStageContainer.dart';
import '../widgets/menuDrawer.dart';
import '../widgets/product_home_card.dart';
import 'doctorDetails.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final AuthService authService = AuthService();

  int selectedPage = 0;
  String profile_pic = userDetails["profile_pic"]!;

  navigateTo(int index) {
    setState(() {
      selectedPage = index;
    });
  }

  final List<Widget> pages = [
    HomePageBody(),
    SelfAssessmentPage(),
    ShopPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        leadingWidth: 90,

        leading: Builder(

          builder: (BuildContext context) {
            return InkWell(
              onTap: () {

                Scaffold.of(context).openDrawer();

              },
              child: Container(

                width: 5,

                margin: EdgeInsets.only(left: 30),

                decoration: BoxDecoration(
                  image: DecorationImage(image: NetworkImage(profile_pic), fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            );
          },

        ),

        title: Text(
          "Scalp Smart",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: MediaQuery
              .sizeOf(context)
              .width * 0.055),
        ),
        centerTitle: false,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>DoctorDetailsPage()));
              },
              icon: const Icon(
                Icons.message_outlined,
                color: appBarColor,
                size: 35,
              )),
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatBotPage()));
              },
              icon: const Icon(
                Icons.graphic_eq_sharp,
                color: appBarColor,
                size: 35,
              )),
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: CustomSearchDelegate());
              },
              icon: const Icon(
                Icons.search,
                color: appBarColor,
                size: 35,
              )),
        ],
      ),

      drawer: CustomMenuDrawer(profile_pic: profile_pic, userName: authService.getCurrentUser()!.email!,),

      body: pages[selectedPage],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedPage,
        backgroundColor: Colors.grey.shade300,
        onTap: navigateTo,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        items: [
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(Icons.home, size: 30,),
          ),
          BottomNavigationBarItem(
            label: "Predict",
            icon: Container(
              width: 80,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [

                      appBarColor,
                      Colors.deepPurple.shade300,

                    ]

                ),
                  borderRadius: BorderRadius.circular(25)),

                child: Icon(Icons.insights_outlined, color: Colors.white,size: 30,)
            ),
          ),
          BottomNavigationBarItem(
              label: "Shop",
              icon: Icon(Icons.shopping_bag,size: 30,)

          ),
        ],
      ),
    );
  }
}

class HomePageBody extends StatelessWidget {
  const HomePageBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),


            CarouselSlider(
                items: [0, 1, 2, 3].map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return InkWell(
                        onTap: () async {
                          final url = Uri.parse((videoLinks[i]["url"]!));

                          await launchUrl(
                              url, mode: LaunchMode.externalApplication);
                        },
                        child: Stack(
                            children: [

                              Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 5.0),
                                decoration: BoxDecoration(
                                    color: buttonColor,
                                    image: DecorationImage(image: AssetImage(
                                        videoLinks[i]["imageAddr"]!))
                                ),
                              ),


                              // Center(child: Icon(Icons.play_circle_fill_outlined, size: 50, color: buttonColor,),),
                            ]
                        ),
                      );
                    },
                  );
                }).toList(),
                options: CarouselOptions(
                  height: 200,
                  viewportFraction: 1,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(
                      milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.3,
                  scrollDirection: Axis.horizontal,
                )
            ),


            const SizedBox(height: 15,),


            const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Stages of Hairloss",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                )),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: MediaQuery
                  .sizeOf(context)
                  .shortestSide,
              child: GridView.count(
                shrinkWrap: true,
                primary: false,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 2,
                children: <Widget>[
                  gridStageContainer(
                    stageName: "Normal",
                    imagePath: "assets/images/Normal.png",
                    stageInfo: stage_info["normal"]!["description"]!,
                  ),
                  gridStageContainer(
                    stageName: "Stage 1",
                    imagePath: stage_info["stage 1"]!["imageAddr"]!,
                    stageInfo: stage_info["stage 1"]!["description"]!,
                  ),

                  gridStageContainer(
                    stageName: "Stage 2",
                    imagePath: stage_info["stage 2"]!["imageAddr"]!,
                    stageInfo: stage_info["stage 2"]!["description"]!,
                  ),
                  gridStageContainer(
                      stageName: "Stage 3",
                      imagePath: stage_info["stage 3"]!["imageAddr"]!,
                      stageInfo: stage_info["stage 3"]!["description"]!),
                ],
              ),
            ),
            const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Top Selling Products",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                )),

            const SizedBox(height: 10,),

            SizedBox(
              height: 290,
              child: ListView.builder(
                  itemCount: 6,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) =>
                      Container(
                        margin: const EdgeInsets.only(right: 20),
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.4,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1),
                          borderRadius: BorderRadius.circular(20),
                        ),

                        child: ProductHomeCard(index: index,),

                      )
              ),
            ),

          ],
        ),
      ),
    );
  }
}


