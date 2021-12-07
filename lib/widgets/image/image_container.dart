import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:mci_flutter_lib/widgets/image/image.dart';

class BaseImageContainerMCI extends StatefulWidget {
  final String? imageUrl;
  final String? imageUrlFallback;
  final Widget onLoading;
  final Widget? onError;
  final bool canScroll;
  final BaseCacheManager? baseCacheManager;
  final double? maxMegaOctet;

  const BaseImageContainerMCI(
      {Key? key,
      this.imageUrl,
      this.imageUrlFallback,
      this.onLoading = const CircularProgressIndicator(),
      this.onError,
      this.canScroll = false,
      this.baseCacheManager,
      this.maxMegaOctet})
      : super(key: key);

  factory BaseImageContainerMCI.empty() {
    return const BaseImageContainerMCI();
  }

  @override
  _ImageContainerMCIState createState() => _ImageContainerMCIState();
}

class _ImageContainerMCIState extends State<BaseImageContainerMCI> {
  bool usingFallback = false;

  _onFirstImageLoaded(bool loadedWithSuccess) {
    if (!loadedWithSuccess && widget.imageUrlFallback != null) {
      if (!usingFallback) {
        setState(() {
          usingFallback = true;
        });
      }
    }
  }

  Widget _createImage() {
    if (usingFallback) {
      if (widget.imageUrlFallback == null || widget.imageUrlFallback == '') {
        return BaseImageMCI.empty();
      } else {
        return BaseImageMCI(
            imageUrl: widget.imageUrlFallback,
            onLoading: widget.onLoading,
            onError: widget.onError,
            canScroll: widget.canScroll,
            baseCacheManager: widget.baseCacheManager,
            maxMegaOctet: widget.maxMegaOctet);
      }
    } else {
      if (widget.imageUrl == null || widget.imageUrl == '') {
        if (widget.imageUrlFallback != null && widget.imageUrlFallback!.isNotEmpty) {
          usingFallback = true;
          return BaseImageMCI(
              imageUrl: widget.imageUrlFallback,
              onLoading: widget.onLoading,
              onError: widget.onError,
              canScroll: widget.canScroll,
              baseCacheManager: widget.baseCacheManager,
              maxMegaOctet: widget.maxMegaOctet);
        } else {
          return BaseImageMCI.empty();
        }
      } else {
        return BaseImageMCI(
            imageUrl: widget.imageUrl,
            onLoading: widget.onLoading,
            onError: widget.imageUrlFallback != null ? widget.onLoading : widget.onError,
            canScroll: widget.canScroll,
            callbackOnLoaded: _onFirstImageLoaded,
            baseCacheManager: widget.baseCacheManager,
            maxMegaOctet: widget.maxMegaOctet);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _createImage();
  }
}
