import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:socketchat/ui/screens/auth_screens/fragments/otp_view.dart';
import 'package:socketchat/ui/screens/auth_screens/fragments/phone_view.dart';
import 'package:stacked/stacked.dart';

import 'auth_view_model.dart';

class AuthView extends StatelessWidget {
  const AuthView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AuthViewModel>.reactive(
      viewModelBuilder: () => AuthViewModel(),
      fireOnModelReadyOnce: true,
      onModelReady: (viewModel){
        final _formKey = GlobalKey<FormState>();
        viewModel.setKeyForForm(_formKey);
      },
      builder: (context, model, child) {

        return PageTransitionSwitcher(
            duration: const Duration(milliseconds: 1000),
            // reverse: model.reverse,
            transitionBuilder: (Widget child,
                Animation<double> animation,
                Animation<double> secondaryAnimation,) {
              return SharedAxisTransition(
                child: child,
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                transitionType: SharedAxisTransitionType.horizontal,
              );
            },
            child: model.currentIndex == 0 ? PhoneView() : OtpView(),
        );
      },
    );
  }
}