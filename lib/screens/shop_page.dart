import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scalp_smart/details/hairCareProducts.dart';
import 'package:scalp_smart/screens/product_details_page.dart';
import 'package:scalp_smart/screens/self_assesment_page.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import '../colors.dart';
import 'package:http/http.dart' as http;

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final TextEditingController searchController = TextEditingController();

  final productTypes = [
    "All",
    "Hairfall",
    "Dandruff",
    "Hair Masks",
    "Volumize"
  ];
  String selectedType = "All";
  bool displaySearch = false;

  Future<void> getProducts()
  async {
    final response = await http.get(Uri.parse("https://pblproject-ljlp.onrender.com/product/api/"));
    if (response.statusCode == 200)
      {
        final products = jsonDecode(response.body);
        print(products);
      }


  }

  Future<void> _refresh() async {
    return await Future.delayed(Duration(seconds: 2));
  }

  @override
  void initState() {
    getProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LiquidPullToRefresh(
          onRefresh: _refresh,
          height: 250,
          animSpeedFactor: 1.5,
          color: appBarColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Visibility(
                  visible: displaySearch,
                  child: SizedBox(
                    height: 45,
                    child: TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        hintText: "Search Products",
                        prefixIcon: Icon(Icons.search),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1)),
                      ),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                      itemCount: productTypes.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedType = productTypes[index];
                              });
                            },
                            child: Chip(
                              label: productTypes[index] == selectedType
                                  ? Text(productTypes[index],
                                      style:
                                          const TextStyle(color: Colors.white))
                                  : Text(productTypes[index],
                                      style: const TextStyle()),
                              color: productTypes[index] == selectedType
                                  ? MaterialStateProperty.all(appBarColor)
                                  : MaterialStateProperty.all(Colors.white),
                            ),
                          ),
                        );
                      }),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 30,
                      crossAxisSpacing: 15,
                      childAspectRatio: 0.65,
                    ),
                    itemCount: products
                        .where((product) =>
                            selectedType == "All" ||
                            selectedType == product["category"])
                        .length,
                    itemBuilder: (context, index) {
                      var filteredProducts = products
                          .where((product) =>
                              selectedType == "All" ||
                              selectedType == product["category"])
                          .toList();
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ProductDetails(
                                product: filteredProducts[index]),
                          ));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 1.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  topLeft: Radius.circular(20),
                                ),
                                child: Hero(
                                    transitionOnUserGestures: true,
                                    tag: filteredProducts[index]["name"]!,
                                    child: Image(
                                        image: NetworkImage(
                                            filteredProducts[index]
                                                ["image"]!))),
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 6),
                                child: Text(
                                  filteredProducts[index]["name"]!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
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
                                        child: Text(
                                          "View Product",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  List Searchproducts = products;
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.arrow_back_ios));
  }

  @override
  Widget buildResults(BuildContext context) {
    List filteredProducts = [];
    for (var product in products) {
      if (product["name"]!.toLowerCase().contains(query.toLowerCase())) {
        filteredProducts.add(product);
      }
    }
    return ListView.builder(
        itemCount: filteredProducts.length,
        itemBuilder: (context, index) {
          var result = filteredProducts[index];
          return ListTile(
            title: Text(result["name"]!),
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List filteredProducts = [];
    for (var product in products) {
      if (product["name"]!.toLowerCase().contains(query.toLowerCase())) {
        filteredProducts.add(product);
      }
    }
    return ListView.separated(
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        var result = filteredProducts[index];
        return InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    ProductDetails(product: filteredProducts[index]),
              ));
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20)),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image(
                      image: NetworkImage(filteredProducts[index]["image"]!)),
                ),
                title: Text(
                  result["name"]!,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("Price : ${result["price"]!}"),
              ),
            ));
      },
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: 20,
        );
      },
    );
  }
}
