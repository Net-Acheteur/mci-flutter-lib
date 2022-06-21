import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mci_flutter_lib/config/mci_colors.dart';
import 'package:mci_flutter_lib/generators/marker_generator.dart';
import 'package:mci_flutter_lib/models/map/map_cluster_object.dart';
import 'package:mci_flutter_lib/models/map/map_object.dart';
import 'package:mci_flutter_lib/widgets/google_map/basic_google_map.dart';

const String withoutGMapMarkersMapStyle =
    '[{"stylers":[{"visibility":"off"}]},{"featureType":"administrative","stylers":[{"visibility":"on"}]},{"featureType":"landscape","stylers":[{"visibility":"on"}]},{"featureType":"poi.park","stylers":[{"visibility":"on"}]},{"featureType":"road","stylers":[{"visibility":"on"}]},{"featureType":"transit.line","stylers":[{"visibility":"on"}]},{"featureType":"water","stylers":[{"visibility":"on"}]}]';

abstract class GoogleMapWidget extends StatefulWidget {
  /// Google map style
  final String? mapStyle;

  /// Markers displayed on the map
  final Iterable<MapObjectModel> markers;

  /// Callback used when a marker is tapped
  final Future<void> Function(List<int>) onTapMarker;

  /// Additional widgets displayed on top of the map
  final Iterable<Widget> widgets;

  /// Does the camera must recenter/resize on focusMarkers when the markers change
  final bool animateCameraWhenMarkersChanged;

  /// Can use the google map zoom controls
  final bool zoomControlsEnabled;

  const GoogleMapWidget({
    Key? key,
    required this.markers,
    required this.onTapMarker,
    this.widgets = const [],
    this.mapStyle,
    this.animateCameraWhenMarkersChanged = true,
    this.zoomControlsEnabled = false,
  }) : super(key: key);

  @override
  State<GoogleMapWidget> createState() => GoogleMapWidgetState();
}

class GoogleMapWidgetState<T extends GoogleMapWidget> extends State<T> with BasicGoogleMap<T>, WidgetsBindingObserver {
  /// The markerRatio is the size of the marker by the width of the screen
  double markerRatio = 0.12;

  GoogleMapWidgetState() : super();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    mapObjects = widget.markers;

    updateCamera();
    update();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);

    mapObjects = widget.markers;
    updateCamera();
    update();
  }

  /// HACK: On Android 10, switching app cause the google map widget to stay blank until an event occurs
  /// https://github.com/flutter/flutter/issues/40284
  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.resumed:
        (await mapCtrl.future).setMapStyle(widget.mapStyle);
        break;
    }
  }

  @protected
  void update() {}

  @protected
  Future<Marker> createCustomMarker(MapObjectModel mapObjectModel, MarkerGenerator generator,
      {Offset anchor = const Offset(0.5, 1.0)}) async {
    Color color = mapObjectModel.style != null ? mapObjectModel.style!.color : MCIColors.secondary;
    late BitmapDescriptor icon;
    if (mapObjectModel.style != null && mapObjectModel.style!.icon != null) {
      icon = await generator.createBitmapDescriptorFromIconDataAndIcon(
          Icons.place, color, Colors.white, mapObjectModel.style!.icon!);
    } else {
      icon = await generator.createBitmapDescriptorFromIconData(Icons.place, color);
    }

    late InfoWindow infoWindow;
    if (mapObjectModel is MapClusterElementObjectModel) {
      infoWindow = InfoWindow(title: mapObjectModel.title, snippet: mapObjectModel.subtitle);
    } else {
      infoWindow = InfoWindow.noText;
    }

    return Marker(
        anchor: anchor,
        markerId: MarkerId(mapObjectModel.objectId),
        position: LatLng(mapObjectModel.latitude, mapObjectModel.longitude),
        icon: icon,
        infoWindow: infoWindow);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> stackedWidgets = createMapManagementButtons();
    if (widget.zoomControlsEnabled) {
      stackedWidgets.addAll(createMapZoomButtons());
    }
    if (widget.widgets.isNotEmpty) {
      stackedWidgets.addAll(widget.widgets);
    }
    return Scaffold(
      body: Stack(children: [
        GoogleMap(
          onTap: (_) {
            widget.onTapMarker([]);
          },
          mapType: currentMapType,
          initialCameraPosition: toFocusCameraPosition,
          onMapCreated: (GoogleMapController controller) async {
            controller.setMapStyle(widget.mapStyle);
            mapCtrl.complete(controller);
          },
          onCameraIdle: onCameraIdle,
          markers: markers,
          polygons: polygons,
          circles: circles,
          polylines: polyLines,
          mapToolbarEnabled: false,
          myLocationEnabled: false,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Stack(
            children: stackedWidgets,
          ),
        ),
      ]),
    );
  }
}
