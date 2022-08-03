import 'dart:math';

import 'package:objectid/objectid.dart';

class MongoUtils {

  String generateUniqueMongoId(){
    final id = ObjectId();
    return id.hexString;
  }

  // String generateUniqueMongoId() {
  //   hex(double value) {
  //     return value.floor().toRadixString(16);
  //   }
  //
  //   String generatedHex =
  //       (hex(DateTime.now().millisecondsSinceEpoch / 1000) + ' ');
  //   for (int i = 0; i < 15; i++) {
  //     generatedHex = generatedHex + generatedHex;
  //   }
  //   final newString = generatedHex.replaceAllMapped(RegExp("/./g"), (match) {
  //     Random random = Random();
  //     double randomNumber = random.nextDouble();
  //     return hex(randomNumber * 16);
  //   });
  //   return newString;
  // }
}
