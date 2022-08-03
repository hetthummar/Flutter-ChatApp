import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:objectid/objectid.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:socketchat/app/locator.dart';
import 'package:socketchat/base/custom_base_view_model.dart';
import 'package:socketchat/const/app_const.dart';
import 'package:socketchat/const/enums/msg_type_enums.dart';
import 'package:socketchat/const/msg_status_const.dart';
import 'package:socketchat/const/msg_type_const.dart';
import 'package:socketchat/data/local/app_databse.dart';
import 'package:socketchat/models/chat_models/deliver_at_update_model.dart';
import 'package:socketchat/models/chat_models/private_message_model.dart';
import 'package:socketchat/models/chat_models/update_message_model.dart';
import 'package:socketchat/models/recent_chat_model/recent_chat_local_model.dart';
import 'package:socketchat/models/chat_models/seen_at_update_model.dart';
import 'package:socketchat/models/connection_model/user_connection_status_request_model.dart';
import 'package:socketchat/models/connection_model/user_connection_status_response_model.dart';
import 'package:socketchat/models/recent_chat_model/recent_chat_server_model.dart';
import 'package:socketchat/models/user/user_basic_data_model.dart';
import 'package:socketchat/models/user/user_basic_data_offline_model.dart';
import 'package:socketchat/services/socket_service.dart';
import 'package:socketchat/utils/api_utils/api_result/api_result.dart';
import 'package:socketchat/utils/api_utils/network_exceptions/network_exceptions.dart';
import 'package:socketchat/utils/blur_hash_generator.dart';
import 'package:socketchat/utils/mongo_utils.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;

class ChatViewModel extends CustomBaseViewModel {
  late UserDataBasicModel userDataBasicModel;
  String? currentUserId;
  bool isSendBtnDisable = true;
  final StreamController<List<MessagesTableData>> _streamController =
      StreamController();

  //Required things for pagination
  List<MessagesTableData> listOfMessage = [];
  int pageNumber = 1;
  int itemPerPage = 100;
  bool isAllItemLoaded = false;
  bool isItemsLoading = true;
  int lastRetrieveDocumentId = 0;
  List<String> notGoingToUpdateMsgSeenList = [];
  bool isOnline = false;
  bool isTyping = false;
  Timer? _timer;
  String selectedImageMsgId = "";

  final StreamController<String> _userActivityStreamController =
      StreamController<String>();
  final ImagePicker _picker = ImagePicker();

  setUserData(UserDataBasicModel _inputDataBasicModel) async {
    userDataBasicModel = _inputDataBasicModel;
    print("userDataBasicModel :- " + userDataBasicModel.id);
    currentUserId = await getAuthService().getUserid();
  }

  listenForConnectionStatus() {
    Stream<bool> userConnectionStatusChangeStreamController =
        getSocketService().listenForUserConnectionStatus(userDataBasicModel.id);

    userConnectionStatusChangeStreamController.listen((event) {
      isOnline = event;
      if (event) {
        _userActivityStreamController.add("Online");
      } else {
        _userActivityStreamController.add("");
      }
    });
  }

  listenForTypingStatus() {
    Stream<bool> userTypingStreamController =
        getSocketService().listenForIsTyping(currentUserId!);
    // Stream<bool> userTypingStreamController = getSocketService().listenForIsTyping(userDataBasicModel.id);

    userTypingStreamController.listen((event) {
      print("ACTION TYPING EVENT :- " + event.toString());

      if (event) {
        _userActivityStreamController.add("Typing...");
      } else {
        if (isOnline) {
          _userActivityStreamController.add("Online");
        } else {
          _userActivityStreamController.add("");
        }
      }
    });
  }

  inputTextChanging() {
    if (!isTyping) {
      getSocketService().changeTypingStatus(userDataBasicModel.id, true);
    }

    if (_timer != null) {
      _timer!.cancel();
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      getSocketService().changeTypingStatus(userDataBasicModel.id, false);
      timer.cancel();
      isTyping = false;
    });
    isTyping = true;
  }

  Stream<String> listenForUserActivityStatus() {
    return _userActivityStreamController.stream;
  }

  makeAllMsgReadLocally() async {
    currentUserId ??= await getAuthService().getUserid();
    List<String> participantList = [currentUserId!, userDataBasicModel.id];
    participantList.sort();
    await getDataManager().makeAllMsgRead(participantList);
  }

  setSendBtnStatus(bool isDisable) {
    isSendBtnDisable = isDisable;
    notifyListeners();
  }

  Future<bool> downloadImage(String msgId, String networkUrl) async {
    var tempDir = await getTemporaryDirectory();
    final targetPath = tempDir.path +
        "/" +
        DateTime.now().millisecondsSinceEpoch.toString() +
        basename(networkUrl);
    bool result = await download2(networkUrl, targetPath);
    if (result) {
      await getDataManager().updateMsgImageUrl(
          msgId: msgId, isNetworkUrl: false, url: targetPath);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> download2(String url, String savePath) async {
    try {
      Response response = await Dio().get(
        url,
        // onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<MessagesTableData?> getMessageObjectFromId(String id) async {
    return await getDataManager().getMessageFromId(id);
  }

  sendMessage(
      {required String inputText,
      required String msgType,
      String? localFileUrl,
      Map<String, dynamic>? imageInfo,
      MessagesTableData? msgTableData}) async {

    if (inputText == "" || currentUserId == null) {
      return;
    }
    currentUserId ??= await getAuthService().getUserid();

    Participants _participants =
        Participants(user1Id: currentUserId!, user2Id: userDataBasicModel.id);
    String randomMongoId1 = MongoUtils().generateUniqueMongoId();
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    String? networkImageUri;
    String? blurHashImage;

    if (msgTableData == null) {

      MessagesTableCompanion _newMessageObject = MessagesTableCompanion.insert(
          msgContentType: msgType,
          msgContent: inputText,
          msgStatus: MsgStatus.pending,
          senderId: currentUserId!,
          receiverId: userDataBasicModel.id,
          receiverName: Value(userDataBasicModel.name),
          receiverCompressedProfileImage:
          Value(userDataBasicModel.compressedProfileImage),
          mongoId: randomMongoId1,
          createdAt: currentTime,
          localFileUrl: Value(localFileUrl),
          networkFileUrl: Value(networkImageUri),
          imageInfo: Value(imageInfo),
          blurHashImageUrl: Value(blurHashImage));

      await getDataManager().insertNewMessage(_newMessageObject);

    }else{

      randomMongoId1 = msgTableData.mongoId;
      localFileUrl = msgTableData.localFileUrl;
      networkImageUri = msgTableData.networkFileUrl;

      currentTime = msgTableData.createdAt;
      msgType = msgTableData.msgContentType;

      blurHashImage = msgTableData.blurHashImageUrl;
      imageInfo = msgTableData.imageInfo;

    }

    if (localFileUrl != null && networkImageUri == null) {
      selectedImageMsgId = randomMongoId1;
      networkImageUri = await uploadFiles(File(localFileUrl));
      if (networkImageUri != null) {
        // blurHashImage
        blurHashImage =
            await BlurHashGenerator().generateBlurHash(localFileUrl);
        await getDataManager().updateMsgImageUrl(
            msgId: randomMongoId1,
            isNetworkUrl: true,
            url: networkImageUri,
            blurHashImageUri: blurHashImage);
        selectedImageMsgId = '';
      } else {
        return;
      }
    }

    PrivateMessageModel _privateMessageModel = PrivateMessageModel(
        id: randomMongoId1,
        createdAt: currentTime,
        msgContentType: msgType,
        receiverId: userDataBasicModel.id,
        senderId: currentUserId!,
        msgContent: inputText,
        senderName: userDataBasicModel.name,
        msgStatus: MsgStatus.sent,
        participants: _participants,
        senderPlaceholderImage: userDataBasicModel.compressedProfileImage,
        networkFileUrl: networkImageUri,
        blurHashImage: blurHashImage,
        imageInfo: imageInfo);

    await sendMessageWithDataModel(
        inputText: inputText,
        currentTime: currentTime,
        privateMessageModel: _privateMessageModel,
        currentUserId: currentUserId!,
        name: userDataBasicModel.name,
        statusLine: '',
        compressedProfileImage: userDataBasicModel.compressedProfileImage,
        id: userDataBasicModel.id);

    //<editor-fold desc="Bulk insert for testing">
    // for(int i =1 ; i< 3000;i++){
    //   MessagesTableCompanion _newMessageObject = MessagesTableCompanion.insert(
    //     msgType: MsgType.txt,
    //     msgContent:i.toString(),
    //     msgStatus: MsgStatus.pending,
    //     senderId: currentUserId!,
    //     receiverId: userDataBasicModel.id,
    //   );
    //   await getDataManager().insertNewMessage(_newMessageObject);
    // }
    //</editor-fold>
  }

  Future<String?> uploadFiles(File _image) async {
    print("image uploading :- " + _image.length.toString());
    try {
      String? uploadUrl;

      FirebaseStorage storage = FirebaseStorage.instance;

      Reference chatSharedPictureRef = storage.ref().child(
          AppConst.chatSharedImageStoragePath +
              DateTime.now().millisecondsSinceEpoch.toString() +
              basename(_image.path));

      UploadTask uploadTask = chatSharedPictureRef.putFile(_image);
      await uploadTask.whenComplete(
        () async {
          uploadUrl = await chatSharedPictureRef.getDownloadURL();
        },
      );

      return uploadUrl;
    } catch (e) {
      stopProgressBar();
      showErrorDialog(description: "Problem occurred while uploading image");
      return null;
    }
  }

  updateSeenForParticularMessage(String msgId, String senderId) async {
    if (!notGoingToUpdateMsgSeenList.contains(msgId)) {
      print("Update seen for Msg id :- " + msgId);

      int seenTime = DateTime.now().millisecondsSinceEpoch;

      SeenAtUpdateModel _seenAtUpdateModel =
          SeenAtUpdateModel(id: msgId, senderId: senderId, seenAt: seenTime);
      // ApiResult<bool> seenUpdateResult =
      //     await getDataManager().updateMsgSeenTime(_seenAtUpdateModel);

      getSocketService().emitUpdateMsgEvent(_seenAtUpdateModel.toJson(),
          () async {
        await getDataManager()
            .updateSeenTimeLocallyForReceiver(msgId, seenTime);

        Future.delayed(const Duration(milliseconds: 700), () {
          notGoingToUpdateMsgSeenList.add(msgId);
        });
      });
    }
  }

  getNewItems() async {
    isItemsLoading = true;
    List<MessagesTableData> _oldMessages = await getDataManager()
        .getOldMessages(lastRetrieveDocumentId, userDataBasicModel.id);
    if (_oldMessages.length < itemPerPage) {
      isAllItemLoaded = true;
    }

    pageNumber = pageNumber + 1;
    listOfMessage.addAll(List.from(_oldMessages));
    lastRetrieveDocumentId = listOfMessage.last.id;
    _streamController.add(listOfMessage);
    await Future.delayed(
      const Duration(milliseconds: 250),
      () {
        //Some time for _streamController to adjust
        isItemsLoading = false;
      },
    );
  }

  Stream<List<MessagesTableData>> getMessagesStream() {
    isItemsLoading = true;

    Stream<List<MessagesTableData>>? _msgStream = getDataManager()
        .watchNewMessages(userDataBasicModel.id, userDataBasicModel.id);

    _msgStream.listen(
      (List<MessagesTableData> event) {
        isItemsLoading = true;

        List<MessagesTableData> recentMessages = List.from(event.reversed);

        for (int i = 0; i < recentMessages.length; i++) {
          int newMsgId = recentMessages[i].id;

          int initialListIdIndex =
              listOfMessage.indexWhere((element) => element.id == newMsgId);
          if (initialListIdIndex == -1) {
            listOfMessage.insert(0, recentMessages[i]);
            _streamController.add(listOfMessage);
            lastRetrieveDocumentId = listOfMessage.last.id;

            if (recentMessages.length < itemPerPage) {
              isAllItemLoaded = true;
            }
          } else {
            listOfMessage[initialListIdIndex] = recentMessages[i];
            _streamController.add(listOfMessage);
          }
          isItemsLoading = false;
        }
      },
    );
    return _streamController.stream;
  }

  imageSelected(bool isCameraSelected) async {
    String selectedImagePath = await selectImage(isCameraSelected);

    print("selectedImagePath :-  " + selectedImagePath);

    if (selectedImagePath != "") {
      File imageFile = File(selectedImagePath);
      ui.Image _decodedImage =
          await decodeImageFromList(imageFile.readAsBytesSync());

      Map<String, int> imageInfo = {};
      imageInfo.putIfAbsent("width", () => _decodedImage.width);
      imageInfo.putIfAbsent("height", () => _decodedImage.height);

      sendMessage(
          inputText: "image",
          msgType: MsgType.image,
          localFileUrl: selectedImagePath,
          imageInfo: imageInfo);
    }
  }

  Future<String> selectImage(bool isFromCamera) async {
    XFile? pickedFile;

    if (isFromCamera) {
      pickedFile = await imgFromCamera();
    } else {
      pickedFile = await imgFromGallery();
    }

    if (pickedFile != null) {
      File finalImage = File(pickedFile.path);

      File? croppedImage = await ImageCropper.cropImage(
        sourcePath: finalImage.path,
        // aspectRatio: CropAspectRatio(ratioX: 11, ratioY: 7)
      );

      if (croppedImage != null) {
        final dir = await getTemporaryDirectory();
        final targetPath = dir.absolute.path +
            "/" +
            DateTime.now().millisecondsSinceEpoch.toString() +
            basename(croppedImage.path);

        // File? compressedImage = await compressFile(croppedImage, targetPath);
        // if (compressedImage != null) {
        //   return compressedImage.path;
        // } else {
        //   return "";
        // }

        bool result = await resizeImage(croppedImage, targetPath);
        if (!result) {
          return "";
        }

        return targetPath;
      } else {
        return "";
      }
    } else {
      return "";
    }
  }

  Future<bool> resizeImage(File file, String path) async {
    img.Image? image = img.decodeImage(file.readAsBytesSync());
    if (image != null) {
      try {
        img.Image thumbnail = img.copyResize(image, width: 450);
        File _targetFile = File(path);
        _targetFile.writeAsBytesSync(img.encodeJpg(thumbnail));
        return true;
      } catch (e) {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<File?> compressFile(File file, String targetPath) async {
    final filePath = file.absolute.path;
    File? result = await FlutterImageCompress.compressAndGetFile(
      filePath,
      targetPath,
      quality: 20,
    );

    return result;
  }

  Future<XFile?> imgFromCamera() async {
    XFile? image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 100);
    return image;
  }

  Future<XFile?> imgFromGallery() async {
    XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    return image;
  }
}
