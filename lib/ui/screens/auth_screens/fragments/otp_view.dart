import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:socketchat/app/routes/style_config.dart';
import 'package:socketchat/config/color_config.dart';
import 'package:socketchat/ui/widgets/custom_button.dart';
import 'package:socketchat/ui/widgets/otp_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../auth_view_model.dart';

class OtpView extends ViewModelWidget<AuthViewModel> {
  OtpView({Key? key}) : super(key: key);
  final timerKey = GlobalKey();

  @override
  AuthViewModel viewModelBuilder(BuildContext context) => AuthViewModel();

  @override
  Widget build(BuildContext context, AuthViewModel viewModel) {
    return WillPopScope(
      onWillPop: () async {
        viewModel.setIndex(0);
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.only(top: 20,left: 20,right: 20,bottom: 6),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () {
                        viewModel.setIndex(0);
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                      child: SvgPicture.asset(
                        "assets/images/mobile_otp_image.svg",
                        fit: BoxFit.fitHeight,
                        height: 140,
                      )),
                  const SizedBox(
                    height: 25,
                  ),
                  Column(
                    children: [
                      Text(
                        "OTP Verification",
                        style: h1Title,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 4, left: 20, right: 20),
                        child: Text(
                          "Please enter the otp that you received on your phone number",
                          textAlign: TextAlign.center,
                          style:
                              h5Title.copyWith(color: ColorConfig.greyColor3),
                        ),
                      ),
                      const SizedBox(
                        height: 54,
                      ),
                      Text(
                        "Enter OTP",
                        style: h5Title,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      OtpWidget(
                        (value) {
                          viewModel.setOtp(value);
                        },
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Didn\'t Recive code?',
                            style: h5Title.copyWith(letterSpacing: 1.4),
                          ),
                          TimerWidget(viewModel.otpTimeoutSeconds, () {
                            viewModel.resendOtp();
                          }, timerKey),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomButton(
                        "VERIFY OTP",
                        buttonPressed: () {
                          viewModel.submitOtp();
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TimerWidget extends StatelessWidget {
  int timerEndSeconds = 60;
  final Function resendOtpCallback;
  final GlobalKey _key;

  TimerWidget(this.timerEndSeconds, this.resendOtpCallback, this._key,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Countdown(
      key: _key,
      seconds: timerEndSeconds,
      build: (BuildContext context, double time) {
        if (time.toInt() == 0) {
          return GestureDetector(
            onTap: () {
              resendOtpCallback();
            },
            child: const Text(
              "Request again",
              style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5),
            ),
          );
        } else {
          return Text(
            time.toInt().toString() + "S",
            style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5),
          );
        }
      },
      interval: const Duration(seconds: 1),
      onFinished: () {},
    );
  }
}
