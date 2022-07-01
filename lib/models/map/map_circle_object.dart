import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mci_flutter_lib/models/map/map_object.dart';
import 'package:mci_flutter_lib/models/map/place_style.dart';

class MapCircleObjectModel<T> extends MapObjectModelWithBounds<T> {
  final Circle circle;

  MapCircleObjectModel({
    required String objectId,
    required double longitude,
    required double latitude,
    required this.circle,
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
  List<Object?> get props => super.props..addAll([circle]);
}
