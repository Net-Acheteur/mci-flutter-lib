import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:mci_flutter_lib/helpers/octet_helper.dart';
import 'package:mci_flutter_lib/mci_flutter_lib.dart';
import 'package:photo_view/photo_view.dart';

class BaseImageMCI extends StatefulWidget {
  final String? imageUrl;
  final Widget onLoading;
  final Widget? onError;
  final bool canScroll;
  final Function(bool)? callbackOnLoaded;
  final BaseCacheManager? baseCacheManager;
  final double? maxMegaOctet;
  final double? width;
  final double? height;

  const BaseImageMCI(
      {Key? key,
      this.imageUrl,
      this.onLoading = const CircularProgressIndicator(),
      this.onError,
      this.canScroll = false,
      this.callbackOnLoaded,
      this.baseCacheManager,
      this.maxMegaOctet,
      this.width,
      this.height})
      : super(key: key);

  factory BaseImageMCI.empty() {
    return const BaseImageMCI();
  }

  @override
  State<BaseImageMCI> createState() => _ImageMCIState();
}

class _ImageMCIState extends State<BaseImageMCI> {
  String _downloadedImage = "";
  late Image _image;
  late Completer<ui.Image> _completer;
  ImageStream? _imageStream;
  ImageStreamListener? _imageStreamListener;
  final ImageConfiguration _imageConfiguration = const ImageConfiguration();

  void _downloadImage() {
    if (widget.imageUrl != null && _downloadedImage != _imageUrlWithoutTimestamp(widget.imageUrl.toString())) {
      if (_imageStreamListener != null) {
        _image.image.resolve(_imageConfiguration).removeListener(_imageStreamListener!);
      }
      _downloadedImage = _imageUrlWithoutTimestamp(widget.imageUrl.toString());
      _image = Image(
          height: widget.height ?? double.infinity,
          width: widget.width ?? double.infinity,
          image: CachedNetworkImageProvider(_createUrl(), cacheManager: widget.baseCacheManager));
      _completer = Completer<ui.Image>();
      _imageStreamListener = ImageStreamListener((ImageInfo info, bool _) {
        if (!_completer.isCompleted) {
          if (widget.callbackOnLoaded != null) {
            widget.callbackOnLoaded!(true);
          }
          _completer.complete(info.image);
        }
      }, onChunk: (ImageChunkEvent imageChunkEvent) {
        if (imageChunkEvent.expectedTotalBytes != null &&
            widget.maxMegaOctet != null &&
            OctetHelper.bytesToMegaBytes(imageChunkEvent.expectedTotalBytes!) > widget.maxMegaOctet!) {
          if (_imageStream != null && _imageStreamListener != null) {
            if (!_completer.isCompleted) {
              if (widget.callbackOnLoaded != null) {
                widget.callbackOnLoaded!(false);
              }
              _completer.completeError('Image too big, download canceled');
            }
            _imageStream!.removeListener(_imageStreamListener!);
            _image.image.evict(configuration: _imageConfiguration);
          }
        }
      }, onError: (Object object, _) {
        if (!_completer.isCompleted) {
          if (widget.callbackOnLoaded != null) {
            widget.callbackOnLoaded!(false);
          }
          _completer.completeError(object);
        }
      });
      _imageStream = _image.image.resolve(_imageConfiguration)..addListener(_imageStreamListener!);
    }
  }

  String _createUrl() {
    String baseUrl = widget.imageUrl ?? "";
    if (baseUrl.startsWith('//')) {
      return 'https:$baseUrl';
    } else {
      return baseUrl;
    }
  }

  String _imageUrlWithoutTimestamp(String imageUrl) {
    if (imageUrl.isNotEmpty) {
      List<String> splitImage = imageUrl.split('?');
      if (splitImage.isNotEmpty) {
        return splitImage[0];
      }
    }
    return imageUrl;
  }

  Widget _createEmptyPhoto() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
            height: widget.height ?? double.infinity,
            width: widget.width ?? double.infinity,
            color: MCIColors.grayLight,
            child: Icon(
              Icons.house_outlined,
              size: min(constraints.maxHeight, constraints.maxWidth),
              color: MCIColors.grayDark,
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _downloadImage();
    return widget.imageUrl != null
        ? LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
            return FutureBuilder<ui.Image>(
              future: _completer.future,
              builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
                if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                  if (widget.canScroll) {
                    return ClipRect(
                        child: PhotoView.customChild(
                            child: Image(
                                image: _image.image,
                                height: widget.height ?? _image.height,
                                width: widget.width ?? _image.width)));
                  } else {
                    BoxFit toFit = BoxFit.scaleDown;
                    if (snapshot.data!.height > constraints.maxHeight && snapshot.data!.width > constraints.maxWidth) {
                      toFit = BoxFit.cover;
                    } else if (snapshot.data!.height > constraints.maxHeight) {
                      toFit = BoxFit.contain;
                    }
                    return Image(
                        image: _image.image,
                        fit: toFit,
                        height: widget.height ?? _image.height,
                        width: widget.width ?? _image.width);
                  }
                } else if (snapshot.hasError) {
                  return widget.onError ?? _createEmptyPhoto();
                } else {
                  return widget.onLoading;
                }
              },
            );
          })
        : _createEmptyPhoto();
  }
}
