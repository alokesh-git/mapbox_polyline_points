library mapbox_polyline_points;
import 'dart:convert';
import 'package:http/http.dart' as http;

enum TravelType { driving, cycling, traffic, walking }

class MapboxpolylinePoints {
  static const String STATUS_OK = "ok";

  ///Get the encoded string from google directions api
  ///
  Future<MapboxPolylineResult> getRouteBetweenCoordinates(
    String mapboxApiKey,
    PointLatLng origin,
    PointLatLng destination,
    TravelType travelMode,
  ) async {
    String mode = travelMode.toString().replaceAll('TravelType.', '');
    MapboxPolylineResult result = MapboxPolylineResult();
    Map<String, String> params = {
      "origin": "${origin.longitude}%2C${origin.latitude}",
      "destination": "${destination.longitude}%2C${destination.latitude}",
      "mode": mode,
      "key": mapboxApiKey
    };
    Uri uri = Uri.parse(
        'https://api.mapbox.com/directions/v5/mapbox/${params['mode']}/${params['origin']}%3B${params['destination']}?alternatives=true&geometries=geojson&overview=full&steps=false&access_token=${params['key']}');

    http.Response response = await http.get(uri);
    if (response.statusCode == 200) {
      var parsedJson = json.decode(response.body);
      result.status = parsedJson["code"];
      if (parsedJson["code"]?.toLowerCase() == STATUS_OK &&
          parsedJson["routes"] != null &&
          parsedJson["routes"].isNotEmpty) {
        for (var i = 0; i < parsedJson["routes"].length; i++) {
          result.points.add(decodeEncodedPolyline(
              parsedJson["routes"][i]["geometry"]["coordinates"]));
        }
      }
    }
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

class PointLatLng {
  /// The latitude in degrees.
  final double latitude;

  /// The longitude in degrees
  final double longitude;
  const PointLatLng({required this.latitude, required this.longitude});

  @override
  String toString() {
    return "lat: $latitude / longitude: $longitude";
  }
}

/// description:
/// project: flutter_polyline_points
/// @package:
/// @author: dammyololade
/// created on: 13/05/2020
class MapboxPolylineResult {
  /// the api status retuned from google api
  ///
  /// returns OK if the api call is successful
  String? status;

  /// list of decoded points
  List<List<PointLatLng>> points = [];

  /// the error message returned from google, if none, the result will be empty
  String? errorMessage;

  MapboxPolylineResult(
      {this.status, this.errorMessage = ""});
}

