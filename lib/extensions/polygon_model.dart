import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mci_flutter_lib/mci_flutter_lib.dart';

extension PolygonModelExtension on PolygonModel {
  LatLngBounds getBoundingBox(double radius, double minPaddingPercent) {
    return polygon.getBoundingBox(radius, minPaddingPercent);
  }
}

extension PolygonModelListExtension on List<PolygonModel> {
  LatLngBounds getBoundingBox(double radius, double minPaddingPercent) {
    LatLngBounds result = first.getBoundingBox(radius, minPaddingPercent);
    forEach((element) {
      LatLngBounds tempLatLngBounds = element.getBoundingBox(radius, minPaddingPercent);

      result = LatLngBounds(
          southwest: LatLng(min(result.southwest.latitude, tempLatLngBounds.southwest.latitude),
              min(result.southwest.longitude, tempLatLngBounds.southwest.longitude)),
          northeast: LatLng(max(result.northeast.latitude, tempLatLngBounds.northeast.latitude),
              max(result.northeast.longitude, tempLatLngBounds.northeast.longitude)));
    });

    return result;
  }
}
