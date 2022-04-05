import 'package:HolyTune/database/SharedPreference.dart';
import 'package:HolyTune/screens/HomePage.dart';
import 'package:HolyTune/screens/TabBarPage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:HolyTune/auth/RegisterScreen.dart';
import 'package:HolyTune/i18n/strings.g.dart';
import 'package:HolyTune/utils/Alerts.dart';
import 'package:HolyTune/utils/ApiUrl.dart';
import 'package:HolyTune/utils/img.dart';
import 'package:HolyTune/utils/my_colors.dart';
import 'package:HolyTune/widgets/AlertDialogue/alertDialogue.dart';
import 'package:HolyTune/widgets/AlertDialogue/loadingAlertDialogue.dart';
import 'package:HolyTune/widgets/DefaultTextFieldWidget.dart';
import 'package:HolyTune/widgets/customTextField.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import 'OTP_MOBILE/OTPFunc/pages/otp_page.dart';

class Register extends StatefulWidget {
  final String email;
  final String pass;
  final String phnNo;
  bool phnPage;
  Register({this.email, this.pass, this.phnNo, this.phnPage});

  @override
  _RegisterState createState() {
    return _RegisterState();
  }
}

class _RegisterState extends State<Register> {
  bool login = false;
  var json = {
    "email": "mir123@gmail.com", //email,
    "name": "mie",
    "password": "password",
    "dob": "1/2/3",
    "phone": "128108272392",
  };
  String email;
  String phnNum = phnNumOtp;
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  bool isDateSelected = false;
  String birthDateInString = "20/09/1990";
  DateTime birthDate;
  final TextEditingController controller = TextEditingController();
  String initialCountry = 'BD';
  PhoneNumber number = PhoneNumber(isoCode: 'BD');
  final TextEditingController _nameTextEditingController =
      TextEditingController();
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  final TextEditingController _conpasswordTextEditingController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String userImageUrl = "";
  File imageFile;

  // (Uri.parse(ApiUrl.REGISTER),
  // body: jsonEncode());
  Future<void> registerUser(String email, String name, String password,
      String dob, String phone, File image) async {
    Alerts.showProgressDialog(context, t.processingpleasewait);
    try {
      print("WORKING HERE $email");
      print("WORKING HERE bro ${widget.email}");

      final multipart =
          http.MultipartRequest("POST", Uri.parse(ApiUrl.REGISTER));
      //..fields["data"] = jsonEncode(json)
      multipart.fields["email"] = email;
      multipart.fields["name"] = name;
      multipart.fields["password"] = "123456";
      multipart.fields["dob"] = dob;
      multipart.fields["phone"] = SharedPref.phoneNO;

      multipart.files.add(await http.MultipartFile.fromPath(
          'image', imageFile.path,
          contentType: MediaType('photo', image.toString())));
      print("IMAGE*********${imageFile.path}");
      print("IMAGE*********${imageFile.path}");

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
          Alerts.showAuthError(context, t.error, resp["message"]);
        } else if (resp["message"] ==
            "Participant registration process is completed successfully!") {
          String profileName = resp["status"]["name"];
          String profileEmail = resp["status"]["email"];
          String profilePhn = resp["status"]["phone"];
          print("PROFILE__________NAME__________$profileName");

          final phnKey = "profilePhn";
          SharedPref.to.prefss.setString("email", profileEmail);
          SharedPref.profileEmail = profileEmail;
          SharedPref.to.prefss.setString(phnKey, profilePhn);
          SharedPref.profilePhn = profilePhn;
          print("YO____YO_____PHONE____${SharedPref.profilePhn}");
          final nameKey = "profileName";

          SharedPref.to.prefss.setString(nameKey, profileName);
          SharedPref.profileName = profileName;

          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => MyTabHomePage()),
              (Route<dynamic> route) => false);
          String msg = resp["message"];
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(msg),
            duration: const Duration(seconds: 4),
          ));
          final key = "loggedin";

          SharedPref.to.prefss.setBool(key, login);
          SharedPref.loginState = false;
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

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar:
          PreferredSize(child: Container(), preferredSize: Size.fromHeight(0)),
      body: Stack(
        fit: StackFit.passthrough,
        children: [
          Column(
            children: [
              Container(
                height: 20,
              ),
              // Container(
              //   //height: double.infinity,
              //   //width: double.infinity,
              //   alignment: Alignment.topCenter,
              //   child: Container(
              //     height: 100,
              //     child: Image.asset(
              //       Img.get("logotrns.png"),
              //       fit: BoxFit.contain,
              //     ),
              //   ),
              // ),
              // Container(
              //   child: Center(
              //       child: Text(
              //         t.appname,
              //         style: TextStyle(fontSize: 26),
              //       )),
              //   width: double.infinity,
              //   height: 100,
              // ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                  width: double.infinity,
                  height: double.infinity,
                  child: ListView(
                    children: [
                      InkWell(
                        onTap: () {
                          _selectPickImage();
                          print("image pressed");
                        },
                        child: CircleAvatar(
                          radius: _screenWidth * 0.153,
                          backgroundColor: Colors.lightBlue,
                          child: CircleAvatar(
                            radius: _screenWidth * 0.15,
                            backgroundColor: Colors.white,
                            backgroundImage:
                                imageFile == null ? null : FileImage(imageFile),
                            child: imageFile == null
                                ? Icon(
                                    Icons.add_a_photo,
                                    size: _screenWidth * 0.15,
                                    color: Colors.grey,
                                  )
                                : Text(""),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                          child: Text(
                        "Set your profile picture",
                        style: TextStyle(
                          color: Colors.lightBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                      SizedBox(
                        height: 40,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextField(
                              keyboardType: TextInputType.text,
                              controller: nameController,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                isDense: true, // Added this
                                contentPadding: EdgeInsets.all(12),
                                hintText: t.fullname,
                                hintStyle: TextStyle(
                                  color: Colors.grey[800],
                                ),
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
                            // TextField(
                            //   keyboardType: TextInputType.text,
                            //   obscureText: true,
                            //   controller: passwordController,
                            //   style: TextStyle(),
                            //   decoration: InputDecoration(
                            //     labelText: "Password",
                            //     labelStyle: TextStyle(),
                            //     enabledBorder: UnderlineInputBorder(
                            //       borderSide: BorderSide(width: 1),
                            //     ),
                            //     focusedBorder: UnderlineInputBorder(
                            //       borderSide: BorderSide(width: 2),
                            //     ),
                            //   ),
                            // ),
                            // TextField(
                            //   keyboardType: TextInputType.text,
                            //   obscureText: true,
                            //   controller: repeatPasswordController,
                            //   style: TextStyle(),
                            //   decoration: InputDecoration(
                            //     labelText: "Repeat Password",
                            //     labelStyle: TextStyle(),
                            //     enabledBorder: UnderlineInputBorder(
                            //       borderSide: BorderSide(width: 1),
                            //     ),
                            //     focusedBorder: UnderlineInputBorder(
                            //       borderSide: BorderSide(width: 2),
                            //     ),
                            //   ),
                            // ),
                            // DefaultTextField(
                            //   controller: registerProvider.phoneNumber,
                            //   textInputType: TextInputType.number,
                            //   backgroundColor: null,
                            //   borderEnable: false,
                            //   context: context,
                            //   headerTitle: "Phone No",
                            //   prefixWidget: InkWell(
                            //     onTap: () => CountryPickUp.CountryCodePickerDialogWidget(
                            //         context: context,
                            //         selectedCountyCode: (code) {
                            //           print('Selected Country Code $code');
                            //           registerProvider.setCountryCode(code);
                            //         }),
                            //     child: Text(
                            //       "+${registerProvider.countryCode} ",
                            //       style: TextStyle(color: Colors.white),
                            //     ),
                            //   ),
                            // ),
                            SizedBox(
                              height: 20,
                            ),
                            widget.phnPage == false
                                ? InternationalPhoneNumberInput(
                                    onInputChanged: (PhoneNumber number) {
                                      print(number.phoneNumber);
                                    },
                                    onInputValidated: (bool value) {
                                      print(value);
                                    },
                                    selectorConfig: SelectorConfig(
                                      selectorType:
                                          PhoneInputSelectorType.BOTTOM_SHEET,
                                    ),
                                    ignoreBlank: false,
                                    autoValidateMode: AutovalidateMode.disabled,
                                    selectorTextStyle:
                                        TextStyle(color: Colors.black),
                                    initialValue: number,
                                    textFieldController: controller,
                                    formatInput: false,
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            signed: true, decimal: true),
                                    inputDecoration: InputDecoration(
                                      isDense: true, // Added this
                                      contentPadding: EdgeInsets.all(12),
                                      labelText: "1********",

                                      labelStyle: TextStyle(),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.7),
                                        borderSide: BorderSide(
                                            color: Colors.lightBlue,
                                            width: 2.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.7),
                                        borderSide: BorderSide(
                                            color: Colors.lightBlue,
                                            width: 2.0),
                                      ),
                                    ),
                                    // inputBorder: OutlineInputBorder(
                                    //   borderRadius: new BorderRadius.circular(25.7),
                                    //   borderSide: BorderSide(color: Colors.lightBlue, width: 2.0),),
                                    onSaved: (PhoneNumber number) {
                                      print('On Saved: $number');
                                      phnNum = number.toString();
                                    },
                                  )
                                : TextField(
                                    keyboardType: TextInputType.text,
                                    controller: emailController,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      isDense: true, // Added this
                                      contentPadding: EdgeInsets.all(12),
                                      hintText: "Type Your Email",
                                      hintStyle: TextStyle(
                                        color: Colors.grey[800],
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.7),
                                        borderSide: BorderSide(
                                            color: Colors.lightBlue,
                                            width: 2.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.7),
                                        borderSide: BorderSide(
                                            color: Colors.lightBlue,
                                            width: 2.0),
                                      ),
                                    ),
                                  ),

                            SizedBox(
                              height: 30,
                            ),

                            // Text(
                            //   "Select Your Birth Date",
                            //   style: TextStyle(
                            //       fontWeight: FontWeight.bold,
                            //       color: Colors.lightBlue),
                            // ),
                            // SizedBox(
                            //   height: 20,
                            // ),
                            // Container(
                            //   height: 60,
                            //   decoration: BoxDecoration(
                            //     color: MyColors.appColor,
                            //     border: Border.all(
                            //       width: 2,
                            //       color: Colors.lightBlue,
                            //     ),
                            //     borderRadius:
                            //         BorderRadius.all(Radius.circular(20)),
                            //   ),
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.start,
                            //     children: [
                            //       SizedBox(
                            //         width: 20,
                            //       ),
                            //       Text("$birthDateInString"),
                            //       SizedBox(
                            //         width: 160,
                            //       ),
                            //       GestureDetector(
                            //           child: new Icon(Icons.calendar_today),
                            //           onTap: () async {
                            //             final datePick = await showDatePicker(
                            //                 context: context,
                            //                 initialDate: new DateTime.now(),
                            //                 firstDate: new DateTime(1900),
                            //                 lastDate: new DateTime(2100));
                            //             if (datePick != null &&
                            //                 datePick != birthDate) {
                            //               setState(() {
                            //                 birthDate = datePick;
                            //                 isDateSelected = true;

                            //                 // put it here
                            //                 birthDateInString =
                            //                     "${birthDate.month}/${birthDate.day}/${birthDate.year}"; // 08/14/2019
                            //               });
                            //             }
                            //           }),
                            //     ],
                            //   ),
                            // ),

                            // SizedBox(
                            //   height: 30,
                            // ),

                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                // ElevatedButton(
                                //   onPressed: () {
                                //     _formKey.currentState.validate();
                                //   },
                                //   child: Text('Validate'),
                                // ),
                                // ElevatedButton(
                                //   onPressed: () {
                                //     getPhoneNumber('+15417543010');
                                //   },
                                //   child: Text('Update'),
                                // ),
                                // ElevatedButton(
                                //   onPressed: () {
                                //     _formKey.currentState.save();
                                //   },
                                //   child: Text('Save'),
                                // ),

                                // SizedBox(
                                //   height: 50,
                                // ),
                                SizedBox(
                                  width: double.infinity,
                                  height: 45,
                                  child: ElevatedButton(
                                    child: Text(
                                      "Submit",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.lightBlue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(20),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      textStyle: TextStyle(fontSize: 17),
                                    ),
                                    onPressed: () {
                                      _formKey.currentState.save();

                                      String email = widget.phnPage == false
                                          ? widget.email
                                          : emailController.text;

                                      String pass = passwordController.text;
                                      String name = nameController.text;
                                      String dob = birthDateInString;
                                      String phone = phnNum;
                                      File image = imageFile;
                                      String fileName = image.path;
                                      print("File Name : $fileName");

                                      print("$emailController");
                                      print("$pass");
                                      print("$name");
                                      print("$birthDate");
                                      print("$phnNum");

                                      uploadAndSaveImage();
                                      // createFttOrderReport(email, name, pass, dob, phone, image);

                                      String _password = "123456";
                                      String _repeatPassword = "123456";

                                      if (_password == "") {
                                        Alerts.show(context, t.error,
                                            t.emptyfielderrorhint);
                                      } else if (_password != _repeatPassword) {
                                        Alerts.show(context, t.error,
                                            t.passwordsdontmatch);
                                      } else {
                                        registerUser(email, name, pass, dob,
                                            phone, image);
                                        // registerUser(_email, _name, _password);

                                      }

                                      //  Route route =
                                      //  MaterialPageRoute(builder: (c) => HomePage(key: Key("1"),));
                                      // Navigator.pushReplacement(context, route);
                                      // var res = EmailAuth.validate(receiverMail: emailController.text, userOTP: otpController.text);
                                      // if(res){
                                      //   print("email Validated");
                                      //   verifyFormAndSubmit();
                                      // }else{
                                      //   print("email  not Validated");
                                      //
                                      //   ScaffoldMessenger.of(context).showSnackBar(
                                      //     SnackBar(
                                      //       content: Text('Please validate your email first'),
                                      //       duration: Duration(seconds: 2),
                                      //     ),
                                      //   );
                                      // }

                                      //
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _selectPickImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      print("$imageFile");
    });
  }

  Future<void> uploadAndSaveImage() async {
    if (imageFile == null) {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: "Please insert an image",
            );
          });
    } else {
      // _passwordTextEditingController.text ==
      //         _conpasswordTextEditingController.text
      //     ? _emailTextEditingController.text.isNotEmpty &&
      //             _passwordTextEditingController.text.isNotEmpty &&
      //             _conpasswordTextEditingController.text.isNotEmpty &&
      //             _nameTextEditingController.text.isNotEmpty
      //?
      //  uploadToStorage();

      //  :
      // displayDialog("Please fill up the registration form")
      //    : displayDialog("Password do not match");
    }
  }

  displayDialog(String msg) {
    showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(
            message: msg,
          );
        });
  }

  uploadToStorage() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(
            message: "Please wait",
          );
        });
    String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();
  }

  void getPhoneNumber(String phoneNumber) async {
    PhoneNumber number =
        await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'US');

    setState(() {
      this.number = number;
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
