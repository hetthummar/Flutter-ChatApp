// To parse this JSON data, do
//
//     final recentChatModel = recentChatModelFromJson(jsonString);

import 'dart:convert';

RecentChatLocalModel recentChatModelFromJson(String str) => RecentChatLocalModel.fromJson(json.decode(str));

String recentChatModelToJson(RecentChatLocalModel data) => json.encode(data.toJson());

class RecentChatLocalModel {
  RecentChatLocalModel({
    required this.id,
    required this.userName,
     this.userCompressedImage,
    required this.participants,
     this.unreadMsg,
     this.lastMsgTime,
     this.lastMsg,
     this.shouldUpdate,
  });

  String id;
  String userName;
  String? userCompressedImage;
  List<String> participants;
  int? unreadMsg;
  int? lastMsgTime;
  String? lastMsg;
  bool? shouldUpdate;

  factory RecentChatLocalModel.fromJson(Map<String, dynamic> json) => RecentChatLocalModel(
    id: json["_id"],
    userName: json["user_name"],
    userCompressedImage: json["user_compressed_image"],
    participants: List<String>.from(json["participants"].map((x) => x)),
    unreadMsg: json["unread_msg"],
    lastMsgTime: json["last_msg_time"],
    lastMsg: json["last_msg"],
    shouldUpdate: json["should_update"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_name": userName,
    "user_compressed_image": userCompressedImage,
    "participants": List<dynamic>.from(participants.map((x) => x)),
    "unread_msg": unreadMsg,
    "last_msg_time": lastMsgTime,
    "last_msg": lastMsg,
    "should_update": shouldUpdate,
  };
}
