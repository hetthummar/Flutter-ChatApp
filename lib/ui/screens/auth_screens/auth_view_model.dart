import 'package:firebase_auth/firebase_auth.dart';
import 'package:socketchat/app/locator.dart';
import 'package:socketchat/app/routes/setup_routes.router.dart';
import 'package:socketchat/base/custom_base_view_model.dart';
import 'package:socketchat/base/custom_index_tracking_view_model.dart';
import 'package:socketchat/const/app_const.dart';
import 'package:socketchat/models/backup_found_model.dart';
import 'package:socketchat/models/user/user_basic_data_offline_model.dart';
import 'package:socketchat/models/user/user_create_model.dart';
import 'package:socketchat/models/user/user_firebase_token_model.dart';
import 'package:socketchat/utils/api_utils/api_result/api_result.dart';
import 'package:socketchat/utils/api_utils/network_exceptions/network_exceptions.dart';

class AuthViewModel extends CustomIndexTrackingViewModel {
  String phoneNumber = "";
  String userName = "";
  String errorText = "";
  bool isSignUpScreen = true;
  String enteredOtp = "";
  int otpTimeoutSeconds = 60;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var formKey;

  String selectedDialCode = "+91";
  String selectedIsoCode = "IN";

  String previousNumber = "";

  String verificationId = "";
  int resendToken = -1;
  bool isResendCode = false;
  final CustomBaseViewModel _customBaseViewModel =
      locator<CustomBaseViewModel>();

  setPhoneNumber(String inputPhoneNumber) {

    phoneNumber = inputPhoneNumber;
  }

  setUserName(String inputName) {
    userName = inputName;
  }

  setErrorText(String inputError) {
    errorText = inputError;
    notifyListeners();
  }

  toggleSignUpScreen() {
    isSignUpScreen = !isSignUpScreen;
    notifyListeners();
  }

  setCountryAndDialCode(String inputIsoCode, String inputDialCode) {
    selectedDialCode = inputDialCode;
    selectedIsoCode = inputIsoCode;
  }

  setOtp(String inputOtp) {
    enteredOtp = inputOtp;
  }

  setKeyForForm(var inputKey) {
    formKey = inputKey;
  }

  resendOtp() async {
    _customBaseViewModel.showProgressBar();

    if (resendToken == -1) {
      await _customBaseViewModel.showErrorDialog(
          description: "Please Try again");
      return;
    }

    isResendCode = true;
    await _auth.verifyPhoneNumber(
      phoneNumber: previousNumber,
      timeout: Duration(seconds: otpTimeoutSeconds),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      forceResendingToken: resendToken,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  sendOtp() async {
    errorText = "";
    notifyListeners();

    if (phoneNumber == previousNumber) {
      _customBaseViewModel.showProgressBar();
      errorText = "";
      await _auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          timeout: Duration(seconds: otpTimeoutSeconds),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
          forceResendingToken: resendToken);
    } else {
      _customBaseViewModel.showProgressBar();

      previousNumber = phoneNumber.trim();
      errorText = "";

      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: otpTimeoutSeconds),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
    }
    return true;
  }

  void codeAutoRetrievalTimeout(String verificationId) {}

  void codeSent(String inputVerificationId, [int? code]) {
    if (code != null) {
      resendToken = code;
    }

    if (isResendCode) {
      otpTimeoutSeconds = 60;
      notifyListeners();
    }
    verificationId = inputVerificationId;
    _customBaseViewModel.stopProgressBar();
    setIndex(1);
  }

  verificationFailed(FirebaseAuthException error) async {
    if (error.code == "invalid-phone-number") {
      await _customBaseViewModel.showErrorDialog(
          description: "Please enter valid phone number");
    } else if (error.code == "too-many-requests") {
      await _customBaseViewModel.showErrorDialog(
          description: "You can't request otp more than three times per day");
    } else {
      await _customBaseViewModel.showErrorDialog(
          description: error.code.toString());
    }
  }

  submitOtp() async {
    _customBaseViewModel.showProgressBar();
    String smsCode = enteredOtp.trim();

    String isSuccess =
        await _customBaseViewModel.getAuthService().signInWithOTP(smsCode,verificationId);

    if (isSuccess == "noError") {
      phoneNumberVerified();
    } else {
      _customBaseViewModel.stopProgressBar();
      if (isSuccess.contains(
          "The sms verification code used to create the phone auth credential is invalid")) {
        _customBaseViewModel.showErrorDialog(
            title: "Invalid OTP",
            description: "Please Use Valid OTP to continue",
            isDismissible: false);
      } else {
        await _customBaseViewModel.showErrorDialog(description: isSuccess);
      }
    }
  }

  verificationCompleted(AuthCredential phoneAuthCredential) async {

    if (currentIndex == 1) {
      _customBaseViewModel.showProgressBar();
      await Future.delayed(
        const Duration(seconds: 1),
        () async {
          String isSuccess = await _customBaseViewModel
              .getAuthService()
              .signIn(phoneAuthCredential);
          if (isSuccess == "noError") {
            phoneNumberVerified();
          } else {
            _customBaseViewModel.stopProgressBar();
            _customBaseViewModel.showErrorDialog(
                description: isSuccess, isDismissible: false);
          }
        },
      );
    }
  }

  phoneNumberVerified() async {

    String tokenId = await _customBaseViewModel
        .getFirebasePushNotificationService()
        .getFcmToken();
    String? id;

      id = await _customBaseViewModel.getAuthService().getUserid();

      if (id == null) {
        _customBaseViewModel.stopProgressBar();
        await _customBaseViewModel.showErrorDialog(
            description: "Please logout and try again");
        return;
      }

      if (isSignUpScreen) {
        UserCreateModel _userCreateModel = UserCreateModel(
            name: userName,
            id: id,
            firebaseTokenId: tokenId,
            phoneNumber: phoneNumber,
            statusLine: AppConst.defaultStatusOfUser);

        ApiResult<bool> result = await _customBaseViewModel
            .getDataManager()
            .createUser(_userCreateModel);

        result.when(success: (bool result) async {
          await signInWithFirebaseAndGoToMainScreen(id!);
        }, failure: (NetworkExceptions e) async {
          _customBaseViewModel.stopProgressBar();
          if(NetworkExceptions.getDioException(e) ==  const NetworkExceptions.conflict()){
            await _customBaseViewModel.showErrorDialog(
                description: "User already exist please login");
          }else{
            await _customBaseViewModel.showErrorDialog(
                description: NetworkExceptions.getErrorMessage(e));
          }
        });
      } else {
        UserFirebaseTokenUpdateModel _userFirebaseTokenUpdateModel =
            UserFirebaseTokenUpdateModel(id: id, firebaseTokenId: tokenId);

        ApiResult<bool> result = await _customBaseViewModel
            .getDataManager()
            .updateFirebaseToken(_userFirebaseTokenUpdateModel);
        result.when(success: (bool result) async {
          await signInWithFirebaseAndGoToMainScreen(id!);
        }, failure: (NetworkExceptions e) async {
          _customBaseViewModel.stopProgressBar();
          if (e == const NetworkExceptions.notFound()) {
            await _customBaseViewModel.showErrorDialog(
                title: "Account not exist",
                description: "Please signup instead");
          } else {
            await _customBaseViewModel.showErrorDialog(
                description: NetworkExceptions.getErrorMessage(e));
          }
        });
      }
  }

  signInWithFirebaseAndGoToMainScreen(String id) async {

      if (isSignUpScreen) {
        UserBasicDataOfflineModel _userBasicDataOfflineModel =
            UserBasicDataOfflineModel(
                name: userName,
                statusLine: AppConst.defaultStatusOfUser,
                profileImage: null,
                compressedProfileImage: null,
                id: id);
        bool resultOfSavingData = await _customBaseViewModel
            .getDataManager()
            .saveUserBasicDataOfflineModel(_userBasicDataOfflineModel);
        _customBaseViewModel.stopProgressBar();
        if (resultOfSavingData) {
          _customBaseViewModel
              .getNavigationService()
              .clearStackAndShow(Routes.mainScreenView);
        } else {
          _customBaseViewModel.showErrorDialog(
              description: "Some problem occurred in saving data");
        }
      } else {
        ApiResult<UserBasicDataOfflineModel> _userBasicDataOfflineModel =
            await _customBaseViewModel.getDataManager().getUserData(id);

        _userBasicDataOfflineModel.when(
          success: (UserBasicDataOfflineModel model) async {
            bool resultOfSavingData = await _customBaseViewModel
                .getDataManager()
                .saveUserBasicDataOfflineModel(model);
            if (resultOfSavingData) {

              //check for backup
              String? userId = await _customBaseViewModel.getAuthService().getUserid();
              ApiResult<BackUpFoundModel> _userBackUpDetails = await _customBaseViewModel.getDataManager().getUserBackupDetail(userId!);
              _userBackUpDetails.when(success: (BackUpFoundModel model){

                if(model.isBackUpFound){
                  _customBaseViewModel.stopProgressBar();
                  _customBaseViewModel
                      .getNavigationService()
                      .clearStackAndShow(Routes.backUpFoundScreen);


                }else{
                  _customBaseViewModel.stopProgressBar();
                  _customBaseViewModel
                      .getNavigationService()
                      .clearStackAndShow(Routes.mainScreenView);
                }

              }, failure: (NetworkExceptions e){
                _customBaseViewModel.stopProgressBar();
                _customBaseViewModel.showErrorDialog(description: "Problem occurred in finding backup");
              });


            } else {
              _customBaseViewModel.showErrorDialog(
                  description: "Some problem occurred in saving data");
            }
          },
          failure: (NetworkExceptions e) {
            _customBaseViewModel.stopProgressBar();
            _customBaseViewModel.showErrorDialog(
                description: NetworkExceptions.getErrorMessage(e));
          },
        );
      }

  }
}
