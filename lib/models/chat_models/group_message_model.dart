// To parse this JSON data, do
//
//     final groupMessageModel = groupMessageModelFromJson(jsonString);

import 'dart:convert';

GroupMessageModel groupMessageModelFromJson(String str) => GroupMessageModel.fromJson(json.decode(str));

String groupMessageModelToJson(GroupMessageModel data) => json.encode(data.toJson());

class GroupMessageModel {
  GroupMessageModel({
    required this.id,
    required this.groupId,
    required this.senderId,
    required this.senderName,
    required this.senderPlaceholderImage,
    required this.msgContent,
    required this.msgContentType,
    required this.createAt,
  });

  String id;
  String groupId;
  String senderId;
  String senderName;
  String senderPlaceholderImage;
  String msgContent;
  String msgContentType;
  int createAt;

  factory GroupMessageModel.fromJson(Map<String, dynamic> json) => GroupMessageModel(
    id: json["_id"],
    groupId: json["group_id"],
    senderId: json["sender_id"],
    senderName: json["sender_name"],
    senderPlaceholderImage: json["sender_placeholder_image"],
    msgContent: json["msgContent"],
    msgContentType: json["msgContentType"],
    createAt: json["create_at"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "group_id": groupId,
    "sender_id": senderId,
    "sender_name": senderName,
    "sender_placeholder_image": senderPlaceholderImage,
    "msg_content": msgContent,
    "msg_content_type": msgContentType,
    "create_at": createAt,
  };
}
