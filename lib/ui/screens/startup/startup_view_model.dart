import 'package:socketchat/app/routes/setup_routes.router.dart';
import 'package:socketchat/base/custom_base_view_model.dart';
import 'package:socketchat/models/user/user_basic_data_offline_model.dart';

class StartUpViewModel extends CustomBaseViewModel {
  runStartupLogic() async {
    // await getAuthService().signOut();
    bool isLoggedIn = await getAuthService().isUserLoggedIn();
    UserBasicDataOfflineModel? _userBasicDataOfflineModel =
        await getDataManager().getUserBasicDataOfflineModel();
    if (isLoggedIn && _userBasicDataOfflineModel != null) {

      bool result = await getDataManager().getBackUpDataDownloadStatus();
      print("RESULT : " + result.toString());
      if(result){
        getNavigationService().clearStackAndShow(Routes.mainScreenView);
      }else{
        getNavigationService().clearStackAndShow(Routes.backUpFoundScreen);
      }

    } else {
      await getAuthService().logOut();
      getNavigationService().clearStackAndShow(Routes.authView);
    }
  }
}
