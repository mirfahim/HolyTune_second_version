import 'dart:math';

import 'package:HolyTune/auth/OTPForEmailAndPhn.dart';
import 'package:HolyTune/database/SharedPreference.dart';
import 'package:HolyTune/utils/TextStyles.dart';
import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:toast/toast.dart';
import '../utils/img.dart';
import 'package:provider/provider.dart';
import '../providers/AppStateNotifier.dart';
import '../i18n/strings.g.dart';
import 'dart:io';
import 'OTP_MOBILE/OTPFunc/stores/login_store.dart';
import 'OTP_MOBILE/OTPFunc/widgets/loader_hud.dart';
import '../utils/Alerts.dart';
import 'dart:convert';
import 'dart:async';
import '../utils/ApiUrl.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import '../models/Userdata.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
//import 'package:sms_receiver/sms_receiver.dart';

GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: [
    'email',
  ],
);

class LoginScreen extends StatefulWidget {
  static const routeName = "/login";
  LoginScreen();

  @override
  LoginScreenRouteState createState() => LoginScreenRouteState();
}

class LoginScreenRouteState extends State<LoginScreen> {
  bool selectedTextField = false;

  var randomNum;
  String phnNO;
  static final FacebookLogin facebookSignIn = FacebookLogin();
  final emailController = TextEditingController();
  final phnController = TextEditingController();
  String loginData;
  GoogleSignInAccount _currentUser;

  Future<void> _handleSignIn() async {
    try {
      await googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  verifyFormAndSubmit() {
    String _email = emailController.text;
    String _password = phnController.text;

    if (_email == "" || _password == "") {
      Alerts.show(context, t.error, t.emptyfielderrorhint);
    } else if (EmailValidator.validate(_email) == false) {
      Alerts.show(context, t.error, t.invalidemailerrorhint);
    } else {
      loginUser(_email, _password, "", "");
    }
  }

  Future<void> loginUser(
      String email, String password, String name, String type) async {
    Alerts.showProgressDialog(context, t.processingpleasewait);
    try {
      var data = {
        "email": email,
        "password": password,
      };
      if (type != "") {
        data = {
          "email": email,
          "password": password,
          "name": name,
          "type": type
        };
      }
      final response = await http.post(Uri.parse(ApiUrl.LOGIN),
          body: jsonEncode({"data": data}));
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
          print(res["user"]);
          //Alerts.show(context, t.success, res["message"]);
          Provider.of<AppStateNotifier>(context, listen: false)
              .setUserData(Userdata.fromJson(res["user"]));
          Navigator.of(context).pop();
        }
        //print(res);
      }
    } catch (exception) {
      // Navigator.pop(context);
      // I get no exception here
      print(exception);
    }
  }

  AppStateNotifier appState;
  verifyFormAndSubmitPassLess() {
    String email = emailController.text;
    email = loginData;

    String mobile = emailController.text;

    if (email == "") {
      Alerts.show(context, t.error, t.emptyfielderrorhint);
    } else if (EmailValidator.validate(email) == false) {
      Alerts.show(context, t.error, t.invalidemailerrorhint);
    } else {
      loginUserPassLess(email, mobile);
    }
  }

  Future<void> loginUserPassLess(String email, String mobile) async {
    Alerts.showProgressDialog(context, t.processingpleasewait);
    try {
      final multipart = http.MultipartRequest("POST", Uri.parse(ApiUrl.LOGIN))
        //..fields["data"] = jsonEncode(json)
        ..fields["email"] = loginData
        ..fields["mobile"] = loginData;

      var response = await multipart.send();
      if (response.statusCode == 200) {
        print(response.toString());
        // Navigator.pop(context);
        // If the server did return a 200 OK response,
        // then parse the JSON.
        Navigator.of(context).pop();
        print("uploaded");
        print(response.statusCode);
        Map<String, dynamic> res =
            jsonDecode(await response.stream.bytesToString());
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

  Future<Null> loginWithFacebook() async {
    final FacebookLoginResult result =
        await facebookSignIn.logIn(['email', 'public_profile']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        print('''
         Logged in!
         
         Token: ${accessToken.token}
         User id: ${accessToken.userId}
         Expires: ${accessToken.expires}
         Permissions: ${accessToken.permissions}
         Declined permissions: ${accessToken.declinedPermissions}
         ''');
        var graphResponse = await http.get(Uri.parse(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${accessToken.token}'));
        Map<String, dynamic> profile = json.decode(graphResponse.body);
        print(profile);
        loginUser(profile['email'], "", profile['name'], "Facebook");
        break;
      case FacebookLoginStatus.cancelledByUser:
        Toast.show('Login cancelled by the user.', context);
        break;
      case FacebookLoginStatus.error:
        Toast.show(
            'Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}',
            context);
        break;
    }
  }

  applesigning() async {
    if (await AppleSignIn.isAvailable()) {
      final AuthorizationResult result = await AppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);
      switch (result.status) {
        case AuthorizationStatus.authorized:
          print(result.credential.email);
          loginUser(
              result.credential.email,
              "",
              result.credential.fullName.familyName +
                  " " +
                  result.credential.fullName.givenName,
              t.facebook);
          break;
        case AuthorizationStatus.error:
          print("Sign in failed: ${result.error.localizedDescription}");
          Alerts.show(context, t.error,
              "Sign in failed: ${result.error.localizedDescription}");
          break;
        case AuthorizationStatus.cancelled:
          print('User cancelled');
          break;
      }
    }
  }

  bool sendOTPTap = false;

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      //check for ios if developing for both android & ios
      AppleSignIn.onCredentialRevoked.listen((_) {
        print("Credentials revoked");
      });
    }
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        // _handleGetContact();
        print(_currentUser.email);
        loginUser(_currentUser.email, "", _currentUser.displayName, t.google);
      }
    });
    googleSignIn.signInSilently();
    //_googleSignIn.signOut();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    emailController.dispose();
    phnController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    appState = Provider.of<AppStateNotifier>(context);

    return Consumer<LoginStore>(
      builder: (_, loginStore, __) {
        return Observer(
          builder: (_) => LoaderHUD(
            inAsyncCall: loginStore.isLoginLoading,
            child: Scaffold(
              //backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: true,
              // backgroundColor: Colors.white,
              appBar: PreferredSize(
                  child: Container(), preferredSize: Size.fromHeight(0)),
              body: Stack(
                fit: StackFit.passthrough,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                          width: double.infinity,
                          height: double.infinity,
                          child: ListView(
                            children: <Widget>[
                              Container(height: 20),
                              Container(
                                //width: 100,
                                //height: double.infinity,
                                //width: double.infinity,
                                alignment: Alignment.topCenter,
                                child: SizedBox(
                                  height: 150,
                                  width: 150,
                                  child: Image.asset(
                                    Img.get("logotrns.png"),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              // Container(
                              //   child: Center(
                              //       child: Text(
                              //     t.appname,
                              //     style: TextStyle(fontSize: 26),
                              //   )),
                              //   width: double.infinity,
                              //   height: 100,
                              // ),
                              SizedBox(
                                child: Center(
                                  child: Text(
                                    t.loginPassage,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF888787),
                                    ),
                                  ),
                                ),
                                width: double.infinity,
                                height: 100,
                              ),
                              SizedBox(
                                child: Center(
                                    child: Text(
                                  t.loginIntro,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.lightBlue),
                                )),
                                width: double.infinity,
                                height: 100,
                              ),
                              Container(height: 10),
                              TextField(
                                onTap: () {
                                  setState(() {
                                    selectedTextField = false;
                                  });
                                },
                                maxLength: 11,
                                controller: phnController,
                                keyboardType: TextInputType.phone,
                                style: TextStyle(),
                                textAlign: TextAlign.center,
                                onChanged: (v) {
                                  // print(v.length);
                                  if (v.length == 11) {
                                    setState(() {
                                      sendOTPTap = true;
                                    });
                                  } else {
                                    setState(() {
                                      sendOTPTap = false;
                                    });
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: "01XXXXXXXXX",
                                  hintStyle: TextStyle(color: Colors.grey[800]),
                                  // labelText:
                                  //     "01xxxxxxxxx", //t.emailaddress + " / Mobile",
                                  isDense: true, // Added this
                                  contentPadding:
                                      EdgeInsets.all(12), // Added this
                                  labelStyle: TextStyle(),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.7),
                                    borderSide: BorderSide(
                                        color: Colors.lightBlue, width: 2.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.7),
                                    borderSide: BorderSide(
                                        color: Colors.lightBlue, width: 2.0),
                                  ),
                                ),
                              ),

                              // Container(height: 05),
                              // Container(
                              //   height: 20,
                              //     child: Center(
                              //       child: Text(
                              //         "Or"
                              //       ),
                              //     ),
                              //
                              // ),
                              //                                                  Verification for email
                              // Container(height: 05),
                              // TextField(
                              //   onTap: () {
                              //     setState(() {
                              //       selectedTextField = true;
                              //     });
                              //   },
                              //   controller: emailController,
                              //   keyboardType: TextInputType.text,
                              //   style: TextStyle(),
                              //   textAlign: TextAlign.center,
                              //   decoration: InputDecoration(
                              //     hintText: "Type Your Email",
                              //     hintStyle: TextStyle(
                              //       color: Colors.grey[800],
                              //     ),
                              //     // labelText:
                              //     //     "Email", //t.emailaddress + " / Mobile",
                              //     isDense: true, // Added this
                              //     contentPadding: EdgeInsets.all(12),
                              //     labelStyle: TextStyle(),
                              //     enabledBorder: OutlineInputBorder(
                              //       borderRadius: BorderRadius.circular(25.7),
                              //       borderSide: BorderSide(
                              //           color: Colors.lightBlue, width: 2.0),
                              //     ),
                              //     focusedBorder: OutlineInputBorder(
                              //       borderRadius: BorderRadius.circular(25.7),
                              //       borderSide: BorderSide(
                              //           color: Colors.lightBlue, width: 2.0),
                              //     ),
                              //   ),
                              // ),

                              // TextField(
                              //   controller: passwordController,
                              //   obscureText: true,
                              //   keyboardType: TextInputType.text,
                              //   style: TextStyle(),
                              //   decoration: InputDecoration(
                              //     labelText: t.password,
                              //     labelStyle: TextStyle(),
                              //     enabledBorder: UnderlineInputBorder(
                              //       borderSide: BorderSide(width: 1),
                              //     ),
                              //     focusedBorder: UnderlineInputBorder(
                              //       borderSide: BorderSide(width: 2),
                              //     ),
                              //   ),
                              // ),
                              //  Container(height: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(height: 5),
                                  // InkWell(
                                  //   onTap: () {
                                  //     Navigator.pushReplacementNamed(
                                  //         context, ForgotPasswordScreen.routeName);
                                  //   },
                                  //   child: Text(
                                  //     t.forgotpassword,
                                  //     style: TextStyle(),
                                  //   ),
                                  // ),
                                ],
                              ),
                              Container(height: 25),
                              // Container(
                              //   width: double.infinity,
                              //   height: 45,
                              //   child: ElevatedButton(
                              //     child: Text(
                              //       "Send OTP",
                              //     ),
                              //     style: ElevatedButton.styleFrom(
                              //       primary: MyColors.accentDark,
                              //       shape: RoundedRectangleBorder(
                              //         borderRadius: BorderRadius.circular(20),
                              //       ),
                              //       padding: EdgeInsets.symmetric(
                              //           horizontal: 10, vertical: 10),
                              //       textStyle:
                              //           TextStyle(fontSize: 17, color: Colors.blue),
                              //     ),
                              //     onPressed: () {
                              //       // if (emailController.text.isNotEmpty) {
                              //       //   //  loginStore.loginScaffoldKey.currentState.save();
                              //       //   loginStore.getCodeWithPhoneNumber(context, emailController.text.toString());
                              //       // } else {
                              //       //   loginStore.loginScaffoldKey.currentState.showSnackBar(SnackBar(
                              //       //     behavior: SnackBarBehavior.floating,
                              //       //     backgroundColor: Colors.red,
                              //       //     content: Text(
                              //       //       'Please enter a phone number',
                              //       //       style: TextStyle(color: Colors.white),
                              //       //     ),
                              //       //   ));
                              //       // }
                              //        Route route = MaterialPageRoute(builder: (c) => OtpPageEmailAndPhn( mobileNo:emailController.text ,));
                              //        Navigator.pushReplacement(context, route);
                              //      // loginHolyTune(emailController.text, emailController.text);
                              //      // verifyFormAndSubmitPassLess();
                              //      // verifyFormAndSubmit();
                              //     },
                              //   ),
                              // ),
                              SizedBox(
                                width: double.infinity,
                                height: 45,
                                child: ElevatedButton(
                                  child: Text(
                                    "Send OTP",
                                  ),
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
                                  onPressed: sendOTPTap == true
                                      ? () {
                                          if (selectedTextField == false) {
                                            if (phnController.text != "") {
                                              sendOTP();
                                              setState(() {
                                                sendOTPTap = false;
                                              });
                                            }
                                          } else {
                                            print("email");
                                            sendEmailOTP();
                                          }
                                        }
                                      : null,
                                ),
                              ),
                              Container(height: 40),

                              // Container(height: 15),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              //   children: [
                              //       InkWell(
                              //         onTap: () {
                              //           Navigator.pushReplacementNamed(
                              //               context, RegisterScreen.routeName);
                              //         },
                              //         child: Text(
                              //           t.createaccount + " with",
                              //           style: TextStyle(
                              //             fontSize: 12,
                              //           ),
                              //         ),
                              //       ),
                              //
                              //     InkWell(
                              //       onTap: () {
                              //         Navigator.pushReplacementNamed(
                              //             context, RegisterScreen.routeName);
                              //       },
                              //       child: Text(
                              //         "Email",
                              //         style: TextStyle(color: Colors.orange),
                              //       ),
                              //     ),
                              //     Text("or"),
                              //     InkWell(
                              //       onTap: () {
                              //         Route route = MaterialPageRoute(builder: (c) => LoginPage());
                              //         Navigator.pushReplacement(context, route);
                              //       },
                              //       child: Text(
                              //         "Mobile",
                              //         style: TextStyle(color: Colors.orange),
                              //       ),
                              //     ),
                              //
                              //
                              //   ],
                              // ),
                              // Container(height: 15),
                              // Column(
                              //   children: <Widget>[
                              //     Container(
                              //       width: double.infinity,
                              //       child: TextButton.icon(
                              //         style: TextButton.styleFrom(
                              //             backgroundColor: Colors.blue),
                              //         icon: FaIcon(
                              //           FontAwesomeIcons.facebook,
                              //           color: Colors.white,
                              //           size: 20,
                              //         ), //`Icon` to display
                              //         label: Text(
                              //           t.facebook,
                              //           style: TextStyle(color: Colors.white),
                              //         ), //`Text` to display
                              //         onPressed: () {
                              //           loginWithFacebook();
                              //         },
                              //       ),
                              //     ),
                              //     Container(
                              //       width: double.infinity,
                              //       child: TextButton.icon(
                              //         style: TextButton.styleFrom(
                              //           backgroundColor: Colors.red[400],
                              //         ),
                              //         icon: FaIcon(
                              //           FontAwesomeIcons.google,
                              //           color: Colors.white,
                              //           size: 20,
                              //         ), //`Icon` to display
                              //         label: Text(
                              //           t.google,
                              //           style: TextStyle(color: Colors.white),
                              //         ), //`Text` to display
                              //         onPressed: () {
                              //           _handleSignIn();
                              //         },
                              //       ),
                              //     ),
                              //     Visibility(
                              //       visible: Platform.isIOS ? true : false,
                              //       child: Container(
                              //         width: double.infinity,
                              //         child: AppleSignInButton(
                              //           // style: ButtonStyle.white,
                              //           type: ButtonType.continueButton,
                              //           onPressed: () {
                              //             applesigning();
                              //           },
                              //         ),
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              Container(height: 15),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Future loginHolyTune(String email, String mobile) async {
  //
  //   // print(check_type);
  //   // print(defective_id);
  //   // print(issue_id);
  //
  //   // final String url = ApiUrl.REGISTER;
  //
  //   try {
  //     final response = await http.post( Uri.parse(ApiUrl.otpURL), body: {
  //       "email": emailController.text,
  //       "mobile": emailController.text,
  //
  //
  //
  //     });
  //     print(response.statusCode);
  //
  //     if (response.statusCode == 200) {
  //
  //       print("success");
  //       String jsonResponseString = response.body;
  //
  //       print("check_response $jsonResponseString");
  //       Map maps = jsonDecode(jsonResponseString);
  //       String status = maps["status"];
  //       if(status== "ok"){
  //         Navigator.of(context).pop();
  //       }else{
  //         Scaffold.of(context).showSnackBar(
  //           SnackBar(
  //             duration: Duration(seconds: 2),
  //             content: Text("Please give correct email or Mobile no"),
  //           ),
  //         );
  //       }
  //       print("********$status");
  //       return (jsonDecode(jsonResponseString));
  //
  //
  //     } else {
  //       throw Exception('Failed to login. Try Again');
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //     Scaffold.of(context).showSnackBar(
  //       SnackBar(
  //         duration: Duration(seconds: 2),
  //         content: Text(e.toString()),
  //       ),
  //     );
  //   }
  // }
  bool onetime = true;

  Future sendOTP() async {
    phnNO = phnController.text;
    SharedPref.phoneNO = phnNO;
    setState(() {
      onetime = false;
    });

    // print("__________________${SharedPref.phoneNO}");
    int min = 1000; //min and max values act as your 6 digit range
    int max = 9999;
    var randomizer = Random();
    var rNum = min + randomizer.nextInt(max - min);
    // print("RANDOM__________NUM__________IS______________$rNum");
    // print("__________________$phnNO");
    randomNum = rNum;

    try {
      final response = await http.post(
          Uri.parse(
              "http://bangladeshsms.com/smsapi?api_key=C20070005f619f9b4a5a13.57431467&type=text&contacts=$phnNO&senderid=8809601000185&msg=আপনার হলি টিউন কোড $randomNum"),
          body: {
            "api_key": "C20070005f619f9b4a5a13.5743147",
            "type": "text",
            "contacts": "8801782084390",
            "senderid": "8809601000185",
            "msg": "fahim vai jindabad",
          });
      // print(response.statusCode);

      if (response.statusCode == 200) {
        print("success");
        String jsonResponseString = response.body;

        print("check_response $jsonResponseString");

        Route route = MaterialPageRoute(
            builder: (c) => OtpPageEmailAndPhn(
                  mobileNo: phnController.text,
                  otp: randomNum.toString(),
                ));
        Navigator.pushReplacement(context, route);
        setState(() {
          onetime = true;
        });
        //        Navigator.pushReplacement(context, route);
        return (jsonDecode(jsonResponseString));
      } else {
        throw Exception('Failed to create. Try Again');
      }
    } catch (e) {
      print(e.toString());
      Scaffold.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 2),
          content: Text(e.toString()),
        ),
      );
    }
  }

  bool load = false;
  void sendEmailOTP() async {
    setState(() {
      load = true;
    });
    EmailAuth.sessionName = "Holy Tune";
    var res = await EmailAuth.sendOtp(receiverMail: emailController.text);
    if (res) {
      print("sent");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('OTP has been sent to your email'),
          duration: Duration(seconds: 5),
        ),
      );

      setState(() {
        load = false;
      });
      Route route = MaterialPageRoute(
          builder: (c) => OtpPageEmailAndPhn(
                email: emailController.text,
                otpStyle: false,
              ));
      Navigator.pushReplacement(context, route);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please check your internet connection or valid email'),
          duration: Duration(seconds: 5),
        ),
      );
      print("not sent");
    }
  }
}
