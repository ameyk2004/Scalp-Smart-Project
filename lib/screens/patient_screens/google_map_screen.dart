import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scalp_smart/colors.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/widget_support.dart';
import 'package:http/http.dart' as http;


class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({super.key});

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {


  static final CameraPosition _pictLocation = const CameraPosition(
    target: LatLng(18.461442656444465, 73.86496711190787),
    zoom: 14.4746,
  );

  final Latitude = 18.461442656444465;
  final Longitude = 73.86496711190787;
  final radius = 1000;
  final apikey = "AIzaSyAVv-fXnoWeN6LG3c7RqAXykXtIUq4scnE";
  List places = [];

  getCUrrentLocation()
  {

  }

  getNearbyPlaces() async
  {
    final url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location="+Latitude.toString()+","+Longitude.toString()+"&radius="+radius.toString()+"&types=dermatologist&keyword=skin%20clinic&key="+apikey;
    print(url);
    final response = await http.get(Uri.parse(url));

    if(response.statusCode == 200)
    {
        final data = jsonDecode(response.body);
        places = data["results"];

        for(int i=0;i<places.length ; i++)
          {
            var location = places[i]["geometry"]["location"];
            _markers.add( Marker(markerId: MarkerId("${2+i}"), position:  LatLng(location["lat"], location["lng"]),));
          }
    }

    setState(() {

    });
  }

  List<Marker> _markers = [];
  List <Marker> list = [
    Marker(markerId: MarkerId("1"), position:  LatLng(18.458814682594884, 73.85021653803034), infoWindow: InfoWindow(
      title: "This is PICT"
    )),

  ];

  String extractUrl(String input) {
    int hrefIndex = input.indexOf("href=\"");

    if (hrefIndex != -1) {
      int closingQuoteIndex = input.indexOf("\"", hrefIndex + 6);

      if (closingQuoteIndex != -1) {
        String url = input.substring(hrefIndex + 6, closingQuoteIndex);
        return url;
      }
    }
    return '';
  }

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
              height: 500,
              child: ListView.separated(
                itemCount: places.length, itemBuilder: (BuildContext context, int index) {


                  return NearbyDoctor(
                    clinicName: places[index]["name"] ?? "Default Clinic Name",
                    openNow: places[index]["opening_hours"]?["open_now"] ?? false,
                    mapUrl: extractUrl(places[index]["photos"]?[0]?["html_attributions"]?[0] ?? "https://www.google.com/maps/@18.5106432,73.9377152,12z?entry=ttu") ,
                  );
              }, separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: 15,);
              },


              ),
            ),
        
          ],
        ),
      ),
    );
  }
}

class NearbyDoctor extends StatelessWidget {
  final String clinicName;
  final bool openNow;
  final String mapUrl;
  const NearbyDoctor({
    super.key, required this.clinicName, required this.openNow, required this.mapUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      width: MediaQuery.of(context).size.width,
      height: 120,
      color: Colors.grey.shade200,

      child: Row(
        children: [
          Container(height: 120,width: 120,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage("https://static.vecteezy.com/system/resources/thumbnails/011/098/092/small_2x/hospital-clinic-building-3d-icon-illustration-png.png"),
              )
            ),
          ),

          SizedBox(width: 15,),
          
          Expanded(
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      Text(clinicName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600), textAlign: TextAlign.left, maxLines: 2,),
                    SizedBox(height: 5,),
                    Text(openNow ? "Open Now" : "Currently Closed", style: TextStyle(fontSize : 15, fontWeight : FontWeight.w500, color: openNow ? Colors.green : Colors.red),  ),
                    SizedBox(height: 8,),
                    Container(
                      height: 40,
                      width: 160,
                
                      decoration: BoxDecoration(color: appBarColor),

                      child: InkWell(
                        onTap: ()
                          {
                            launchUrl(Uri.parse(mapUrl), mode: LaunchMode.externalApplication);
                          },
                          child: Center(child: Text("View on Maps", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),))),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  widget({required Row child}) {}
}
