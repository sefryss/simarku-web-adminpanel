


import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ui/common/common.dart';

class PrefData {
  static String pkgName = "story_admin_panel";
  static String login = pkgName + "login";
  static String keyIsAccess = pkgName + "access";
  static String keyLoginId = pkgName + "loginId";
  static String keyAction = pkgName + "action";



  static setLogin(bool s,String id,bool isAccess) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(login, s);
    prefs.setString(keyLoginId, id);
    prefs.setBool(keyIsAccess, isAccess);
  }


  static Future checkAccess({required BuildContext context,required Function function}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isAccess= prefs.getBool(keyIsAccess) ?? false;
    if(isAccess){
      function();
    }else{
      showCustomToast(message: "You are demo user..",context: context);
    }
  }

  static getLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // String id = prefs.getString(keyLoginId) ?? "";

    return prefs.getBool(login) ?? false;
  }

  static getLoginId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String id = prefs.getString(keyLoginId) ?? "";

    return id;
  }


  static Future<int> getAction() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(keyAction) ?? 0;
  }

  static setAction(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(keyAction, value);
  }

}
