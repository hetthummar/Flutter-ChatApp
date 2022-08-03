import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:socketchat/app/locator.dart';
import 'package:socketchat/config/api_config.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:socketchat/services/firebase_crashlytics_service.dart';
import 'package:socketchat/services/firebase_auth_service.dart';
import 'package:socketchat/services/firebase_performance_service.dart';
import 'package:socketchat/utils/formate_query_parameter.dart';

class Client {
  String baseUrl = ApiConfig.baseUrl;

  Dio? _dio;
  BaseOptions options = BaseOptions(
    connectTimeout: 1000 * 300,
    receiveTimeout: 1000 * 300,
  );

  Map<String, Object>? header;

  Client();

  Client setUrlEncoded() {
    header!.remove('Content-Type');
    header!
        .putIfAbsent('Content-Type', () => 'application/x-www-form-urlencoded');
    _dio!.options.headers = header;
    return this;
  }

  setHeaders(){
    _dio!.options.headers = header;
    return this;
  }

  Future<Client> setProtectedApiHeader() async {
    FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
    // String? token = await _firebaseAuthService.getUserid();
    String? idToken = await _firebaseAuthService.getIdToken();
    String? userId = await _firebaseAuthService.getUserid();
    header!.putIfAbsent('authorization', () => 'Bearer $idToken');
    header!.putIfAbsent('userid', () => userId!);
    return this;
  }

  Client builder() {
    header = <String, Object>{};
    header!.putIfAbsent('Accept', () => 'application/json');
    header!.putIfAbsent('Content-Type', () => 'application/json');
    _dio = Dio(options);
    _dio!.interceptors.add(dioInterceptor);
    _dio!.interceptors.add(PrettyDioLogger(requestBody: true, requestHeader:true,responseHeader: true,compact:false));
    _dio!.options.baseUrl = baseUrl;
    _dio!.options.headers = header;
    return this;
  }

  Dio build() {
    _dio!.options.headers = header;
    (_dio!.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
          client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    print("HET 99 100 :- " + header.toString());

    return _dio!;
  }
}

final FirebasePerformanceService _firebasePerformanceService =
    locator<FirebasePerformanceService>();

InterceptorsWrapper dioInterceptor = InterceptorsWrapper(
  onRequest: (options, handler) {
    print("options :- " + options.headers.toString());
    if (options.method == 'GET') {
      if (options.queryParameters.isNotEmpty) {
        options.queryParameters =
            FormatQueryParameter().replaceSpace(options.queryParameters);
      }
    }
    // _firebasePerformanceService.startHttpTracking(options.uri.toString());
    return handler.next(options); //continue
  },
  onResponse: (response, handler) {
    // _firebasePerformanceService.stopHttpTracking(response.statusCode ?? 400);
    return handler.next(response); // continue
  },
  onError: (DioError e, handler) async {
    Response? _response = e.response;

    if (_response != null) {
      int? statusCode = _response.statusCode;

      if (statusCode != null) {
        // _firebasePerformanceService.stopHttpTrackingWithError(responseCode: statusCode);
        if ((statusCode / 100).floor() == 5) {
          FirebaseCrashlyticsService _crashlyticsService =
              locator<FirebaseCrashlyticsService>();
          await _crashlyticsService
              .addError(_response.statusMessage ?? "" + " -- " + e.toString());
        } else if ((statusCode / 100).floor() == 4) {}
      } else {
        // _firebasePerformanceService.stopHttpTrackingWithError();
      }
    } else {
      // _firebasePerformanceService.stopHttpTrackingWithError();
    }

    // return DioExceptions(e);
    return handler.next(e); //continue
  },
);
