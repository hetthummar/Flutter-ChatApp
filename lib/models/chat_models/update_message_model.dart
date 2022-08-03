// To parse this JSON data, do
//
//     final updateMessageModel = updateMessageModelFromJson(jsonString);

import 'dart:convert';

UpdateMessageModel updateMessageModelFromJson(String str) => UpdateMessageModel.fromJson(json.decode(str));

String updateMessageModelToJson(UpdateMessageModel data) => json.encode(data.toJson());

class UpdateMessageModel {
  UpdateMessageModel({
    required this.id,
    required this.seenAt,
    required this.deliveredAt,
    required this.msgStatus,
    required this.isSent,
  });

  String id;
  int? deliveredAt;
  bool isSent;

  int? seenAt;
  int msgStatus;

  factory UpdateMessageModel.fromJson(Map<String, dynamic> json) => UpdateMessageModel(
    id: json["_id"],
    seenAt: json["seen_at"],
    deliveredAt: json["delivered_at"],
    msgStatus: json["msg_status"],
    isSent: json["is_sent"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "seen_at": seenAt,
    "delivered_at": deliveredAt,
    "msg_status": msgStatus,
    "is_sent": isSent,
  };
}
