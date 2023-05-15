# mapbox_polyline_points
A flutter plugin that allow you to user mapbox direction api into google map 

<div style="text-align: center"><table><tr>
  <td style="text-align: center">
  <a href="https://raw.githubusercontent.com/alokesh-git/mapbox_polyline_points/main/WhatsApp%20Image%202023-04-09%20at%2012.43.33%20PM.jpeg">
    <img src="https://raw.githubusercontent.com/alokesh-git/mapbox_polyline_points/main/WhatsApp%20Image%202023-04-09%20at%2012.43.33%20PM.jpeg" width="200"/></a>
</td>
</tr></table></div>

## Getting Started
This package contains List of List coordinates that allow you to more that one routes

## Usage
To use this package, add mapbox_polyline_points as a [dependency in your pubspec.yaml file](https://flutter.dev/docs/development/packages-and-plugins/using-packages).

## Import the package
```dart
import 'package:mapbox_polyline_points/mapbox_polyline_points.dart';
```

## method
Get the list of points by Geo-coordinate, this return an instance of MapboxPolylineResult, which
contains the status of the api, the errorMessage, and the list of decoded points.
```dart
MapboxPolylinePoints mapboxPolylinePoints = MapboxPolylinePoints();
MapboxPolylineResult result = await mapboxPolylinePoints.getRouteBetweenCoordinates(mapboxAPiKey,
        _originLatitude, _originLongitude, _destLatitude, _destLongitude);
print(result.points);
```
## example
```dart
import 'dart:convert';
import 'package:barbar_saloon/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapbox_polyline_points/mapbox_polyline_points.dart';

const LatLng _currentPosition = LatLng(28.6817149, 77.0534036);
const LatLng _currentPosition1 = LatLng(28.6277039, 77.1424405);
const LatLng _currentPosition2 = LatLng(40.698432, -73.924038);
const LatLng _currentPosition3 = LatLng(28.6730915, 77.0384241);
const LatLng _currentPosition4 = LatLng(28.6730915, 77.0384241);

class MapScreen extends StatefulWidget {
  static const String routerName = "/map_screen";
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<Marker>? _markers = [];
  bool? _serviceEnabled;
  late Position _locationData;
  LatLng? _center;
  List<List<LatLng>> polylineCoordinates = [];
  GoogleMapController? mapController;
   Map<PolylineId, Polyline> polylines = {};
  MapboxPolylinePoints mapboxpolylinePoints = MapboxPolylinePoints();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _determinePosition();
  }


  void _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.');
  } 

   _locationData = await Geolocator.getCurrentPosition();
   _getPolyline();
   setState(() {
     _center = LatLng(_locationData.latitude, _locationData.longitude);
   });
}
_addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,width: 5, color: Colors.greenAccent, points: polylineCoordinates[0]);
    polylines[id] = polyline;
    setState(() {});
  }
 void _getPolyline() async {
    MapboxPolylineResult result = await mapboxpolylinePoints.getRouteBetweenCoordinates(
        'pk.eyJ1IjoiYWxva2phZGhhdiIsImEiOiJjbGNnNGQxZGUwcmNiM3lrNTM3YjFnaWc4In0.4sdA4V90-ZAsGyxKxuNLiw',
        PointLatLng(latitude: _locationData.latitude,longitude:  _locationData.longitude),
        PointLatLng(latitude: _currentPosition.latitude, longitude: _currentPosition.longitude),
        TravelType.walking
        );
    if (result.points.isNotEmpty){
      for (List<PointLatLng> element in result.points) {
         polylineCoordinates.add(decodeEncodedPolyline(element));
        }
      
    }
    _addPolyLine();
  }
    List<LatLng> decodeEncodedPolyline(List<PointLatLng> encoded) {
    List<LatLng> poly = [];
    for (int i = 0; i < encoded.length; i++) {
      poly.add(LatLng(encoded[i].latitude,encoded[i].longitude));
    }
    return poly;
  }


  List<Map> listSaloon = [
    {
      "image": "assets/images/outlate.jpg",
      "shop-name": "Afzal Cutting and sallon",
      "name": "Afzal khan",
      "distance": "14km"
    },
    {
      "image": "assets/images/outlet2.jpg",
      "shop-name": "Afzal Cutting and sallon",
      "name": "Afzal khan",
      "distance": "14km"
    },
    {
      "image": "assets/images/outlet3.jpg",
      "shop-name": "Afzal Cutting and sallon",
      "name": "Afzal khan",
      "distance": "14km"
    },
    {
      "image": "assets/images/outlet4.jpg",
      "shop-name": "Afzal Cutting and sallon",
      "name": "Afzal khan",
      "distance": "14km"
    },
    {
      "image": "assets/images/outlet5.jpg",
      "shop-name": "Afzal Cutting and sallon",
      "name": "Afzal khan",
      "distance": "14km"
    },
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: (_center == null)
            ? const Center(child: CircularProgressIndicator())
            : SizedBox(
                width: size.width,
                height: size.height,
                child: Stack(
                  children: [
                    SizedBox(
                      width: size.width,
                      height: size.height,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: _center!,
                          zoom: 16,
                        ),
                        onMapCreated: (controller) async {
                          mapController = controller;
                          var currentMarker = await BitmapDescriptor.fromAssetImage(
                                  ImageConfiguration.empty,
                                  "assets/images/location.png");
                          var markerIcon =
                              await BitmapDescriptor.fromAssetImage(
                                  ImageConfiguration.empty,
                                  "assets/images/locations.png");
                          _markers = [
                            Marker(
                                markerId: const MarkerId("djf0"),
                                position: LatLng(_locationData.latitude,
                                    _locationData.longitude),
                                    icon: currentMarker,
                                onTap: () {
                                  _center = LatLng(_locationData.latitude,
                                      _locationData.longitude);
                                  setState(() {});
                                }),
                            Marker(
                              markerId: const MarkerId("djf"),
                              position: _currentPosition,
                              icon: markerIcon,
                              onTap: () {
                                _center = _currentPosition;
                                setState(() {});
                              },
                            ),
                            Marker(
                              markerId: const MarkerId("djf1"),
                              position: _currentPosition1,
                              icon: markerIcon,
                              onTap: () {
                                _center = _currentPosition1;
                                setState(() {});
                              },
                            ),
                            Marker(
                              markerId: const MarkerId("djf2"),
                              position: _currentPosition2,
                              icon: markerIcon,
                              onTap: () {
                                _center = _currentPosition2;
                                setState(() {});
                              },
                            ),
                            Marker(
                              markerId: const MarkerId("djf3"),
                              position: _currentPosition3,
                              icon: markerIcon,
                              onTap: () {
                                _center = _currentPosition3;
                                setState(() {});
                              },
                            ),
                            Marker(
                              markerId: const MarkerId("djf5"),
                              position: _currentPosition4,
                              icon: markerIcon,
                              onTap: () {
                                _center = _currentPosition4;
                                setState(() {});
                              },
                            ),
                          ];
                          setState(() {});
                        },
                        markers: _markers!.asMap().values.toSet(),
                        myLocationButtonEnabled: true,
                        polylines: Set<Polyline>.of(polylines.values),
                      ),
                    ),
                    Positioned(
                      bottom: 4,
                      left: 0,
                      child: SizedBox(
                        width: size.width,
                        height: size.height * 0.15,
                        child: ListView.builder(
                          itemCount: listSaloon.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => InkWell(
                            onTap: () => _getPolyline(),
                            child: Container(
                              width: size.width * 0.35,
                              height: size.height * 0.15,
                              margin: EdgeInsets.symmetric(horizontal: 8.0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(2.5, 2.5),
                                      blurRadius: 5,
                                      color: shadowcolor,
                                    )
                                  ]),
                              child: Flex(
                                direction: Axis.vertical,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: Image.asset(
                                        listSaloon[index]["image"],
                                        fit: BoxFit.fitWidth,
                                      )),
                                  Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                    Text(listSaloon[index]["shop-name"],
                                        style: TextStyle(fontSize: 10.0,fontWeight: FontWeight.w600,color:blackcolor)),
                                    
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(listSaloon[index]["name"],
                                        style: TextStyle(fontSize: 8.0,fontWeight:FontWeight.w400,color:blackcolor)),
                                        Row(
                                          children: [
                                            Icon(Icons.directions_walk,size: 10,),
                                            Text(listSaloon[index]["distance"],
                                                style: TextStyle(
                                                    fontSize: 8.0,
                                                    fontWeight: FontWeight.w600,color: blackcolor))
                                          ],
                                        ),
                                      ],
                                    ),
                                  ]))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 30,
                      left:10,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: blackcolor,
                          backgroundColor: Colors.white.withOpacity(0.2)
                        ),
                        onPressed: (){
                          Navigator.pop(context);
                        }, icon: const Icon(Icons.arrow_back), label: const Text('back')))
                  ],
                ),
              ));
  }
}


// also you can add distance and durations and result is a instance of MapboxPolylineResult

double distance = (result.distance[0].floor()) / 1000;
print(distance);

 double seconds = result.distance[0];
  
  // Convert the seconds to a Duration object
  Duration duration = Duration(seconds: seconds.toInt());
  
  // Extract the hours, minutes, and remaining seconds from the Duration
  int hours = duration.inHours;
  int minutes = duration.inMinutes.remainder(60);
  int remainingSeconds = duration.inSeconds.remainder(60);
  
  // Print the result
  print('$hours hours $minutes minutes $remainingSeconds seconds');
```

## Hint
kindly ensure you use a valid mapbox direction api key,  
[If you need help generating direction api key for your project click this link](https://docs.mapbox.com/playground/directions/)