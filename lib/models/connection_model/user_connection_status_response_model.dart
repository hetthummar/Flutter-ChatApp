import 'dart:convert';

UserConnectionStatusResponseModel userConnectionStatusModelFromJson(String str) => UserConnectionStatusResponseModel.fromJson(json.decode(str));

String userConnectionStatusModelToJson(UserConnectionStatusResponseModel data) => json.encode(data.toJson());

class UserConnectionStatusResponseModel {
  UserConnectionStatusResponseModel({
    required this.data,
  });

  bool data;

  factory UserConnectionStatusResponseModel.fromJson(Map<String, dynamic> json) => UserConnectionStatusResponseModel(
    data: json["data"],
  );

  Map<String, dynamic> toJson() => {
    "data": data,
  };
}
