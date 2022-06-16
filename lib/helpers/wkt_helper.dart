import 'package:collection/collection.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class WKTHelper {
  static const polygonName = 'POLYGON';
  static const multiPolygonName = 'MULTIPOLYGON';

  static List<LatLng> _fromStringValuesToArrayLatLng(List<String> onlyValues) {
    List<LatLng> result = [];
    for (var value in onlyValues) {
      List<String> splitValue = value.trim().split(' ');
      result.add(LatLng(double.parse(splitValue[1]), double.parse(splitValue[0])));
    }
    return result;
  }

  static List<LatLng> convertWKTToArrayLatLng(String? wkt) {
    if (wkt != null && wkt.isNotEmpty) {
      try {
        List<String> onlyValues = wkt.split('((')[1].split('))')[0].split(',');
        return _fromStringValuesToArrayLatLng(onlyValues);
      } catch (_) {
        return [];
      }
    }
    return [];
  }

  static String convertArrayLatLngToWKT(List<LatLng> listOfLatLng) {
    if (listOfLatLng.isNotEmpty) {
      String result = '$polygonName((';

      listOfLatLng.forEachIndexed((index, latLng) {
        result += '${latLng.longitude} ${latLng.latitude}';
        if (index < (listOfLatLng.length - 1)) {
          result += ', ';
        }
      });
      result += '))';
      return result;
    }
    return '';
  }

  static List<List<LatLng>> convertWKTToMultiArrayLatLng(String? wkt) {
    if (wkt != null && wkt.isNotEmpty) {
      try {
        if (wkt.contains(multiPolygonName)) {
          List<String> polygons = wkt.split('((')..removeAt(0);
          polygons.first = polygons.first.substring(1);
          polygons.last = polygons.last.split(')))')[0];
          List<List<LatLng>> result = [];
          for (var poly in polygons) {
            if (poly.contains(')),')) {
              result.add(_fromStringValuesToArrayLatLng(poly.split(')),')[0].split(',')));
            } else {
              result.add(_fromStringValuesToArrayLatLng(poly.split(',')));
            }
          }
          return result;
        } else if (wkt.contains(polygonName)) {
          return List<List<LatLng>>.from([convertWKTToArrayLatLng(wkt)]);
        }
      } catch (_) {
        return [];
      }
    }
    return [];
  }
}
