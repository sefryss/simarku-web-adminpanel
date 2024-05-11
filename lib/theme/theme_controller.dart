import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'color_scheme.dart';


class ThemeController extends GetxController{

  static String pkgName = "story_";
  static String IS_DARK_MODE = pkgName + "themeMode";

  ThemeMode themeMode = ThemeMode.dark;
  RxBool isDarkTheme = false.obs;

  SharedPreferences? prefs;

  @override
  void onInit() {
    setTheme();
    super.onInit();
  }


  bool checkDarkTheme(){
    return isDarkTheme.value;
  }

  Future<void> setTheme() async {

    prefs = await SharedPreferences.getInstance();
    int i =await prefs!.getInt(IS_DARK_MODE)??ThemeMode.light.index;

    if(i == ThemeMode.light.index){
      themeMode = ThemeMode.light;
    }else{
      themeMode = ThemeMode.dark;
    }

    isDarkTheme.value = (themeMode == ThemeMode.dark);

    update();
  }


  setThemeStatusBar(BuildContext context){

    Future.delayed(Duration(milliseconds: 300),(){ SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          systemNavigationBarColor: getCardColor(context), // navigation bar color
          statusBarColor: getCardColor(context), // sta

          statusBarBrightness: themeController.checkDarkTheme()
              ? Brightness.light
              : Brightness.dark // tus bar color
      ),
    );});



  }

  void changeTheme(BuildContext context) async {
    if (themeMode == ThemeMode.light)
      themeMode = ThemeMode.dark;
    else
      themeMode = ThemeMode.light;
    isDarkTheme.value = themeMode == ThemeMode.dark;
    setThemeStatusBar(context);
    update();


    if (prefs != null) {
      await prefs!.setInt(IS_DARK_MODE, themeMode.index);
    } else {
      prefs = await SharedPreferences.getInstance();
      await prefs!.setInt(IS_DARK_MODE, themeMode.index);
    }


  }
}