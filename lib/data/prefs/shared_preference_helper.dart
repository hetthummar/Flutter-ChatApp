import 'package:socketchat/models/user/user_basic_data_offline_model.dart';

abstract class SharedPreferenceHelper{
  Future<bool> saveUserBasicDataOfflineModel(UserBasicDataOfflineModel _userBasicDataOfflineModel);
  Future<UserBasicDataOfflineModel?> getUserBasicDataOfflineModel();
  Future<bool> clearSharedPreference();
  Future<bool> isBackUpDataDownloadComplete(bool status);
  Future<bool> getBackUpDataDownloadStatus();

}