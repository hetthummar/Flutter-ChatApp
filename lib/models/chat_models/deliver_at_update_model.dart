// To parse this JSON data, do
//
//     final deliverAtUpdateModel = deliverAtUpdateModelFromJson(jsonString);

import 'dart:convert';

DeliverAtUpdateModel deliverAtUpdateModelFromJson(String str) => DeliverAtUpdateModel.fromJson(json.decode(str));

String deliverAtUpdateModelToJson(DeliverAtUpdateModel data) => json.encode(data.toJson());

class DeliverAtUpdateModel {
  DeliverAtUpdateModel({
    required this.id,
    required this.deliveredAt,
    required this.senderId,
  });

  String id;
  int deliveredAt;
  String senderId;

  factory DeliverAtUpdateModel.fromJson(Map<String, dynamic> json) => DeliverAtUpdateModel(
    id: json["_id"],
    deliveredAt: json["delivered_at"],
    senderId: json["sender_id"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "delivered_at": deliveredAt,
    "sender_id": senderId,
  };
}
