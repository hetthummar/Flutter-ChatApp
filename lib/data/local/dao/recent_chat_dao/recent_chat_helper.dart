import 'package:socketchat/data/local/app_databse.dart';
import 'package:socketchat/models/recent_chat_model/recent_chat_local_model.dart';

abstract class RecentChatDaoHelper {

  Future insertNewRecentChat(RecentChatLocalModel _recentChatModel);
  Stream<List<RecentChatTableData>> watchRecentChat();
  Future<List<RecentChatTableData>> getRecentChatTableDataFromUserIds(List<String> userIdList);
  Future updateRecentChatTableData(RecentChatTableCompanion _recentChatTableCompanion);
  Future makeAllMsgRead(List<String> userIdList);


}
