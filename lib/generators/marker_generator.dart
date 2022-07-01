import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mci_flutter_lib/mci_flutter_lib.dart';

class MarkerGenerator {
  late final double _markerSize;
  late final double _fillCircleWidth;
  late final Offset _fillCircleOffset;
  late final double _fontSize;
  late final Offset _textOffset;

  MarkerGenerator(this._markerSize) {
    // calculate marker dimensions
    _fillCircleWidth = _markerSize / 4.6;
    _fillCircleOffset = Offset(_markerSize / 2, _markerSize / 2.6);
    _fontSize = _markerSize / 3.1;
    _textOffset = Offset(_fillCircleOffset.dx, _fillCircleOffset.dy);
  }

  /// Creates a BitmapDescriptor from an IconData
  Future<BitmapDescriptor> createBitmapDescriptorFromIconData(IconData iconData, Color iconColor) async {
    final pictureRecorder = PictureRecorder();
    final canvas = Canvas(pictureRecorder);

    _paintMarker(canvas, iconColor, iconData, offset: const Offset(0, 0));

    final picture = pictureRecorder.endRecording();
    final image = await picture.toImage(_markerSize.round(), _markerSize.round());
    final bytes = await image.toByteData(format: ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(bytes != null ? bytes.buffer.asUint8List() : Uint8List(0));
  }

  /// Creates a BitmapDescriptor from an IconData with text content
  Future<BitmapDescriptor> createBitmapDescriptorFromRoundAndCenteredIconDataAndText(
      IconData iconData, Color iconColor, Color circleColor, String text) async {
    final pictureRecorder = PictureRecorder();
    final canvas = Canvas(pictureRecorder);

    _paintMarker(canvas, iconColor, iconData, sizeFactor: 0.7);
    _paintCircleFill(canvas, circleColor, sizeFactor: 0.9);
    _paintText(canvas, text, iconColor);

    final picture = pictureRecorder.endRecording();
    final image = await picture.toImage(_markerSize.round(), _markerSize.round());
    final bytes = await image.toByteData(format: ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(bytes != null ? bytes.buffer.asUint8List() : Uint8List(0));
  }

  /// Creates a BitmapDescriptor from an IconData with text content
  Future<BitmapDescriptor> createBitmapDescriptorFromIconDataAndText(
      IconData iconData, Color iconColor, Color circleColor, String text) async {
    final pictureRecorder = PictureRecorder();
    final canvas = Canvas(pictureRecorder);

    _paintMarker(canvas, iconColor, iconData, offset: const Offset(0, 0));
    _paintCircleFill(canvas, circleColor);
    _paintText(canvas, text, iconColor);

    final picture = pictureRecorder.endRecording();
    final image = await picture.toImage(_markerSize.round(), _markerSize.round());
    final bytes = await image.toByteData(format: ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(bytes != null ? bytes.buffer.asUint8List() : Uint8List(0));
  }

  /// Creates a BitmapDescriptor from an IconData with icon content
  Future<BitmapDescriptor> createBitmapDescriptorFromIconDataAndIcon(
      IconData iconData, Color iconColor, Color circleColor, IconData icon) async {
    final pictureRecorder = PictureRecorder();
    final canvas = Canvas(pictureRecorder);

    _paintMarker(canvas, iconColor, iconData, offset: const Offset(0, 0));
    _paintCircleFill(canvas, circleColor);
    _paintIcon(canvas, iconColor, icon);

    final picture = pictureRecorder.endRecording();
    final image = await picture.toImage(_markerSize.round(), _markerSize.round());
    final bytes = await image.toByteData(format: ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(bytes != null ? bytes.buffer.asUint8List() : Uint8List(0));
  }

  /// Paints the icon background
  void _paintCircleFill(Canvas canvas, Color color, {double sizeFactor = 1}) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;
    canvas.drawCircle(_fillCircleOffset, _fillCircleWidth * sizeFactor, paint);
  }

  /// Paints the marker
  void _paintMarker(Canvas canvas, Color color, IconData iconData, {double sizeFactor = 1, Offset? offset}) {
    final painter = TextPainter(textDirection: TextDirection.ltr);
    painter.text = TextSpan(
        text: String.fromCharCode(iconData.codePoint),
        style: TextStyle(
          letterSpacing: 0.0,
          fontSize: _markerSize * sizeFactor,
          fontFamily: iconData.fontFamily,
          color: color,
        ));
    painter.layout();
    painter.paint(canvas, offset ?? Offset(_textOffset.dx - painter.width / 2, _textOffset.dy - painter.height / 2));
  }

  /// Paints the icon
  void _paintIcon(Canvas canvas, Color color, IconData iconData, {Offset? offset}) {
    final painter = TextPainter(textDirection: TextDirection.ltr);
    painter.text = TextSpan(
        text: String.fromCharCode(iconData.codePoint),
        style: TextStyle(
          letterSpacing: 0.0,
          fontSize: _fontSize,
          fontFamily: iconData.fontFamily,
          color: color,
        ));
    painter.layout();
    painter.paint(canvas, offset ?? Offset(_textOffset.dx - painter.width / 2, _textOffset.dy - painter.height / 2));
  }

  /// Paints the text
  void _paintText(Canvas canvas, String text, Color color, {double fontFactor = 1.0, Offset? offset}) {
    TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
    var fontSize = _fontSize * fontFactor;
    painter.text = TextSpan(
      text: text,
      style: TextStyle(fontSize: fontSize, color: color, fontWeight: FontWeight.bold, fontFamily: 'Gilroy'),
    );
    painter.layout();

    if (painter.width > (_fillCircleWidth * 1.9)) {
      _paintText(canvas, text, color, fontFactor: (fontFactor * 0.9));
      return;
    }
    painter.paint(canvas, offset ?? Offset(_textOffset.dx - painter.width / 2, _textOffset.dy - painter.height / 2));
  }

  Future<BitmapDescriptor> getBytesFromCanvas(String text) async {
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    TextPainter painter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    painter.text = TextSpan(
      text: text,
      style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
    );
    painter.layout();
    final Paint paint1 = Paint()..color = MCIColors.primary;
    canvas.drawRect(
        Rect.fromCenter(
          center: const Offset(0, 0),
          width: painter.width * 2,
          height: painter.height * 2,
        ),
        paint1);
    painter.paint(
      canvas,
      const Offset(0, 0),
    );

    final img = await pictureRecorder.endRecording().toImage((painter.width).toInt(), (painter.height).toInt());
    final data = await img.toByteData(format: ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  Marker createMarker(String id, LatLng position, BitmapDescriptor markerContent,
      {InfoWindow markerInfoWindow = InfoWindow.noText, Function()? callback, Offset anchor = const Offset(0.5, 1.0)}) {
    return Marker(
        anchor: anchor,
        markerId: MarkerId(id),
        position: position,
        onTap: callback,
        icon: markerContent,
        infoWindow: markerInfoWindow);
  }

  Future<Marker> createPinPointMarker(String id, LatLng position, Function() callback,
      {Offset anchor = const Offset(0.5, 1.0)}) async {
    BitmapDescriptor markerContent = await createBitmapDescriptorFromIconData(Icons.place, MCIColors.secondary);
    return createMarker(id, position, markerContent, callback: callback, anchor: anchor);
  }

  Future<Marker> createRoundMultiPinPointMarker(String id, int number, LatLng position, Function() callback,
      {Offset anchor = const Offset(0.5, 0.5)}) async {
    BitmapDescriptor markerContent = await createBitmapDescriptorFromRoundAndCenteredIconDataAndText(
        Icons.circle, MCIColors.secondary, Colors.white, number.toString());
    return createMarker(id, position, markerContent, callback: callback, anchor: anchor);
  }

  Future<Marker> createMultiPinPointMarker(String id, int number, LatLng position,
      {Function()? callback, Color color = MCIColors.secondary, Offset anchor = const Offset(0.5, 1.0)}) async {
    BitmapDescriptor markerContent =
        await createBitmapDescriptorFromIconDataAndText(Icons.place, color, Colors.white, number.toString());
    return createMarker(id, position, markerContent, callback: callback, anchor: anchor);
  }

  Future<Marker> createTextMarker(String id, String text, LatLng position,
      {Function()? callback, Offset anchor = const Offset(0.5, 1.0)}) async {
    final BitmapDescriptor desiredMarker = await getBytesFromCanvas(text);

    return createMarker(
      id,
      position,
      desiredMarker,
      callback: callback,
      anchor: anchor,
    );
  }
}
