import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';


int actionDashBoard=0;
int actionCategories=1;
int dummyActionCategories=-1;
int actionStories=2;
int dummyActionStories=-2;
int actionHomeSlider=3;
int dummyActionHomeSlider=-3;
int actionSendNotification=4;
int actionSettings=5;
int actionAddCategory=6;
int actionEditCategory=7;
int actionEditStory=9;
int actionAddStory=8;
int actionAddSlider=10;
int actionAuthor=11;
int dummyActionAuthor=-11;
int actionAddAuthor=12;
int actionEditAuthor=13;


List<int> mainActionList=[actionCategories,actionStories,actionHomeSlider,actionSendNotification,actionSettings,actionAuthor];
List<int> dummyActionList=[dummyActionCategories,dummyActionStories,dummyActionHomeSlider,dummyActionAuthor];
int dummyAction=-1;


List<int> actionList=[actionAddCategory,actionAddStory,actionAddSlider,actionAddAuthor];


// int dummyActionDashBoard=0;
// int dummyActionCategories=1;
// int dummyActionStories=2;
// int dummyActionHomeSlider=3;
// int dummyActionSendNotification=4;
// int dummyActionSettings=5;
// int dummyActionAddCategory=6;
// int dummyActionEditCategory=7;
// int dummyActionEditStory=9;
// int dummyActionAddStory=8;
// int dummyActionAddSlider=10;

class Constants{




  static String assetPath="assets/images/";
  static String assetSvgPath="assets/svg/";
  static String assetDarkSvgPath="assets/dark/";
  static String fontsFamily="PlusJakartaText";
  static String headerFontsFamily="CormorantGaramond";
  static String serverKey="AAAAtVe8iRk:APA91bEWinHaQGE00vZVTszgQkgAwRnX7bkOG_VzycllzleaRf2v5xr-VUZCzEIOr_A7N0PzNmxurRs_WC_2fpfqvqf7PdQXpcmzYZzcprrVBqJpNpimqN1lYugt-W-rQCwCxP5UijRB";

  static String url="PDF (URL)";
  static String file="Upload Pdf File";
  static String placeImage  = assetPath + "place.png";


  static void exitApp() {
    if (Platform.isIOS) {
      exit(0);
    } else {
      SystemNavigator.pop();
    }
  }

  static pushPage(var className, {Function? function}) {
    Get.toNamed(className)!.then((value) {
      if(function!=null){
        function();
      }
    });
  }

}

