import 'package:moor_flutter/moor_flutter.dart';
import 'package:socketchat/data/local/app_databse.dart';
import 'package:socketchat/data/local/dao/recent_chat_dao/recent_chat_helper.dart';
import 'package:socketchat/data/local/tables/recent_chat_table/recent_chat_table.dart';
import 'package:socketchat/data/local/app_databse.dart';
import 'package:socketchat/models/recent_chat_model/recent_chat_local_model.dart';

part 'recent_chat_dao.g.dart';

@UseDao(tables: [RecentChatTable])
class RecentChatDao extends DatabaseAccessor<AppDatabase>
    with _$RecentChatDaoMixin
    implements RecentChatDaoHelper {
  final AppDatabase db;

  // int pageSize = 100;

  RecentChatDao(this.db) : super(db);

  @override
  Future insertNewRecentChat(RecentChatLocalModel _recentChatModel) async {

    print("JEIO :- " + _recentChatModel.toJson().toString());
    print("JEIO :- " + _recentChatModel.userCompressedImage.toString());

    RecentChatTableCompanion _recentChatTableCompanion =
    RecentChatTableCompanion(
      id: Value(_recentChatModel.id),
      user_name: Value(_recentChatModel.userName),
      user_compressed_image: Value(_recentChatModel.userCompressedImage),
      participants: Value(_recentChatModel.participants),
      // unread_msg: Value(_recentChatModel.unreadMsg ?? 0),
      last_msg_time: Value(_recentChatModel.lastMsgTime),
      last_msg_text: Value(_recentChatModel.lastMsg),
    );

    await into(recentChatTable).insert(_recentChatTableCompanion,mode: InsertMode.insertOrReplace);
  }

  @override
  Stream<List<RecentChatTableData>> watchRecentChat() {
    return (select(recentChatTable)
      ..orderBy(
        ([
              (t) =>
              OrderingTerm(
                  expression: t.last_msg_time, mode: OrderingMode.desc),
        ]),
      ))
        .watch();
  }

  @override
  Future<List<RecentChatTableData>> getRecentChatTableDataFromUserIds(
      List<String> userIdList) async {
    return await (select(recentChatTable)
      ..where((tbl) => tbl.participants.equalsValue(userIdList)))
        .get();
  }

  @override
  Future updateRecentChatTableData(
      RecentChatTableCompanion _recentChatTableCompanion) async {
    return await (update(recentChatTable)
      ..where((tbl) => tbl.id.equals(_recentChatTableCompanion.id.value)))
        .write(_recentChatTableCompanion);
  }

  @override
  Future makeAllMsgRead(List<String> userIdList) async {
    RecentChatTableCompanion _recentChatTableCompanion = const RecentChatTableCompanion(unread_msg: Value(0));
    return await (update(recentChatTable)
      ..where((tbl) => tbl.participants.equalsValue(userIdList))).write(
        _recentChatTableCompanion);
  }
}
