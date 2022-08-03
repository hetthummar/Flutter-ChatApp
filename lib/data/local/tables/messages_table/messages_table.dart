import 'dart:convert';

import 'package:moor_flutter/moor_flutter.dart';

class MessagesTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get mongoId => text()();

  TextColumn get msgContentType => text()();

  TextColumn get msgContent => text()();

  IntColumn get msgStatus => integer()();

  TextColumn get senderId => text()();

  TextColumn get receiverId => text()();
  TextColumn get receiverName => text().nullable()();
  TextColumn get receiverCompressedProfileImage => text().nullable()();

  IntColumn get createdAt => integer()();

  IntColumn get deliveredAt => integer().nullable()();

  IntColumn get seenAt => integer().nullable()();

  BoolColumn get isSent => boolean().withDefault(const Constant(false))();

  TextColumn get localFileUrl => text().nullable()();

  TextColumn get networkFileUrl => text().nullable()();
  TextColumn get blurHashImageUrl => text().nullable()();

  TextColumn get imageInfo =>
      text().map(const imageInfoConvertor()).nullable()();


}

class imageInfoConvertor extends TypeConverter<Map<String, dynamic>, String> {
  const imageInfoConvertor();

  includes() {}

  @override
  Map<String, dynamic>? mapToDart(String? fromDb) {
    if (fromDb != null) {
      return (json.decode(fromDb) as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  @override
  String? mapToSql(Map<String, dynamic>? value) {
    if (value != null) {
      return json.encode(value);
    } else {
      return null;
    }
  }
}
