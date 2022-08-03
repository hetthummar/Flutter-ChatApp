import 'dart:convert';

UserSearchModel userSearchModelFromJson(String str) => UserSearchModel.fromJson(json.decode(str));

String userSearchModelToJson(UserSearchModel data) => json.encode(data.toJson());

class UserSearchModel {
  UserSearchModel({
    required this.searchFor,
    required this.startAfterId,
  });

  String searchFor;
  String? startAfterId;

  factory UserSearchModel.fromJson(Map<String, dynamic> json) => UserSearchModel(
    searchFor: json["search_for"],
    startAfterId: json["start_after_id"],
  );

  Map<String, dynamic> toJson() => {
    "search_for": searchFor,
    "start_after_id": startAfterId,
  };
}
