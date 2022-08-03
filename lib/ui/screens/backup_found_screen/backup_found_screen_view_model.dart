import 'package:socketchat/app/routes/setup_routes.router.dart';
import 'package:socketchat/base/custom_base_view_model.dart';
import 'package:socketchat/models/backup_data_model.dart';
import 'package:socketchat/models/recent_chat_model/recent_chat_local_model.dart';
import 'package:socketchat/models/recent_chat_model/recent_chat_server_model.dart';
import 'package:socketchat/utils/api_utils/api_result/api_result.dart';
import 'package:socketchat/utils/api_utils/network_exceptions/network_exceptions.dart';

class backupFoundScreenViewModel extends CustomBaseViewModel {

  downloadBackUpData() async {
    String? idOfUser = await getAuthService().getUserid();
    ApiResult<List<RecentChatServerModel>> _backUpDataModel = await getDataManager()
        .getUserBackUpData(idOfUser!);

    _backUpDataModel.when(success: (List<RecentChatServerModel> listOfRecentChat) async{
      print("BACKUP DATA MODEL :- " + listOfRecentChat.length.toString());

      for(int i = 0;i<listOfRecentChat.length;i++){
        RecentChatServerModel _recentChatServerModel = listOfRecentChat[i];
        bool isUser1 = false;
        List<String> participantList =
        List.from(_recentChatServerModel.participants);
        participantList.sort();
        int indexOfCurrentUser =
        participantList.indexWhere((element) => element == idOfUser);
        if (indexOfCurrentUser == 0) {
          isUser1 = true;
        }
        RecentChatLocalModel _recentChatLocalModel = RecentChatLocalModel(
          id: _recentChatServerModel.id,
          userName: isUser1
              ? _recentChatServerModel.user2Name
              : _recentChatServerModel.user1Name,
          userCompressedImage: isUser1
              ? _recentChatServerModel.user2CompressedImage
              : _recentChatServerModel.user1CompressedImage,
          participants: participantList,
        );

        await getDataManager().insertNewRecentChat(_recentChatLocalModel);
        getNavigationService().clearStackAndShow(Routes.mainScreenView);
      }
      await getDataManager().isBackUpDataDownloadComplete(true);

    }, failure: (NetworkExceptions e) {
      showErrorDialog(description: NetworkExceptions.getErrorMessage(e));
    });
  }

}