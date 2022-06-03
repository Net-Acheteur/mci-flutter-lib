
import 'package:flutter/material.dart';
import 'package:mci_flutter_lib/config/mci_colors.dart';
import 'package:mci_flutter_lib/widgets/bounce_button.dart';

class DrawerMCI extends StatefulWidget {
  final Widget visibleWidget;
  final Widget hiddenWidget;
  final Duration animationDuration;
  final bool disabled;

  const DrawerMCI({
    super.key,
    required this.visibleWidget,
    required this.hiddenWidget,
    this.animationDuration = const Duration(milliseconds: 500),
    this.disabled = false,
  });

  @override
  State<DrawerMCI> createState() => _DrawerMCIState();
}

class _DrawerMCIState extends State<DrawerMCI> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: widget.animationDuration,
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        widget.visibleWidget,
        SizeTransition(
          sizeFactor: _animation,
          child: widget.hiddenWidget,
        ),
        if (!widget.disabled)
          BounceButtonMCI(
            content: Padding(
              padding: const EdgeInsets.all(5),
              child: Icon(
                _controller.isCompleted ? Icons.arrow_upward : Icons.arrow_downward,
                color: MCIColors.primary,
              ),
            ),
            onTap: () async {
              if (_controller.isAnimating) {
                return;
              }
              if (_controller.isCompleted) {
                await _controller.reverse();
                setState(() {});
              } else {
                await _controller.forward();
                setState(() {});
              }
            },
          ),
      ],
    );
  }
}
