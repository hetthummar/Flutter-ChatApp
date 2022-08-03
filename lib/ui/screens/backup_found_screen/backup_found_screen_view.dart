import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:socketchat/app/routes/style_config.dart';
import 'package:socketchat/config/color_config.dart';
import 'package:socketchat/config/size_config.dart';
import 'package:socketchat/ui/screens/backup_found_screen/backup_found_screen_view_model.dart';
import 'package:socketchat/ui/widgets/custom_button.dart';
import 'package:stacked/stacked.dart';

class BackUpFoundScreen extends StatelessWidget {
   BackUpFoundScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<backupFoundScreenViewModel>.nonReactive(
      onModelReady: (viewModel){
        viewModel.downloadBackUpData();
      },
      builder: (BuildContext context, backupFoundScreenViewModel model,
          Widget? child) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.only(left: 50.0, right: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 16.vertical(),
                ),
                Container(
                  height: 260, //
                  color: Colors.transparent,
                  child: Lottie.asset("assets/animations/backup_found_animation.json",fit:BoxFit.cover),
                ),
                Text(
                  "Looking for Backup",
                  style: h1Title.copyWith(fontSize: 22),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "We are looking for backup please don’t close application till download is complete",
                  style: h4Title.copyWith(color: ColorConfig.greyColor3,fontSize: 15,letterSpacing: 0.8),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 3.vertical(),
                ),
              ],
            ),
          ),
        );
      },
      viewModelBuilder: () => backupFoundScreenViewModel(),
    );
  }
}
