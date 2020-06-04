import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../RegistrationAndLogIn/RegistrationSecondPage.dart';

class ShowMap extends StatefulWidget {

  double latitude;
  double longitude;
  ShowMap(this.longitude,this.latitude);
  @override
  _ShowMapState createState() => _ShowMapState(this.longitude,this.latitude);
}

class _ShowMapState extends State<ShowMap> {

  double latitude;
  double longitude;
  _ShowMapState(this.longitude,this.latitude);

  Marker myMark;

  void _updatePosition(LatLng _position) {
    setState(() {
      myMark = myMark.copyWith(
          positionParam: LatLng(_position.latitude, _position.longitude)
      );
    });
  }


  @override
  initState(){
    myMark = Marker(
      markerId: MarkerId("myMarkId"),
      draggable: false,
      position: LatLng(latitude, longitude),
      onTap: (){},
    );
    super.initState();
  }

  GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Select Location'),
          backgroundColor: Colors.green[700],
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,size: 25,),
            onPressed: ()=> Navigator.pop(context),
          ),
        ),
        body: GoogleMap(
          mapType: MapType.normal,
          onMapCreated: (GoogleMapController controller) {
            mapController = controller;
          },
          initialCameraPosition: CameraPosition(
            target: LatLng(latitude,longitude),
            zoom: 17.0,
          ),
          onTap: _updatePosition,
          markers: Set.from([
            myMark,
          ]),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          compassEnabled: true,
          tiltGesturesEnabled: true,
          rotateGesturesEnabled: true,
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.pop(
              context,
              {
                "latitude": myMark.position.latitude,
                "longitude": myMark.position.longitude,
              },
            );
          },
          child: Icon(Icons.check,size: 40,),
          backgroundColor: Colors.pinkAccent,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}