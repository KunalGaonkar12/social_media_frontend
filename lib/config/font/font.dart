import 'package:flutter/material.dart';


//Used to set the text style
class RobotoFonts{
  static const String robotoFamily='Roboto';


  static TextStyle regular({
    double fontSize=0,
    Color color=Colors.black,
  }) {
    return TextStyle(
      fontFamily: robotoFamily,
      fontSize: fontSize,
      color: color,
      fontWeight: FontWeight.w300,
    );
  }


  static TextStyle medium({
    double fontSize=0,
    Color color=Colors.black,
  }) {
    return TextStyle(
      fontFamily: robotoFamily,
      fontSize: fontSize,
      color: color,
      fontWeight: FontWeight.w500,
    );
  }



  static TextStyle semiBold({
    double fontSize=0,
    Color color=Colors.black,
  }) {
    return TextStyle(
      fontFamily: robotoFamily,
      fontSize: fontSize,
      color: color,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle bold({
  double fontSize=0,
  Color color=Colors.black,
  }) {
    return TextStyle(
      fontFamily: robotoFamily,
      fontSize: fontSize,
      color: color,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle boldItalic({
  double fontSize=0,
  Color color=Colors.black,
  }) {
    return TextStyle(
      fontFamily: robotoFamily,
      fontSize: fontSize,
      fontStyle: FontStyle.italic,
      color: color,
      fontWeight: FontWeight.bold,
    );
  }
}