import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../colors.dart';



class ProductDetails extends StatelessWidget {
  final product;
  const ProductDetails({super.key, this.product});


  double _calculateFontSize(String text, double containerWidth) {
    final double defaultFontSize = 20.0;
    final double tolerance = 10.0;

    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: defaultFontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: containerWidth);

    if (textPainter.width > containerWidth + tolerance) {
      // If text overflows, calculate font size to fit inside the container
      return (containerWidth / textPainter.width) * defaultFontSize;
    } else {
      // If no overflow, return the default font size
      return defaultFontSize;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: FittedBox(
            child: Text(
              product["brand"]!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
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
          ]),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Hero(
                      tag : product["name"]! ,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        height: MediaQuery.of(context).size.width,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1.5),
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                                image: NetworkImage(product["image"]!),
                                fit: BoxFit.cover)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 28.0, right: 30.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: appBarColor,
                          size: 27,
                        ),
                        const SizedBox(
                          width: 10,
                        ),

                        product["best seller"]! == "true" ?
                        Container(
                            decoration: BoxDecoration(
                                color: appBarColor,
                                borderRadius: BorderRadius.circular(6)),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 6),
                              child: Text(
                                "Best Seller",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            )) : const SizedBox.shrink(),
                        const Spacer(
                          flex: 1,
                        ),
                        const Icon(
                          Icons.thumb_up_alt_outlined,
                          color: appBarColor,
                          size: 27,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        IconButton(
                          icon :  Icon(
                            Icons.share_outlined,
                            color: appBarColor,
                            size: 27,
                          ), onPressed: () {

                            Share.shareUri(Uri.parse(product["url"]!));

                        },
                        ),
                      ],
                    ),
                  ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  //
                  // Center(
                  //   child: RatingBar.builder(
                  //
                  //       allowHalfRating: true,
                  //       glowColor: appBarColor,
                  //       glowRadius: 1,
                  //
                  //       itemBuilder: (context, _)=>Icon(Icons.star, color: buttonColor,), onRatingUpdate: (rating){}),
                  // ),

                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        product["name"]!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: _calculateFontSize(product["name"]!, MediaQuery.of(context).size.width),
                        ),
                        maxLines: 1,
                        textScaler: TextScaler.noScaling, // Ensures text size is not affected by the system's font size settings
                      ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    padding: const EdgeInsets.all(14),
                    width: double.infinity,
                    height: 140,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(width: 1)),
                    child: SingleChildScrollView(
                      child: Text(
                        product["Description"],
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color.fromRGBO(225, 226, 227, 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Price : ${product["price"]}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                  ),
                ),
                const SizedBox(height: 10,),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 22.0),
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final url = Uri.parse(product["url"]);
                        await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(buttonColor),
                        foregroundColor: MaterialStateProperty.all(Colors.white),
                      ),
                      icon: const Icon(Icons.shopping_bag),
                      label:  Text(
                        "Buy Product",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),



        ],



      ),
    );
  }
}
