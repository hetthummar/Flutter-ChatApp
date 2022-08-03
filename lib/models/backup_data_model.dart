// To parse this JSON data, do
//
//     final backupDataModel = backupDataModelFromJson(jsonString);

import 'dart:convert';

import 'package:socketchat/models/recent_chat_model/recent_chat_server_model.dart';

BackupDataModel backupDataModelFromJson(String str) => BackupDataModel.fromJson(json.decode(str));

String backupDataModelToJson(BackupDataModel data) => json.encode(data.toJson());

class BackupDataModel {
  BackupDataModel({
    required this.data,
  });

  List<RecentChatServerModel> data;

  factory BackupDataModel.fromJson(Map<String, dynamic> json) => BackupDataModel(
    data: List<RecentChatServerModel>.from(json["data"].map((x) => RecentChatServerModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}