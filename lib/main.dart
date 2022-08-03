import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:socketchat/app/routes/setup_routes.router.dart';
import 'package:socketchat/services/firebase_push_notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:stacked_services/stacked_services.dart';

import 'app/locator.dart';
import 'app/setup_bottom_sheet.dart';
import 'app/setup_dilog.dart';
import 'config/color_config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() {
  runZonedGuarded(() {

    WidgetsFlutterBinding.ensureInitialized();

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
        .then((_) async {

      await Firebase.initializeApp();
      await dotenv.load(fileName: ".env");


      // await dotenv.load(fileName: ".env");
      await AwesomeNotifications().initialize(
        null,
        [
          NotificationChannel(
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            ledColor: Colors.white,
          ),
        ],
      );

      setupLocator();
      setUpBototmSheet();
      setupDialogUi();

      runApp(const MyApp());
    });
  }, (error, trace) async {
    await FirebaseCrashlytics.instance
        .recordError(error, trace, reason: "mainDart Error");
  });
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await showNotification(
    message.data['title'],
    message.data['body'],
    image: message.data['image'],
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebasePushNotificationService _notificationService =
    locator<FirebasePushNotificationService>();
    _notificationService.initMessaging();

    EasyLoading.instance
      ..indicatorType = EasyLoadingIndicatorType.ring
      ..loadingStyle = EasyLoadingStyle.custom
      ..maskColor = Colors.black.withOpacity(0.5)
      ..maskType = EasyLoadingMaskType.custom
      ..backgroundColor = ColorConfig.accentColor.withAlpha(1)
      ..textColor = Colors.white
      ..indicatorColor = Colors.white;

    return MaterialApp(
      builder: EasyLoading.init(),
      title: 'Chat App',
      navigatorKey: StackedService.navigatorKey,
      onGenerateRoute: StackedRouter().onGenerateRoute,
      initialRoute: "/",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        cursorColor: ColorConfig.accentColor,
        accentColor: ColorConfig.accentColor,
        primaryColor: ColorConfig.primaryColor,
        dividerColor: Colors.black26,
        fontFamily: 'Poppins',
      ), //authService().handleAuth()//SubScriptionView()//KycViewHolder()//RegistrationViewHolder(currentPageToShow: 3,),
    );
  }
}
