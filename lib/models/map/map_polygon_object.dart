import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mci_flutter_lib/models/map/map_object.dart';
import 'package:mci_flutter_lib/models/map/place_style.dart';

class MapPolygonObjectModel<T> extends MapObjectModelWithBounds<T> {
  final List<Polygon> polygons;

  MapPolygonObjectModel({
    required String objectId,
    required double longitude,
    required double latitude,
    required this.polygons,
    required LatLngBounds bounds,
    bool needFocus = false,
    PlaceStyle? style,
    required List<T> items,
  }) : super(
          objectId: objectId,
          latitude: latitude,
          longitude: longitude,
          bounds: bounds,
          needFocus: needFocus,
          style: style,
          items: items,
        );

  @override
  List<Object?> get props => super.props..addAll([polygons]);
}
