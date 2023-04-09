library mapbox_polyline_points;
import 'package:mapbox_polyline_points/src/utils/polyline_result.dart';
import 'package:mapbox_polyline_points/src/utils/request_enums.dart';
import 'src/point_lat_lng.dart';
import 'src/network_util.dart';

export 'src/utils/request_enums.dart';
export 'src/utils/polyline_waypoint.dart';
export 'src/network_util.dart';
export 'src/point_lat_lng.dart';
export 'src/utils/polyline_result.dart';

class MapboxPolylinePoints {
  NetworkUtil util = NetworkUtil();

  /// Get the list of coordinates between two geographical positions
  /// which can be used to draw polyline between this two positions
  ///
  Future<MapboxPolylineResult> getRouteBetweenCoordinates(
      String mapboxApiKey, PointLatLng origin, PointLatLng destination,
      {TravelType traveltype = TravelType.walking,}) async {
    return await util.getRouteBetweenCoordinates(
        mapboxApiKey,
        origin,
        destination,
        traveltype,);
  }

}