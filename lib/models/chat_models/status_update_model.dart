import 'dart:convert';

StatusUpdateModel statusUpdateModelFromJson(String str) => StatusUpdateModel.fromJson(json.decode(str));

String statusUpdateModelToJson(StatusUpdateModel data) => json.encode(data.toJson());

class StatusUpdateModel {
  StatusUpdateModel({
    required this.id,
    required this.msgStatus,
  });

  String id;
  int msgStatus;

  factory StatusUpdateModel.fromJson(Map<String, dynamic> json) => StatusUpdateModel(
    id: json["_id"],
    msgStatus: json["msg_status"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "msg_status": msgStatus,
  };
}
