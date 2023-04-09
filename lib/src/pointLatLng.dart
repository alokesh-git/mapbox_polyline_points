/// A pair of latitude and longitude coordinates, stored as degrees.
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