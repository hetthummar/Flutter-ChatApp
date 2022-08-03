import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:socketchat/app/locator.dart';
import 'package:socketchat/const/end_points.dart';
import 'package:socketchat/data/network/api_service/user_connection_status/user_connection_status_helper.dart';
import 'package:socketchat/models/connection_model/user_connection_status_request_model.dart';
import 'package:socketchat/models/connection_model/user_connection_status_response_model.dart';
import 'package:socketchat/utils/api_utils/api_result/api_result.dart';
import 'package:socketchat/utils/api_utils/network_exceptions/network_exceptions.dart';
import 'package:socketchat/utils/client.dart';

class UserConnectionStatusService extends UserConnectionStatusHelper {
  Client _client = locator<Client>();

  UserConnectionStatusService() {
    _client = Client();
  }

  @override
  Future<ApiResult<UserConnectionStatusResponseModel>> getUserConnectionStatus(
      UserConnectionStatusRequestModel userConnectionStatusModel) async {
    Client tempClient = await _client.builder().setProtectedApiHeader();
    try {
      Response _response = await tempClient.build().get(
          EndPoints.userConnectionStatus,
          queryParameters: userConnectionStatusModel.toJson());

      print("_response.data :- " + _response.data.toString());

      UserConnectionStatusResponseModel _userConnectionStatusResponseModel =
          UserConnectionStatusResponseModel.fromJson(_response.data);
      return ApiResult.success(data: _userConnectionStatusResponseModel);
    } catch (e) {
      print("KKPQWD sa: - " + e.toString());
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }
}
