
import 'package:socketchat/data/local/app_databse.dart';
import 'package:socketchat/data/local/dao/message_dao/message_dao.dart';
import 'package:socketchat/models/chat_models/update_message_model.dart';

abstract class MessagesDaoHelper {

  Future insertNewMessage(MessagesTableCompanion message);
  Stream<List<MessagesTableData>> watchNewMessages(String _id,String partnerId);
  Future updateExitingMsg(UpdateMessageModel message);
  Future<List<MessagesTableData>> getOldMessages(int _id,String partnerId);
  Future<List<MessagesTableData>> getNotSentMsg(String userId);
  Future<bool> updateSeenTimeLocallyForReceiver(String msgId,int seenAt);
  Future<bool> updateMsgImageUrl({required String msgId,required bool isNetworkUrl,required String url,String? blurHashImageUri});
  Future<bool> makeAllMessageRead();
  Future<MessagesTableData?> getMessageFromId(String id);

}
