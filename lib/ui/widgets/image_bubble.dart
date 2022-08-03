import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:socketchat/config/color_config.dart';
import 'package:socketchat/config/size_config.dart';
import 'package:socketchat/utils/color_utils.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart' as flutterBlurHash;
import 'package:blurhash_dart/blurhash_dart.dart';

class ImageBubble extends StatelessWidget {
  String? imageFileUrl;
  final bool isSender;
  final bool sent;
  final bool delivered;
  final bool seen;
  final String sendTime;
  final String senderName;
  final int widthOfImage;
  final int heightOfImage;
  final Function updateSeen;

  Function(String status)? clickListener;

  final bool isLoading;
  String? imageNetworkUrl;
  String? imageNetworkBlurHash;

  String imageProcessingStatus;

  ImageBubble({
    Key? key,
    this.imageFileUrl,
    this.imageNetworkUrl,
    this.sent = false,
    this.delivered = false,
    this.seen = false,
    required this.sendTime,
    this.isSender = true,
    this.senderName = "",
    required this.widthOfImage,
    required this.heightOfImage,
    this.isLoading = false,
    this.clickListener,
    this.imageNetworkBlurHash,
    required this.updateSeen,
    required this.imageProcessingStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool stateTick = false;
    Icon? stateIcon;
    if (sent) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done,
        size: 13,
        color: Colors.white70,
      );
    }
    if (delivered) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done_all,
        size: 14,
        color: Colors.white70,
      );
    }
    if (seen) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done_all,
        size: 14,
        color: Colors.green,
      );
    }

    if (!sent && !delivered && !seen) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.watch_later_outlined,
        size: 13,
        color: Colors.white70,
      );
    }

    if (!seen) {
      updateSeen();
    }

    double inverseAspectRatio = heightOfImage / widthOfImage;
    double width = 74.horizontal();
    double height = width * inverseAspectRatio;

    print("isSender :- "  + isSender.toString());

    return Container(
      width: width,
      height: height,
      alignment: isSender ? Alignment.bottomRight : Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        child: Stack(
          alignment: isSender ? Alignment.bottomRight : Alignment.bottomLeft,
          fit: StackFit.loose,
          children: [
            imageProcessingStatus == "toUpload" || imageProcessingStatus == "processCompleted"
                ? SizedBox(
                    width: width,
                    height: height,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(imageFileUrl!),
                        fit: BoxFit.cover,
                        alignment: Alignment.bottomRight,
                      ),
                    ),
                  )
                : Container(),
            imageProcessingStatus == "toDownload"
                ? imageNetworkBlurHash != null
                    ? SizedBox(
                        width: width,
                        height: height,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: AspectRatio(
                                aspectRatio: 1 / inverseAspectRatio,
                                child: flutterBlurHash.BlurHash(
                                    hash: imageNetworkBlurHash!))
                            // child: Image.network(
                            //   imageNetworkUrl!,
                            //   fit: BoxFit.cover,
                            //   alignment: Alignment.bottomRight,
                            // ),
                            ),
                      )
                    : SizedBox(
                        width: width,
                        height: height,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: AspectRatio(
                              aspectRatio: 1 / inverseAspectRatio,
                              child: Container(
                                color: Colors.black87,
                              ),
                            )),
                      )
                : Container(),
            imageProcessingStatus == "toUpload" && !isLoading
                ? GestureDetector(
                    onTap: () {
                      if (clickListener != null) {
                        clickListener!("uploading");
                      }
                    },
                    child: SizedBox(
                      width: width,
                      height: height,
                      child: Center(
                        child: Container(
                          width: 45,
                          height: 45,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black54,
                          ),
                          child: const Icon(
                            Icons.upload_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
            imageProcessingStatus == "toDownload" && !isLoading
                ? GestureDetector(
                    onTap: () {
                      if (clickListener != null) {
                        clickListener!("downloading");
                      }
                    },
                    child: SizedBox(
                      width: width,
                      height: height,
                      child: Center(
                        child: Container(
                          width: 45,
                          height: 45,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black54,
                          ),
                          child: const Icon(
                            Icons.download_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
            isLoading
                ? SizedBox(
                    width: width,
                    height: height,
                    child: Center(
                        child: SpinKitRing(
                      color: ColorConfig.accentColor,
                      lineWidth: 4.5,
                      size: 40.0,
                    )),
                  )
                : const SizedBox(),
            Positioned(
              bottom: 0,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(8),
                    bottomLeft: Radius.circular(8)),
                child: Container(
                    width: width,
                    height: 24,
                    color: Colors.black38,
                    child: isSender
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(sendTime,
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500)),
                              const SizedBox(
                                width: 4,
                              ),
                              stateIcon ?? Container(),
                              const SizedBox(
                                width: 6,
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(sendTime,
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500)),
                              const SizedBox(
                                width: 4,
                              ),
                            ],
                          )),
              ),
            ),
          ],
        ),
      ),
    );
  }
// else if (imageNetworkUrl != null) {
//
//   return Container(
//     width: width,
//     height: height,
//     alignment: isSender ? Alignment.bottomRight : Alignment.bottomLeft,
//     child: Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
//       child: Stack(
//         children: [
//           imageNetworkBlurHash != null
//               ? SizedBox(
//                   width: width,
//                   height: height,
//                   child: ClipRRect(
//                       borderRadius: BorderRadius.circular(8),
//                       child: AspectRatio(
//                           aspectRatio: 1 / inverseAspectRatio,
//                           child: flutterBlurHash.BlurHash(
//                               hash: imageNetworkBlurHash!))
//                       // child: Image.network(
//                       //   imageNetworkUrl!,
//                       //   fit: BoxFit.cover,
//                       //   alignment: Alignment.bottomRight,
//                       // ),
//                       ),
//                 )
//               : SizedBox(
//                   width: width,
//                   height: height,
//                   child: ClipRRect(
//                       borderRadius: BorderRadius.circular(8),
//                       child: AspectRatio(
//                         aspectRatio: 1 / inverseAspectRatio,
//                         child: Container(
//                           color: Colors.black87,
//                         ),
//                       )
//                       ),
//                 ),
//           imageFileUrl == null && !isLoading
//               ? GestureDetector(
//                   onTap: () {
//                     if (clickListener != null) {
//                       clickListener!();
//                     }
//                   },
//                   child: SizedBox(
//                     width: width,
//                     height: height,
//                     child: Center(
//                       child: Container(
//                         width: 45,
//                         height: 45,
//                         decoration: const BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Colors.black54,
//                         ),
//                         child: const Icon(
//                           Icons.download_rounded,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 )
//               : const SizedBox(),
//           isLoading
//               ? SizedBox(
//                   width: width,
//                   height: height,
//                   child: Center(
//                       child: SpinKitRing(
//                     color: ColorConfig.accentColor,
//                     lineWidth: 4.5,
//                     size: 40.0,
//                   )),
//                 )
//               : const SizedBox(),
//           Positioned(
//             bottom: 0,
//             child: ClipRRect(
//               borderRadius: const BorderRadius.only(
//                   bottomRight: Radius.circular(8),
//                   bottomLeft: Radius.circular(8)),
//               child: Container(
//                 width: width,
//                 height: 24,
//                 color: Colors.black38,
//                 child: isSender
//                     ? Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Text(sendTime,
//                               style: TextStyle(
//                                   color: Colors.white.withOpacity(0.9),
//                                   fontSize: 10,
//                                   fontWeight: FontWeight.w500)),
//                           const SizedBox(
//                             width: 4,
//                           ),
//                           stateIcon != null ? stateIcon : Container(),
//                           const SizedBox(
//                             width: 6,
//                           ),
//                         ],
//                       )
//                     : Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Text(sendTime,
//                               style: TextStyle(
//                                   color: Colors.white.withOpacity(0.9),
//                                   fontSize: 10,
//                                   fontWeight: FontWeight.w500)),
//                           const SizedBox(
//                             width: 4,
//                           ),
//                         ],
//                       ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// } else {
//   return Container(
//     width: 100,
//     height: 100,
//     color: Colors.black,
//   );
// }
}
