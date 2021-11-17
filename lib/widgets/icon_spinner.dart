import 'package:flutter/material.dart';
import 'package:mci_flutter_lib/config/mci_colors.dart';

class IconSpinner extends StatelessWidget {
  final double size;

  const IconSpinner({Key? key, this.size = 18}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(2),
        padding: const EdgeInsets.all(2),
        width: size,
        height: size,
        child: const CircularProgressIndicator(
          strokeWidth: 2,
          backgroundColor: Colors.white,
          color: MCIColors.secondary,
        ));
  }
}
