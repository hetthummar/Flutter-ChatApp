// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

import '../../models/user/user_basic_data_model.dart';
import '../../ui/screens/auth_screens/auth_view.dart';
import '../../ui/screens/backup_found_screen/backup_found_screen_view.dart';
import '../../ui/screens/chat_screen/chat_view.dart';
import '../../ui/screens/main_screen/main_screen_view.dart';
import '../../ui/screens/startup/startup_view.dart';

class Routes {
  static const String startUpView = '/';
  static const String mainScreenView = '/main-screen-view';
  static const String chatView = '/chat-view';
  static const String authView = '/auth-view';
  static const String backUpFoundScreen = '/back-up-found-screen';
  static const all = <String>{
    startUpView,
    mainScreenView,
    chatView,
    authView,
    backUpFoundScreen,
  };
}

class StackedRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.startUpView, page: StartUpView),
    RouteDef(Routes.mainScreenView, page: MainScreenView),
    RouteDef(Routes.chatView, page: ChatView),
    RouteDef(Routes.authView, page: AuthView),
    RouteDef(Routes.backUpFoundScreen, page: BackUpFoundScreen),
  ];
  @override
  Map<Type, StackedRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, StackedRouteFactory>{
    StartUpView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const StartUpView(),
        settings: data,
      );
    },
    MainScreenView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const MainScreenView(),
        settings: data,
      );
    },
    ChatView: (data) {
      var args = data.getArgs<ChatViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => ChatView(
          args.userDataBasicModel,
          key: args.key,
        ),
        settings: data,
      );
    },
    AuthView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const AuthView(),
        settings: data,
      );
    },
    BackUpFoundScreen: (data) {
      var args = data.getArgs<BackUpFoundScreenArguments>(
        orElse: () => BackUpFoundScreenArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => BackUpFoundScreen(key: args.key),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// ChatView arguments holder class
class ChatViewArguments {
  final UserDataBasicModel userDataBasicModel;
  final Key? key;
  ChatViewArguments({required this.userDataBasicModel, this.key});
}

/// BackUpFoundScreen arguments holder class
class BackUpFoundScreenArguments {
  final Key? key;
  BackUpFoundScreenArguments({this.key});
}
