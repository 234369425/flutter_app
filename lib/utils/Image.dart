import 'dart:convert';
import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';

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
    {int width = 200, int height = 300, int quality = 80}) async {
  return compress(file, width: width, height: height, quality: quality)
      .then((value) => base64Encode(value));
}
