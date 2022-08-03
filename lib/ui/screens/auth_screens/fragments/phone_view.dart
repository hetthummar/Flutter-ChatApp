import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:socketchat/app/routes/style_config.dart';
import 'package:socketchat/config/color_config.dart';
import 'package:socketchat/config/size_config.dart';
import 'package:socketchat/ui/widgets/custom_button.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import '../auth_view_model.dart';

class PhoneView extends ViewModelWidget<AuthViewModel> {
  PhoneView({Key? key}) : super(key: key);

  @override
  AuthViewModel viewModelBuilder(BuildContext context) => AuthViewModel();

  @override
  Widget build(BuildContext context, AuthViewModel viewModel) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: ColorConfig.backgroundColor,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 20,
            ),
            child: SizedBox(
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child:  Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 220),
                          child: SvgPicture.asset(
                            "assets/images/auth_image.svg",
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        BottomSheetWidget(),
                        Container(
                          height: 10,
                          color: Colors.white,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BottomSheetWidget extends HookViewModelWidget<AuthViewModel> {
  BottomSheetWidget({Key? key}) : super(key: key);

  @override
  AuthViewModel viewModelBuilder(BuildContext context) => AuthViewModel();

  @override
  Widget buildViewModelWidget(BuildContext context, AuthViewModel viewModel) {
    var _userNameTextController =
        useTextEditingController(text: viewModel.userName);
    var _phoneNumberController = useTextEditingController();
    _userNameTextController.addListener(
      () {
        String inputText = _userNameTextController.text;
        viewModel.setUserName(inputText);
      },
    );

    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18), topRight: Radius.circular(18)),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 16.0, right: 16, top: 18, bottom: 0),
            child: AnimationLimiter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: AnimationConfiguration.toStaggeredList(
                  children: [
                    Text(
                      viewModel.isSignUpScreen ? "Sign up" : "Log in",
                      style: h1Title.copyWith(
                          fontSize: 30,
                          color: ColorConfig.accentColor,
                          letterSpacing: 0.8),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      "Get your self register in our application and give your customer rewards",
                      style: h5Title,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, top: 10),
                      child: Column(
                        children: [
                          AnimatedSwitcher(
                            switchInCurve: Curves.easeInCubic,
                            switchOutCurve: Curves.easeOutCubic,
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween(
                                    begin: const Offset(0.5, 0.0),
                                    end: const Offset(0.0, 0.0),
                                  ).animate(animation),
                                  child: child,
                                ),
                              );
                            },
                            child: viewModel.isSignUpScreen
                                ? Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 16.0),
                                    child: FadeInAnimation(
                                      duration: viewModel.previousNumber == ""
                                          ? const Duration(seconds: 1)
                                          : const Duration(seconds: 0),
                                      child: Form(
                                        key: viewModel.formKey,
                                        child: TextFormField(
                                          controller: _userNameTextController,
                                          validator: (text) {
                                            if (text == null ||
                                                text.length < 2) {
                                              return "Name should contain more than 1 characters";
                                            }
                                            return null;
                                          },
                                          decoration: const InputDecoration(
                                              filled: true,
                                              fillColor: Color(0xffE3E3E3),
                                              hintText: 'Enter Your Name',
                                              contentPadding: EdgeInsets.only(
                                                  left: 26.0,
                                                  bottom: 20.0,
                                                  top: 20.0),
                                              border: InputBorder.none),
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                          ),
                          InternationalPhoneNumberInput(
                              textFieldController: _phoneNumberController,
                              textStyle: const TextStyle(
                                fontSize: 14,
                              ),
                              validator: (value) {},
                              onInputChanged: (number) {
                                _phoneNumberController.selection =
                                    TextSelection.collapsed(
                                        offset:
                                            _phoneNumberController.text.length);
                                if (number.phoneNumber != null) {
                                  viewModel.setPhoneNumber(number.phoneNumber!);
                                }
                                viewModel.setCountryAndDialCode(
                                    number.isoCode!, number.dialCode!);
                              },
                              initialValue: PhoneNumber(
                                  dialCode: viewModel.selectedDialCode,
                                  isoCode: viewModel.selectedIsoCode,
                                  phoneNumber: viewModel.phoneNumber),
                              formatInput: true,
                              // ignoreBlank: false,
                              selectorConfig: const SelectorConfig(
                                  trailingSpace: true,
                                  selectorType:
                                      PhoneInputSelectorType.BOTTOM_SHEET,
                                  setSelectorButtonAsPrefixIcon: true,
                                  leadingPadding: 20),
                              inputDecoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xffE3E3E3),
                                hintText: 'Enter Phone Number',
                                contentPadding: const EdgeInsets.only(
                                    left: 14.0, bottom: 16.0, top: 20.0),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              )),
                        ],
                      ),
                    ),
                    viewModel.errorText != ""
                        ? Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 38.0, top: 6),
                              child: Text(viewModel.errorText,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.4)),
                            ),
                          )
                        : Container(),
                    const SizedBox(
                      height: 26,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: CustomButton(
                        "SEND OTP",
                        buttonPressed: () {
                          bool isSignUpScreen = viewModel.isSignUpScreen;
                          isSignUpScreen
                              ? viewModel.formKey.currentState!.validate()
                              : null;
                          String enteredPhoneNumber = viewModel.phoneNumber;

                          if (enteredPhoneNumber.isEmpty) {
                            viewModel.setErrorText("Phone number is required");
                          } else if (enteredPhoneNumber.length < 10) {
                            viewModel.setErrorText("Enter valid number");
                          } else {
                            if (isSignUpScreen
                                ? viewModel.formKey.currentState!.validate()
                                : true) {
                              viewModel.sendOtp();
                            }
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        viewModel.toggleSignUpScreen();
                      },
                      child: Text(
                        viewModel.isSignUpScreen
                            ? "Already have an account? Log in"
                            : "Need a new Account? Sign UP",
                        style: const TextStyle(letterSpacing: 0.6),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                  ],
                  duration: const Duration(milliseconds: 800),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    horizontalOffset: viewModel.previousNumber == "" ? 80.0 : 0,
                    child: FadeInAnimation(
                      child: widget,
                      duration: viewModel.previousNumber == ""
                          ? null
                          : const Duration(milliseconds: 30),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
