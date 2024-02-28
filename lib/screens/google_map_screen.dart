import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Google Map"),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        width: MediaQuery.of(context).size.width,
        height: 500,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(width: 3)
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: GoogleMap(
            initialCameraPosition: _pictLocation,
            compassEnabled: true,
            markers: Set<Marker>.of(_markers),
            mapType: MapType.terrain,
            onMapCreated: (GoogleMapController controller){
              _controller.complete(controller);
            },
          ),
        ),
      ),
    );
  }
}
