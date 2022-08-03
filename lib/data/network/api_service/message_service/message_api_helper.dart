import 'package:socketchat/models/basic_models/id_model.dart';
import 'package:socketchat/models/chat_models/deliver_at_update_model.dart';
import 'package:socketchat/models/chat_models/private_message_model.dart';
import 'package:socketchat/models/recent_chat_model/recent_chat_local_model.dart';
import 'package:socketchat/models/chat_models/seen_at_update_model.dart';
import 'package:socketchat/models/chat_models/status_update_model.dart';
import 'package:socketchat/models/recent_chat_model/recent_chat_server_model.dart';
import 'package:socketchat/models/user/user_create_model.dart';
import 'package:socketchat/models/user/user_firebase_token_model.dart';
import 'package:socketchat/models/user/user_search_model.dart';
import 'package:socketchat/models/user/user_search_result_list.dart';
import 'package:socketchat/utils/api_utils/api_result/api_result.dart';

abstract class MessageApiHelper {
  Future<ApiResult<bool>> sendPrivateMessage(
      PrivateMessageModel privateMessageModel,
      RecentChatServerModel _recentChatModel);

  Future<ApiResult<bool>> updateMsgDeliverTime(
    DeliverAtUpdateModel statusUpdateModel,
  );

  //
  Future<ApiResult<bool>> updateMsgSeenTime(
    SeenAtUpdateModel seenAtUpdateModel,
  );

  Future<ApiResult<bool>> msgUpdatedLocallyForSender(IdModel _idModel);
  Future<ApiResult<bool>> updateRecentChat(Map<String,Object> updateObject);
}
