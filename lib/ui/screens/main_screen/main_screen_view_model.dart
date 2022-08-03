import 'dart:async';
import 'package:socketchat/app/locator.dart';
import 'package:socketchat/app/routes/setup_routes.router.dart';
import 'package:socketchat/base/custom_base_view_model.dart';
import 'package:socketchat/base/custom_index_tracking_view_model.dart';
import 'package:socketchat/services/socket_service.dart';

class MainScreenViewModel extends CustomIndexTrackingViewModel {
  final CustomBaseViewModel _baseViewModel = locator<CustomBaseViewModel>();

  initializeSocket() async {
    SocketService _socketService = _baseViewModel.getSocketService();
    String? userId = await _baseViewModel.getAuthService().getUserid();

    if (userId != null) {
      connectToSocket(_socketService,userId);
      Timer.periodic(
        const Duration(seconds: 5),
        (Timer timer) async{
          String? userId = await _baseViewModel.getAuthService().getUserid();
          if(userId != null){
            connectToSocket(_socketService,userId);
          }
        },
      );
    } else {
      _baseViewModel.getNavigationService().clearStackAndShow(Routes.authView);
      _baseViewModel.showErrorDialog(
          description:
              "You logged out from app due to unexpected problem please login again");
    }
  }

  connectToSocket(SocketService _socketService,String userId){
    if (_socketService.getSocketInstance() != null) {

      if(_socketService.getSocketInstance()!.disconnected){
        _socketService.connectToSocket(userId);
      }
    }else{
      _socketService.connectToSocket(userId);
    }
  }



}
