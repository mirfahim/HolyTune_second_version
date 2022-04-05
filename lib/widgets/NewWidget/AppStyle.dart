import 'package:flutter/material.dart';
//import 'package:HolyTune/widgets/NewWidget/Dimension.dart';

import 'Dimension.dart';



class AppStyle {
  static TextStyle title(
      {FontWeight fontWeight,
        double fontSize,
        color,
        double latterSpacing = 0.5,
        double wordSpacing = 0.5}) =>
      TextStyle(
        color: color ?? Colors.white,
        fontWeight: fontWeight ?? Dimension.textBold,
        fontSize: fontSize ?? Dimension.Text_title_Big,
      );

  static TextStyle title3(
      {FontWeight fontWeight,
        double fontSize,
        color,
        double latterSpacing = 0.5,
        double wordSpacing = 0.5}) =>
      TextStyle(
        color: color ?? Colors.white.withOpacity(0.5),
        fontWeight: fontWeight ?? Dimension.textBold,
        fontSize: fontSize ?? Dimension.Text_Size_Big,
      );

  static TextStyle title4(
      {FontWeight fontWeight,
        double fontSize,
        color,
        double latterSpacing = 0.5,
        double wordSpacing = 0.5}) =>
      TextStyle(
        color: color ?? Color(0xffFD7B10),
        fontWeight: fontWeight ?? Dimension.textBold,
        fontSize: fontSize ?? Dimension.Text_Size_Big,
      );

  static TextStyle title1(
      {FontWeight fontWeight,
        double fontSize,
        color,
        double latterSpacing = 0.0,
        double wordSpacing = 0.0}) =>
      TextStyle(
          color: color ?? Color(0xffFD7B10),
          fontWeight: fontWeight ?? Dimension.textBold,
          fontSize: fontSize ?? Dimension.Text_Size_Big_1,
          letterSpacing: latterSpacing,
          wordSpacing: wordSpacing);

  static TextStyle title2(
      {FontWeight fontWeight,
        double fontSize,
        color,
        double latterSpacing = 0.5,
        double wordSpacing = 0.5}) =>
      TextStyle(
          color: color ?? Color(0xffFD7B10),
          fontWeight: fontWeight ?? FontWeight.w300,
          fontSize: fontSize ?? Dimension.Text_Size_Big_2,
          letterSpacing: latterSpacing,
          wordSpacing: wordSpacing);

  static TextStyle normal_text(
      {FontWeight fontWeight,
        double fontSize,
        color,
        double latterSpacing,
        double wordSpacing}) =>
      TextStyle(
        fontWeight: fontWeight ?? FontWeight.normal,
        letterSpacing: latterSpacing ?? Dimension.latter_spaceing,
        color: color ?? Colors.white,
        fontSize: fontSize ?? Dimension.Text_Size_Small,
        wordSpacing: wordSpacing,
      );

  static TextStyle normal_text1(
      {FontWeight fontWeight,
        double fontSize,

        Color color,
        double latterSpacing,
        double wordSpacing}) =>
      TextStyle(
          letterSpacing: latterSpacing ?? Dimension.latter_spaceing,
          color: color ?? Color(0xff818181),
          fontSize: fontSize ?? Dimension.Text_Size_Big_2,
          fontWeight: fontWeight ?? FontWeight.normal,
          wordSpacing: wordSpacing);

  static TextStyle normal_text_black(
      {FontWeight fontWeight,
        double fontSize,
        Color color,
        double latterSpacing,
        double wordSpacing}) =>
      TextStyle(
          wordSpacing: wordSpacing ?? 0.0,
          letterSpacing: latterSpacing ?? Dimension.latter_spaceing,
          color: color ?? Color(0xff525252),
          fontSize: fontSize ?? Dimension.Text_Size,
          fontWeight: fontWeight ?? Dimension.textBold);
  static TextStyle listLengthText = AppStyle.title2(

      fontSize: 16,
      fontWeight: FontWeight.w400);

/*  static TextStyle normal_text_2 = TextStyle(
    letterSpacing: Dimension.latter_spaceing,
    color: Colors.white,
    fontSize: 18,
    fontWeight: Dimension.textBold
  );*/
  static TextStyle normal_bold_text(
      {FontWeight fontWeight, fontSize, color, double letterSpacing}) =>
      TextStyle(
        letterSpacing: letterSpacing ?? Dimension.latter_spaceing,
        color: color ?? Colors.white,
        fontWeight: fontWeight ?? Dimension.textBold,
        fontSize: fontSize ?? Dimension.Text_Size_Big,
      );

  static TextStyle hit_style = TextStyle(
    color: Dimension.hint_color,
    fontSize: 14.0,
    fontWeight: Dimension.textNormal,
    letterSpacing: Dimension.latter_spaceing,
  );
}
