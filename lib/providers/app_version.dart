import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:new_version/new_version.dart';
import 'package:http/http.dart' as http;

class AppVersion extends ChangeNotifier {
  final int versionCode = 9; //Version code from web
  final newVersion =
      NewVersion(iOSId: 'com.holytune.app', androidId: 'com.holytune.app');

  Future<bool> checkVersion() async {
    Uri url = Uri.parse("https://adminapplication.com/getAppVersion");
    bool result = false;
    await http.get(url).then((response) {
      if (response.statusCode == 200) {
        var rowData = jsonDecode(response.body);
        int settingVersion = int.parse(rowData['app_version']['app_version']);
        if (settingVersion <= versionCode) {
          result = true;
        } else {
          result = false;
        }
      } else {
        result = false;
      }
    });
    return result;
  }

  void customDialog(BuildContext context, String btnName, Function() btnFun,
      Function() cBtnFun) {
    var w = MediaQuery.of(context).size.width * 1;
    var h = MediaQuery.of(context).size.height * 1;
    showAnimatedDialog(
      context: context,
      barrierColor: Colors.black38,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(0),
          insetPadding: EdgeInsets.symmetric(horizontal: 20),
          backgroundColor: Colors.transparent,
          content: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: w,
                  padding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: w / 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: ListTile(
                    leading: Image(
                      image: AssetImage("assets/images/logotrns.png"),
                    ),
                    title: Text(
                      "Holy Tune - Islamic Song",
                      style: TextStyle(
                        color: Colors.indigo[900],
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      "Entertainment",
                      style: TextStyle(
                        color: Color(0xFF5c874b),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: w,
                  padding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: w / 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Text(
                    "Holy Tune new update version is available on google play store.\n\nPlease install now letest version!",
                    style: TextStyle(
                      color: Color(0xFF02041A),
                      fontSize: 14,
                    ),
                  ),
                ),
                Container(
                  width: w,
                  padding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: w / 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (btnName != null)
                        ElevatedButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Color(0xFF689f38),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                          ),
                          child: Text(
                            btnName != "" ? btnName : "Button Name",
                            style: TextStyle(),
                          ),
                          // ignore: unnecessary_null_in_if_null_operators
                          onPressed: btnFun ?? null,
                        ),
                      if (cBtnFun != null) SizedBox(width: 10),
                      if (cBtnFun != null)
                        ElevatedButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.red[900],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 50, horizontal: 10),
                          ),
                          child: Text("cancel"),
                          onPressed: cBtnFun ?? () => Navigator.pop(context),
                        )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      animationType: DialogTransitionType.scale,
      curve: Curves.bounceInOut,
      duration: Duration(milliseconds: 500),
    );
  }
}
