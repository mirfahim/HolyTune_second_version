

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:path/path.dart';
// import 'package:HolyTune/widgets/NewWidget/AppSpace.dart';
// import 'package:HolyTune/widgets/NewWidget/AppStyle.dart';
// import 'package:HolyTune/widgets/NewWidget/Dimension.dart';

import '../main.dart';
import 'NewWidget/AppSpace.dart';
import 'NewWidget/AppStyle.dart';
import 'NewWidget/Dimension.dart';

Widget DefaultTextField(
    {@required TextEditingController controller,
      FocusNode focusNode,
      String label,
      Color backgroundColor,
      Widget prefixIcon,
      Widget suffixIcon,
      Widget prefixWidget,
      int maxLine = 1,
      TextInputType textInputType = TextInputType.text,
      bool obscureText = false,
      String hint,
      bool readOnly = false,
      bool enable = true,
      Function onTap,
      bool isRequired = false,
      bool borderEnable = true,
      Color underlineColor = Colors.white,
      double padding = 16,
      Color cursorColor = Colors.white,
      bool passwordEye = true,
      double left_padding = 30,
      double right_padding = 30,
      double top_padding = 0,
      double bottom_padding = 0,
      double font_size = 16,
      double contentPadding_left = 20,
      double contentPadding_bottom = 10,
      double contentPadding_top = 12,
      double focusedBorderRadius = 25.7,
      double enabledBorderRadius = 25.7,
      String headerTitle,
      Color borderColor,
      bool validator = false,
      Color textColor,
      Color headerTitleColor,
      BuildContext context,
      Function(String) onChanged}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      headerTitle != null
          ? Padding(
        padding: EdgeInsets.only(left: left_padding),
        child: Text(
          "${headerTitle ?? ""}",
          style: TextStyle(
              color: headerTitleColor ?? Colors.white.withOpacity(0.6),
              fontSize: Dimension.textFiledHeaderTitleSize,
              fontWeight: FontWeight.bold),
        ),
      )
          : Container(),
      headerTitle != null ? AppSpaces.spaces_height_10 : Container(),
      Padding(
        padding: EdgeInsets.only(left: left_padding, right: right_padding),
        child: Theme(
          data: Theme.of(context).copyWith(splashColor: backgroundColor),
          child: TextField(
            keyboardType: textInputType,
            readOnly: readOnly,
            onTap: onTap,
            onChanged: onChanged,
            obscureText: obscureText,
            autofocus: false,
            style: TextStyle(
                fontSize: font_size, color: textColor ?? Color(0xFFbdc6cf)),
            cursorColor: Colors.black,
            controller: controller,
            decoration: InputDecoration(
              prefix: prefixWidget,
              prefixIcon: prefixIcon ?? null,
              suffixIcon: suffixIcon ?? null,
              filled: true,
              fillColor: backgroundColor,
              // hintText: '${hint ?? ""}',
              hintStyle: AppStyle.hit_style,
              alignLabelWithHint: true,
              contentPadding: EdgeInsets.only(
                  left: contentPadding_left,
                  bottom: contentPadding_bottom,
                  top: contentPadding_top),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: borderColor ?? backgroundColor),
                borderRadius: BorderRadius.circular(focusedBorderRadius),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: borderColor ?? backgroundColor),
                borderRadius: BorderRadius.circular(focusedBorderRadius),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
