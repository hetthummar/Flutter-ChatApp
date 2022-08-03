// To parse this JSON data, do
//
//     final idModel = idModelFromJson(jsonString);

import 'dart:convert';

IdModel idModelFromJson(String str) => IdModel.fromJson(json.decode(str));

String idModelToJson(IdModel data) => json.encode(data.toJson());

class IdModel {
  IdModel({
    required this.id,
  });

  String id;

  factory IdModel.fromJson(Map<String, dynamic> json) => IdModel(
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
  };
}
