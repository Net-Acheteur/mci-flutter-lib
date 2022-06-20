import 'dart:math';

import 'package:geo/geo.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';

extension LatLngListExtensions on List<LatLng> {
  ///Gets a bounding box around the given points, with a buffer (radius) in km
  ///If a minPaddingPercent is provided, ensures that there is at least minPaddingPercent
  ///of the strict bounding box around the points, between this strict bounding box and the final bounding box
  LatLngBounds getBoundingBox(double radius, double minPaddingPercent) {
    LatLng maxNELatLng;
    LatLng minSWLatLng;
    var isFirst = true;

    if (isEmpty) {
      return LatLngExtensions.defaultCoordinates.getBoundingBox(radius);
    } else if (length == 1) {
      return first.getBoundingBox(radius);
    }

    maxNELatLng = first;
    minSWLatLng = first;

    for (var coord in this) {
      if (isFirst) {
        isFirst = false;
        continue;
      }

      maxNELatLng = LatLng(max(maxNELatLng.latitude, coord.latitude), max(maxNELatLng.longitude, coord.longitude));
      minSWLatLng = LatLng(min(minSWLatLng.latitude, coord.latitude), min(minSWLatLng.longitude, coord.longitude));
    }

    var neBound = maxNELatLng.getBoundingBox(radius).northeast;
    var swBound = minSWLatLng.getBoundingBox(radius).southwest;

    if (minPaddingPercent > 0.0) {
      var minLatPadding = (maxNELatLng.latitude - minSWLatLng.latitude) * minPaddingPercent / 100;
      var minLonPadding = (maxNELatLng.longitude - minSWLatLng.longitude) * minPaddingPercent / 100;

      if (neBound.latitude - maxNELatLng.latitude < minLatPadding) {
        neBound = LatLng(maxNELatLng.latitude + minLatPadding, neBound.longitude);
        swBound = LatLng(minSWLatLng.latitude - minLatPadding, swBound.longitude);
      }

      if (minSWLatLng.longitude - swBound.longitude < minLonPadding) {
        neBound = LatLng(neBound.latitude, maxNELatLng.longitude + minLonPadding);
        swBound = LatLng(swBound.latitude, minSWLatLng.longitude - minLonPadding);
      }
    }

    return LatLngBounds(northeast: neBound, southwest: swBound);
  }
}

extension LatLngListListExtensions on List<List<LatLng>> {
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

extension LatLngExtensions on LatLng {
  static LatLng defaultCoordinates = const LatLng(48.86063415166791, 2.346286181237024);

  ///Gets a bounding box around the given point, with a buffer (radius) in km
  LatLngBounds getBoundingBox(double radius) {
    var distToSquareAngle = sqrt(2 * pow(radius, 2)) * 1000;

    var northeastLatLon = geo.computeOffset(geo.LatLng(latitude, longitude), distToSquareAngle, 45);
    var southwestLatLon = geo.computeOffset(geo.LatLng(latitude, longitude), distToSquareAngle, 225);

    return LatLngBounds(
        northeast: LatLng(northeastLatLon.lat.toDouble(), northeastLatLon.lng.toDouble()),
        southwest: LatLng(southwestLatLon.lat.toDouble(), southwestLatLon.lng.toDouble()));
  }

  String toXrmString() {
    return '$latitude,$longitude';
  }

  double distanceFromLatLng(LatLng other) {
    double p = 0.017453292519943295;
    double a = 0.5 -
        cos((other.latitude - latitude) * p) / 2 +
        cos(latitude * p) * cos(other.latitude * p) * (1 - cos((other.longitude - longitude) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}
