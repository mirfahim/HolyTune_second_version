import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:HolyTune/auth/OTP_MOBILE/OTPFunc/stores/login_store.dart';
import 'package:HolyTune/auth/OTP_MOBILE/OTPFunc/widgets/loader_hud.dart';
import 'package:HolyTune/providers/AppStateNotifier.dart';
import 'package:HolyTune/utils/TextStyles.dart';
import 'package:HolyTune/utils/img.dart';

import '../theme.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AppStateNotifier appState;
  TextEditingController phoneController = TextEditingController();
  String initialCountry = 'BD';
  PhoneNumber number = PhoneNumber(isoCode: 'BD');
  String phnNum;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginStore>(
      builder: (_, loginStore, __) {
        return Observer(
          builder: (_) => LoaderHUD(
            inAsyncCall: loginStore.isLoginLoading,
            child: Scaffold(
              backgroundColor: Colors.white,
              key: loginStore.loginScaffoldKey,
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                child: Stack(
                                  children: <Widget>[
                                    Center(
                                      child: Container(
                                        height: 240,
                                        constraints: const BoxConstraints(
                                          maxWidth: 500
                                        ),
                                        margin: const EdgeInsets.only(top: 100),
                                        decoration: const BoxDecoration(color: Colors.white,
                                            borderRadius: BorderRadius.all(Radius.circular(30))),
                                      ),
                                    ),
                                    Center(
                                      child: Container(
                                          constraints: const BoxConstraints(maxHeight: 340),
                                           margin: const EdgeInsets.symmetric(horizontal: 8),
                                          child: Image.asset('assets/images/login.png')),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 10),
                                  child: RichText(
                                    textAlign: TextAlign.start,
                                    text: TextSpan(
                                        text: 'Holy',
                                        style: TextStyles.caption(context).copyWith(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xffe46b10),
                                        ),
                                        children: [
                                          TextSpan(
                                            text: 'Tune',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 30),
                                          ),
                                        ]),
                                  ),),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: <Widget>[
                              Container(
                                  constraints: const BoxConstraints(
                                      maxWidth: 500
                                  ),
                                  margin: const EdgeInsets.symmetric(horizontal: 10),
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(children: <TextSpan>[
                                      TextSpan(text: 'We will send you an ', style: TextStyle(color: Colors.black)),
                                      TextSpan(
                                          text: 'One Time Password ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                      TextSpan(text: 'on this mobile number. ', style: TextStyle(color: Colors.white)),
                                      TextSpan(text: 'Put phone no with country code', style: TextStyle(color: Colors.white)),
                                    ]),
                                  )),
                              Container(
                                height: 40,
                                constraints: const BoxConstraints(
                                  maxWidth: 500
                                ),
                                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                child: CupertinoTextField(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.all(Radius.circular(4))
                                  ),
                                  controller: phoneController,
                                  clearButtonMode: OverlayVisibilityMode.editing,
                                  keyboardType: TextInputType.phone,
                                  maxLines: 1,
                                  placeholder: '+8801xxxxxxxxx',
                                ),
                              ),
                              // Form(
                              //   child: Container(
                              //     margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              //     constraints: const BoxConstraints(
                              //         maxWidth: 500
                              //     ),
                              //     child: InternationalPhoneNumberInput(
                              //       onInputChanged: (PhoneNumber number) {
                              //         print(number.phoneNumber);
                              //       },
                              //       onInputValidated: (bool value) {
                              //         print(value);
                              //       },
                              //       selectorConfig: SelectorConfig(
                              //         selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                              //       ),
                              //       ignoreBlank: false,
                              //       autoValidateMode: AutovalidateMode.disabled,
                              //       selectorTextStyle: TextStyle(color: Colors.black),
                              //       initialValue: number,
                              //       textFieldController: phoneController,
                              //       formatInput: false,
                              //       keyboardType: TextInputType.numberWithOptions(
                              //           signed: true, decimal: true),
                              //       inputBorder: OutlineInputBorder(),
                              //       onSaved: (PhoneNumber number) {
                              //
                              //         print('On Saved: $number');
                              //         phnNum = number.toString();
                              //       },
                              //     ),
                              //   ),
                              // ),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                constraints: const BoxConstraints(
                                    maxWidth: 500
                                ),
                                child: RaisedButton(
                                  onPressed: () {

                                 //   print("$phnNum");
                                    if (phoneController.text.isNotEmpty) {
                                    //  loginStore.loginScaffoldKey.currentState.save();
                                      loginStore.getCodeWithPhoneNumber(context, phoneController.text.toString());
                                    } else {
                                      loginStore.loginScaffoldKey.currentState.showSnackBar(SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.red,
                                        content: Text(
                                          'Please enter a phone number',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ));
                                    }
                                  },
                                  color: MyColors.primaryColor,
                                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          'Next',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(Radius.circular(20)),
                                            color: Colors.white,
                                          ),
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.orange,
                                            size: 16,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
