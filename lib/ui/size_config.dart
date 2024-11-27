import 'dart:developer';

import 'package:flutter/material.dart';

class SizeConfig {
  static late Size _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late Orientation orientation;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.sizeOf(context);
    screenWidth = _mediaQueryData.width;
    log('$screenWidth');
    screenHeight = _mediaQueryData.height;
    orientation = _mediaQueryData.width > _mediaQueryData.height
        ? Orientation.landscape
        : Orientation.portrait;
  }
}

double getProportionateScreenHeight(double inputHeight) {
  double screenHeight = SizeConfig.screenHeight;
  return (inputHeight / 812.0) * screenHeight;
}

double getProportionateScreenWidth(double inputWidth) {
  double screenWidth = SizeConfig.screenHeight;
  return (inputWidth / 1500.0) * screenWidth;
}
