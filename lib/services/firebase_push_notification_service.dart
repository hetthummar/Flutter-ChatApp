import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:socketchat/app/locator.dart';
import 'package:socketchat/const/shared_pref_const.dart';
import 'package:socketchat/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebasePushNotificationService {
  Future<String> getFcmToken() async {
    FirebaseMessaging _fcm = FirebaseMessaging.instance;
    String? fcmToken = await _fcm.getToken();

    return fcmToken.toString();
  }

  initMessaging() {
    FirebaseMessaging.instance.getInitialMessage().then((value) => {});

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        Map<String, dynamic>? notificationMessage = message.data;
        showNotification(
            notificationMessage['title'], notificationMessage['body'],
            image: notificationMessage['image']);
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        // Map<String, dynamic>? notification = message.data;

        setupLocator();
        // NavigationService _navigationService = locator<NavigationService>();
        // _navigationService.navigateTo(Routes.notificationView);
      },
    );
  }
}

showNotification(String title, String message, {String? image}) async {
  bool shouldShowNotification = await isNotificationOn();

  if (shouldShowNotification) {
    if (image != null) {
      AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: Random().nextInt(2147483647),
              title: title,
              body: message,
              channelKey: "basic_channel",
              notificationLayout: NotificationLayout.BigPicture,
              bigPicture: image));
    } else {
      AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: Random().nextInt(2147483647),
              title: title,
              body: message,
              channelKey: "basic_channel"));
    }
  }
}

Future<bool> isNotificationOn() async {

  try {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.getBool(SharedPrefConst.notificationStatus) ?? true;
  } catch (e) {
    return true;
  }
}
//
// updateNotificationCount() async {
//   SharedpreferenceUtils _sharedpreferenceUtils = SharedpreferenceUtils();
//   try {
//     int notificationCount = await getNotificationCount();
//     SharedPreferences _prefs = await SharedPreferences.getInstance();
//     _prefs.setInt(
//         _sharedpreferenceUtils.notificationCount, notificationCount + 1);
//     return true;
//   } catch (e) {
//     return false;
//   }
// }
//
// Future<int> getNotificationCount() async {
//   SharedpreferenceUtils _sharedpreferenceUtils = SharedpreferenceUtils();
//   try {
//     SharedPreferences _prefs = await SharedPreferences.getInstance();
//     return _prefs.getInt(_sharedpreferenceUtils.notificationCount) ?? 0;
//   } catch (e) {
//     return 0;
//   }
// }
