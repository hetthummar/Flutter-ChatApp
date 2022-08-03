import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:moor_flutter/moor_flutter.dart' as moor_flutter;
import 'package:socketchat/app/locator.dart';
import 'package:socketchat/app/routes/setup_routes.router.dart';
import 'package:socketchat/const/enums/bottom_sheet_enums.dart';
import 'package:socketchat/const/msg_status_const.dart';
import 'package:socketchat/data/data_manager.dart';
import 'package:socketchat/data/local/app_databse.dart' as moor_database;
import 'package:socketchat/data/prefs/shared_preference_service.dart';
import 'package:socketchat/models/chat_models/private_message_model.dart';
import 'package:socketchat/models/chat_models/update_message_model.dart';
import 'package:socketchat/models/recent_chat_model/recent_chat_local_model.dart';
import 'package:socketchat/models/recent_chat_model/recent_chat_server_model.dart';
import 'package:socketchat/models/user/user_basic_data_model.dart';
import 'package:socketchat/models/user/user_basic_data_offline_model.dart';
import 'package:socketchat/services/firebase_auth_service.dart';
import 'package:socketchat/services/firebase_push_notification_service.dart';
import 'package:socketchat/services/socket_service.dart';
import 'package:socketchat/utils/mongo_utils.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CustomBaseViewModel extends BaseViewModel {
  final FirebaseAuthService _firebaseAuthService =
      locator<FirebaseAuthService>();
  final FirebasePushNotificationService _firebasePushNotificationService =
      locator<FirebasePushNotificationService>();
  final SharedPreferenceService _sharedPreferenceService =
      locator<SharedPreferenceService>();

  final NavigationService _navigationService = locator<NavigationService>();
  final BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  final DialogService _dialogService = locator<DialogService>();
  final DataManager _dataManager = locator<DataManager>();
  final SocketService _socketService = locator<SocketService>();
  final moor_database.AppDatabase _appDatabase =
      locator<moor_database.AppDatabase>();

  FirebaseAuthService getAuthService() => _firebaseAuthService;

  FirebasePushNotificationService getFirebasePushNotificationService() =>
      _firebasePushNotificationService;

  NavigationService getNavigationService() => _navigationService;

  BottomSheetService getBottomSheetService() => _bottomSheetService;

  DialogService getDialogService() => _dialogService;

  DataManager getDataManager() => _dataManager;

  SocketService getSocketService() => _socketService;

  SharedPreferenceService getSharedPreferenceService() =>
      _sharedPreferenceService;

  moor_database.AppDatabase getAppDatabase() => _appDatabase;

  refreshScreen() {
    notifyListeners();
  }

  showProgressBar({String title = "Please wait..."}) {
    EasyLoading.show(status: title);
  }

  stopProgressBar() {
    EasyLoading.dismiss();
  }

  goToPreviousScreen() {
    getNavigationService().back();
  }

  gotoChatScreen(UserDataBasicModel _userBasicDataModel) {
    getNavigationService().navigateTo(Routes.chatView,
        arguments: ChatViewArguments(userDataBasicModel: _userBasicDataModel));
  }

  logOut({bool shouldRedirectToAuthenticationPage = true}) async {
    await getAuthService().logOut();
    if (shouldRedirectToAuthenticationPage) {
      getNavigationService().clearStackAndShow(Routes.authView);
    }
  }

  showErrorDialog(
      {String title = "Problem occurred",
      String description = "Some problem occurred Please try again",
      bool isDismissible = true}) async {
    stopProgressBar();
    await _bottomSheetService.showCustomSheet(
        title: title,
        description: description,
        mainButtonTitle: "OK",
        variant: bottomSheetEnum.error,
        barrierDismissible: isDismissible);
  }

  Future<void> sendMessageWithDataModel(
      {required String inputText,
        required int currentTime,
        required PrivateMessageModel privateMessageModel,
        required  String currentUserId,
        required  String id,
        required  String name,
          String? compressedProfileImage,
        required  String statusLine}) async {
    String randomMongoId2 = MongoUtils().generateUniqueMongoId();

    late UserDataBasicModel userDataBasicModel = UserDataBasicModel(
        id: id,
        name: name,
        compressedProfileImage: compressedProfileImage,
        statusLine: statusLine);

    UserBasicDataOfflineModel? _userBasicDataOfflineModel =
        await getDataManager().getUserBasicDataOfflineModel();

    if (_userBasicDataOfflineModel != null) {
      List<String> participantList = [currentUserId, userDataBasicModel.id];
      participantList.sort();

      bool isSenderUser1 = false;
      int indexOfSender =
          participantList.indexWhere((element) => element == currentUserId);
      if (indexOfSender == 0) {
        isSenderUser1 = true;
      }

      List<moor_database.RecentChatTableData> _recentChatTableData =
          await getDataManager()
              .getRecentChatTableDataFromUserIds(participantList);
      String recentChatId = randomMongoId2;
      if (_recentChatTableData.isNotEmpty) {
        recentChatId = _recentChatTableData[0].id;
      }

      RecentChatServerModel _recentChatServerModel = RecentChatServerModel(
          id: recentChatId,
          user1Name: isSenderUser1
              ? _userBasicDataOfflineModel.name
              : userDataBasicModel.name,
          user1CompressedImage: isSenderUser1
              ? _userBasicDataOfflineModel.compressedProfileImage
              : userDataBasicModel.compressedProfileImage,
          user2Name: isSenderUser1
              ? userDataBasicModel.name
              : _userBasicDataOfflineModel.name,
          user2CompressedImage: isSenderUser1
              ? userDataBasicModel.compressedProfileImage
              : _userBasicDataOfflineModel.compressedProfileImage,
          participants: participantList,
          user1LocalUpdated: isSenderUser1,
          user2LocalUpdated: !isSenderUser1,
          shouldUpdateRecentChat:
              _recentChatTableData.isNotEmpty ? true : false);

      if (_recentChatTableData.isEmpty) {
        RecentChatLocalModel _recentChatLocalModel = RecentChatLocalModel(
            id: recentChatId,
            userName: userDataBasicModel.name,
            userCompressedImage: userDataBasicModel.compressedProfileImage,
            participants: participantList,
            unreadMsg: 0,
            lastMsg: inputText,
            lastMsgTime: currentTime,
            shouldUpdate: false);
        getDataManager().insertNewRecentChat(_recentChatLocalModel);
      }

      await getSocketService().sendPrivateMessage(
        privateMessageModel,
        _recentChatServerModel,
        () async {
          UpdateMessageModel _updateMessageModel = UpdateMessageModel(
              id: privateMessageModel.id!,
              seenAt: null,
              deliveredAt: null,
              msgStatus: MsgStatus.sent,
              isSent: true);

          moor_database.RecentChatTableCompanion _recentChatTableCompanion =
              moor_database.RecentChatTableCompanion(
                  id: moor_flutter.Value(recentChatId),
                  last_msg_time: moor_flutter.Value(currentTime),
                  last_msg_text: moor_flutter.Value(inputText));

          await getDataManager().updateExitingMsg(_updateMessageModel);
          await getDataManager()
              .updateRecentChatTableData(_recentChatTableCompanion);
        },
      );
    }
  }
}
