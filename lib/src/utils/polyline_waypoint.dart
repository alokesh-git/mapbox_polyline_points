/// description:
/// project: mapbox_polyline_points
/// @package:
/// @author: dammyololade
/// created on: 08/04/2023
class PolylineWayPoint {
  /// the location of the waypoint,
  /// You can specify waypoints using the following values:
  /// --- Latitude/longitude coordinates (lat/lng): an explicit value pair. (-34.92788%2C138.60008 comma, no space),
  /// --- Place ID: The unique value specific to a location. This value is only available only if
  ///     the request includes an API key or mapbox Maps 
  /// ---
  String location;

  /// is a boolean which indicates that the waypoint is a stop on the route,
  /// which has the effect of splitting the route into two routes
  bool stopOver;

  PolylineWayPoint({required this.location, this.stopOver = true});

  @override
  String toString() {
    if (stopOver) {
      return location;
    } else {
      return "via:$location";
    }
  }
}