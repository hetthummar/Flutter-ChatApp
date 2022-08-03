import 'dart:convert';

UserConnectionStatusRequestModel userConnectionStatusModelFromJson(String str) => UserConnectionStatusRequestModel.fromJson(json.decode(str));

String userConnectionStatusModelToJson(UserConnectionStatusRequestModel data) => json.encode(data.toJson());

class UserConnectionStatusRequestModel {
  UserConnectionStatusRequestModel({
    required this.id,
  });

  String id;

  factory UserConnectionStatusRequestModel.fromJson(Map<String, dynamic> json) => UserConnectionStatusRequestModel(
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
  };
}
