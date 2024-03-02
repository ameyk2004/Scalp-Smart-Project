import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scalp_smart/colors.dart';

import '../../widgets/widget_support.dart';
import 'package:http/http.dart' as http;


class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({super.key});

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {


  static final CameraPosition _pictLocation = const CameraPosition(
    target: LatLng(18.458814682594884, 73.85021653803034),
    zoom: 14.4746,
  );

  final Latitude = 18.458814682594884;
  final Longitude = 73.85021653803034;
  final radius = 50;
  final apikey = "AIzaSyAVv-fXnoWeN6LG3c7RqAXykXtIUq4scnE";

  getCUrrentLocation()
  {
  }

  getNearbyPlaces() async
  {
    final url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location="+Latitude.toString()+","+Longitude.toString()+"&radius="+radius.toString()+"&types=dermatologist&key="+apikey;
    print(url);
    final response = await http.get(Uri.parse(url));

    if(response.statusCode == 200)
    {
        print(response.body);
    }
  }

  List<Marker> _markers = [];
  List <Marker> list = [
    Marker(markerId: MarkerId("1"), position:  LatLng(18.458814682594884, 73.85021653803034), infoWindow: InfoWindow(
      title: "This is PICT"
    )),

  ];


  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    _markers.addAll(list);
    getNearbyPlaces();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height/2,
              child: Stack(
        
                children: [
                  GoogleMap(
                    initialCameraPosition: _pictLocation,
                    compassEnabled: true,
                    markers: Set<Marker>.of(_markers),
                    mapType: MapType.terrain,
                    onMapCreated: (GoogleMapController controller){
                      _controller.complete(controller);
                    },
                  ),
                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.0),
                      child: Row(
                        children: [
                          InkWell(onTap : () {Navigator.of(context).pop();}, child: Icon(Icons.arrow_back_ios)),
                          Expanded(
                            child: TextField(
                              style : AppWidget.boldTextStyle(),
                            
                              decoration: InputDecoration(
                                filled: true,
                                constraints: BoxConstraints(maxHeight: 50 ,maxWidth: double.infinity),
                                hintStyle: TextStyle(fontWeight: FontWeight.normal),
                                prefixIcon: Icon(Icons.search),
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: appBarColor), borderRadius: BorderRadius.circular(15)),
                                focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 2, color: appBarColor),borderRadius: BorderRadius.circular(15)),
                                hintText: "Search",
                                fillColor: Colors.white
                              ),
                            
                              ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        
        
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              color: appBarColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                    child: Text("Nearby Dermatologists", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),)),
              ),
            ),
        
            Container(
              height: MediaQuery.of(context).size.height/2-50,
              child: ListView(
              children: [
                NearbyDoctor(),
                SizedBox(height: 10,),
                NearbyDoctor(),
                SizedBox(height: 10,),
                NearbyDoctor(),
                SizedBox(height: 10,),
                NearbyDoctor(),
                SizedBox(height: 10,),
                NearbyDoctor(),
              ],
              ),
            ),
        
          ],
        ),
      ),
    );
  }
}

class NearbyDoctor extends StatelessWidget {
  const NearbyDoctor({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      width: MediaQuery.of(context).size.width,
      height: 90,
      color: Colors.grey.shade200,
    );
  }
}
