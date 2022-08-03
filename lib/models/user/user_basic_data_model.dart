// To parse this JSON data, do
//
//     final userCreateModel = userCreateModelFromJson(jsonString);

import 'dart:convert';

UserDataBasicModel userCreateModelFromJson(String str) => UserDataBasicModel.fromJson(json.decode(str));

String userCreateModelToJson(UserDataBasicModel data) => json.encode(data.toJson());

class UserDataBasicModel {
  UserDataBasicModel({
    required this.id,
    required this.name,
    required this.statusLine,
    required this.compressedProfileImage
  });

  String id;
  String name;
  String statusLine;
  String? compressedProfileImage;

  factory UserDataBasicModel.fromJson(Map<String, dynamic> json) => UserDataBasicModel(
    id: json["_id"],
    name: json["name"],
    statusLine: json["status_line"],
    compressedProfileImage: json["compressed_profile_image"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "status_line": statusLine,
    "compressed_profile_image": compressedProfileImage,
  };
}
