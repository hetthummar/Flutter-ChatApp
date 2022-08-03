import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:socketchat/app/routes/style_config.dart';
import 'package:socketchat/config/color_config.dart';
import 'package:socketchat/config/size_config.dart';

class NoSearchResultFoundWidget extends StatelessWidget {
  const NoSearchResultFoundWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(left: 34,right: 34,top: 6.vertical()),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           Container(
            width: 70.horizontal(),
              height: 29.vertical(),
              child: SvgPicture.asset("assets/images/no_search_result_found_image.svg")),
          Text(
            "Not Found",
            style: h1Title.copyWith(fontSize: 24, letterSpacing: 0.6),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            "Result you are looking for is not found please Try again with\ndifferent name",
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
