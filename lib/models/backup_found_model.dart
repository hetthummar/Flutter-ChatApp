import 'dart:convert';

BackUpFoundModel backUpFoundModelFromJson(String str) => BackUpFoundModel.fromJson(json.decode(str));

String backUpFoundModelToJson(BackUpFoundModel data) => json.encode(data.toJson());

class BackUpFoundModel {
  BackUpFoundModel({
    required this.isBackUpFound,
  });

  bool isBackUpFound;

  factory BackUpFoundModel.fromJson(Map<String, dynamic> json) => BackUpFoundModel(
    isBackUpFound: json["isBackUpFound"],
  );

  Map<String, dynamic> toJson() => {
    "isBackUpFound": isBackUpFound,
  };
}
