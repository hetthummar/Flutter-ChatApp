// To parse this JSON data, do
//
//     final userNameStatusUpdateModel = userNameStatusUpdateModelFromJson(jsonString);

import 'dart:convert';

UserNameStatusUpdateModel userNameStatusUpdateModelFromJson(String str) => UserNameStatusUpdateModel.fromJson(json.decode(str));

String userNameStatusUpdateModelToJson(UserNameStatusUpdateModel data) => json.encode(data.toJson());

class UserNameStatusUpdateModel {
  UserNameStatusUpdateModel({
    required this.name,
    required this.statusLine,
  });

  String name;
  String statusLine;

  factory UserNameStatusUpdateModel.fromJson(Map<String, dynamic> json) => UserNameStatusUpdateModel(
    name: json["name"],
    statusLine: json["status_line"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "status_line": statusLine,
  };
}
