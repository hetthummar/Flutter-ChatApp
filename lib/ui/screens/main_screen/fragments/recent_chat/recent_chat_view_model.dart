import 'package:socketchat/app/routes/setup_routes.router.dart';
import 'package:socketchat/base/custom_base_view_model.dart';
import 'package:socketchat/data/local/app_databse.dart';

class RecentChatViewModel extends CustomBaseViewModel {

  String userId = "";

  Stream<List<RecentChatTableData>> getRecentChats() {
    Stream<List<RecentChatTableData>>? _msgStream =
        getDataManager().watchRecentChat();
    return _msgStream;
  }

  getUserId() async{
    userId = (await getAuthService().getUserid())!;
  }
}
