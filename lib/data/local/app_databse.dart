// @UseMoor(tables: [MessagesTable],daos: [MessageDao])
// class AppDatabase extends _$AppDatabase{
//   AppDatabase()
//       : super((FlutterQueryExecutor.inDatabaseFolder(
//     path: 'chat_app_database.sqlite',
//     logStatements: true,
//   )));
//   @override1
//   int get schemaVersion => 1;
// }

import 'package:moor_flutter/moor_flutter.dart';
import 'package:socketchat/data/local/dao/message_dao/message_dao.dart';
import 'package:socketchat/data/local/dao/recent_chat_dao/recent_chat_dao.dart';
import 'package:socketchat/data/local/tables/messages_table/messages_table.dart';
import 'package:socketchat/data/local/tables/recent_chat_table/recent_chat_table.dart';

part 'app_databse.g.dart';

@UseMoor(tables: [MessagesTable,RecentChatTable],daos: [MessageDao,RecentChatDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super( (FlutterQueryExecutor.inDatabaseFolder(
    path: 'chat_app_database_trial63.sqlite',
    logStatements: true,
  )));

  @override
  int get schemaVersion => 1;

  Future<void> deleteAllTables() {
    return transaction(() async {
      for (final table in allTables) {
        await delete(table).go();
      }
    });
  }

}

