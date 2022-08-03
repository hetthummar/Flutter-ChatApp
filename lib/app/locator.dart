import 'package:socketchat/base/custom_base_view_model.dart';
import 'package:socketchat/data/data_manager.dart';
import 'package:socketchat/data/local/app_databse.dart';
import 'package:socketchat/data/network/api_service/message_service/message_api_service.dart';
import 'package:socketchat/data/network/api_service/user_connection_status/user_connection_status_service.dart';
import 'package:socketchat/data/network/api_service/users/user_api_service.dart';
import 'package:socketchat/data/prefs/shared_preference_service.dart';
import 'package:socketchat/services/firebase_crashlytics_service.dart';
import 'package:socketchat/services/firebase_performance_service.dart';
import 'package:socketchat/services/firebase_push_notification_service.dart';
import 'package:socketchat/services/firebase_auth_service.dart';
import 'package:socketchat/services/socket_service.dart';
import 'package:socketchat/ui/screens/auth_screens/auth_view_model.dart';
import 'package:socketchat/ui/screens/chat_screen/chat_view_model.dart';
import 'package:socketchat/ui/screens/main_screen/fragments/profile/profile_view_model.dart';
import 'package:socketchat/ui/screens/main_screen/fragments/search/search_view_model.dart';
import 'package:socketchat/ui/screens/main_screen/main_screen_view_model.dart';
import 'package:socketchat/ui/screens/startup/startup_view_model.dart';
import 'package:get_it/get_it.dart';
import 'package:socketchat/utils/client.dart';
import 'package:stacked_services/stacked_services.dart';

GetIt locator = GetIt.I;

void setupLocator() {

  locator.registerLazySingleton(() => BottomSheetService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => NavigationService());

  locator.registerLazySingleton(() => FirebaseCrashlyticsService());
  locator.registerLazySingleton(() => FirebasePushNotificationService());
  locator.registerLazySingleton(() => FirebasePerformanceService());
  locator.registerLazySingleton(() => FirebaseAuthService());

  //Data
  locator.registerLazySingleton(() => DataManager());
  locator.registerLazySingleton(() => Client());
  locator.registerLazySingleton(() => SharedPreferenceService());

  //View Models
  locator.registerLazySingleton(() => AuthViewModel());
  locator.registerLazySingleton(() => MainScreenViewModel());
  locator.registerLazySingleton(() => StartUpViewModel());
  locator.registerLazySingleton(() => ChatViewModel());
  locator.registerLazySingleton(() => CustomBaseViewModel());
  locator.registerLazySingleton(() => SearchViewModel());
  locator.registerLazySingleton(() => ProfileViewModel());

  //Api Services
  locator.registerLazySingleton(() => UserApiService());
  locator.registerLazySingleton(() => MessageApiService());

  //Socket Services
  locator.registerLazySingleton(() => SocketService());

  //Moor Database
  locator.registerLazySingleton(() => AppDatabase());
  locator.registerLazySingleton(() => UserConnectionStatusService());

}
