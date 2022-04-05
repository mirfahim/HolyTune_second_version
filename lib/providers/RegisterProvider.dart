// import 'dart:convert';
// import 'dart:ui' as ui;
// import 'package:devicelocale/devicelocale.dart';
// import 'package:flutter/material.dart';
//
// import 'package:provider/provider.dart';
// import '../main.dart';
//
// class RegisterProvider with ChangeNotifier {
//   TextEditingController username = TextEditingController();
//   TextEditingController email = TextEditingController();
//   TextEditingController password = TextEditingController();
//   TextEditingController confirmPassword = TextEditingController();
//   TextEditingController phoneNumber = TextEditingController();
//   var formkey_signin = GlobalKey<FormState>();
//   final GlobalKey<ScaffoldState> scaffoldKey_signUp =
//   GlobalKey<ScaffoldState>();
//   bool obscureText = true, confirmObscure = true;
//   bool Loading = false;
//   BuildContext context;
//   LoadingButtonProvider loadingButtonProvider;
//   LoginProvider loginProvider;
//
//   clearTextFiled() {
//     username.text = "";
//     phoneNumber.text = "";
//     password.text = "";
//     confirmPassword.text = "";
//     email.text = "";
//     confirmPassword.text = "";
//   }
//
//   String countryCode;
//
//   void setView(BuildContext context) async {
//     this.context = context;
//     loadingButtonProvider = Provider.of<LoadingButtonProvider>(context);
//     loginProvider = Provider.of<LoginProvider>(context);
//
//     //print("County Info  :::  ${}");
//   }
//
//   RegisterProvider() {
//     countryCode = '1';
//   }
//
//   void changePasswordVisibility() {
//     obscureText = !obscureText;
//     notifyListeners();
//   }
//
//   void changeConfirmPasswordVisibility() {
//     confirmObscure = !confirmObscure;
//     notifyListeners();
//   }
//
//   bool checkPassword() {
//     if (password.text == confirmPassword.text)
//       return true;
//     else {
//       ErrorMessage(context, message: language.Pass_not_match);
//       return false;
//     }
//   }
//
//   void requestRegister() async {
//     if (checkPassword()) {
//       //Loading = true;
//       setLoadingStatus(isLoading: true);
//
//       Map<String, dynamic> body = {
//         AppConstant.name: username.text,
//         AppConstant.email: email.text,
//         AppConstant.password: password.text,
//         AppConstant.password_confirmation: password.text,
//         AppConstant.mobile: phoneNumber.text
//       };
//
//       Map<String, dynamic> response = await ApiClient.Request(context,
//           url: URL.Show_User, body: body, method: Method.POST);
//
//       print("Registation Response ==> ${response} ");
//
//       print("Registation Test  ${response["error"]}");
//
//       try {
//         if (response["error"] != null) {
//           loadingButtonProvider.setLogInButtonLoadingStatus(false);
//
//           setLoadingStatus(isLoading: false);
//
//           print(
//               "Trying To Login Success ......................................  ${response["data"]["original"]}");
//           ErrorMessage(context,
//               message: (response[AppConstant.data][AppConstant.original])
//                   .toString());
//         } else if (response["success"] != null) {
//           print(
//               "Trying To Login Faild ......................................  ${response}");
//
//           loginProvider.email = email;
//           loginProvider.password = password;
//           loginProvider.requestLogin();
//
//           // loadingButtonProvider.setLogInButtonLoadingStatus(false);
//           setLoadingStatus(isLoading: false);
//
//           //setLoadingStatus(isLoading: false);
//           // showSuccessDialog();
//         } else {
//           try {
//             ErrorMessage(context, message: response[AppConstant.Error]);
//           } catch (e) {
//             ErrorMessage(context, message: language.Something_went_wrong);
//           }
//           // Loading = false;
//           setLoadingStatus(isLoading: false);
//         }
//       } catch (e) {
//         print("Registation Error ${e}");
//         try {
//           ErrorMessage(context, message: response[AppConstant.Error]);
//         } catch (e) {
//           ErrorMessage(context, message: language.Something_went_wrong);
//         }
//         //Loading = false;
//         setLoadingStatus(isLoading: false);
//       }
//       //notifyListeners();
//     } else {
//       loadingButtonProvider.setSignUpButtonLoading(false);
//     }
//   }
//
//   setLoadingStatus({bool isLoading}) {
//     loadingButtonProvider.setSignUpButtonLoading(isLoading);
//   }
//
//   void showSuccessDialog() {
//     showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (_) {
//           return AlertDialog(
//             backgroundColor: Themes.Background,
//             title: Text(
//               language.Success,
//               style: Theme.of(context).textTheme.headline1,
//             ),
//             content: Text(
//               language.Signup_Successful,
//               style: Theme.of(context).textTheme.bodyText1,
//             ),
//             elevation: 10,
//             actions: [
//               FlatButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                   Navigator.of(context).pop();
//                 },
//                 child: Text(
//                   language.OK,
//                   style: TextStyle(
//                       color: Themes.Primary,
//                       fontSize: Dimension.Text_Size_Small,
//                       fontWeight: Dimension.boldText),
//                 ),
//               )
//             ],
//           );
//         });
//   }
//
//   void setCountryCode(String code) {
//     countryCode = code;
//     notifyListeners();
//   }
// }
