import 'package:socketchat/models/backup_data_model.dart';
import 'package:socketchat/models/backup_found_model.dart';
import 'package:socketchat/models/recent_chat_model/recent_chat_server_model.dart';
import 'package:socketchat/models/user/user_basic_data_offline_model.dart';
import 'package:socketchat/models/user/user_create_model.dart';
import 'package:socketchat/models/user/user_firebase_token_model.dart';
import 'package:socketchat/models/user/user_image_model.dart';
import 'package:socketchat/models/user/user_name_status_update_model.dart';
import 'package:socketchat/models/user/user_search_model.dart';
import 'package:socketchat/models/user/user_search_result_list.dart';
import 'package:socketchat/utils/api_utils/api_result/api_result.dart';

abstract class UserApiHelper {

  Future<ApiResult<bool>> createUser(
    UserCreateModel userCreateModel,
  );

  Future<ApiResult<bool>> updateFirebaseToken(
      UserFirebaseTokenUpdateModel userFirebaseTokenUpdateModel,
      );

  Future<ApiResult<UserSearchResultList>> searchUsers(UserSearchModel model);

  Future<ApiResult<bool>> updateNameStatusUser(UserNameStatusUpdateModel _userNameStatusUpdateModel);
  Future<ApiResult<bool>> updateImageOfUser(UserImageModel _userImageModel);
  Future<ApiResult<UserBasicDataOfflineModel>> getUserData(String id);
  Future<ApiResult<BackUpFoundModel>> getUserBackupDetail(String id);
  Future<ApiResult<List<RecentChatServerModel>>> getUserBackUpData(String id);

}
