// To parse this JSON data, do
//
//     final userCreateModel = userCreateModelFromJson(jsonString);

import 'dart:convert';

UserCreateModel userCreateModelFromJson(String str) => UserCreateModel.fromJson(json.decode(str));

String userCreateModelToJson(UserCreateModel data) => json.encode(data.toJson());

class UserCreateModel {
  UserCreateModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.firebaseTokenId,
    required this.statusLine,
  });

  //status_line

  String id;
  String name;
  String phoneNumber;
  String firebaseTokenId;
  String statusLine;

  factory UserCreateModel.fromJson(Map<String, dynamic> json) => UserCreateModel(
    id: json["_id"],
    name: json["name"],
    phoneNumber: json["phoneNumber"],
    firebaseTokenId: json["firebase_token_id"],
    statusLine: json["status_line"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "phoneNumber": phoneNumber,
    "firebase_token_id": firebaseTokenId,
    "status_line": statusLine,
  };
}
