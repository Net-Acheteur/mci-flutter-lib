import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mci_flutter_lib/models/map/map_object.dart';

class ClusterManagerHelper {
  static double calculateDistanceInKM(LatLng firstLatLng, LatLng secondLatLng) {
    double degree = 0.017453292519943295; // PI / 180
    double earthRadius = 6371; // KM
    double a = 0.5 -
        cos((secondLatLng.latitude - firstLatLng.latitude) * degree) / 2 +
        cos(firstLatLng.latitude * degree) *
            cos(secondLatLng.latitude * degree) *
            (1 - cos((secondLatLng.longitude - firstLatLng.longitude) * degree)) /
            2;
    return earthRadius * 2 * asin(sqrt(a));
  }

  /// Create a list of cluster (list of MapObjectModel)
  static List<List<T>> getClusters<T extends MapObjectModel>(List<T> objectToCluster, LatLngBounds boundingBox,
      {double distanceFactor = 0.25, double distanceKM = 0.0}) {
    double distanceMaxToTest = distanceKM > 0.0
        ? distanceKM
        : calculateDistanceInKM(boundingBox.southwest, boundingBox.northeast) * distanceFactor;

    List<List<T>> preClusters = List<List<T>>.empty(growable: true);
    while (objectToCluster.isNotEmpty) {
      T toCompare = objectToCluster.removeAt(0);
      if (preClusters.isEmpty) {
        preClusters.add([toCompare]);
      } else {
        bool toAddList = true;
        for (var listCluster in preClusters) {
          bool toAddInList = false;
          for (var preCluster in listCluster) {
            if (_areMarkersCloseEnough(preCluster, toCompare, distanceMaxToTest)) {
              toAddInList = true;
              break;
            }
          }
          if (toAddInList) {
            listCluster.add(toCompare);
            toAddList = false;
            break;
          }
        }
        if (toAddList) {
          preClusters.add([toCompare]);
        }
      }
    }
    return preClusters;
  }

  static bool _areMarkersCloseEnough(MapObjectModel firstMarker, MapObjectModel secondMarker, double maxDistance) {
    return calculateDistanceInKM(LatLng(firstMarker.latitude, firstMarker.longitude),
            LatLng(secondMarker.latitude, secondMarker.longitude)) <
        maxDistance;
  }
}
