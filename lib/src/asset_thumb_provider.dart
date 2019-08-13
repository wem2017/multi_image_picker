import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui show instantiateImageCodec, Codec;
import 'package:multi_image_picker/multi_image_picker.dart';

class AssetThumbImageProvider extends ImageProvider<AssetThumbImageProvider> {
  final Asset asset;

  final int width;

  final int height;

  final int quality;

  final double scale;

  const AssetThumbImageProvider(
    this.asset, {
    @required this.width,
    @required this.height,
    this.quality = 100,
    this.scale = 1.0,
  })  : assert(asset != null),
        assert(width != null),
        assert(height != null);

  @override
  ImageStreamCompleter load(AssetThumbImageProvider key) {
    return new MultiFrameImageStreamCompleter(
      codec: _loadAsync(key),
      scale: key.scale,
    );
  }

  Future<ui.Codec> _loadAsync(AssetThumbImageProvider key) async {
    assert(key == this);

    ByteData data = await key.asset
        .getThumbByteData(key.width, key.height, quality: key.quality);
    final bytes = data.buffer.asUint8List();

    return await ui.instantiateImageCodec(bytes);
  }

  @override
  Future<AssetThumbImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<AssetThumbImageProvider>(this);
  }
}
