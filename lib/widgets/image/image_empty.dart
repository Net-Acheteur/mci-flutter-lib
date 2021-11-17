import 'package:flutter/material.dart';
import 'package:mci_flutter_lib/mci_flutter_lib.dart';

class ImageEmpty extends StatelessWidget {
  final BoxDecoration? boxDecoration;

  const ImageEmpty({Key? key, this.boxDecoration}) : super(key: key);

  factory ImageEmpty.withBoxDecoration(
      {BoxDecoration boxDecoration = const BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
          color: MCIColors.grayLight)}) {
    return ImageEmpty(boxDecoration: boxDecoration);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
            decoration: boxDecoration,
            color: boxDecoration == null ? MCIColors.grayLight : null,
            child: Icon(
              Icons.house_outlined,
              size: constraints.maxHeight,
              color: MCIColors.grayDark,
            ));
      },
    );
  }
}
