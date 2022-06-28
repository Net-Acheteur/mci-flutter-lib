import 'package:collection/collection.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mci_flutter_lib/models/map/polygon_model.dart';

class WKTHelper {
  static const polygonName = 'POLYGON';
  static const multiPolygonName = 'MULTIPOLYGON';

  /// Get a list of LatLng from a list of string
  /// ex: '43.98394 3.3400', '43.98394 3.3400', '43.98394 3.3400'
  static List<LatLng> _fromStringValuesToArrayLatLng(List<String> onlyValues) {
    List<LatLng> result = [];
    for (var value in onlyValues) {
      List<String> splitValue = value.trim().split(' ');
      result.add(LatLng(double.parse(splitValue[1]), double.parse(splitValue[0])));
    }
    return result;
  }

  /// First of the list is the polygon
  /// Others are the holes
  static List<List<LatLng>> convertWKTToArrayLatLng(String? wkt) {
    if (wkt != null && wkt.isNotEmpty) {
      try {
        /// Holes
        bool holesWithSpace = wkt.contains('), (');
        bool holesWithoutSpace = wkt.contains('),(');
        if (holesWithSpace || holesWithoutSpace) {
          List<String> holes = holesWithSpace ? wkt.split('), (') : wkt.split('),(');
          List<List<LatLng>> result = List<List<LatLng>>.empty(growable: true);
          holes.asMap().forEach((index, value) {
            if (index == 0) {
              result.add(_fromStringValuesToArrayLatLng(value.split('((')[1].split(',')));
            } else if (index == (holes.length - 1)) {
              result.add(_fromStringValuesToArrayLatLng(value.split(')')[0].split(',')));
            } else {
              result.add(_fromStringValuesToArrayLatLng(value.split(',')));
            }
          });
          return result;
        } else {
          List<String> onlyValues = wkt.split('((')[1].split('))')[0].split(',');
          return [_fromStringValuesToArrayLatLng(onlyValues)];
        }
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
          result += ',';
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
          return List<List<LatLng>>.from(convertWKTToArrayLatLng(wkt));
        }
      } catch (_) {
        return [];
      }
    }
    return [];
  }

  static List<PolygonModel> convertWKTToPolygonClass(String? wkt) {
    if (wkt != null && wkt.isNotEmpty) {
      try {
        List<PolygonModel> polygons = List<PolygonModel>.empty(growable: true);
        if (wkt.contains(multiPolygonName)) {
          bool polygonsWithSpace = wkt.contains(')), ((');
          List<String> stringPolygons;
          if (polygonsWithSpace) {
            stringPolygons = wkt.split(')), ((');
          } else {
            stringPolygons = wkt.split(')),((');
          }
          stringPolygons.asMap().forEach((index, value) {
            List<List<LatLng>> fromString;
            if (index == 0) {
              fromString = convertWKTToArrayLatLng('((${value.split('(((')[1]}))');
            } else if (index == (stringPolygons.length - 1)) {
              fromString = convertWKTToArrayLatLng('((${value.split(')))')[0]}))');
            } else {
              fromString = convertWKTToArrayLatLng('(($value))');
            }
            polygons.add(PolygonModel(
                polygon: fromString.first,
                holes: fromString.foldIndexed([], (index, previous, element) {
                  if (index != 0) {
                    previous.add(element);
                  }
                  return previous;
                })));
          });
          return polygons;
        } else if (wkt.contains(polygonName)) {
          List<List<LatLng>> fromString = convertWKTToArrayLatLng(wkt);
          return [
            PolygonModel(
                polygon: fromString.first,
                holes: fromString.foldIndexed([], (index, previous, element) {
                  if (index != 0) {
                    previous.add(element);
                  }
                  return previous;
                }))
          ];
        }
      } catch (_) {
        return [PolygonModel()];
      }
    }
    return [PolygonModel()];
  }
}
