import 'package:socketchat/ui/screens/auth_screens/auth_view.dart';
import 'package:socketchat/ui/screens/backup_found_screen/backup_found_screen_view.dart';
import 'package:socketchat/ui/screens/chat_screen/chat_view.dart';
import 'package:socketchat/ui/screens/main_screen/main_screen_view.dart';
import 'package:socketchat/ui/screens/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';

@StackedApp(
  routes: [
    MaterialRoute(page: StartUpView, initial: true),
    MaterialRoute(page: MainScreenView),
    MaterialRoute(page: ChatView),
    MaterialRoute(page: AuthView),
    MaterialRoute(page: BackUpFoundScreen),
  ],
)
class AppSetup {}
