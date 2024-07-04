import 'dart:io';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

int actionDashBoard = 0;
int actionCategories = 1;
int dummyActionCategories = -1;
int actionStories = 2;
int dummyActionStories = -2;
int actionHomeSlider = 3;
int dummyActionHomeSlider = -3;
int actionSendNotification = 4;
int actionSettings = 5;
int actionAddCategory = 6;
int actionEditCategory = 7;
int actionEditStory = 9;
int actionAddStory = 8;
int actionAddSlider = 10;
int actionAuthor = 11;
int dummyActionAuthor = -4;
int actionAddAuthor = 12;
int actionEditAuthor = 13;
int actionGenre = 14;
int actionAddGenre = 15;
int actionEditGenre = 16;
int dummyActionGenre = -5;
int actionUser = 17;
int actionAddUser = 18;
int actionEditUser = 19;
int dummyActionUser = -6;
int actionSekilasInfo = 20;
int actionAddSekilasInfo = 21;
int actionEditSekilasInfo = 22;
int dummyActionSekilasInfo = -7;
int actionKegiatanLiterasi = 23;
int actionAddKegiatanLiterasi = 24;
int actionEditKegiatanLiterasi = 25;
int dummyActionKegiatanLiterasi = -8;
int dummyActionDonationBook = -9;
int actionDonationBook = 27;
int actionAddDonationBook = 28;
int actionEditDonationBook = 29;
int actionFeedback = 30;
int actionEditFeedback = 31;
int dummyActionFeedback = -10;
int actionRating = 32;
int actionEditRating = 33;
int dummyActionRating = -11;
int actionChat = 34;
int actionEditChat = 35;
int dummyActionChat = -12;
int actionDetailChat = 36;
int actionTukarMilik = 37;
int actionEditTukarMilik = 38;
int dummyActionTukarMilik = -13;
int actionTukarPinjam = 39;
int actionEditTukarPinjam = 40;
int dummyActionTukarPinjam = -14;

List<int> mainActionList = [
  actionCategories,
  actionStories,
  actionHomeSlider,
  actionSendNotification,
  actionSettings,
  actionAuthor,
  actionGenre,
  actionUser,
  actionSekilasInfo,
  actionKegiatanLiterasi,
  actionDonationBook,
  actionFeedback,
  actionRating,
  actionChat,
  actionDetailChat,
  actionTukarMilik,
  actionTukarPinjam,
];
List<int> dummyActionList = [
  dummyActionCategories,
  dummyActionStories,
  dummyActionHomeSlider,
  dummyActionAuthor,
  dummyActionGenre,
  dummyActionUser,
  dummyActionSekilasInfo,
  dummyActionKegiatanLiterasi,
  dummyActionDonationBook,
  dummyActionFeedback,
  dummyActionRating,
  dummyActionChat,
  dummyActionTukarMilik,
  dummyActionTukarPinjam,
];
int dummyAction = -1;

List<int> actionList = [
  actionAddCategory,
  actionAddStory,
  actionAddSlider,
  actionAddAuthor,
  actionAddGenre,
  actionAddUser,
  actionAddSekilasInfo,
  actionAddKegiatanLiterasi,
  actionAddDonationBook,
];

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

class Constants {
  static String assetPath = "assets/images/";
  static String assetSvgPath = "assets/svg/";
  static String assetDarkSvgPath = "assets/dark/";
  static String fontsFamily = "PlusJakartaText";
  static String headerFontsFamily = "CormorantGaramond";
  static String serverKey =
      "AAAADC54ZAU:APA91bFIFCf68d9-9DSpCr2H_YSCOwEnggt3Z-mBQMgAKCbwLraGAFvjfctM4U6x97qVoY-ORbyYeH5yIcEdi6QVuTr1ewOeWrUHqHitToi6_-DFpb0oFj7mX9Zosf8712l4r-U-6Q_n";

  static String physichBook = "Buku Fisik";
  static String file = "E-Book";
  static String placeImage = assetPath + "place.png";

  static void exitApp() {
    if (Platform.isIOS) {
      exit(0);
    } else {
      SystemNavigator.pop();
    }
  }

  static pushPage(var className, {Function? function}) {
    Get.toNamed(className)!.then((value) {
      if (function != null) {
        function();
      }
    });
  }
}
