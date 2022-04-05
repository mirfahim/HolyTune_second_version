import 'package:flutter/material.dart';
import 'package:HolyTune/auth/AuthOtherFields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../i18n/strings.g.dart';
import '../utils/Alerts.dart';
import 'dart:convert';
import 'dart:async';
import '../utils/ApiUrl.dart';
import 'package:http/http.dart' as http;
import 'LoginScreen.dart';
import '../utils/img.dart';
import '../utils/my_colors.dart';
import 'package:email_validator/email_validator.dart';
import 'package:email_auth/email_auth.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class MobileAuthScreen extends StatefulWidget {
  static const routeName = "/registerMobile";
  MobileAuthScreen();

  @override
  RegisterScreenRouteState createState() => new RegisterScreenRouteState();
}

class RegisterScreenRouteState extends State<MobileAuthScreen> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  String initialCountry = 'NG';
  PhoneNumber number = PhoneNumber(isoCode: 'NG');
  final _pinPutController = TextEditingController();
  final _pinPutFocusNode = FocusNode();

  final mobileController = TextEditingController();
  final otpController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();

  //
  // verifyFormAndSubmit() {
  //
  //   String _name = mobileController.text;
  //   String _password = passwordController.text;
  //   String _repeatPassword = repeatPasswordController.text;
  //
  //   if ( _mobile == "" || _password == "") {
  //     Alerts.show(context, t.error, t.emptyfielderrorhint);
  //   } else if (EmailValidator.validate(_mobile) == false) {
  //     Alerts.show(context, t.error, t.invalidemailerrorhint);
  //   } else if (_password != _repeatPassword) {
  //     Alerts.show(context, t.error, t.passwordsdontmatch);
  //   } else {
  //     registerUser(_email,_name, _password);
  //   }
  // }

  Future<void> registerUser(String email, String name, String password) async {
    Alerts.showProgressDialog(context, t.processingpleasewait);
    try {
      final response = await http.post(Uri.parse(ApiUrl.REGISTER),
          body: jsonEncode({
            "data": {
              "email": email,
              "name": name,
              "password": password,
            }
          }));
      if (response.statusCode == 200) {
        // Navigator.pop(context);
        // If the server did return a 200 OK response,
        // then parse the JSON.
        Navigator.of(context).pop();
        print(response.body);
        Map<String, dynamic> res = json.decode(response.body);
        if (res["status"] == "error") {
          Alerts.show(context, t.error, res["message"]);
        } else {
          Alerts.show(context, t.success, res["message"]);
        }
        print(res);
      }
    } catch (exception) {
      // Navigator.pop(context);
      // I get no exception here
      print(exception);
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.

    mobileController.dispose();
    passwordController.dispose();
    repeatPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final BoxDecoration pinPutDecoration = BoxDecoration(
      color: const Color.fromRGBO(43, 46, 66, 1),
      borderRadius: BorderRadius.circular(10.0),
      border: Border.all(
        color: const Color.fromRGBO(126, 203, 224, 1),
      ),
    );
    return new Scaffold(
      key: _globalKey,
      resizeToAvoidBottomInset: true,
      // backgroundColor: MyColors.primary,
      appBar:
          PreferredSize(child: Container(), preferredSize: Size.fromHeight(0)),
      body: Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          Container(
            //height: double.infinity,
            //width: double.infinity,
            alignment: Alignment.topCenter,
            child: Image.asset(
              Img.get("launcher_icon.png"),
              fit: BoxFit.contain,
            ),
          ),
          Column(children: <Widget>[
            Container(
              height: 20,
            ),
            Container(
              child: Center(
                  child: Text(
                t.appname,
                style: TextStyle(fontSize: 26),
              )),
              width: double.infinity,
              height: 100,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                width: double.infinity,
                height: double.infinity,
                child: ListView(
                  children: <Widget>[
                    Container(height: 30),
                    Container(height: 20),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          InternationalPhoneNumberInput(
                            onInputChanged: (PhoneNumber number) {
                              print(number.phoneNumber);
                            },
                            onInputValidated: (bool value) {
                              print(value);
                            },
                            selectorConfig: SelectorConfig(
                              selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                            ),
                            ignoreBlank: false,
                            autoValidateMode: AutovalidateMode.disabled,
                            selectorTextStyle: TextStyle(color: Colors.black),
                            initialValue: number,
                            textFieldController: mobileController,
                            formatInput: false,
                            keyboardType: TextInputType.numberWithOptions(
                                signed: true, decimal: true),
                            inputBorder: OutlineInputBorder(),
                            onSaved: (PhoneNumber number) {
                              print('On Saved: $number');
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Pinput(
                        // fieldsCount: 6,
                        // withCursor: true,
                        // textStyle: const TextStyle(
                        //     fontSize: 25.0, color: Colors.white),
                        // eachFieldWidth: 40.0,
                        // eachFieldHeight: 55.0,
                        // onSubmit: (String pin) => _showSnackBar(pin),
                        focusNode: _pinPutFocusNode,
                        controller: _pinPutController,
                        // submittedFieldDecoration: pinPutDecoration,
                        // selectedFieldDecoration: pinPutDecoration,
                        // followingFieldDecoration: pinPutDecoration,
                        pinAnimationType: PinAnimationType.fade,
                        onSubmitted: (pin) async {
                          try {
                            await FirebaseAuth.instance
                                .signInWithCredential(
                                    PhoneAuthProvider.credential(
                                        verificationId: varificationCode,
                                        smsCode: pin))
                                .then((value) async {
                              if (value.user != null) {
                                print("pass to home");
                                Route route = MaterialPageRoute(
                                    builder: (c) => LoginScreen());
                                Navigator.pushReplacement(context, route);
                              }
                            });
                          } catch (e) {
                            FocusScope.of(context).unfocus();
                            _globalKey.currentState.showSnackBar(
                                SnackBar(content: Text("Invalid OTP")));
                          }
                        },
                      ),
                    ),
                    Container(height: 20),
                    TextField(
                      keyboardType: TextInputType.number,
                      controller: otpController,
                      style: TextStyle(),
                      decoration: InputDecoration(
                        labelText: "OTP",
                        labelStyle: TextStyle(),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(width: 1),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(width: 2),
                        ),
                      ),
                    ),
                    Container(height: 20),
                    TextField(
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      controller: passwordController,
                      style: TextStyle(),
                      decoration: InputDecoration(
                        labelText: t.password,
                        labelStyle: TextStyle(),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(width: 1),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(width: 2),
                        ),
                      ),
                    ),
                    Container(height: 20),
                    TextField(
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      controller: repeatPasswordController,
                      style: TextStyle(),
                      decoration: InputDecoration(
                        labelText: t.repeatpassword,
                        labelStyle: TextStyle(),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(width: 1),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(width: 2),
                        ),
                      ),
                    ),
                    Container(height: 35),
                    Container(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                        child: Text(
                          t.register,
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: MyColors.accentDark,
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          textStyle: TextStyle(fontSize: 17),
                        ),
                        onPressed: () {
                          // Route route =
                          //     MaterialPageRoute(builder: (c) => Register());
                          // Navigator.pushReplacement(context, route);

                          //verifyFormAndSubmit();
                          print(
                              "________*****************${mobileController.text}");
                          _verifyPhone();
                          //
                        },
                      ),
                    ),
                  ],
                  //mainAxisSize: MainAxisSize.min,
                ),
              ),
            ),
          ]),
        ],
      ),
    );
  }

  String varificationCode;
  _verifyPhone() async {
    print("________*****************${mobileController.text}");
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+8801782084390",
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) async {
          if (value.user != null) {
            print("userLogged in");
            Route route = MaterialPageRoute(builder: (c) => LoginScreen());
            Navigator.pushReplacement(context, route);
          }
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (String varificariobID, int resendCode) {
        setState(() {
          varificationCode = varificariobID;
        });
      },
      codeAutoRetrievalTimeout: (String varificationID) {
        setState(() {
          varificationCode = varificationID;
        });
      },
      timeout: Duration(seconds: 60),
    );
  }
}
