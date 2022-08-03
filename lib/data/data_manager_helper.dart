import 'package:socketchat/data/local/dao/message_dao/messages_helper.dart';
import 'package:socketchat/data/local/dao/recent_chat_dao/recent_chat_helper.dart';
import 'package:socketchat/data/network/api_helper.dart';
import 'package:socketchat/data/network/api_service/user_connection_status/user_connection_status_helper.dart';
import 'package:socketchat/data/prefs/shared_preference_helper.dart';

abstract class DataManagerHelper implements ApiHelper,MessagesDaoHelper,UserConnectionStatusHelper,SharedPreferenceHelper,RecentChatDaoHelper{

}