import 'dart:io';
import 'package:blurhash_dart/blurhash_dart.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

class BlurHashGenerator {

  generateBlurHash(String imageUrl) async {
    print("HEYU :- " + imageUrl);

    final data = File(imageUrl).readAsBytesSync();
    final image = img.decodeImage(data.toList());
    String hashValue = await encodeBlurHashAsync(image!);
    return hashValue;
  }

  Future<String> encodeBlurHashAsync(img.Image image) async {
    return compute(_encodeHashWithParams, image);
  }
}

String _encodeHashWithParams(img.Image image) {
  return BlurHash.encode(image).hash;
}


