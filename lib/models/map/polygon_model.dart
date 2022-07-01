import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolygonModel {
  final List<LatLng> polygon;
  final List<List<LatLng>> holes;

  const PolygonModel({this.polygon = const [], this.holes = const []});
}
