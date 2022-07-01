import 'package:mci_flutter_lib/models/map/map_object.dart';
import 'package:mci_flutter_lib/models/map/place_style.dart';

class MapClusterElementObjectModel extends MapObjectModel {
  final String? title;
  final String? subtitle;
  final String clusterId;
  final String typeId;

  const MapClusterElementObjectModel({
    required String objectId,
    required double longitude,
    required double latitude,
    this.title,
    this.subtitle,
    this.clusterId = 'default',
    this.typeId = 'default',
    PlaceStyle? style,
    bool needFocus = false,
  }) : super(
          objectId: objectId,
          longitude: longitude,
          latitude: latitude,
          style: style,
          needFocus: needFocus,
        );

  @override
  List<Object?> get props => super.props..addAll([title, subtitle, clusterId, typeId]);
}

class MapClusterGroupObjectModel extends MapObjectModel {
  final String? title;
  final String? subtitle;
  final String clusterId;
  final String typeId;
  final Iterable<MapClusterElementObjectModel> items;

  const MapClusterGroupObjectModel({
    required String objectId,
    required double longitude,
    required double latitude,
    this.title,
    this.subtitle,
    this.clusterId = 'default',
    this.typeId = 'default',
    this.items = const [],
    PlaceStyle? style,
    bool needFocus = false,
  }) : super(
          objectId: objectId,
          longitude: longitude,
          latitude: latitude,
          style: style,
          needFocus: needFocus,
        );

  @override
  List<Object?> get props => super.props..addAll([title, subtitle, clusterId, typeId, items]);
}
