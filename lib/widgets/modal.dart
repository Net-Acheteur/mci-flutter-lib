import 'package:flutter/material.dart';
import 'package:mci_flutter_lib/mci_flutter_lib.dart';

class ModalMCI extends StatelessWidget {
  final Widget content;
  final bool withCloseButton;
  final bool scrollable;
  final _scrollController = ScrollController();

  ModalMCI({
    Key? key,
    required this.content,
    this.withCloseButton = true,
    this.scrollable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: scrollable,
      child: SingleChildScrollView(
        physics: scrollable ? const AlwaysScrollableScrollPhysics() : const NeverScrollableScrollPhysics(),
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(15),
          child: Stack(
            children: [
              content,
              if (withCloseButton)
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Icon(
                        Icons.close,
                        size: 24,
                        color: MCIColors.primary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
