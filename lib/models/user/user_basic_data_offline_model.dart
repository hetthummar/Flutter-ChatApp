// To parse this JSON data, do
//
//     final userCreateModel = userCreateModelFromJson(jsonString);

import 'dart:convert';

UserBasicDataOfflineModel userCreateModelFromJson(String str) => UserBasicDataOfflineModel.fromJson(json.decode(str));

String userCreateModelToJson(UserBasicDataOfflineModel data) => json.encode(data.toJson());

class UserBasicDataOfflineModel {
  UserBasicDataOfflineModel({
    required this.id,
    required this.name,
    required this.statusLine,
    required this.compressedProfileImage,
    required this.profileImage
  });

  String id;
  String name;
  String statusLine;
  String? compressedProfileImage;
  String? profileImage;

  factory UserBasicDataOfflineModel.fromJson(Map<String, dynamic> json) => UserBasicDataOfflineModel(
    id: json["_id"],
    name: json["name"],
    statusLine: json["status_line"],
    compressedProfileImage: json["compressed_profile_image"],
    profileImage: json["profile_image"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "status_line": statusLine,
    "compressed_profile_image": compressedProfileImage,
    "profile_image": profileImage,
  };
}
