import 'package:flutter/material.dart';
import 'package:socketchat/config/size_config.dart';
import 'package:socketchat/ui/screens/startup/startup_view_model.dart';
import 'package:stacked/stacked.dart';

class StartUpView extends StatelessWidget {
  const StartUpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StartUpViewModel>.reactive(
      onModelReady: (StartUpViewModel model) {
        SizeConfig().init(context);
        model.runStartupLogic();
      },
      viewModelBuilder: () => StartUpViewModel(),
      builder: (context, model, child) {
        return Container();
      },
    );
  }
}
