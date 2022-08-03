import 'dart:async';

import 'package:moor_flutter/moor_flutter.dart';
import 'package:socketchat/app/locator.dart';
import 'package:socketchat/base/custom_base_view_model.dart';
import 'package:socketchat/config/api_config.dart';
import 'package:socketchat/const/app_const.dart';
import 'package:socketchat/const/msg_status_const.dart';
import 'package:socketchat/const/msg_type_const.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:socketchat/data/data_manager.dart';
import 'package:socketchat/data/local/app_databse.dart';
import 'package:socketchat/models/basic_models/id_model.dart';
import 'package:socketchat/models/chat_models/deliver_at_update_model.dart';
import 'package:socketchat/models/chat_models/private_message_model.dart';
import 'package:socketchat/models/recent_chat_model/recent_chat_local_model.dart';
import 'package:socketchat/models/chat_models/update_message_model.dart';
import 'package:socketchat/models/recent_chat_model/recent_chat_server_model.dart';
import 'package:socketchat/models/user/user_basic_data_offline_model.dart';
import 'package:socketchat/services/firebase_auth_service.dart';
import 'package:socketchat/utils/model_converters.dart';
import 'package:socketchat/utils/mongo_utils.dart';
import 'package:stacked/stacked.dart';

class SocketService {
  final DataManager _dataManager = locator<DataManager>();

  // final FirebaseAuthService _firebaseAuthService =FirebaseAuthService();
  late String idOfUser;
  Socket? socket;
  Timer? _timer;

  disconnectFromSocket() {
    if (socket != null) {
      socket!.disconnect();
    }
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  connectToSocket(String userId) async {
    idOfUser = userId;
    if (socket != null) {
      print("NEW SOCKET DISPOSING");
      socket!.dispose();
    }

    try {
      print("NEW SOCKET CREATED");

      socket = io(
          ApiConfig.baseUrl,
          OptionBuilder()
              .setTransports(['websocket']) //
              .disableAutoConnect()
              .disableReconnection()
              .setQuery({"userId": userId})
              .build());

      if (socket != null) {
        socket!.connect();

        socket!.onConnecting((data) => print("socket :-Connecting"));
        socket!.onConnect(
          (_) async {
            print("socket :-Connected");
            listenForIncomingMsg();
            List<MessagesTableData> _notSentMsg =
                await _dataManager.getNotSentMsg(userId);
            startEmittingUserStatus(userId, true);

            for (MessagesTableData msg in _notSentMsg) {
              print("MSG FROM MOOR IS SENDING :- " + msg.msgContent);

              if (msg.msgContentType == MsgType.txt) {
                Participants _participants = Participants(
                    user1Id: msg.senderId, user2Id: msg.receiverId);
                int currentTime = DateTime.now().millisecondsSinceEpoch;

                UserBasicDataOfflineModel? _userBasicDataOfflineModel =
                    await _dataManager.getUserBasicDataOfflineModel();

                if (_userBasicDataOfflineModel != null) {
                  PrivateMessageModel _privateMessageModel =
                      PrivateMessageModel(
                    id: msg.mongoId,
                    createdAt: currentTime,
                    msgContentType: msg.msgContentType,
                    receiverId: msg.receiverId,
                    senderId: msg.senderId,
                    msgContent: msg.msgContent,
                    senderName: _userBasicDataOfflineModel.name,
                    senderPlaceholderImage:
                        _userBasicDataOfflineModel.compressedProfileImage,
                    msgStatus: MsgStatus.sent,
                    participants: _participants,
                    networkFileUrl: msg.networkFileUrl,
                    blurHashImage: msg.blurHashImageUrl,
                    imageInfo: msg.imageInfo,
                  );
                  String? currentUserId = msg.senderId;

                  await CustomBaseViewModel().sendMessageWithDataModel(
                      inputText: msg.msgContent,
                      currentTime: currentTime,
                      privateMessageModel: _privateMessageModel,
                      currentUserId: currentUserId,
                      name: msg.receiverName ?? "",
                      compressedProfileImage:
                          msg.receiverCompressedProfileImage,
                      id: msg.receiverId,
                      statusLine: '');

                  // List<String> participantList = [currentUserId, msg.receiverId];
                  // participantList.sort();
                  //
                  // bool isSenderUser1 = false;
                  // int indexOfSender = participantList.indexWhere((element) => element == _userBasicDataOfflineModel.name);
                  // if(indexOfSender == 0){
                  //   isSenderUser1 = true;
                  // }
                  // String randomMongoId2 = MongoUtils().generateUniqueMongoId();
                  // List<RecentChatTableData> _recentChatTableData = await _dataManager.getRecentChatTableDataFromUserIds(participantList);
                  // String recentChatId = randomMongoId2;
                  // if (_recentChatTableData.isNotEmpty) {
                  //   recentChatId = _recentChatTableData[0].id;
                  // }
                  //
                  // RecentChatServerModel _recentChatServerModel = RecentChatServerModel(
                  //     id: recentChatId,
                  //     user1Name: isSenderUser1
                  //         ? _userBasicDataOfflineModel.name
                  //         : userDataBasicModel.name,
                  //     user1CompressedImage: isSenderUser1
                  //         ? _userBasicDataOfflineModel.compressedProfileImage
                  //         : userDataBasicModel.compressedProfileImage,
                  //     user2Name: isSenderUser1
                  //         ? userDataBasicModel.name
                  //         : _userBasicDataOfflineModel.name,
                  //     user2CompressedImage: isSenderUser1
                  //         ? userDataBasicModel.compressedProfileImage
                  //         : _userBasicDataOfflineModel.compressedProfileImage,
                  //     participants: participantList,
                  //     user1LocalUpdated: isSenderUser1,
                  //     user2LocalUpdated: !isSenderUser1,
                  //     shouldUpdate: _recentChatTableData.isNotEmpty ? true : false);
                  //
                  // if (_recentChatTableData.isEmpty) {
                  //   RecentChatLocalModel _recentChatLocalModel = RecentChatLocalModel(
                  //       id: recentChatId,
                  //       userName: userDataBasicModel.name,
                  //       userCompressedImage: userDataBasicModel.compressedProfileImage,
                  //       participants: participantList,
                  //       unreadMsg: 0,
                  //       lastMsg: inputText,
                  //       lastMsgTime: currentTime,
                  //       shouldUpdate: false);
                  //   _dataManager.insertNewRecentChat(_recentChatLocalModel);
                  // }
                  // await _dataManager.sendPrivateMessage(_privateMessageModel, _recentChatServerModel);
                }
              }
            }
          },
        );
        socket!.onConnectTimeout((client) => print("socket :- timeout :-"));
        socket!.onDisconnect((data) {
          print("socket :-DisConnect");
          socket!.clearListeners();
        });

        socket!.onReconnecting((data) => print("socket :- reconnecting"));
        socket!.onReconnectAttempt(
            (data) => print("socket :- onReconnectAttempt"));
        socket!
            .onReconnectFailed((data) => print("socket :- onReconnectFailed"));
        socket!.onReconnectError((data) => print("socket :- onReconnectError"));
        socket!
            .onReconnect((data) => print("socket :- reconnected succesfull"));
      }

      // socket.emit("privateMsg", {"content": "Hello"});
    } catch (e) {
      print("socket :- error :- ${e.toString()}");
    }
  }

  // reConnect(){
  //   if(socket != null){
  //     socket!.connect();
  //   }
  // }

  startEmittingUserStatus(String userId, bool status) {
    _timer = Timer.periodic(
      const Duration(milliseconds: 1500),
      (Timer timer) {
        Map<String, dynamic> userConnectionData = {
          "userStatus": status,
          "id": userId
        };
        // print("EMITING STATUS :- "  + userConnectionData.toString());
        socket!.emit("userStatus", userConnectionData);
      },
    );
  }

  Socket? getSocketInstance() {
    return socket;
  }

  Stream<bool> listenForUserConnectionStatus(String userIdToListen) {
    StreamController<bool> userConnectionStatusChangeStreamController =
        StreamController<bool>();

    print("USER ID TO LIETEN :- " + userIdToListen);

    socket!.on(
      userIdToListen + "_status",
      (data) async {
        userConnectionStatusChangeStreamController.add(data);
      },
    );
    return userConnectionStatusChangeStreamController.stream
        .asBroadcastStream();
  }

  Stream<bool> listenForIsTyping(String userIdToListen) {
    StreamController<bool> userConnectionStatusChangeStreamController =
        StreamController<bool>();

    socket!.on(
      // userIdToListen + "_typing",
      "typing",
      (data) async {
        userConnectionStatusChangeStreamController.add(data);
      },
    );
    return userConnectionStatusChangeStreamController.stream
        .asBroadcastStream();
  }

  changeTypingStatus(String receiverId, bool isTyping) {
    Map<String, dynamic> userConnectionData = {
      "id": receiverId,
      "isTyping": isTyping
    };
    socket!.emit("typing", userConnectionData);
  }

  sendPrivateMessage(PrivateMessageModel _privateMessageModel,
      RecentChatServerModel _recentChatServerModel, Function callback) async {
    Map<String, dynamic> privateMessageFullModel = {};
    privateMessageFullModel.putIfAbsent(
        "privateMessageModel", () => _privateMessageModel);
    privateMessageFullModel.putIfAbsent(
        "recentChatModel", () => _recentChatServerModel);

    print("SOCKET EMIT EVENT :- " + "newPrivateMessage");

    socket!.emitWithAck("newPrivateMessage", privateMessageFullModel,
        ack: ([data]) async {
      callback();
    });
  }

  emitUpdateMsgEvent(Map<String, dynamic> data, Function callback) {
    print("SOCKET EMIT EVENT :- " + "updatePrivateMessage");

    socket!.emitWithAck(
      "updatePrivateMessage",
      data,
      ack: ([data]) async {
        callback();
        // await _dataManager
        //     .updateRecentChatTableData(_recentChatTableCompanion);
        // await _dataManager.insertNewMessage(_localModel);
      },
    );
  }

  List<bool> processStarted = [];
  List<bool> processEnded = [];

  listenForIncomingMsg() async {
    print("SOCKET LISNING FOR INCOMING EVENT");

    socket!.on(
      "newPrivateMessage",
      (data) async {
        print("SOCKET EVENT :- " + "newPrivateMessage :- " + data.toString());
        try {
          PrivateMessageModel _privateMessageModel =
              PrivateMessageModel.fromJson(data);
          MessagesTableCompanion _localModel = ModelConverters()
              .convertMongoModelToLocalModel(_privateMessageModel);

          List<String> participantList = [
            _privateMessageModel.participants.user1Id,
            _privateMessageModel.participants.user2Id
          ];
          participantList.sort();

          for (int i = 0; i < 5; i++) {
            List<RecentChatTableData> _recentChatTable = await _dataManager
                .getRecentChatTableDataFromUserIds(participantList);

            print("LOOP STARTED");

            for (int i = 0; i < 5; i++) {
              if (processStarted.isNotEmpty) {
                await Future.delayed(const Duration(seconds: 1));
              } else {
                break;
              }
            }

            if (_recentChatTable.isNotEmpty) {
              String id = _recentChatTable[0].id;
              int count = _recentChatTable[0].unread_msg ?? 1;
              processStarted.add(true);
              print("LOOP COUNT :- " + count.toString());

              DeliverAtUpdateModel _deliverUpdateModel = DeliverAtUpdateModel(
                  id: _privateMessageModel.id!,
                  deliveredAt: DateTime.now().millisecondsSinceEpoch,
                  senderId: _privateMessageModel.senderId);

              emitUpdateMsgEvent(
                _deliverUpdateModel.toJson(),
                () async {
                  processEnded.add(true);

                  if (processStarted.length == processEnded.length) {
                    List<RecentChatTableData> _recentChatLatestData =
                        await _dataManager
                            .getRecentChatTableDataFromUserIds(participantList);

                    int totalMsgCount =
                        (_recentChatLatestData[0].unread_msg ?? 1) +
                            processStarted.length;

                    print("totalMsgCount 0 :-  " +
                        processStarted.length.toString());
                    print("totalMsgCount 1 :-  " + totalMsgCount.toString());
                    RecentChatTableCompanion _recentChatTableCompanion =
                        RecentChatTableCompanion(
                            id: Value(id),
                            unread_msg: Value(totalMsgCount),
                            last_msg_time: _localModel.createdAt,
                            last_msg_text: _localModel.msgContent);
                    await _dataManager
                        .updateRecentChatTableData(_recentChatTableCompanion);
                    processStarted = [];
                    processEnded = [];
                    await _dataManager.insertNewMessage(_localModel);
                  }
                },
              );

              // await _dataManager.updateMsgDeliverTime(_deliverUpdateModel);
              break;
            } else {
              await Future.delayed(const Duration(seconds: 1));
            }
          }
        } catch (e) {
          print(
              "SOCKET EVENT :- " + "newPrivateMessage ERROR:- " + e.toString());
        }
      },
    );

    // socket!.on(
    //   "updateExistingMessage",
    //   (data) async {
    //     print(
    //         "SOCKET EVENT :- " + "updateExistingMessage :- " + data.toString());
    //
    //     try {
    //       Map<String, dynamic> incomingJsonData = data;
    //       incomingJsonData.putIfAbsent("is_sent", () => true);
    //
    //       print("not send msg 22 :- " + incomingJsonData.toString());
    //
    //       UpdateMessageModel _updateMessageModel =
    //           UpdateMessageModel.fromJson(incomingJsonData);
    //       print("not send msg 33 :- " + _updateMessageModel.toString());
    //       await _dataManager.updateExitingMsg(_updateMessageModel);
    //     } catch (e) {}
    //   },
    // );

    socket!.on(
      "updateExistingMessageWithAcknowledgeApi",
      (data) async {
        print("SOCKET EVENT :- " + "updateExistingMessageWithAcknowledgeApi");

        try {
          Map<String, dynamic> incomingJsonData = data;
          incomingJsonData.putIfAbsent("is_sent", () => true);

          UpdateMessageModel _updateMessageModel =
              UpdateMessageModel.fromJson(incomingJsonData);

          // if(_updateMessageModel.msgStatus == MsgStatus.seen){
          //
          // }
          IdModel _idModel = IdModel(id: _updateMessageModel.id);
          await _dataManager.updateExitingMsg(_updateMessageModel);
          await _dataManager.msgUpdatedLocallyForSender(_idModel);
        } catch (e) {
          print("HALO :-  " + e.toString());
        }
      },
    );

    List<bool> processStartedForNewRecentChat = [];

    socket!.on('newRecentChat', (data) async {
      print("SOCKET EVENT :- " + "newRecentChat :-  " + data.toString());
      try {
        RecentChatServerModel _recentChatServerModel =
            RecentChatServerModel.fromJson(data);

        // String? userId = idOfUser ;//?? await (_firebaseAuthService.getUserid());

        bool isUser1 = false;
        List<String> participantList =
            List.from(_recentChatServerModel.participants);
        participantList.sort();
        int indexOfCurrentUser =
            participantList.indexWhere((element) => element == idOfUser);
        if (indexOfCurrentUser == 0) {
          isUser1 = true;
        }

        RecentChatLocalModel _recentChatLocalModel = RecentChatLocalModel(
          id: _recentChatServerModel.id,
          userName: isUser1
              ? _recentChatServerModel.user2Name
              : _recentChatServerModel.user1Name,
          userCompressedImage: isUser1
              ? _recentChatServerModel.user2CompressedImage
              : _recentChatServerModel.user1CompressedImage,
          participants: participantList,
          // unreadMsg: _recentChatServerModel,
          // lastMsg: inputText,
          // lastMsgTime: currentTime,
          // shouldUpdate: false
        );

        List<RecentChatTableData> _recentChatTableData =
            await _dataManager.getRecentChatTableDataFromUserIds(
                _recentChatLocalModel.participants);

        print("_recentChatLocalModel :- " +
            _recentChatLocalModel.toJson().toString());

        if (_recentChatTableData.isEmpty) {
          await _dataManager.insertNewRecentChat(_recentChatLocalModel);
        } else {
          // processStartedForNewRecentChat.add(true);
          int totalMsgCount = (_recentChatTableData[0].unread_msg ?? 0); // +
          // processStartedForNewRecentChat
          //     .length; //processStartedForNewRecentChat.length;
          RecentChatTableCompanion _recentChatTableCompanion =
              RecentChatTableCompanion(
                  id: Value(_recentChatTableData[0].id),
                  unread_msg: Value(totalMsgCount),
                  user_name: Value(_recentChatLocalModel.userName),
                  user_compressed_image:
                      Value(_recentChatLocalModel.userCompressedImage),
                  last_msg_time: Value(_recentChatTableData[0].last_msg_time),
                  last_msg_text: Value(_recentChatTableData[0].last_msg_text));
          await _dataManager
              .updateRecentChatTableData(_recentChatTableCompanion);
          // processStartedForNewRecentChat = [];
        }

        Map<String, Object> _updateObject = {};
        String keyOfUserLocalUpdate = "";
        if (isUser1) {
          keyOfUserLocalUpdate = "user1_local_updated";
        } else {
          keyOfUserLocalUpdate = "user2_local_updated";
        }

        _updateObject.putIfAbsent("_id", () => _recentChatLocalModel.id);
        _updateObject.putIfAbsent(keyOfUserLocalUpdate, () => true);

        await _dataManager.updateRecentChat(_updateObject);
      } catch (e) {}
      // _recentChatModel.participants
    });
  }
}
