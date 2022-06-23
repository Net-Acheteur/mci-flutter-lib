import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as map_toolkit;
import 'package:mci_flutter_lib/config/mci_colors.dart';

class GoogleMapHelper {
  static Polygon createPolygon(String id, List<LatLng> coordinates) {
    return Polygon(
        polygonId: PolygonId(id),
        points: coordinates,
        strokeWidth: 2,
        strokeColor: MCIColors.secondary,
        fillColor: Colors.grey.withOpacity(0.3));
  }

  static Circle createCircle(String id, LatLng coordinates) {
    return Circle(
        circleId: CircleId(id),
        center: coordinates,
        radius: 1000,
        strokeWidth: 2,
        strokeColor: MCIColors.secondary,
        fillColor: Colors.grey.withOpacity(0.3));
  }

  static LatLng stringToLatLng(String stringToConvert) {
    if (stringToConvert.contains(',')) {
      String lat = stringToConvert.split(',')[0];
      String lng = stringToConvert.split(',')[1];
      return LatLng(double.parse(lat), double.parse(lng));
    } else {
      return const LatLng(0, 0);
    }
  }

  static LatLngBounds extendsBoundsByPercentage(LatLngBounds latLngBounds, double percentage) {
    double distanceLat = max(latLngBounds.southwest.latitude, latLngBounds.northeast.latitude) -
        min(latLngBounds.southwest.latitude, latLngBounds.northeast.latitude);
    double distanceLng = max(latLngBounds.southwest.longitude, latLngBounds.northeast.longitude) -
        min(latLngBounds.southwest.longitude, latLngBounds.northeast.longitude);
    double minLat = latLngBounds.southwest.latitude - (distanceLat * percentage);
    double minLng = latLngBounds.southwest.longitude - (distanceLat * percentage);
    double maxLat = latLngBounds.northeast.latitude + (distanceLng * percentage);
    double maxLng = latLngBounds.northeast.longitude + (distanceLng * percentage);
    if (minLat < -90) {
      minLat = -90;
    }
    if (minLng < -180) {
      minLng = -180;
    }
    if (maxLat > 90) {
      maxLat = 90;
    }
    if (maxLng > 180) {
      maxLng = 180;
    }
    return LatLngBounds(southwest: LatLng(minLat, minLng), northeast: LatLng(maxLat, maxLng));
  }

  static Future<LatLng> calculatePointFromGesture(
      double x, double y, GoogleMapController mapCtrl, bool isAndroid) async {
    if (isAndroid) {
      // HACK: on Android it's times 3
      x *= 3;
      y *= 3;
    }
    ScreenCoordinate screenCoordinate = ScreenCoordinate(x: x.round(), y: y.round());
    LatLng latLng = await mapCtrl.getLatLng(screenCoordinate);
    return latLng;
  }

  static bool isPointInsidePolygon(Polygon polygon, LatLng point) {
    return map_toolkit.PolygonUtil.containsLocation(map_toolkit.LatLng(point.latitude, point.longitude),
        polygon.points.map((e) => map_toolkit.LatLng(e.latitude, e.longitude)).toList(), true);
  }
}
