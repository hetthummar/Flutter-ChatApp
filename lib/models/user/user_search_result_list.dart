// To parse this JSON data, do
//
//     final userSearchResultList = userSearchResultListFromJson(jsonString);

import 'dart:convert';

import 'package:socketchat/models/user/user_basic_data_model.dart';

UserSearchResultList userSearchResultListFromJson(String str) => UserSearchResultList.fromJson(json.decode(str));

String userSearchResultListToJson(UserSearchResultList data) => json.encode(data.toJson());

class UserSearchResultList {
  UserSearchResultList({
    required this.success,
    required this.data,
    required this.message,
  });

  bool success;
  List<UserDataBasicModel> data;
  String message;

  factory UserSearchResultList.fromJson(Map<String, dynamic> json) => UserSearchResultList(
    success: json["success"],
    data: List<UserDataBasicModel>.from(json["data"].map((x) => UserDataBasicModel.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "message": message,
  };
}
