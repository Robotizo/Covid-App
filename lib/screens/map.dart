import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';



class MapPage extends StatefulWidget {


  @override
  Map createState() => Map();

}


class Map extends State<MapPage> {


  //Variables Start
    GoogleMapController _controller;
    static const LatLng _kelowna = const LatLng(49.887951, -119.496010);
    static const LatLng _kelownatwo = const LatLng(49.8864986, -119.5006121);
    static const LatLng _kelownathree = const LatLng(49.8864986, -119.51);
    List<Marker> marker1 = [];
    

  
  //Variables End

  //Methods Start


    void mapCreated(controller) {
      setState(() {
        _controller = controller;
      });
    }


    void initState(){
      _getLocation();
      super.initState();

    }


    Future<void> _getLocation() async {
      var currentLocation = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      setState(() {
  
        marker1.add(
          Marker(
            markerId: MarkerId('myMarkerPos'),
            draggable: true, 
            onTap: () {
            
              print("Tapped");
            },
       
            position: LatLng(currentLocation.latitude, currentLocation.longitude),
            infoWindow: InfoWindow(
              title: "Test",
      
            )
          )

        );

        _controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(currentLocation.latitude, currentLocation.longitude),
              zoom: 11.0,
            )
          )
        );

      });

    }




    void addMarker(){
      setState(() {
        marker1.add(Marker(
          markerId: MarkerId('myMarker2'),
          draggable: true, 
          onTap: () {
            print("Marker taped");
          },
          position: _kelownathree,
        ));
  
      });

    }

    void removeMarker(){
      setState(() {
        marker1.remove(Marker(
          markerId: MarkerId('myMarker2'),
        ));
      });

    }


    Widget mapArea(){
      return GoogleMap(
        onMapCreated: mapCreated,
        initialCameraPosition: CameraPosition(
          target: _kelowna,
          zoom: 5.0,
        ),
        myLocationButtonEnabled: false,
        myLocationEnabled: true,
        markers: Set.from(marker1), 
      );
    }


  //Methods End




  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(

        body: Stack(
          children: <Widget>[
              mapArea(),
          ],

        ),


       
        floatingActionButton: FloatingActionButton.extended(
          onPressed: (){
            debugPrint("done");
            _getLocation();
          },

          tooltip: "Get Location",
          label: Text(
              'Location',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            
          icon: Icon(Icons.my_location, color: Colors.black),
          backgroundColor: Color.fromRGBO(255, 153, 51, 1),
        ),
        


      ),
    );
  }
}