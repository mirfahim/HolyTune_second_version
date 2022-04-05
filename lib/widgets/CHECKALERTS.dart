import 'package:HolyTune/screens/TabBarPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../auth/LoginScreen.dart';
import '../i18n/strings.g.dart';

class CheckAlerts {
  static Future<void> show(context, title, message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Text(message),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(t.ok),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                    MyTabHomePage()), (Route<dynamic> route) => false);
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> showCupertinoAlert(context, title, message) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: new Text(title),
          content: new Text(message),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text(t.ok),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ));
  }

  static showProgressDialog(BuildContext context, String title) {
    try {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              content: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  CircularProgressIndicator(),
                  Padding(
                    padding: EdgeInsets.only(left: 15),
                  ),
                  Flexible(
                      flex: 8,
                      child: Text(
                        title,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            );
          });
    } catch (e) {
      print(e.toString());
    }
  }

  static subscriptionloginrequiredhint(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(t.loginrequired),
          content: Text(t.loginrequiredhint),
          actions: <Widget>[
            TextButton(
              child: Text(t.cancel.toUpperCase()),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(t.login.toUpperCase()),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, LoginScreen.routeName);
              },
            )
          ],
        );
      },
    );
  }

  static showPlaySubscribeAlertDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(t.subscribehint),
          content: Text(t.playsubscriptionrequiredhint),
          actions: <Widget>[
            TextButton(
              child: Text(t.cancel.toUpperCase()),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(t.subscribe),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  static showPreviewSubscribeAlertDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(t.subscribehint),
          content: Text(t.previewsubscriptionrequiredhint),
          actions: <Widget>[
            TextButton(
              child: Text(t.cancel.toUpperCase()),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(t.subscribe),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}
