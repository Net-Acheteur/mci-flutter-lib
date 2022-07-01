import 'package:flutter/material.dart';

class PlaceStyle {
  final Color color;
  final IconData? icon;
  final double iconFactor;

  const PlaceStyle({
    required this.color,
    this.icon,
    this.iconFactor = 1.0,
  });
}
