import 'package:socketchat/app/locator.dart';
import 'package:socketchat/app/routes/style_config.dart';
import 'package:socketchat/config/color_config.dart';
import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';
import 'package:socketchat/ui/widgets/custom_button.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:socketchat/const/enums/dialogs_enum.dart';

void setupDialogUi() {
  final dialogService = locator<DialogService>();

  final builders = {
    dialogEnum.saveOrNot: (context, sheetRequest, completer) =>
        LogoutDialog(request: sheetRequest, completer: completer),
    dialogEnum.success: (context, sheetRequest, completer) =>
        SuccessDialog(request: sheetRequest, completer: completer),
    dialogEnum.confirmation: (context, sheetRequest, completer) =>
        ConfirmationDialog(request: sheetRequest, completer: completer),
    dialogEnum.failure: (context, sheetRequest, completer) =>
        FailureDialog(request: sheetRequest, completer: completer),
    dialogEnum.permission: (context, sheetRequest, completer) =>
        PermissionDialog(request: sheetRequest, completer: completer),
  };

  dialogService.registerCustomDialogBuilders(builders);
}

class FailureDialog extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const FailureDialog({required this.request, required this.completer});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Center(
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(14)),
                color: Colors.white,
              ),
              child: Padding(
                padding:
                const  EdgeInsets.only(left: 13, top: 16, right: 13, bottom: 15),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 130,
                        height: 130, //
                        color: Colors.transparent,
                        child: Lottie.asset("assets/animations/failure.json"),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        request.title ?? "Failure",
                        style: TextStyle(fontSize: 23),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(request.description ?? "Some problem occured",
                          style: TextStyle(fontSize: 16, color: Colors.grey)),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 20, bottom: 10),
                        child: GestureDetector(
                          onTap: () {
                            completer(DialogResponse(confirmed: true));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(14)),
                              color: ColorConfig.redColor,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Center(
                                  child: Text(
                                "OK",
                                style: TextStyle(color: Colors.white),
                              )),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            // Positioned(
            //   top: -50,
            //   child: Container(
            //     width: 100,
            //     height: 100, //
            //     child: Image.asset("assets/images/wrong.png"),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class SuccessDialog extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  SuccessDialog({required this.request, required this.completer});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Center(
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(14)),
                color: Colors.white,
              ),
              child: Padding(
                padding:
                    EdgeInsets.only(left: 13, top: 10, right: 13, bottom: 15),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 150,
                        height: 150, //
                        color: Colors.transparent,
                        child: Lottie.asset("assets/animations/success.json"),
                      ),
                      Text(
                        request.title ?? "Success",
                        style: TextStyle(fontSize: 23),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                          request.description ??
                              "Information saved Succesfully",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              letterSpacing: 0.8)),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 20, bottom: 10),
                        child: GestureDetector(
                          onTap: () {
                            completer(DialogResponse(confirmed: true));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(14)),
                              color: ColorConfig.greenColor,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Center(
                                  child: Text(
                                request.mainButtonTitle ?? "OK",
                                style: TextStyle(color: Colors.white),
                              )),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            // Positioned(
            //   top: -200,
            //   child: Container(
            //     width: 150,
            //     height: 150, //
            //     color: Colors.transparent,
            //     child: Lottie.asset("assets/animations/success.json"),
            //   ),
            // ),
            // Positioned(
            //   top: -50,
            //   child: Container(
            //     width: 100,
            //     height: 100, //
            //     child: Image.asset("assets/images/right_success.png"),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class LogoutDialog extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  LogoutDialog({required this.request, required this.completer});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        child: Padding(
          padding: EdgeInsets.only(left: 13, top: 13, right: 21, bottom: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10.0, top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.power_settings_new,
                          color: ColorConfig.greyColor2),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        request.title ?? "Are you sure",
                        style: TextStyle(
                          fontSize: 21,
                          color: ColorConfig.greyColor2,
                          fontFamily: 'ProximaNova',
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(
                    request.description ?? "Are you sure you want to logout?",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        fontFamily: 'ProximaNova'),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    RaisedButton(
                      color: Colors.white,
                      elevation: 0,
                      onPressed: () {
                        DialogResponse _dialogResponse =
                            DialogResponse(confirmed: false);
                        completer(_dialogResponse);
                      },
                      child: Text(
                        'NO',
                        style: TextStyle(
                            color: ColorConfig.greyColor2, fontSize: 18.0),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    RaisedButton(
                        color: ColorConfig.greyColor2,
                        elevation: 0,
                        onPressed: () async {
                          DialogResponse _dialogResponse =
                              DialogResponse(confirmed: true);
                          completer(_dialogResponse);
                        },
                        child: Text(
                          'YES',
                          style: TextStyle(color: Colors.white, fontSize: 18.0),
                        )),
                    const SizedBox(
                      width: 17,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ConfirmationDialog extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const ConfirmationDialog({required this.request, required this.completer});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, top: 20, right: 16, bottom: 18),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                request.title ?? "Are You Sure?",
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 14.0, right: 14),
                child: Text(
                  request.description ?? "Are You Sure about this action",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                      color: Colors.black38),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: CustomButton(
                      "NO",
                      backgroundColor: ColorConfig.backgroundColor,
                      textColor: Colors.black,
                      height: 42,
                      fontSize: 16,
                      buttonPressed: () {
                        completer(DialogResponse(confirmed: false));
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    flex: 1,
                    child: CustomButton(
                      "CONFIRM",
                      backgroundColor: ColorConfig.accentColor,
                      height: 42,
                      fontSize: 16,
                      buttonPressed: () {
                        completer(DialogResponse(confirmed: true));
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PermissionDialog extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  PermissionDialog({required this.request, required this.completer});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        child: Padding(
          padding: EdgeInsets.only(left: 13, top: 13, right: 21, bottom: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10.0, top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Permission Required',
                        style: TextStyle(
                            fontSize: 21, color: ColorConfig.greyColor2),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(
                    request.description ?? "Please Grant ",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    RaisedButton(
                      color: Colors.white,
                      elevation: 0,
                      onPressed: () {
                        DialogResponse _dialogResponse =
                            DialogResponse(confirmed: false);
                        completer(_dialogResponse);
                      },
                      child: Text(
                        'NO',
                        style: TextStyle(
                            color: ColorConfig.greyColor2, fontSize: 18.0),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    RaisedButton(
                      color: ColorConfig.greyColor2,
                      elevation: 0,
                      onPressed: () async {
                        DialogResponse _dialogResponse =
                            DialogResponse(confirmed: true);
                        completer(_dialogResponse);
                      },
                      child: Text(
                        'YES',
                        style: TextStyle(color: Colors.white, fontSize: 18.0),
                      ),
                    ),
                    const SizedBox(
                      width: 17,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
