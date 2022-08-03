import 'package:socketchat/app/locator.dart';
import 'package:socketchat/data/local/app_databse.dart';
import 'package:socketchat/data/local/dao/message_dao/message_dao.dart';
import 'package:socketchat/data/network/api_service/message_service/message_api_helper.dart';
import 'package:socketchat/data/network/api_service/message_service/message_api_service.dart';
import 'package:socketchat/data/network/api_service/user_connection_status/user_connection_status_service.dart';
import 'package:socketchat/data/prefs/shared_preference_service.dart';
import 'package:socketchat/models/backup_data_model.dart';
import 'package:socketchat/models/backup_found_model.dart';
import 'package:socketchat/models/basic_models/id_model.dart';
import 'package:socketchat/models/chat_models/deliver_at_update_model.dart';
import 'package:socketchat/models/chat_models/private_message_model.dart';
import 'package:socketchat/models/recent_chat_model/recent_chat_local_model.dart';
import 'package:socketchat/models/chat_models/seen_at_update_model.dart';
import 'package:socketchat/models/chat_models/status_update_model.dart';
import 'package:socketchat/models/chat_models/update_message_model.dart';
import 'package:socketchat/models/connection_model/user_connection_status_request_model.dart';
import 'package:socketchat/models/connection_model/user_connection_status_response_model.dart';
import 'package:socketchat/models/recent_chat_model/recent_chat_server_model.dart';
import 'package:socketchat/models/user/user_basic_data_offline_model.dart';
import 'package:socketchat/models/user/user_create_model.dart';

import 'package:socketchat/models/user/user_firebase_token_model.dart';
import 'package:socketchat/models/user/user_image_model.dart';
import 'package:socketchat/models/user/user_name_status_update_model.dart';
import 'package:socketchat/models/user/user_search_model.dart';
import 'package:socketchat/models/user/user_search_result_list.dart';

import 'package:socketchat/utils/api_utils/api_result/api_result.dart';

import 'data_manager_helper.dart';
import 'network/api_service/users/user_api_service.dart';

class DataManager implements DataManagerHelper {
  final UserApiService _userApiServices = locator<UserApiService>();
  final AppDatabase _appDatabase = locator<AppDatabase>();
  final MessageApiService _messageApiService = locator<MessageApiService>();
  final UserConnectionStatusService _userConnectionStatusService = locator<UserConnectionStatusService>();
  final SharedPreferenceService _sharedPreferenceService = locator<SharedPreferenceService>();

  @override
  Future<ApiResult<bool>> createUser(UserCreateModel userCreateModel) {
    return _userApiServices.createUser(userCreateModel);
  }

  @override
  Future<ApiResult<bool>> updateFirebaseToken(
      UserFirebaseTokenUpdateModel userFirebaseTokenUpdateModel) {
    return _userApiServices.updateFirebaseToken(userFirebaseTokenUpdateModel);
  }

  @override
  Future<ApiResult<UserSearchResultList>> searchUsers(UserSearchModel model) {
    return _userApiServices.searchUsers(model);
  }

  @override
  Future insertNewMessage(MessagesTableCompanion message) {
    return _appDatabase.messageDao.insertNewMessage(message);
  }

  @override
  Stream<List<MessagesTableData>> watchNewMessages(String _id,String partnerId) {
    return _appDatabase.messageDao.watchNewMessages(_id,partnerId);
  }

  @override
  Future<List<MessagesTableData>> getOldMessages(int _id,String partnerId) {
    return _appDatabase.messageDao.getOldMessages(_id,partnerId);
  }

  @override
  Future<ApiResult<bool>> sendPrivateMessage(
      PrivateMessageModel privateMessageModel,RecentChatServerModel recentChatServerModel) {
    return _messageApiService.sendPrivateMessage(privateMessageModel,recentChatServerModel);
  }

  @override
  Future updateExitingMsg(UpdateMessageModel message) {
    return _appDatabase.messageDao.updateExitingMsg(message);
  }

  @override
  Future<ApiResult<bool>> updateMsgDeliverTime(DeliverAtUpdateModel deliverAtUpdateModel) {
    return _messageApiService.updateMsgDeliverTime(deliverAtUpdateModel);
  }

  @override
  Future<ApiResult<bool>> updateMsgSeenTime(SeenAtUpdateModel seenAtUpdateModel) {
    return _messageApiService.updateMsgSeenTime(seenAtUpdateModel);
  }

  @override
  Future<ApiResult<UserConnectionStatusResponseModel>> getUserConnectionStatus(UserConnectionStatusRequestModel userConnectionStatusModel) {
    return _userConnectionStatusService.getUserConnectionStatus(userConnectionStatusModel);
  }

  @override
  Future<ApiResult<bool>> msgUpdatedLocallyForSender(IdModel _idModel) {
    return _messageApiService.msgUpdatedLocallyForSender(_idModel);
  }

  @override
  Future<List<MessagesTableData>> getNotSentMsg(String userId) {
    return _appDatabase.messageDao.getNotSentMsg(userId);
  }

  @override
  Future<bool> updateSeenTimeLocallyForReceiver(String msgId, int seenAt) {
    return _appDatabase.messageDao.updateSeenTimeLocallyForReceiver(msgId, seenAt);
  }



  @override
  Future<ApiResult<bool>> updateNameStatusUser(UserNameStatusUpdateModel _userNameStatusUpdateModel) {
    return _userApiServices.updateNameStatusUser(_userNameStatusUpdateModel);
  }

  @override
  Future<ApiResult<UserBasicDataOfflineModel>> getUserData(String id) {
    return _userApiServices.getUserData(id);
  }

  @override
  Future<UserBasicDataOfflineModel?> getUserBasicDataOfflineModel() {
    return _sharedPreferenceService.getUserBasicDataOfflineModel();
  }

  @override
  Future<bool> saveUserBasicDataOfflineModel(UserBasicDataOfflineModel _userBasicDataOfflineModel) {
    return _sharedPreferenceService.saveUserBasicDataOfflineModel(_userBasicDataOfflineModel);
  }

  @override
  Future<ApiResult<bool>> updateImageOfUser(UserImageModel _userImageModel) {
    return _userApiServices.updateImageOfUser(_userImageModel);
  }

  @override
  Future insertNewRecentChat(RecentChatLocalModel _recentChatModel) {
    return _appDatabase.recentChatDao.insertNewRecentChat(_recentChatModel);
  }

  @override
  Stream<List<RecentChatTableData>> watchRecentChat() {
    return _appDatabase.recentChatDao.watchRecentChat();
  }

  @override
  Future<List<RecentChatTableData>> getRecentChatTableDataFromUserIds(List<String> userIdList) {
    return _appDatabase.recentChatDao.getRecentChatTableDataFromUserIds(userIdList);
  }

  @override
  Future updateRecentChatTableData(RecentChatTableCompanion _recentChatTableCompanion) {
    return _appDatabase.recentChatDao.updateRecentChatTableData(_recentChatTableCompanion);
  }

  @override
  Future makeAllMsgRead(List<String> userIdList) {
    return _appDatabase.recentChatDao.makeAllMsgRead(userIdList);
  }

  @override
  Future<bool> updateMsgImageUrl({required String msgId, required bool isNetworkUrl, required String url, String? blurHashImageUri}) {
    return _appDatabase.messageDao.updateMsgImageUrl(msgId: msgId, isNetworkUrl: isNetworkUrl, url: url,blurHashImageUri: blurHashImageUri);
  }

  @override
  Future<bool> makeAllMessageRead() {
    return _appDatabase.messageDao.makeAllMessageRead();
  }

  @override
  Future<bool> clearSharedPreference() {
    return _sharedPreferenceService.clearSharedPreference();
  }

  @override
  Future<MessagesTableData?> getMessageFromId(String id) {
    return _appDatabase.messageDao.getMessageFromId(id);
  }

  @override
  Future<ApiResult<bool>> updateRecentChat(Map<String, Object> updateObject) {
    return _messageApiService.updateRecentChat(updateObject);
  }

  @override
  Future<ApiResult<BackUpFoundModel>> getUserBackupDetail(String id) {
    return _userApiServices.getUserBackupDetail(id);
  }

  @override
  Future<ApiResult<List<RecentChatServerModel>>> getUserBackUpData(String id) {
    return _userApiServices.getUserBackUpData(id);
  }

  @override
  Future<bool> getBackUpDataDownloadStatus() {
    return _sharedPreferenceService.getBackUpDataDownloadStatus();
  }

  @override
  Future<bool> isBackUpDataDownloadComplete(bool status) {
    return _sharedPreferenceService.isBackUpDataDownloadComplete(status);
  }


}
