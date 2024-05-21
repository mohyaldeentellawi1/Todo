import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

const Color bluishClr = Colors.indigoAccent;
const Color redLClr = Colors.red;
const Color tealClr = Colors.teal;
const Color orangeClr = Colors.orange;
const Color pinkCrl = Colors.pink;
const Color white = Colors.white;
const Color blueGray = Color.fromRGBO(115, 147, 179, 1);
Color primaryClr = Colors.grey.shade100;
const Color darkGreyClr = Colors.black;
const Color darkHeaderClr = Colors.grey;

class Themes {
  static final liGht = ThemeData(
    useMaterial3: true,
    primaryColor: primaryClr,
    colorScheme: ColorScheme.light(
      surface: primaryClr,
      brightness: Brightness.light,
    ),
  );
  static final daRk = ThemeData(
    primaryColor: darkGreyClr,
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      surface: darkGreyClr,
      brightness: Brightness.dark,
    ),
  );
}

TextStyle get headingStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
    color: Get.isDarkMode ? Colors.white : Colors.black,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  ));
}

TextStyle get subheadingStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
    color: Get.isDarkMode ? Colors.white : Colors.black,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ));
}

TextStyle get titleStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
    color: Get.isDarkMode ? Colors.white : Colors.black,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ));
}

TextStyle get subTitleStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
    color: Get.isDarkMode ? Colors.white : Colors.black,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  ));
}

TextStyle get bodyStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
    color: Get.isDarkMode ? Colors.white : Colors.black,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  ));
}

TextStyle get body2Style {
  return GoogleFonts.lato(
      textStyle: TextStyle(
    color: Get.isDarkMode ? Colors.grey[200] : Colors.black,
    fontSize: 14,
    fontWeight: FontWeight.w300,
  ));
}
