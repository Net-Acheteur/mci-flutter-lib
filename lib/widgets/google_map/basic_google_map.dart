import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as maps_toolkit;
import 'package:mci_flutter_lib/mci_flutter_lib.dart';

mixin BasicGoogleMap<T extends StatefulWidget> on State<T> {
  /// Object to display on the map
  Iterable<MapObjectModel> mapObjects = const [];

  /// Google map type
  MapType currentMapType = MapType.normal;

  /// Buttons tag
  final String floatingMapStyleTag = 'MapStyleButton';
  final String floatingRecenterTag = 'RecenterButton';

  /// Display or not the recenter button
  late bool isRecenterButtonVisible;

  /// GoogleMapController, initialized when the GoogleMap widget is initialized
  late Completer<GoogleMapController> mapCtrl;

  /// Camera update to animate to focus desired toFocusCameraPosition and toFocusMapBounds
  late CameraUpdate toFocusCameraUpdate;

  /// Map bounds to focus (ex: all the markers inside this map bounds)
  LatLngBounds toFocusMapBounds = LatLngExtensions.defaultCoordinates.getBoundingBox(2.5);

  /// Camera position to focus (ex: center of all the markers)
  CameraPosition toFocusCameraPosition = CameraPosition(target: LatLngExtensions.defaultCoordinates, zoom: 1.0);

  /// Markers, polygons and circles to display on the map
  late Set<Marker> markers;
  late Set<Polygon> polygons;
  late Set<Circle> circles;
  late Set<Polyline> polyLines;

  /// Markers used to center/zoom on the map
  Iterable<MapObjectModel> getFocusMarkers() {
    return mapObjects.where((element) => element.needFocus);
  }

  /// Hashcode to compare new markers and decide if an update is needed
  late int widgetMarkersHashCode;
  late int widgetFocusMarkersHashCode;

  @override
  void initState() {
    super.initState();
    widgetMarkersHashCode = [].toHashCode();
    widgetFocusMarkersHashCode = [].toHashCode();
    isRecenterButtonVisible = false;
    markers = <Marker>{};
    polygons = <Polygon>{};
    circles = <Circle>{};
    polyLines = <Polyline>{};
    mapCtrl = Completer();
  }

  void onCameraIdle() async {
    await updateRecenterButtonState();
  }

  void toggleMapType() {
    setState(() {
      currentMapType = (currentMapType == MapType.normal) ? MapType.satellite : MapType.normal;
    });
  }

  Future<void> recenterCamera({CameraUpdate? cameraUpdate}) async {
    await (await mapCtrl.future).animateCamera(cameraUpdate ?? toFocusCameraUpdate);
  }

  /// Update camera data to display the focusMarkers inside the view
  Future<void> updateCamera({Iterable<MapObjectModel>? specificFocusMarkers}) async {
    Iterable<MapObjectModel> focusMarkers = specificFocusMarkers ?? getFocusMarkers();

    var newWidgetFocusMarkersHashCode = focusMarkers.toHashCode();

    if (widgetFocusMarkersHashCode == newWidgetFocusMarkersHashCode && specificFocusMarkers == null) {
      return;
    }

    if (focusMarkers.isNotEmpty) {
      toFocusCameraPosition =
          CameraPosition(target: LatLng(focusMarkers.first.latitude, focusMarkers.first.longitude), zoom: 1.0);
      List<LatLng> latLngToFocus = List<LatLng>.empty(growable: true);
      for (var focusMarker in focusMarkers) {
        if (focusMarker is MapObjectModelWithBounds) {
          latLngToFocus.addAll([focusMarker.bounds.northeast, focusMarker.bounds.southwest]);
        } else {
          latLngToFocus.add(LatLng(focusMarker.latitude, focusMarker.longitude));
        }
      }
      toFocusMapBounds = latLngToFocus.getBoundingBox(2.5, 10.0);
      toFocusCameraUpdate = CameraUpdate.newLatLngBounds(toFocusMapBounds, 0.0);
    } else {
      toFocusCameraPosition = CameraPosition(target: LatLngExtensions.defaultCoordinates, zoom: 1.0);
      toFocusMapBounds = LatLngExtensions.defaultCoordinates.getBoundingBox(2.5);
      toFocusCameraUpdate = CameraUpdate.newLatLngBounds(toFocusMapBounds, 0.0);
    }

    widgetFocusMarkersHashCode = newWidgetFocusMarkersHashCode;

    if (focusMarkers.isNotEmpty) {
      await recenterCamera();
    }
  }

  /// Determine if the recenter button should be displayed
  Future<void> updateRecenterButtonState() async {
    var cameraCtrl = await mapCtrl.future;
    var visibleRegion = await cameraCtrl.getVisibleRegion();

    List<maps_toolkit.LatLng> visibleBounds = [
      maps_toolkit.LatLng(visibleRegion.northeast.latitude, visibleRegion.northeast.longitude),
      maps_toolkit.LatLng(visibleRegion.northeast.latitude, visibleRegion.southwest.longitude),
      maps_toolkit.LatLng(visibleRegion.southwest.latitude, visibleRegion.southwest.longitude),
      maps_toolkit.LatLng(visibleRegion.southwest.latitude, visibleRegion.northeast.longitude),
    ];

    // Check if the current region contains the center of the current bounds
    var center = maps_toolkit.LatLng((toFocusMapBounds.northeast.latitude + toFocusMapBounds.southwest.latitude) / 2,
        (toFocusMapBounds.northeast.longitude + toFocusMapBounds.southwest.longitude) / 2);

    var isInitialCenterVisible = maps_toolkit.PolygonUtil.containsLocation(center, visibleBounds, true);

    setState(() {
      isRecenterButtonVisible = !isInitialCenterVisible;
    });
  }

  /// Create the buttons to
  /// - change the map type
  /// - recenter the map
  List<Widget> createMapManagementButtons() {
    return [
      Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              FloatingActionButton(
                heroTag: floatingMapStyleTag,
                onPressed: () {
                  toggleMapType();
                },
                backgroundColor: Colors.white,
                child: const Icon(Icons.layers_outlined, color: MCIColors.grayDark),
              ),
              const SizedBox(height: 10, width: 0),
              Visibility(
                visible: isRecenterButtonVisible,
                child: FloatingActionButton(
                  heroTag: floatingRecenterTag,
                  onPressed: () async {
                    await recenterCamera();
                  },
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.pin_drop_outlined, color: MCIColors.grayDark),
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  /// Create the buttons to zoom
  List<Widget> createMapZoomButtons() {
    return [
      Positioned(
        bottom: 0,
        right: 0,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BounceButtonMCI(
                onTap: () async {
                  (await mapCtrl.future).animateCamera(CameraUpdate.zoomIn());
                },
                content: Container(
                  width: 48,
                  height: 48,
                  color: Colors.white,
                  child: const Icon(Icons.add, color: MCIColors.grayDark),
                ),
              ),
              Container(
                width: 48,
                height: 1,
                color: MCIColors.grayDark,
              ),
              BounceButtonMCI(
                onTap: () async {
                  (await mapCtrl.future).animateCamera(CameraUpdate.zoomOut());
                },
                content: Container(
                  width: 48,
                  height: 48,
                  color: Colors.white,
                  child: const Icon(Icons.remove, color: MCIColors.grayDark),
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }
}
