import 'package:flutter/material.dart';

class MyColors {
  static Color primary = Colors.grey[900]; //Color(0xFF1976D2);
  static Color primaryDark = Colors.grey[900]; //Color(0xFF1565C0);
  static Color primaryLight = Colors.grey[900]; //Color(0xFF1E88E5);
  static const Color primaryVeryLight = Color(0xFFD5E4F1);
  static const Color accent = Color(0xfff7892b);
  static const Color accentDark = Color(0xfff7892b);
  static const Color accentLight = Color(0xfff7892b);
  static const Color lightBlue = Color(007);
  static const Color darkBlue = Color(00008);
  static Color appColor = HexColor("#F0F0F0");
  static Color miniPlayerColor = HexColor("#007BC3");
  static Color softBlueColor = HexColor("#E5EDF1");

  static const Color grey_3 = Color(0xFFf7f7f7);
  static const Color grey_5 = Color(0xFFf2f2f2);
  static const Color grey_10 = Color(0xFFe6e6e6);
  static const Color grey_20 = Color(0xFFcccccc);
  static const Color grey_40 = Color(0xFF999999);
  static const Color grey_60 = Color(0xFF666666);
  static const Color grey_80 = Color(0xFF37474F);
  static const Color grey_90 = Color(0xFF263238);
  static const Color grey_95 = Color(0xFF1a1a1a);
  static const Color grey_100_ = Color(0xFF0d0d0d);
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
