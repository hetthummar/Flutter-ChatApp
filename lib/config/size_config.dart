import 'package:flutter/widgets.dart';

class SizeConfig {
  MediaQueryData? _mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;
  static double? blockSizeHorizontal;
  static double? blockSizeVertical;

  static double? _safeAreaHorizontal;
  static double? _safeAreaVertical;
  static double? safeBlockHorizontal;
  static double? safeBlockVertical;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData?.size.width;
    screenHeight = _mediaQueryData?.size.height;
    blockSizeHorizontal = screenWidth! / 414;
    blockSizeVertical = screenHeight! / 856;

    _safeAreaHorizontal =
        _mediaQueryData!.padding.right + _mediaQueryData!.padding.left;
    _safeAreaVertical =
        _mediaQueryData!.padding.top + _mediaQueryData!.padding.bottom;
    safeBlockHorizontal = (screenWidth! - _safeAreaHorizontal!) / 100;
    safeBlockVertical = (screenHeight! - _safeAreaVertical!) / 100;
  }
}

extension SizeConfigExtension on int {
  double vertical() {
    return this * SizeConfig.safeBlockVertical!;
  }

  double horizontal() {
    print( "HELO :- " + (this * SizeConfig.safeBlockHorizontal!).toString());
    return this * SizeConfig.safeBlockHorizontal!;
  }
}
