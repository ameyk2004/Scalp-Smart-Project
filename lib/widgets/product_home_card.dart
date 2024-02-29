import 'package:flutter/material.dart';
import 'package:scalp_smart/screens/patient_screens/product_details_page.dart';

import '../colors.dart';
import '../services/details/hairCareProducts.dart';

class ProductHomeCard extends StatelessWidget {
  final int index;

  const ProductHomeCard({
    super.key, required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductDetails(product: products[index],)));
      },
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            ),
            child: Hero(
              tag: products[index]["name"]!,
                child: Image(image: NetworkImage(products[index]["image"]!))),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(products[index]["name"]!, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 30,
                decoration: const BoxDecoration(
                  color: buttonColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: const SizedBox(
                  width: double.infinity,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("View Product", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
