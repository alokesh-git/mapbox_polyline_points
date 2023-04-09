import 'dart:convert';
import 'package:http/http.dart' as http;
import 'pointLatLng.dart';
import '../src/utils/request_enums.dart';
import 'utils/polyline_result.dart';

class NetworkUtil {
  static const String statusok = "ok";

  ///Get the encoded string from google directions api
  ///
  Future<MapboxPolylineResult> getRouteBetweenCoordinates(
      String mapboxApiKey,
      PointLatLng origin,
      PointLatLng destination,
      TravelType travelType,) async {
    String mode = travelType.toString().replaceAll('TravelType.', '');
    MapboxPolylineResult result = MapboxPolylineResult();
    Map<String,String> params = {
      "origin": "${origin.longitude}%2C${origin.latitude}",
      "destination": "${destination.longitude}%2C${destination.latitude}",
      "mode": mode,
      "key": mapboxApiKey
    };
       Uri uri =
        Uri.parse('https://api.mapbox.com/directions/v5/mapbox/${params['mode']}/${params['origin']}%3B${params['destination']}?alternatives=true&geometries=geojson&overview=full&steps=false&access_token=${params['key']}');

    var response = await http.get(uri);
    if (response.statusCode == 200) {
      var parsedJson = json.decode(response.body);
      result.status = parsedJson["code"];
      if (parsedJson["status"]?.toLowerCase() == statusok &&
          parsedJson["routes"] != null &&
          parsedJson["routes"].isNotEmpty) {
             for (var i = 0; i < parsedJson["routes"].length; i++) {
             result.points.add(decodeEncodedPolyline(
            parsedJson["routes"][i]["geometry"]["coordinates"]));
          }
       
      }}

    return result;
  }
 List<PointLatLng> decodeEncodedPolyline(List<dynamic> encoded) {
    List<PointLatLng> poly = [];
    for (var i = 0; i < encoded.length; i++) {
      poly.add(PointLatLng(longitude: encoded[i][0], latitude: encoded[i][1]));
    }
    return poly;
  }
}