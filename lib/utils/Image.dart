import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/constants/defaults.dart';
import 'package:flutter_app/utils/cache.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageUtils {
  static Widget dynamicAvatar(avatar, {size, width, height}) {
    if (avatar == null) {
      return Image.asset(headPortrait);
    }
    if (avatar.startsWith("assets")) {
      return Image.asset(avatar);
    } else if (isInternetImage(avatar)) {
      return new CachedNetworkImage(
          imageUrl: avatar,
          cacheManager: cacheManager,
          width: size ?? null,
          height: size ?? null,
          fit: BoxFit.fill);
    } else {
      return Image.memory(Base64Decoder().convert(avatar),
          fit: BoxFit.cover,
          width: width,
          height: height,
          gaplessPlayback: true);
    }
  }

  static bool isInternetImage(String image) => image.startsWith("http");
}

Future<List<int>> compress(File file,
    {int width = 200, int height = 300, int quality = 80}) async {
  try {
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: width,
      minHeight: height,
      quality: quality,
    );
    return result;
  } catch (e) {
    print('e => ${e.toString()}');
    return null;
  }
}

Future<String> compressToString(File file,
    {int width,
    int height,
    int quality = 80,
    double scale = 0.7,
    dynamic finish}) async {
  if (width != null && height != null) {
    return compress(file, width: width, height: height, quality: quality)
        .then((value) => base64Encode(value));
  } else {
    Image.file(file)
        .image
        .resolve(ImageConfiguration.empty)
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      var width = info.image.width;
      var height = info.image.height;
      compress(file,
              width: (width * scale).toInt(),
              height: (height * scale).toInt(),
              quality: quality)
          .then((value) => base64Encode(value))
          .then((value) => finish(value));
    }));
  }
}
