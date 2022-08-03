// To parse this JSON data, do
//
//     final recentChatServerModel = recentChatServerModelFromJson(jsonString);

import 'dart:convert';

RecentChatServerModel recentChatServerModelFromJson(String str) => RecentChatServerModel.fromJson(json.decode(str));

String recentChatServerModelToJson(RecentChatServerModel data) => json.encode(data.toJson());

class RecentChatServerModel {
  RecentChatServerModel({
    required this.id,
    required this.user1Name,
     this.user1CompressedImage,
    required this.user2Name,
     this.user2CompressedImage,
    required this.participants,
    required this.user1LocalUpdated,
    required this.user2LocalUpdated,
     this.shouldUpdateRecentChat,
  });

  String id;
  String user1Name;
  String? user1CompressedImage;
  String user2Name;
  String? user2CompressedImage;
  List<String> participants;
  bool user1LocalUpdated;
  bool user2LocalUpdated;
  bool? shouldUpdateRecentChat;

  factory RecentChatServerModel.fromJson(Map<String, dynamic> json) => RecentChatServerModel(
    id: json["_id"],
    user1Name: json["user1_name"],
    user1CompressedImage: json["user1_compressed_image"],
    user2Name: json["user2_name"],
    user2CompressedImage: json["user2_compressed_image"],
    participants: List<String>.from(json["participants"].map((x) => x)),
    user1LocalUpdated: json["user1_local_updated"],
    user2LocalUpdated: json["user2_local_updated"],
    shouldUpdateRecentChat: json["should_update_recent_chat"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user1_name": user1Name,
    "user1_compressed_image": user1CompressedImage,
    "user2_name": user2Name,
    "user2_compressed_image": user2CompressedImage,
    "participants": List<dynamic>.from(participants.map((x) => x)),
    "user1_local_updated": user1LocalUpdated,
    "user2_local_updated": user2LocalUpdated,
    "should_update_recent_chat": shouldUpdateRecentChat,
  };
}
