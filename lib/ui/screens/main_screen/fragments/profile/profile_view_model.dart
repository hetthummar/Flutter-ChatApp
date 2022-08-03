import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:socketchat/app/routes/setup_routes.router.dart';
import 'package:socketchat/base/custom_base_view_model.dart';
import 'package:socketchat/const/app_const.dart';
import 'package:socketchat/const/enums/dialogs_enum.dart';
import 'package:socketchat/models/user/user_basic_data_offline_model.dart';
import 'package:socketchat/models/user/user_image_model.dart';
import 'package:socketchat/models/user/user_name_status_update_model.dart';
import 'package:socketchat/utils/api_utils/api_result/api_result.dart';
import 'package:socketchat/utils/api_utils/network_exceptions/network_exceptions.dart';
import 'package:socketchat/utils/random_string_generator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:socketchat/const/enums/bottom_sheet_enums.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class ProfileViewModel extends CustomBaseViewModel {
  var formKeyForEditProfile = GlobalKey<FormState>();
  String userName = "";
  String userStatus = "";
  String? profileImage;

  getUserData() async {
    UserBasicDataOfflineModel? _userBasicDataOfflineModel =
        await getDataManager().getUserBasicDataOfflineModel();
    if (_userBasicDataOfflineModel != null) {
      userName = _userBasicDataOfflineModel.name;
      userStatus = _userBasicDataOfflineModel.statusLine;
      profileImage = _userBasicDataOfflineModel.profileImage;
      notifyListeners();
    }
  }

  logoutUser() async {
    DialogResponse? _dialogResponse = await getDialogService().showCustomDialog(
        title: "Logout",
        description:
            "Are you sure that you want to logout from application. All saved data will be lost.",
        variant: dialogEnum.confirmation);

    if (_dialogResponse != null) {
      if (_dialogResponse.confirmed) {
        showProgressBar();
        await getSocketService().disconnectFromSocket();
        await getAuthService().logOut();
        await getAppDatabase().deleteAllTables();
        bool result = await getDataManager().clearSharedPreference();
        if(result){
          stopProgressBar();
          getNavigationService().clearStackAndShow(Routes.authView);
        }
      }
    }
  }

  changeProfilePicture() async {
    File _imageFile;
    final ImagePicker _picker = ImagePicker();
    XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      showProgressBar();
      _imageFile = File(pickedFile.path);

      File? croppedImage = await ImageCropper.cropImage(
          sourcePath: _imageFile.path,
          aspectRatio: const CropAspectRatio(ratioX: 4, ratioY: 5),
          cropStyle: CropStyle.circle);

      if (croppedImage != null) {
        final dir = await getTemporaryDirectory();
        final targetPath = dir.absolute.path +
            "/" +
            DateTime.now().millisecondsSinceEpoch.toString() +
            basename(croppedImage.path);

        File? compressedImage = await compressFile(croppedImage, targetPath);

        if (compressedImage != null) {
          List<File> _imagesFile = [croppedImage, compressedImage];
          List<String> listOfUrl = await uploadFiles(_imagesFile);
          if (listOfUrl.isNotEmpty) {
            UserImageModel _userImageModel = UserImageModel(
                profileImage: listOfUrl[0],
                compressedProfileImage: listOfUrl[1]);
            ApiResult<bool> _uploadImageResult =
                await getDataManager().updateImageOfUser(_userImageModel);
            await _uploadImageResult.when<FutureOr>(
                success: (bool result) async {
              UserBasicDataOfflineModel? _userBasicDataOfflineModel =
                  await getDataManager().getUserBasicDataOfflineModel();
              if (_userBasicDataOfflineModel != null) {
                _userBasicDataOfflineModel.profileImage =
                    _userImageModel.profileImage;
                _userBasicDataOfflineModel.compressedProfileImage =
                    _userImageModel.compressedProfileImage;
                await getDataManager()
                    .saveUserBasicDataOfflineModel(_userBasicDataOfflineModel);
                profileImage = _userImageModel.profileImage;
                notifyListeners();
              }
            }, failure: (NetworkExceptions e) {
              showErrorDialog(
                  description: NetworkExceptions.getErrorMessage(e));
            });

            stopProgressBar();
          }
        } else {
          stopProgressBar();
          showErrorDialog(
              description: "Problem occurred in compressing please try again");
        }
      } else {
        stopProgressBar();
        showErrorDialog(
            description: "Problem occurred in cropping image please try again");
      }
    }
  }

  Future<List<String>> uploadFiles(List<File> _images) async {
    print("image uploading :- " + _images.length.toString());

    List<String> downloadedUrlList = [];

    FirebaseStorage storage = FirebaseStorage.instance;

    Reference profilePictureRef = storage.ref().child(
        AppConst.profilePictureStoragePath +
            DateTime.now().millisecondsSinceEpoch.toString() +
            basename(_images[0].path));

    Reference compressedProfilePictureRef = storage.ref().child(
        AppConst.compressedProfilePictureStoragePath +
            DateTime.now().millisecondsSinceEpoch.toString() +
            basename(_images[1].path));

    UploadTask uploadTask;

    try {
      for (int i = 0; i < 2; i++) {
        if (i == 0) {
          uploadTask = profilePictureRef.putFile(_images[0]);
          await uploadTask.whenComplete(() async {
            String downloadUrl = await profilePictureRef.getDownloadURL();
            downloadedUrlList.add(downloadUrl);
          });
        } else {
          uploadTask = compressedProfilePictureRef.putFile(_images[1]);
          await uploadTask.whenComplete(() async {
            String downloadUrl =
                await compressedProfilePictureRef.getDownloadURL();
            downloadedUrlList.add(downloadUrl);
          });
        }
      }
      return downloadedUrlList;
    } catch (e) {
      stopProgressBar();
      showErrorDialog(description: "Problem occurred while uploading image");
      return [];
    }
  }

  Future<File?> compressFile(File file, String targetPath) async {
    final filePath = file.absolute.path;

    File? result = await FlutterImageCompress.compressAndGetFile(
      filePath,
      targetPath,
      quality: 50,
    );

    return result;
  }

  openEditProfileBottomSheet() async {
    UserBasicDataOfflineModel? _userBasicDataOfflineModel =
        await getSharedPreferenceService().getUserBasicDataOfflineModel();

    Map<String, dynamic> dialogData = {};

    if (_userBasicDataOfflineModel != null) {
      dialogData.putIfAbsent("name", () => _userBasicDataOfflineModel.name);
      dialogData.putIfAbsent(
          "status", () => _userBasicDataOfflineModel.statusLine);
    } else {
      dialogData.putIfAbsent("name", () => "");
      dialogData.putIfAbsent("status", () => "");
    }

    dialogData.putIfAbsent("form_key", () => formKeyForEditProfile);

    SheetResponse? _sheetResponse = await getBottomSheetService()
        .showCustomSheet(
            data: dialogData,
            variant: bottomSheetEnum.editProfile,
            barrierDismissible: true);

    if (_sheetResponse != null && _sheetResponse.data != null) {
      print("_sheetResponse :- " + _sheetResponse.data.toString());

      String name = _sheetResponse.data['name'];
      String status = _sheetResponse.data['status'];

      UserNameStatusUpdateModel _userNameStatusUpdateModel =
          UserNameStatusUpdateModel(statusLine: status, name: name);

      showProgressBar();
      ApiResult<bool> _nameStatusUpdateResult = await getDataManager()
          .updateNameStatusUser(_userNameStatusUpdateModel);

      _nameStatusUpdateResult.when(success: (bool result) async {
        stopProgressBar();

        UserBasicDataOfflineModel? _userBasicDataOfflineModel =
            await getDataManager().getUserBasicDataOfflineModel();
        if (_userBasicDataOfflineModel != null) {
          _userBasicDataOfflineModel.name = name;
          _userBasicDataOfflineModel.statusLine = status;

          await getDataManager()
              .saveUserBasicDataOfflineModel(_userBasicDataOfflineModel);
          getDialogService().showCustomDialog(variant: dialogEnum.success);

          userName = _userNameStatusUpdateModel.name;
          userStatus = _userNameStatusUpdateModel.statusLine;
          notifyListeners();
        } else {
          showErrorDialog();
        }
      }, failure: (NetworkExceptions e) {
        stopProgressBar();
        showErrorDialog(description: NetworkExceptions.getErrorMessage(e));
      });
    }
  }
}
