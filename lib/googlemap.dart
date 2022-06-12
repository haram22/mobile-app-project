import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';



class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

 static final CameraPosition _place = CameraPosition(
    target: LatLng(37.0812124, 126.81445959999998),
    zoom: 14.4746,
  );
//   List<Marker> _markers = [];
//   void initState() {
//    super.initState();
//    _markers.add(Marker(
//        markerId: MarkerId("1"),
//        draggable: true,
//        onTap: () => print("Marker!"),
//        position: LatLng(37.4537251, 126.7960716)));
//  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar:AppBar(
        backgroundColor: Colors.white,

        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Color(0xff4262A0)),
          onPressed: () {
            Navigator.pop(context,true);
          },
        ),

        title: Image(image: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/thumb/5/57/HGU-Emblem-eng.svg/1024px-HGU-Emblem-eng.svg.png?20200507143923'),height: 50),
        actions: [
          IconButton(onPressed: () {

          },
              icon : Icon(Icons.search, color: Color(0xff4262A0),)
          )
        ],
        centerTitle: true,
        elevation: 0,
      ),
        body: GoogleMap(
//           onMapCreated: _onMapCreated,
//           initialCameraPosition: CameraPosition(
//             target: _center,
//             zoom: 11.0,
//           ),
          myLocationButtonEnabled: false,
          // markers: Set.from(_markers),
          onMapCreated: _onMapCreated,
          initialCameraPosition: _place
        ),
      ),
    );
  }
}
