import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:socketchat/config/color_config.dart';
import 'package:socketchat/ui/widgets/custom_circular_image.dart';
import 'package:socketchat/utils/date_time_util.dart';
import 'package:socketchat/utils/extensions/string_extension.dart';

class SingleChatWidget extends StatelessWidget {
  Function chatClickCallback;
  String name;
  String description;
  String? time;
  String? compressedProfileImage;
  int? unreadMessage;

  SingleChatWidget({
    Key? key,
    required this.name,
    required this.description,
    required this.compressedProfileImage,
    required this.chatClickCallback,
    this.time,
    this.unreadMessage = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6,bottom: 6,left: 4),
      child: ListTile(
          focusColor:Colors.grey,
        onTap: (){
          chatClickCallback();
        },
        leading: CustomCircularImage(
          width: 54,
          height: 54,
          imageUri: compressedProfileImage,
        ),
        title: Text(
          name.capitalize(),
          style: const TextStyle(
              height: 1,
              fontSize: 16,
              letterSpacing: 0.4,
              fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
         description,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              fontSize: 12,
              letterSpacing: 1,
              color: Colors.black38,
              fontWeight: FontWeight.w400),
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 8,
            ),
            time != null ? Text(
              time!,
              style: const TextStyle(
                  fontSize: 10,
                  letterSpacing: 0.4,
                  color: Colors.black38,
                  fontWeight: FontWeight.w500),
            ):const SizedBox(width: 0,height: 0,),
            const SizedBox(
              height: 4,
            ),
            unreadMessage == 0 || unreadMessage == null ? const SizedBox(
              width: 0,
              height: 0,
            ):Container(
              alignment: Alignment.center,
              height: 21,
              width: 21,
              decoration: BoxDecoration(
                color: ColorConfig.accentColor,
                shape: BoxShape.circle,
              ),
              child:  Text(
                unreadMessage.toString(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10.4,
                    fontWeight: FontWeight.w600),
              ),
            )
          ],
        ),
      ),
    );

    // return InkWell(
    //   onTap: () {
    //     chatClickCallback();
    //   },
    //   child: Padding(
    //     padding:
    //         const EdgeInsets.only(left: 14.0, right: 18, top: 10, bottom: 14),
    //     child: Row(
    //       mainAxisSize: MainAxisSize.max,
    //       children: [
    //         CustomCircularImage(
    //           width: 56,
    //           height: 56,
    //           imageUri: compressedProfileImage,
    //         ),
    //         const SizedBox(
    //           width: 12,
    //         ),
    //         Flexible(
    //           child: Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: [
    //                 Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: [
    //                     Text(
    //                       name.capitalize(),
    //                       style: const TextStyle(
    //                           height: 1,
    //                           fontSize: 18,
    //                           letterSpacing: 0.4,
    //                           fontWeight: FontWeight.w700),
    //                     ),
    //                     Padding(
    //                       padding: const EdgeInsets.only(left: 4.0, top: 2),
    //                       child: Text(
    //                         description,
    //                         style: TextStyle(
    //                             height: 1,
    //                             fontSize: 14,
    //                             letterSpacing: 0.2,
    //                             color: ColorConfig.greyColor3,
    //                             fontWeight: FontWeight.w400),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //                 Column(
    //                   crossAxisAlignment: CrossAxisAlignment.end,
    //                   children: [
    //                     Text(
    //                       time!,
    //                       style: const TextStyle(
    //                           fontSize: 11,
    //                           letterSpacing: 0.4,
    //                           color: Colors.grey,
    //                           fontWeight: FontWeight.w400),
    //                     ),
    //                     Padding(
    //                       padding: const EdgeInsets.only(top: 4, right: 4),
    //                       child: Container(
    //                         alignment: Alignment.center,
    //                         height: 25,
    //                         width: 25,
    //                         decoration: BoxDecoration(
    //                           color: ColorConfig.accentColor,
    //                           shape: BoxShape.circle,
    //                         ),
    //                         child: Text(
    //                           "6",
    //                           style: TextStyle(color: Colors.white),
    //                         ),
    //                       ),
    //                       // child: CircleAvatar(
    //                       //   minRadius: 13,
    //                       //   backgroundColor: ColorConfig.accentColor,
    //                       //   child:  Center(
    //                       //     child: const Text(
    //                       //       "12",
    //                       //       style: TextStyle(
    //                       //           color: Colors.white,
    //                       //           fontSize: 12,
    //                       //           height: 1,
    //                       //           fontWeight: FontWeight.w600,
    //                       //           letterSpacing: 0.6),
    //                       //     ),
    //                       //   ),
    //                       // )
    //                       // child: Container(
    //                       //   decoration: BoxDecoration(
    //                       //       shape: BoxShape.circle,
    //                       //       color: ColorConfig.accentColor),
    //                       //   child: Padding(
    //                       //     padding: const EdgeInsets.all(12.0),
    //                       //     child: Text(
    //                       //       "12",
    //                       //       style: TextStyle(
    //                       //         height: 1,
    //                       //           fontWeight: FontWeight.w600,
    //                       //           letterSpacing: 0.5,
    //                       //           color: Colors.white, fontSize: 11),
    //                       //     ),
    //                       //   ),
    //                       // ),
    //                     )
    //                   ],
    //                 )
    //               ]),
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }
}
