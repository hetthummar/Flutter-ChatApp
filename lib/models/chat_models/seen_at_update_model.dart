import 'dart:convert';

SeenAtUpdateModel seenAtUpdateModelFromJson(String str) => SeenAtUpdateModel.fromJson(json.decode(str));

String seenAtUpdateModelToJson(SeenAtUpdateModel data) => json.encode(data.toJson());

class SeenAtUpdateModel {
  SeenAtUpdateModel({
    required this.id,
    required this.seenAt,
    required this.senderId,
  });

  String id;
  int seenAt;
  String senderId;

  factory SeenAtUpdateModel.fromJson(Map<String, dynamic> json) => SeenAtUpdateModel(
    id: json["_id"],
    seenAt: json["seen_at"],
    senderId: json["sender_id"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "seen_at": seenAt,
    "sender_id": senderId,
  };
}
