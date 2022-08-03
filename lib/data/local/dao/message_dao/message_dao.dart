import 'package:moor_flutter/moor_flutter.dart';
import 'package:socketchat/data/local/app_databse.dart';
import 'package:socketchat/data/local/dao/message_dao/messages_helper.dart';
import 'package:socketchat/data/local/tables/messages_table/messages_table.dart';
import 'package:socketchat/models/chat_models/update_message_model.dart';

part 'message_dao.g.dart';

@UseDao(tables: [MessagesTable])
class MessageDao extends DatabaseAccessor<AppDatabase>
    with _$MessageDaoMixin
    implements MessagesDaoHelper {
  final AppDatabase db;
  int pageSize = 100;

  MessageDao(this.db) : super(db);

  @override
  Future insertNewMessage(MessagesTableCompanion message) async {
    await into(messagesTable).insert(message);
  }

  @override
  Stream<List<MessagesTableData>> watchNewMessages(
      String _id, String partnerId) {
    // return db.select(MessagesTableData()).watch();

    return (select(messagesTable)
          ..where((tbl) =>
              tbl.receiverId.equals(partnerId) | tbl.senderId.equals(partnerId))
          ..orderBy(
            ([
              (t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc),
            ]),
          )
          ..limit(pageSize))
        .watch();
  }

  @override
  Future updateExitingMsg(UpdateMessageModel updateMessageModel) async {
    MessagesTableCompanion _messageTableCompanion = MessagesTableCompanion(
        msgStatus: Value(updateMessageModel.msgStatus),
        seenAt: Value(updateMessageModel.seenAt),
        deliveredAt: Value(updateMessageModel.deliveredAt),
        isSent: Value(updateMessageModel.isSent));

    (update(messagesTable)
          ..where((tbl) => tbl.mongoId.equals(updateMessageModel.id)))
        .write(_messageTableCompanion);
  }

  @override
  Future<List<MessagesTableData>> getOldMessages(
      int _id, String partnerId) async {
    return (select(messagesTable)
          ..where((tbl) =>
              tbl.receiverId.equals(partnerId) | tbl.senderId.equals(partnerId))
          ..orderBy(
            ([
              (t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc),
            ]),
          )
          ..where((tbl) => (tbl.id).isSmallerThanValue(_id))
          ..limit(pageSize))
        .get();
  }

  @override
  Future<List<MessagesTableData>> getNotSentMsg(String userId) {
    return (select(messagesTable)
          ..orderBy(
            ([
              (t) => OrderingTerm(expression: t.id, mode: OrderingMode.asc),
            ]),
          )
          ..where((tbl) =>
              (tbl.isSent).equals(false) & (tbl.senderId).equals(userId)))
        .get();
  }

  @override
  Future<bool> updateSeenTimeLocallyForReceiver(
      String msgId, int seenAt) async {
    try {
      MessagesTableCompanion _messageTableCompanion = MessagesTableCompanion(
        seenAt: Value(seenAt),
      );

      await (update(messagesTable)..where((tbl) => tbl.mongoId.equals(msgId)))
          .write(_messageTableCompanion);
      return true;
    } catch (e) {
      return false;
    }
  }

  // @override
  // Future<bool> updateMsgImageUrl({String msgId, bool isNetworkUrl, String url, String? blurHashImageUri}) {
  //   // TODO: implement updateMsgImageUrl
  //   throw UnimplementedError();
  // }

  @override
  Future<bool> updateMsgImageUrl(
      {required String msgId,
      required bool isNetworkUrl,
      required String url,
      String? blurHashImageUri}) async {
    try {
      MessagesTableCompanion _messageTableCompanion;

      if (isNetworkUrl) {
        _messageTableCompanion = MessagesTableCompanion(
            networkFileUrl: Value(url),
            blurHashImageUrl: Value(blurHashImageUri));
      } else {
        _messageTableCompanion = MessagesTableCompanion(
          localFileUrl: Value(url),
        );
      }

      await (update(messagesTable)..where((tbl) => tbl.mongoId.equals(msgId)))
          .write(_messageTableCompanion);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> makeAllMessageRead() async {
    return false;
    // MessagesTableCompanion _messageTableCompanion = MessagesTableCompanion();
    // try {
    //   await update(messagesTable)
    //       .write(_messageTableCompanion);
    // }catch(e){
    //
    // }
  }

  @override
  Future<MessagesTableData?> getMessageFromId(String id) async {
    return (await (select(messagesTable)
          ..where((tbl) => tbl.mongoId.equals(id)))
        .get())[0];
  }
}
