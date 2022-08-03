import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class FirebaseCrashlyticsService {

  addError(String? errorMessage) async {

    if (kReleaseMode){
    // await  FirebaseCrashlytics.instance.setCustomKey("serverError", erroeMessage ?? "Message is null");
    await FirebaseCrashlytics.instance.recordError(
        "serverError", StackTrace.current,
        reason: errorMessage ?? "Message is null");
    }
  }
}
