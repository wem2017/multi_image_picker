import 'dart:async';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:multi_image_picker/asset.dart';
import 'package:multi_image_picker/cupertino_options.dart';

class MultiImagePicker {
  static const MethodChannel _channel =
      const MethodChannel('multi_image_picker');

  /// Invokes the multi image picker selector.
  ///
  /// You must provide [maxImages] option, which will limit
  /// the number of images that the user can choose. On iOS
  /// you can pass also [options] parameter which should be
  /// an instance of [CupertinoOptions] class. It allows you
  /// to customize the look of the image picker. On android
  /// you have to provide custom styles via resource files
  /// as specified in the official docs on Github.
  ///
  /// This method returns list of [Asset] objects. Because
  /// they are just placeholders containing the actual
  /// identifier to the image, not the image itself you can
  /// pick thousands of images at a time, with no performance
  /// penalty. How to request the original image or a thumb
  /// you can refer to the docs for the Asset class.
  static Future<List<Asset>> pickImages({
    @required int maxImages,
    CupertinoOptions options = const CupertinoOptions(),
  }) async {
    assert(maxImages != null);

    if (maxImages != null && maxImages < 0) {
      throw new ArgumentError.value(maxImages, 'maxImages cannot be negative');
    }

    final List<dynamic> images =
        await _channel.invokeMethod('pickImages', <String, dynamic>{
      'maxImages': maxImages,
      'iosOptions': options.toJson(),
    });

    var assets = List<Asset>();
    for (var item in images) {
      var asset = Asset(
        item['identifier'],
        item['width'],
        item['height'],
      );
      assets.add(asset);
    }
    return assets;
  }

  /// Requests a thumbnail with [width] and [height]
  /// for a given [identifier].
  ///
  /// This method is used by the asset class, you
  /// should not invoke it manually. For more info
  /// refer to [Asset] class docs.
  ///
  /// The actual image data is sent via BinaryChannel.
  static Future<bool> requestThumbnail(
      String identifier, int width, int height) async {
    assert(identifier != null);
    assert(width != null);
    assert(height != null);

    if (width != null && width < 0) {
      throw new ArgumentError.value(width, 'width cannot be negative');
    }

    if (height != null && height < 0) {
      throw new ArgumentError.value(height, 'height cannot be negative');
    }

    bool ret =
        await _channel.invokeMethod("requestThumbnail", <String, dynamic>{
      "identifier": identifier,
      "width": width,
      "height": height,
    });
    return ret;
  }

  /// Requests the original image data for a given
  /// [identifier].
  ///
  /// This method is used by the asset class, you
  /// should not invoke it manually. For more info
  /// refer to [Asset] class docs.
  ///
  /// The actual image data is sent via BinaryChannel.
  static Future<bool> requestOriginal(String identifier) async {
    bool ret = await _channel.invokeMethod("requestOriginal", <String, dynamic>{
      "identifier": identifier,
    });
    return ret;
  }

  /// Refresh image gallery with specific path
  /// [path].
  ///
  /// This method is used by refresh image gallery
  /// Some of the image picker would not be refresh automatically
  /// You can refresh it manually.
  static Future<bool> refreshImage({@required String path,}) async {
    assert(path != null);
    bool result = await _channel.invokeMethod("refreshImage", <String, dynamic>{
      "path" : path
    });

    return result;
  }

  
}
