import 'dart:convert';

UserFirebaseTokenUpdateModel userFirebaseTokenUpdateModelFromJson(String str) => UserFirebaseTokenUpdateModel.fromJson(json.decode(str));

String userFirebaseTokenUpdateModelToJson(UserFirebaseTokenUpdateModel data) => json.encode(data.toJson());

class UserFirebaseTokenUpdateModel {
  UserFirebaseTokenUpdateModel({
    required this.id,
    required this.firebaseTokenId,
  });

  String firebaseTokenId;
  String id;

  factory UserFirebaseTokenUpdateModel.fromJson(Map<String, dynamic> json) => UserFirebaseTokenUpdateModel(
    id: json["_id"],
    firebaseTokenId: json["firebase_token_id"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "firebase_token_id": firebaseTokenId,
  };
}
