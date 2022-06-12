import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';



class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
static final _cameraPosition  = CameraPosition(
    target: LatLng(36.102232, 129.3897838),
    zoom: 20,
  );
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar:AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(onPressed: () {
            Navigator.of(context).pop();
          },
              icon : Icon(Icons.arrow_back, color: Color(0xff4262A0),)
          ),
        title: Image(image: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/thumb/5/57/HGU-Emblem-eng.svg/1024px-HGU-Emblem-eng.svg.png?20200507143923'),height: 50),
        
        centerTitle: true,
        elevation: 0,
      ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: _cameraPosition
        ),
      ),
    );
  }
}
