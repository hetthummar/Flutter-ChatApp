// To parse this JSON data, do
//
//     final userImageModel = userImageModelFromJson(jsonString);

import 'dart:convert';

UserImageModel userImageModelFromJson(String str) => UserImageModel.fromJson(json.decode(str));

String userImageModelToJson(UserImageModel data) => json.encode(data.toJson());

class UserImageModel {
  UserImageModel({
    required this.profileImage,
    required this.compressedProfileImage,
  });

  String profileImage;
  String compressedProfileImage;

  factory UserImageModel.fromJson(Map<String, dynamic> json) => UserImageModel(
    profileImage: json["profile_image"],
    compressedProfileImage: json["compressed_profile_image"],
  );

  Map<String, dynamic> toJson() => {
    "profile_image": profileImage,
    "compressed_profile_image": compressedProfileImage,
  };
}
