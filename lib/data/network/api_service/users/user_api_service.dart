import 'package:dio/dio.dart';
import 'package:socketchat/app/locator.dart';
import 'package:socketchat/const/end_points.dart';
import 'package:socketchat/data/network/api_service/users/user_api_helper.dart';
import 'package:socketchat/models/backup_data_model.dart';
import 'package:socketchat/models/backup_found_model.dart';
import 'package:socketchat/models/recent_chat_model/recent_chat_server_model.dart';
import 'package:socketchat/models/user/user_basic_data_model.dart';
import 'package:socketchat/models/user/user_basic_data_offline_model.dart';
import 'package:socketchat/models/user/user_create_model.dart';
import 'package:socketchat/models/user/user_firebase_token_model.dart';
import 'package:socketchat/models/user/user_image_model.dart';
import 'package:socketchat/models/user/user_name_status_update_model.dart';
import 'package:socketchat/models/user/user_search_model.dart';
import 'package:socketchat/models/user/user_search_result_list.dart';
import 'package:socketchat/utils/api_utils/api_result/api_result.dart';
import 'package:socketchat/utils/api_utils/network_exceptions/network_exceptions.dart';
import 'package:socketchat/utils/client.dart';

class UserApiService implements UserApiHelper{

  Client _client = locator<Client>();

  UserApiService() {
    _client =  Client();
  }

  @override
  Future<ApiResult<bool>> createUser(UserCreateModel userCreateModel) async{

    try {
      await _client.builder().build().post(EndPoints.addUser,data: userCreateModel.toJson());
      return const ApiResult.success(data: true);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }

  }

  @override
  Future<ApiResult<bool>> updateFirebaseToken(UserFirebaseTokenUpdateModel userFirebaseTokenUpdateModel) async {
    try {
      await _client.builder().build().patch(EndPoints.updateUserToken,data: userFirebaseTokenUpdateModel.toJson());
      return const ApiResult.success(data: true);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<UserSearchResultList>> searchUsers(UserSearchModel model) async{
    // try {
      Response _response = await _client.builder().build().get(EndPoints.searchUser,queryParameters:model.toJson());
      UserSearchResultList _userSearchResultList = UserSearchResultList.fromJson(_response.data);
      return ApiResult.success(data: _userSearchResultList);
    // }
    // catch (e) {
    //   // UserSearchResultList _userSearchResultList = UserSearchResultList(success: false,data: [],message:"");
    //   return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    // }
  }

  @override
  Future<ApiResult<bool>> updateNameStatusUser(UserNameStatusUpdateModel _userNameStatusUpdateModel) async{
    try {

     Client _tempClient = await _client.builder().setProtectedApiHeader();

      await _tempClient.build().patch(EndPoints.updateUser,data: _userNameStatusUpdateModel.toJson());
      return const ApiResult.success(data: true);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<UserBasicDataOfflineModel>> getUserData(String id)async {

    Map<String,String> queryParameters = {};
    queryParameters.putIfAbsent("_id", () => id);

    Client tempClient = await _client.builder().setProtectedApiHeader();

    try {
      Response _response = await tempClient.build().get(EndPoints.getSingleUser,queryParameters: queryParameters);
      UserBasicDataOfflineModel _userBasicOfflineModel = UserBasicDataOfflineModel.fromJson(_response.data['data']);
      return ApiResult.success(data: _userBasicOfflineModel);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<bool>> updateImageOfUser(UserImageModel _userImageModel) async{
    try {
      Client _tempClient = await _client.builder().setProtectedApiHeader();
      await _tempClient.build().patch(EndPoints.updateUser,data: _userImageModel.toJson());
      return const ApiResult.success(data: true);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<BackUpFoundModel>> getUserBackupDetail(String id) async{
    try {

      Map<String,String> queryParameters = {};
      queryParameters.putIfAbsent("_id", () => id);

      Client _tempClient = await _client.builder().setProtectedApiHeader();
      Response _response = await _tempClient.build().get(EndPoints.getBackupDetails,queryParameters: queryParameters);
      BackUpFoundModel _backUpFoundModel = BackUpFoundModel.fromJson(_response.data["data"]);
      return ApiResult.success(data: _backUpFoundModel);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<List<RecentChatServerModel>>> getUserBackUpData(String id) async{
    try {

      Map<String,String> queryParameters = {};
      queryParameters.putIfAbsent("_id", () => id);

      Client _tempClient = await _client.builder().setProtectedApiHeader();
      Response _response = await _tempClient.build().get(EndPoints.getUserBackupData,queryParameters: queryParameters);
      List<RecentChatServerModel> _listOfRecentChat = [];
      List<dynamic> _listOfData = _response.data["data"] as List;

      for(int i = 0 ;i<_listOfData.length;i++){
        _listOfRecentChat.add(RecentChatServerModel.fromJson(_listOfData[i]));
      }
      return ApiResult.success(data: _listOfRecentChat);
    } catch (e) {
      print("F SD :- "  + e.toString());
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

}