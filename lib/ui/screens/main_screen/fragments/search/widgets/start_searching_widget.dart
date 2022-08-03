import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:socketchat/app/routes/style_config.dart';
import 'package:socketchat/config/color_config.dart';
import 'package:socketchat/config/size_config.dart';

class StartSearchingWidget extends StatelessWidget {
  const StartSearchingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(left: 34,right: 34,top: 8.vertical()),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              width: 40.horizontal(),
              height: 26.vertical(),
              child: SvgPicture.asset("assets/images/start_searching_image.svg")),
          Text(
            "Start Searching",
            style: h1Title.copyWith(fontSize: 24, letterSpacing: 0.6),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            "Find interesting people by searching them and start the conversation\n(Enter min 2 character)",
            style: h4Title.copyWith(fontSize: 14, letterSpacing: 0.6,color: ColorConfig.greyColor3),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 2.vertical(),
          ),
        ],
      ),
    );
  }
}
