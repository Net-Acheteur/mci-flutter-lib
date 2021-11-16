import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerContainer extends StatelessWidget {
  const ShimmerContainer({Key? key, required this.baseColor, required this.highlightColor}) : super(key: key);

  factory ShimmerContainer.grey() {
    return ShimmerContainer(baseColor: Colors.grey.shade100, highlightColor: Colors.grey.shade300);
  }

  factory ShimmerContainer.black() {
    return const ShimmerContainer(baseColor: Colors.black12, highlightColor: Colors.black54);
  }

  factory ShimmerContainer.blue() {
    return const ShimmerContainer(baseColor: Colors.white60, highlightColor: Color(0x5500385E));
  }

  final Color baseColor;
  final Color highlightColor;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      enabled: true,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: baseColor,
      ),
    );
  }
}
