import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static SharedPref to = SharedPref();
  initial()async{
    prefss = await SharedPreferences.getInstance();
  }
  SharedPreferences prefss ;
  static String profileEmail;
  static bool loginState ;
  static String profileName = "there";
  static String profilePhn = "";
  static String imageProfile = "";
  static String phoneNO ;
  static bool settingAppbar = false ;
  static String imageURL = "https://adminapplication.com/uploads/thumbnails/" ;
}