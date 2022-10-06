import 'package:HolyTune/auth/AuthOtherFields.dart';
import 'package:HolyTune/utils/Alerts.dart';
import 'package:HolyTune/widgets/CHECKALERTS.dart';
import 'package:email_auth/email_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:numeric_keyboard/numeric_keyboard.dart';
import 'package:HolyTune/database/SharedPreference.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:HolyTune/i18n/strings.g.dart';
import 'package:HolyTune/utils/ApiUrl.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:provider/provider.dart';
import 'package:HolyTune/auth/OTP_MOBILE/OTPFunc/stores/login_store.dart';
import 'package:HolyTune/auth/OTP_MOBILE/OTPFunc/widgets/loader_hud.dart';

import 'OTP_MOBILE/OTPFunc/theme.dart';

String phnNumOtp;

class OtpPageEmailAndPhn extends StatefulWidget {
  final String otp;
  final String mobileNo;
  final String email;
  final bool otpStyle;
  const OtpPageEmailAndPhn(
      {Key key, this.mobileNo, this.email, this.otp, this.otpStyle})
      : super(key: key);

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPageEmailAndPhn> {
  bool login = false;

  File imageFile;

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');
    print("WORKING____________");
    final file = File('${(await getTemporaryDirectory()).path}/$path');

    print("WORKING____________");
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  Future<void> checkUser(String phone) async {
    Alerts.showProgressDialog(context, t.processingpleasewait);
    try {
      final multipart =
          http.MultipartRequest("POST", Uri.parse(ApiUrl.CHECKUSER))
            //..fields["data"] = jsonEncode(json)

            ..fields["phone"] = SharedPref.phoneNO;

      var response = await multipart.send();
      print(response.statusCode);
      if (response.statusCode == 200) {
        print("WORKING HERE");

        // Navigator.pop(context);
        // If the server did return a 200 OK response,
        // then parse the JSON.
        Map<String, dynamic> resp =
            jsonDecode(await response.stream.bytesToString());
        print("MY______RESPONSE______$resp");
        print("RESPONSE___MSG___ ${resp["status"]}");
        if (resp["status"] == "error") {
          CheckAlerts.show(context, "Successfully Login", resp["message"]);
          String profileName = resp["data"]["name"];
          String profileEmail = resp["data"]["email"];
          String imageName = resp["data"]["image"];
          String profilePhn = resp["data"]["phone"];
          print("PROFILE__________NAME__________$profileName");
          print("PROFILE__________NAME__________$profileEmail");

          final phnKey = "profilePhn";

          SharedPref.to.prefss.setString(phnKey, profilePhn);
          SharedPref.to.prefss.setString("profileEmail", profileEmail);
          SharedPref.profileEmail = profileEmail;
          SharedPref.profilePhn = profilePhn;
          print("YO____YO_____PHONE____${SharedPref.profilePhn}");
          final nameKey = "profileName";
          SharedPref.to.prefss.setString(nameKey, profileName);
          SharedPref.profileName = profileName;
          final imageKey = "imageKey";
          SharedPref.to.prefss.setString(imageKey, imageName);
          SharedPref.imageProfile = imageName;
          final key = "loggedin";

          SharedPref.to.prefss.setBool(key, login);
          SharedPref.loginState = false;
        } else {
          Route route = MaterialPageRoute(builder: (c) => Register());
          Navigator.pushReplacement(context, route);
        }

        // String loginState = SharedPref.to.prefss.setString("Loggedin");
        //  print("___LOGIN___STATE___BRO___$loginState");
        print(response.statusCode);
        Map<String, dynamic> res =
            jsonDecode(await response.stream.bytesToString());
        if (res["status"] == "error") {
          //  Alerts.show(context, t.error, res["msg"]);
        } else {
          //   Alerts.show(context, t.success, res["message"]);
        }
        print(res);
        if (res["status"] == "error") {
          // Alerts.show(context, t.error, res["msg"]);
        }
      }
    } catch (exception) {
      // I get no exception here
      print("POPPOP>>>>$exception");
    }
  }

  String mobileNo = "+8801717653445";
  int otp;
  String text = '';

  void _onKeyboardTap(String value) {
    setState(() {
      text = text + value;
    });
    print("______________$text");
  }

  Widget otpNumberWidget(int position) {
    final w = MediaQuery.of(context).size.width;
    try {
      return Container(
        height: 50,
        width: w / 7,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0),
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        child: Center(
            child: Text(
          text[position],
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        )),
      );
    } catch (e) {
      return Container(
        height: 50,
        width: w / 7,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0),
            borderRadius: const BorderRadius.all(Radius.circular(8))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    mobileNo = widget.mobileNo;

    return Consumer<LoginStore>(
      builder: (_, loginStore, __) {
        return Observer(
          builder: (_) => LoaderHUD(
            inAsyncCall: loginStore.isOtpLoading,
            child: Scaffold(
              backgroundColor: Colors.white,
              key: loginStore.otpScaffoldKey,
              appBar: AppBar(
                leading: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      color: MyColors.primaryColorLight.withAlpha(20),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.blue,
                      size: 16,
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                elevation: 0,
                backgroundColor: Colors.white,
                brightness: Brightness.light,
              ),
              body: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Text(
                                    'Enter 4 Digits Verification Code \nSent to - $mobileNo',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 107, 107, 107),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 30),
                                Container(
                                  constraints:
                                      const BoxConstraints(maxWidth: 500),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      otpNumberWidget(0),
                                      SizedBox(width: 10),
                                      otpNumberWidget(1),
                                      SizedBox(width: 10),
                                      otpNumberWidget(2),
                                      SizedBox(width: 10),
                                      otpNumberWidget(3),
                                      // otpNumberWidget(4),
                                      // otpNumberWidget(5),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 30),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  constraints:
                                      const BoxConstraints(maxWidth: 500),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      print("my otp varification is ${widget.otp}");
                                      if (widget.otpStyle == false) {
                                        varifyOTP();
                                      } else {
                                        if (widget.otp == text) {
                                          String phone = SharedPref.phoneNO;
                                          checkUser(phone);
                                        } else {
                                          Alerts.show(context, t.error,
                                              "Please enter the right OTP");
                                          // Scaffold.of(context).showSnackBar(
                                          //   SnackBar(
                                          //     duration: Duration(seconds: 3),
                                          //     content: Text("Please enter the right otp number"),
                                          //   ),
                                          // );
                                        }
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.lightBlue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      textStyle: TextStyle(
                                          fontSize: 17, color: Colors.blue),
                                    ),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 30),
                                      child: Text(
                                        'Confirmed',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          NumericKeyboard(
                            onKeyboardTap: _onKeyboardTap,
                            textColor:
                                Colors.blueGrey, // MyColors.primaryColorLight,
                            rightIcon: Icon(
                              Icons.backspace,
                              color: Colors
                                  .blueGrey, // MyColors.primaryColorLight,
                            ),
                            rightButtonFn: () {
                              setState(() {
                                text = text.substring(0, text.length - 1);
                              });
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  varifyOTP() {
    var res = EmailAuth.validate(receiverMail: widget.email, userOTP: text);
    if (res) {
      print("email Validated");
      verifyFormAndSubmit();
    } else {
      print("email  not Validated");

      Alerts.show(context, t.error, t.confirmOtpFirst);
    }
  }

  verifyFormAndSubmit() {
    String _otp = text;
    String _email = widget.email;

    if (_email == "" || _otp == "") {
      Alerts.show(context, t.error, t.emptyfielderrorhint);
    } else if (EmailValidator.validate(_email) == false) {
      Alerts.show(context, t.error, t.invalidemailerrorhint);
    } else {
      Route route = MaterialPageRoute(
          builder: (c) => Register(
                email: widget.email,
                phnPage: false,
              ));
      Navigator.pushReplacement(context, route);
      // registerUser(_email, _name, _password);

    }
  }
}
