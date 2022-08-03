// To parse this JSON data, do
//
//     final privateMessageModel = privateMessageModelFromJson(jsonString);

import 'dart:convert';

PrivateMessageModel privateMessageModelFromJson(String str) =>
    PrivateMessageModel.fromJson(json.decode(str));

String privateMessageModelToJson(PrivateMessageModel data) =>
    json.encode(data.toJson());

class PrivateMessageModel {
  PrivateMessageModel({
    this.id,
    required this.participants,
    required this.receiverId,
    required this.senderId,
    required this.senderName,
     this.senderPlaceholderImage,
    required this.msgContent,
    required this.msgContentType,
    required this.createdAt,
    this.deliveredAt,
    this.seenAt,
    required this.msgStatus,
    this.networkFileUrl,
    this.imageInfo,
    this.blurHashImage,
  });

  String? id;
  Participants participants;
  String receiverId;
  String senderId;
  String senderName;
  String? senderPlaceholderImage;
  String msgContent;
  String msgContentType;
  int createdAt;
  int? deliveredAt;
  int? seenAt;
  int msgStatus;
  String? networkFileUrl;
  String? blurHashImage;
  Map<String, dynamic>? imageInfo;

  factory PrivateMessageModel.fromJson(Map<String, dynamic> json) =>
      PrivateMessageModel(
        id: json["_id"],
        participants: Participants.fromJson(json["participants"]),
        receiverId: json["receiver_id"],
        senderId: json["sender_id"],
        senderName: json["sender_name"],
        senderPlaceholderImage: json["sender_placeholder_image"],
        msgContent: json["msg_content"],
        msgContentType: json["msg_content_type"],
        createdAt: json["created_at"],
        deliveredAt: json["delivered_at"],
        seenAt: json["seen_at"],
        msgStatus: json["msg_status"],
        networkFileUrl: json["network_file_url"],
        imageInfo: json["image_info"],
        blurHashImage: json["blur_hash_image"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "participants": participants.toJson(),
        "receiver_id": receiverId,
        "sender_id": senderId,
        "sender_name": senderName,
        "sender_placeholder_image": senderPlaceholderImage,
        "msg_content": msgContent,
        "msg_content_type": msgContentType,
        "created_at": createdAt,
        "delivered_at": deliveredAt,
        "seen_at": seenAt,
        "msg_status": msgStatus,
        "network_file_url": networkFileUrl,
        "image_info": imageInfo,
        "blur_hash_image": blurHashImage,
      };
}

class Participants {
  Participants({
    required this.user1Id,
    required this.user2Id,
  });

  String user1Id;
  String user2Id;

  factory Participants.fromJson(Map<String, dynamic> json) => Participants(
        user1Id: json["user1_id"],
        user2Id: json["user2_id"],
      );

  Map<String, dynamic> toJson() => {
        "user1_id": user1Id,
        "user2_id": user2Id,
      };
}
