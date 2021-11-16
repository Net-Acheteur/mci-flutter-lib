import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BounceButtonMCI extends StatefulWidget {
  final Widget content;
  final void Function()? onTap;
  final Duration durationAnimation;
  final double sizeDown;

  const BounceButtonMCI(
      {Key? key,
      required this.content,
      this.onTap,
      this.durationAnimation = const Duration(
        milliseconds: 50,
      ),
      this.sizeDown = 0.1})
      : super(key: key);

  @override
  _BounceButtonMCIState createState() => _BounceButtonMCIState();
}

class _BounceButtonMCIState extends State<BounceButtonMCI> with SingleTickerProviderStateMixin {
  late double _scale;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.durationAnimation,
      lowerBound: 0.0,
      upperBound: widget.sizeDown,
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _tap() async {
    if (widget.onTap != null) {
      await _controller.forward();
      await _controller.reverse();
      widget.onTap?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    return GestureDetector(onTap: _tap, child: Transform.scale(scale: _scale, child: widget.content));
  }
}
