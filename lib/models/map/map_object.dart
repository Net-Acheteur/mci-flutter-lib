import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mci_flutter_lib/models/map/place_style.dart';

class MapObjectModel extends Equatable {
  final String objectId;
  final double longitude;
  final double latitude;
  final bool needFocus;
  final PlaceStyle? style;

  const MapObjectModel({
    required this.objectId,
    required this.longitude,
    required this.latitude,
    this.needFocus = false,
    this.style,
  });

  bool isInsideBounds(LatLngBounds latLngBounds) {
    return latLngBounds.contains(LatLng(latitude, longitude));
  }

  @override
  List<Object?> get props => [objectId, latitude, longitude, needFocus];
}

abstract class MapObjectModelWithBounds<T> extends MapObjectModel {
  final LatLngBounds bounds;
  final LatLng centroid;
  final List<T> items;

  MapObjectModelWithBounds({
    required String objectId,
    required double longitude,
    required double latitude,
    bool needFocus = false,
    PlaceStyle? style,
    required this.bounds,
    required this.items,
  })  : centroid = LatLng(latitude, longitude),
        super(
          objectId: objectId,
          latitude: latitude,
          longitude: longitude,
          needFocus: needFocus,
          style: style,
        );

  @override
  bool isInsideBounds(LatLngBounds latLngBounds) {
    return latLngBounds.contains(LatLng(bounds.southwest.latitude, bounds.southwest.longitude)) ||
        latLngBounds.contains(LatLng(bounds.southwest.latitude, bounds.northeast.longitude)) ||
        latLngBounds.contains(LatLng(bounds.northeast.latitude, bounds.southwest.longitude)) ||
        latLngBounds.contains(LatLng(bounds.northeast.latitude, bounds.northeast.longitude)) ||
        latLngBounds.contains(centroid) ||
        bounds.contains(latLngBounds.southwest) ||
        bounds.contains(latLngBounds.northeast);
  }

  @override
  List<Object?> get props => super.props..addAll([bounds, centroid, items]);
}
