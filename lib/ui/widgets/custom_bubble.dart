import 'package:flutter/material.dart';
import 'package:socketchat/config/color_config.dart';
import 'package:socketchat/config/size_config.dart';
import 'dart:math' as math;

import 'package:socketchat/utils/color_utils.dart';

const double BUBBLE_RADIUS = 10;

///basic chat bubble type
///
///chat bubble [BorderRadius] can be customized using [bubbleRadius]
///chat bubble color can be customized using [color]
///chat bubble tail can be customized  using [tail]
///chat bubble display message can be changed using [text]
///[text] is the only required parameter
///message sender can be changed using [isSender]
///[sent],[delivered] and [seen] can be used to display the message state
///chat bubble [TextStyle] can be customized using [textStyle]

class CustomBubble extends StatelessWidget {
  final double bubbleRadius;
  final bool isSender;
  final Color color;
  final String text;
  final bool tail;
  final bool sent;
  final bool delivered;
  final bool seen;
  final TextStyle textStyle;
  final String senderName;
  final Function updateSeen;
  final String sendTime;

  CustomBubble(
      {Key? key,
      required this.text,
      this.bubbleRadius = BUBBLE_RADIUS,
      this.isSender = true,
      this.color = Colors.white70,
      this.tail = true,
      this.sent = false,
      this.delivered = false,
      this.seen = false,
      this.textStyle = const TextStyle(
        color: Colors.black87,
        fontSize: 16,
      ),
      this.senderName = "",
      required this.updateSeen,
      required this.sendTime})
      : super(key: key);

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
        size: 13,
        color: Colors.white70,
      );
    }
    if (seen) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done_all,
        size: 13,
        color: Colors.green,
      );
    }

    if (!sent && !delivered && !seen) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.watch_later_outlined,
        size: 12,
        color: Colors.white70,
      );
    }

    if (!seen) {
      updateSeen();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 0, bottom: 0),
      child: Row(
        children: <Widget>[
          isSender
              ? const Expanded(
                  child: SizedBox(
                    width: 5,
                  ),
                )
              : Container(),
          Container(
            color: Colors.transparent,
            constraints: BoxConstraints(maxWidth: 80.horizontal()),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(bubbleRadius),
                    topRight: Radius.circular(bubbleRadius),
                    bottomLeft: Radius.circular(tail
                        ? isSender
                            ? bubbleRadius
                            : 0
                        : BUBBLE_RADIUS),
                    bottomRight: Radius.circular(tail
                        ? isSender
                            ? 0
                            : bubbleRadius
                        : BUBBLE_RADIUS),
                  ),
                ),
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: stateTick
                          ? const EdgeInsets.fromLTRB(12, 10, 10, 10)
                          : const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          senderName != ""
                              ? Text(
                                  senderName,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: ColorUtils().getRandomColor(),
                                      letterSpacing: 0.5),
                                  textAlign: TextAlign.left,
                                )
                              : const SizedBox(),
                          // Text("", textAlign: TextAlign.left),
                          isSender
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.only(bottom:4.0),
                                        child: Text(
                                          text,
                                          style: textStyle,
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ),
                                    stateIcon != null && stateTick
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                top: 0.0, left: 8),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: stateIcon
                                                          .icon ==
                                                      Icons.watch_later_outlined
                                                  ? CrossAxisAlignment.center
                                                  : CrossAxisAlignment.end,
                                              children: [
                                                Text(sendTime,
                                                    style: TextStyle(
                                                        color: Colors.white
                                                            .withOpacity(0.9),
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w300)),
                                                const SizedBox(
                                                  width: 4,
                                                ),
                                                stateIcon,
                                              ],
                                            ),
                                          )
                                        : const SizedBox(
                                            width: 1,
                                          ),
                                  ],
                                )
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Flexible(
                                      child: Container(
                                        child: Text(
                                          text,
                                          style: textStyle,
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, left: 8),
                                      child: Text(sendTime,
                                          style: const TextStyle(
                                              color: Colors.black38,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w400)),
                                    )
                                  ],
                                ),
                        ],
                      ),
                    ),
                    // stateIcon != null && stateTick
                    //     ? Positioned(
                    //         bottom: 0,
                    //         right: 6,
                    //         child: Row(
                    //           children: [
                    //             Text("07:27",style:TextStyle(color:ColorConfig.greyColor2)),
                    //             SizedBox(
                    //               width: 10,
                    //             ),
                    //             stateIcon,
                    //           ],
                    //         ),
                    //       )
                    //     : SizedBox(
                    //         width: 1,
                    //       ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
