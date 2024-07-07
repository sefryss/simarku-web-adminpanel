import 'dart:developer';

import 'package:ebookadminpanel/controller/chat_controller.dart';
import 'package:ebookadminpanel/controller/donation_book_controller.dart';
import 'package:ebookadminpanel/controller/genre_controller.dart';
import 'package:ebookadminpanel/controller/kegiatan_literasi_controller.dart';
import 'package:ebookadminpanel/controller/sekilas_ilmu_controller.dart';
import 'package:ebookadminpanel/controller/story_controller.dart';
import 'package:ebookadminpanel/model/user_model.dart';
import 'package:ebookadminpanel/ui/chat/subwidget/chat_web_widget.dart';
import 'package:ebookadminpanel/ui/donation_book/addDonationBook/add_donation_book_screen.dart';
import 'package:ebookadminpanel/ui/donation_book/donation_book_screen.dart';
import 'package:ebookadminpanel/ui/feedback/addFeedback/add_feedback_screen.dart';
import 'package:ebookadminpanel/ui/feedback/feedback_screen.dart';
import 'package:ebookadminpanel/ui/genre/addGenre/add_genre_screen.dart';
import 'package:ebookadminpanel/ui/genre/genre_screen.dart';
import 'package:ebookadminpanel/ui/kegiatan_literasi/addKegiatanLiterasi/add_kegiatan_literasi_screen.dart';
import 'package:ebookadminpanel/ui/kegiatan_literasi/kegiatan_literasi_screen.dart';
import 'package:ebookadminpanel/ui/rating/addRating/add_rating_screen.dart';
import 'package:ebookadminpanel/ui/rating/rating_screen.dart';
import 'package:ebookadminpanel/ui/sekilas_info/addSekilasInfo/add_sekilas_info_screen.dart';
import 'package:ebookadminpanel/ui/sekilas_info/sekilas_info_screen.dart';
import 'package:ebookadminpanel/ui/tukar_milik/detail_tukar_milik/detail_tukar_milik.dart';
import 'package:ebookadminpanel/ui/tukar_milik/tukar_milik_screen.dart';
import 'package:ebookadminpanel/ui/tukar_pinjam/detail_tukar_pinjam/detail_tukar_pinjam.dart';
import 'package:ebookadminpanel/ui/tukar_pinjam/tukar_pinjam_screen.dart';
import 'package:ebookadminpanel/ui/user/detail_user/detail_user.dart';
import 'package:ebookadminpanel/ui/user/user_screen.dart';
import 'package:ebookadminpanel/util/common_blank_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ebookadminpanel/controller/home_controller.dart';
import 'package:ebookadminpanel/main.dart';
import 'package:ebookadminpanel/ui/common/common.dart';
import 'package:ebookadminpanel/ui/dashboard/dashboard_screen.dart';
import 'package:ebookadminpanel/ui/home/sidemenu/side_menu.dart';
import 'package:ebookadminpanel/ui/homeslider/addSlider/add_slider_screen.dart';
import 'package:ebookadminpanel/ui/setting/setting_screen.dart';
import '../../controller/data/FirebaseData.dart';
import '../../controller/data/LoginData.dart';
import '../../theme/app_theme.dart';
import '../../theme/color_scheme.dart';
import '../../util/constants.dart';
import '../../util/pref_data.dart';
import '../../util/responsive.dart';
import '../book/addBook/add_book_screen.dart';
import '../book/book_screen.dart';
import '../homeslider/home_slider_screen.dart';
import '../notification/send_notification.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePage();
  }
}

class _HomePage extends State<HomePage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  HomeController homeController = Get.put(HomeController());

  UserModel? currentUser;

  @override
  void initState() {
    super.initState();

    fetchCurrentUser();

    LoginData.getDeviceId();
    SystemChannels.lifecycle.setMessageHandler((message) {
      log('Message: $message');

      if (ChatController.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          ChatController.updateActiveStatus(true);
        }
        if (message.toString().contains('hidden')) {
          ChatController.updateActiveStatus(false);
        }
      }

      return Future.value(message);
    });
  }

  Future<void> fetchCurrentUser() async {
    try {
      UserModel user = await UserModel.fetchCurrentUser();
      setState(() {
        currentUser = user;
      });
    } catch (e) {
      print('Error fetching current user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    LoginData.getDeviceId();
    setScreenSize(context);

    themeController.setThemeStatusBar(context);
    return WillPopScope(
        child: CommonPage(
            widget: Container(
          child: Scaffold(
            key: _key,
            drawer: Responsive.isDesktop(context)
                ? null
                : SideMenu(function: (value) {
                    print("value------${value}");
                    changeAction(value);

                    _key.currentState!.openEndDrawer();
                  }),
            backgroundColor: getBackgroundColor(context),
            appBar: AppBar(
              backgroundColor: getCardColor(context),
              title: getMaxLineFont(
                  context, 'Simarku', 85, getPrimaryColor(context), 1,
                  customFont: Constants.headerFontsFamily,
                  fontWeight: FontWeight.w900),
              systemOverlayStyle: getBrightnessLight(),
              elevation: 0,
              toolbarHeight: 70.h,
              leading: Responsive.isDesktop(context)
                  ? Container(
                      width: 0,
                    )
                  : IconButton(
                      icon: Icon(
                        Icons.sort_sharp,
                        color: getPrimaryColor(context),
                      ),
                      onPressed: () => _key.currentState!.openDrawer(),
                    ),
              leadingWidth: Responsive.isDesktop(context) ? 0 : 100.w,
              actions: [
                Container(
                  decoration: getDefaultDecoration(
                      borderColor: getBorderColor(context),
                      borderWidth: 0.5,
                      radius: getResizeRadius(context, 40)),
                  margin: EdgeInsets.symmetric(
                    vertical: 15.h,
                  ),
                  child: Row(
                    children: [
                      imageSvg('dark_mode.svg',
                          height: 20.h,
                          width: 20.h,
                          color: themeController.checkDarkTheme()
                              ? getPrimaryColor(context)
                              : getSubFontColor(context), onTap: () {
                        if (!themeController.checkDarkTheme()) {
                          themeController.changeTheme(context);
                        }
                      }),
                      Container(
                        height: 20.h,
                        color: getBorderColor(context),
                        width: 0.5,
                        margin: EdgeInsets.symmetric(horizontal: 15.h),
                      ),
                      imageSvg('light_mode.svg',
                          height: 20.h,
                          width: 20.h,
                          color: themeController.checkDarkTheme()
                              ? getSubFontColor(context)
                              : getPrimaryColor(context), onTap: () {
                        if (themeController.checkDarkTheme()) {
                          themeController.changeTheme(context);
                        }
                      }),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15.h),
                ),
                GestureDetector(
                  onTap: () {
                    _showPopupMenu();
                  },
                  child: Container(
                          alignment: Alignment.center,
                          child: currentUser != null &&
                                  currentUser!.profilePicture.isNotEmpty
                              ? Container(
                                  width: 40.h,
                                  height: 40.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: getPrimaryColor(context),
                                        width: 2.0),
                                  ),
                                  child: ClipOval(
                                    child: Image.network(
                                      currentUser!.profilePicture,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : imageAsset(
                                  themeController.checkDarkTheme()
                                      ? 'profile_dark.png'
                                      : 'profile.png',
                                  height: 40.h,
                                  width: 40.h,
                                ))
                      .marginSymmetric(horizontal: 20.h),
                )
              ],
            ),
            body: SafeArea(
              child: Container(
                child: Row(
                  children: [
                    Responsive.isDesktop(context)
                        ? SideMenu(
                            function: (value) {
                              _key.currentState!.openEndDrawer();
                              changeAction(value);
                            },
                          )
                        : Container(),
                    Expanded(
                        child: Container(
                      color: getBackgroundColor(context),
                      // child:  getTabWidget(),
                      child: Obx(() => getTabWidget()),
                    ))
                  ],
                ),
              ),
            ),
          ),
        )),
        onWillPop: () async {
          onBackClick();
          return false;
        });
  }

  onBackClick() {
    int action = selectedAction.value;
    if (action != actionDashBoard) {
      if (mainActionList.contains(action)) {
        changeAction(actionDashBoard);
      } else {
        print("action---${oldAction}");
        changeAction(oldAction);
      }
    } else {
      Constants.exitApp();
    }
  }

  getTabWidget() {
    int action = selectedAction.value;

    print("action----${action}");

    if (dummyActionList.contains(action)) {
      action = lastAction;
    }

    print("action---111-${action}");

    // if (action == actionCategories) {
    //   PrefData.setAction(actionCategories);
    //   return CategoryScreen(function: () {
    //     changeAction(actionAddCategory);
    //   });
    // } else if (action == actionAddCategory) {
    //   PrefData.setAction(actionAddCategory);

    //   CategoryController categoryController = Get.put(CategoryController());

    //   categoryController.clearData();

    //   return AddCategoryScreen(function: () {
    //     onBackClick();
    //   });
    // } else if (action == actionEditCategory) {
    //   PrefData.setAction(actionEditCategory);

    //   categoryController.categoryModel = homeController.categoryModel;

    //   categoryController.setAllCategoryDate(homeController.categoryModel);

    //   return AddCategoryScreen(
    //     function: () {
    //       onBackClick();
    //     },
    //     categoryModel: homeController.categoryModel,
    //   );
    // } else
    // if (action == actionAuthor) {
    //   PrefData.setAction(actionAuthor);
    //   authorController.clearAuthData();

    //   return AuthorScreen(
    //     function: () {
    //       onBackClick();
    //       changeAction(actionAddAuthor);
    //     },
    //   );
    // } else if (action == actionAddAuthor) {
    //   PrefData.setAction(actionAddAuthor);

    //   AuthorController authorController = Get.put(AuthorController());

    //   authorController.clearAuthData();

    //   return AddAuthorScreen(
    //     function: () {
    //       onBackClick();
    //       changeAction(actionAuthor);
    //     },
    //   );
    // } else if (action == actionEditAuthor) {
    //   PrefData.setAction(actionEditAuthor);

    //   authorController.authorModel = homeController.authorModel;

    //   if (authorController.isStatus) {
    //     authorController.setAllDataFromAuthorModel(
    //         homeController.authorModel, false);
    //   }

    //   return AddAuthorScreen(
    //     function: () {
    //       onBackClick();
    //       changeAction(actionAuthor);
    //     },
    //     authorModel: homeController.authorModel,
    //   );
    // } else

    if (action == actionGenre) {
      PrefData.setAction(actionGenre);
      genreController.clearGenreData();

      return GenreScreen(
        function: () {
          onBackClick();
          changeAction(actionAddGenre);
        },
      );
    } else if (action == actionAddGenre) {
      PrefData.setAction(actionAddGenre);

      GenreController genreController = Get.put(GenreController());

      genreController.clearGenreData();

      return AddGenreScreen(
        function: () {
          onBackClick();
          changeAction(actionGenre);
        },
      );
    } else if (action == actionEditGenre) {
      PrefData.setAction(actionEditGenre);

      genreController.genreModel = homeController.genreModel;

      if (genreController.isStatus) {
        genreController.setAllDataFromGenreModel(
            homeController.genreModel, false);
      }

      return AddGenreScreen(
        function: () {
          onBackClick();
          changeAction(actionGenre);
        },
        genreModel: homeController.genreModel,
      );
    } else if (action == actionStories) {
      PrefData.setAction(actionStories);

      storyController.clearStoryData();
      return StoryScreen(
        function: () {
          changeAction(actionAddStory);
          // onBackClick();
        },
      );
    } else if (action == actionAddStory) {
      PrefData.setAction(actionAddStory);

      StoryController storyController = Get.put(StoryController());

      storyController.clearStoryData();

      return AddStoryScreen(
        function: () {
          onBackClick();
          homeController.fetchStoryData();
          changeAction(actionStories);
        },
      );
    } else if (action == actionEditStory) {
      PrefData.setAction(actionEditStory);

      storyController.homeController = homeController;
      storyController.storyModel = homeController.storyModel;

      // if(!storyController.isBack.value){

      storyController.setAllDataFromStoryModel(
          homeController.storyModel, homeController);

      // }
      return AddStoryScreen(
        function: () {
          onBackClick();
          changeAction(actionStories);
        },
        storyModel: homeController.storyModel,
      );
    } else if (action == actionDonationBook) {
      PrefData.setAction(actionDonationBook);

      donationBookController.clearStoryData();
      return DonasiBookScreen(
        function: () {
          changeAction(actionAddDonationBook);
          // onBackClick();
        },
      );
    } else if (action == actionAddDonationBook) {
      PrefData.setAction(actionAddDonationBook);

      DonationBookController donationBookController =
          Get.put(DonationBookController());

      donationBookController.clearStoryData();

      return AddDonationBookScreen(
        function: () {
          onBackClick();
          homeController.fetchDonationBook();
          changeAction(actionDonationBook);
        },
      );
    } else if (action == actionEditDonationBook) {
      PrefData.setAction(actionEditDonationBook);

      donationBookController.homeController = homeController;
      donationBookController.storyModel = homeController.donationBookModel;

      // if(!donationBookController.isBack.value){

      donationBookController.setAllDataFromStoryModel(
          homeController.donationBookModel, homeController);

      // }
      return AddDonationBookScreen(
        function: () {
          onBackClick();
          changeAction(actionDonationBook);
        },
        donationBookModel: homeController.donationBookModel,
      );
    } else if (action == actionFeedback) {
      PrefData.setAction(actionFeedback);

      return FeedbackScreen(
        function: () {
          // changeAction(actionAddDonationBook);
          // onBackClick();
        },
      );
    } else if (action == actionEditFeedback) {
      PrefData.setAction(actionEditFeedback);

      feedbackController.homeController = homeController;
      feedbackController.feedbackModel = homeController.feedbackModel;

      // if(!feedbackController.isBack.value){

      feedbackController
          .setAllDataFromFeedbackModel(homeController.feedbackModel);

      // }
      return AddFeedbackScreen(
        function: () {
          onBackClick();
          changeAction(actionFeedback);
        },
        feedbackModel: homeController.feedbackModel,
      );
    } else if (action == actionRating) {
      PrefData.setAction(actionRating);

      return RatingScreen(
        function: () {
          // changeAction(actionAddDonationBook);
          // onBackClick();
        },
      );
    } else if (action == actionEditRating) {
      PrefData.setAction(actionEditRating);

      ratingController.homeController = homeController;
      ratingController.rateUsModel = homeController.rateUsModel;

      // if(!ratingController.isBack.value){

      ratingController.setAllDataFromRatingModel(homeController.rateUsModel);

      // }
      return AddRatingScreen(
        function: () {
          onBackClick();
          changeAction(actionRating);
        },
        rateUsModel: homeController.rateUsModel,
      );
    } else if (action == actionKegiatanLiterasi) {
      PrefData.setAction(actionKegiatanLiterasi);
      kegiatanLiterasiController.clearKegiatanLiterasiData();

      return KegiatanLiterasiScreen(
        function: () {
          onBackClick();
          changeAction(actionAddKegiatanLiterasi);
        },
      );
    } else if (action == actionAddKegiatanLiterasi) {
      PrefData.setAction(actionAddKegiatanLiterasi);

      KegiatanLiterasiController kegiatanLiterasiController =
          Get.put(KegiatanLiterasiController());

      kegiatanLiterasiController.clearKegiatanLiterasiData();

      return AddKegiatanLiterasiScreen(
        function: () {
          onBackClick();
          changeAction(actionKegiatanLiterasi);
        },
      );
    } else if (action == actionEditKegiatanLiterasi) {
      PrefData.setAction(actionEditKegiatanLiterasi);

      kegiatanLiterasiController.kegiatanLiterasiModel =
          homeController.kegiatanLiterasiModel;

      kegiatanLiterasiController.kegiatanLiterasiModel =
          homeController.kegiatanLiterasiModel;

      kegiatanLiterasiController
          .setAllKegiatanLiterasi(homeController.kegiatanLiterasiModel);

      return AddKegiatanLiterasiScreen(
        function: () {
          onBackClick();
          changeAction(actionKegiatanLiterasi);
        },
        kegiatanLiterasiModel: homeController.kegiatanLiterasiModel,
      );
    } else if (action == actionSekilasInfo) {
      PrefData.setAction(actionSekilasInfo);
      sekilasInfoController.clearSekilasInfoData();

      return SekilasInfoScreen(
        function: () {
          onBackClick();
          changeAction(actionAddSekilasInfo);
        },
      );
    } else if (action == actionAddSekilasInfo) {
      PrefData.setAction(actionAddSekilasInfo);

      SekilasInfoController sekilasInfoController =
          Get.put(SekilasInfoController());

      sekilasInfoController.clearSekilasInfoData();

      return AddSekilasInfoScreen(
        function: () {
          onBackClick();
          changeAction(actionSekilasInfo);
        },
      );
    } else if (action == actionEditSekilasInfo) {
      PrefData.setAction(actionEditSekilasInfo);

      sekilasInfoController.sekilasInfoModel = homeController.sekilasInfoModel;

      sekilasInfoController.sekilasInfoModel = homeController.sekilasInfoModel;

      sekilasInfoController.setAllSekilasInfo(homeController.sekilasInfoModel);

      return AddSekilasInfoScreen(
        function: () {
          onBackClick();
          changeAction(actionSekilasInfo);
        },
        sekilasInfoModel: homeController.sekilasInfoModel,
      );
    } else if (action == actionChat) {
      PrefData.setAction(actionChat);

      return ChatWebWidget();
    } else if (action == actionTukarMilik) {
      PrefData.setAction(actionTukarMilik);

      // donationBookController.clearStoryData();
      return TukarMilikScreen(
        function: () {
          // changeAction(actionAddTukarMilik);
          // onBackClick();
        },
      );
    } else if (action == actionEditTukarMilik) {
      PrefData.setAction(actionEditTukarMilik);

      tukarMilikController.homeController = homeController;
      tukarMilikController.tukarMilikModel = homeController.tukarMilikModel;

      // if(!tukarMilikController.isBack.value){

      tukarMilikController.setAllDataFromTukarMilikModel(
          homeController.tukarMilikModel, homeController);

      // }
      return DetailTukarMilik(
        function: () {
          onBackClick();
          changeAction(actionTukarMilik);
        },
        tukarMilikModel: homeController.tukarMilikModel,
      );
    } 
    
    else if (action == actionTukarPinjam) {
      PrefData.setAction(actionTukarPinjam);

      // donationBookController.clearStoryData();
      return TukarPinjamScreen(
        function: () {
          // changeAction(actionAddTukarMilik);
          // onBackClick();
        },
      );
    } else if (action == actionEditTukarPinjam) {
      PrefData.setAction(actionEditTukarPinjam);

      tukarPinjamController.homeController = homeController;
      tukarPinjamController.tukarPinjamModel = homeController.tukarPinjamModel;

      // if(!tukarPinjamController.isBack.value){

      tukarPinjamController.setAllDataFromTukarPinjamModel(
          homeController.tukarPinjamModel, homeController);

      // }
      return DetailTukarPinjam(
        function: () {
          onBackClick();
          changeAction(actionTukarPinjam);
        },
        tukarPinjamModel: homeController.tukarPinjamModel,
      );
    }

       else if (action == actionUser) {
      PrefData.setAction(actionUser);

      // donationBookController.clearStoryData();
      return UserScreen(
        function: () {
          // changeAction(actionAddTukarMilik);
          // onBackClick();
        },
      );
    } else if (action == actionEditUser) {
      PrefData.setAction(actionEditUser);

      userController.homeController = homeController;
      userController.userModel = homeController.userModel;

      // if(!userController.isBack.value){

      userController.setAllDataFromUserModel(
          homeController.userModel, homeController);

      // }
      return DetailUser(
        function: () {
          onBackClick();
          changeAction(actionUser);
        },
        userModel: homeController.userModel,
      );
    }
    // else if (action == actionDetailChat) {
    //   PrefData.setAction(actionDetailChat);
    //   return DetailChatScreen(
    //       // function: () {
    //       //   changeAction(actionAddSlider);
    //       // },
    //       );
    // }

    else if (action == actionHomeSlider) {
      PrefData.setAction(actionHomeSlider);
      return HomeSliderScreen(
        function: () {
          changeAction(actionAddSlider);
        },
      );
    } else if (action == actionSendNotification) {
      PrefData.setAction(actionSendNotification);
      return SendNotification(
        function: () {
          changeAction(actionAddSlider);
        },
      );
    } else if (action == actionAddSlider) {
      PrefData.setAction(actionAddSlider);
      return AddSliderScreen(
        function: () {
          onBackClick();
        },
      );
    } else if (action == actionStories) {
      PrefData.setAction(actionStories);
      return StoryScreen(function: () {
        if (homeController.categoryList.length > 0) {
          changeAction(actionAddStory);
        } else {
          showCustomToast(context: context, message: 'No category found');
        }
      });
    } else if (action == actionSettings) {
      PrefData.setAction(actionSettings);
      return SettingScreen(function: () {});
    } else if (action == actionDashBoard) {
      PrefData.setAction(actionDashBoard);
      return DashboardScreen(function: () {});
    }
  }

  void _showPopupMenu() async {
    double width = isWeb(context) ? 120.w : 150.h;

    double right = isWeb(context) ? 50.h : 15.h;

    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(50.w, 50.h, right, 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.r)),
      color: getCardColor(context),
      items: [
        // PopupMenuItem<String>(
        //     child: Container(
        //       width: width,
        //       child: DrawerListTile(
        //         title: "Edit Profile",
        //         iconData: Icons.account_circle_sharp,
        //         space: 0,
        //         press: () {
        //           // onTap(profilePage);
        //           Navigator.of(context).pop();
        //         },
        //       ),
        //     ),
        //     value: 'Edit Profile'),
        // PopupMenuItem<String>(
        //     child: Container(
        //       width: width,
        //       child: DrawerListTile(
        //         title: "Нәтиже",
        //         iconData: Icons.account_circle_sharp,
        //         space: 0,
        //         press: () {
        //           // onTap(reportPage);
        //           Navigator.of(context).pop();
        //         },
        //       ),
        //     ),
        //     value: 'Нәтиже'),
        // PopupMenuItem<String>(
        //     child: Container(
        //       width: width,
        //       child: DrawerListTile(
        //         title: "Жарық",
        //         iconData: Icons.account_circle_sharp,
        //         space: 0,
        //         child: SizedBox(
        //           width: 35.w,
        //           height: 31.h,
        //           child: FittedBox(
        //             fit: BoxFit.fill,
        //             child: Obx(() =>
        //                 CupertinoSwitch(
        //                   value: !themeController.checkDarkTheme(),
        //                   onChanged: (value) {
        //                     themeController.changeTheme(context);
        //                     Navigator.of(context).pop();
        //                   },
        //                   thumbColor: Colors.white,
        //                   activeColor: getPrimaryColor(context),
        //                 )),
        //           ),
        //         ),
        //         press: () {},
        //       ),
        //     ),
        //     value: 'Жарық'),

        // PopupMenuItem<String>(
        //     child: Container(
        //       width: width,
        //       child: DrawerListTile(
        //         title: "Change Password",
        //         iconData: Icons.account_circle_sharp,
        //         space: 0,
        //         press: () {
        //
        //           PrefData.checkAccess(context: context, function: (){
        //
        //             showChangePasswordDialog(context).then((value){
        //
        //               Navigator.of(context)
        //                   .pop();
        //`
        //             });
        //
        //           });
        //         },
        //       ),
        //     ),
        //     value: 'Change Password'),

        PopupMenuItem<String>(
            child: Container(
              width: width,
              child: DrawerListTile(
                title: "Keluar",
                iconData: Icons.account_circle_sharp,
                space: 0,
                color: Colors.red,
                visibility: false,
                press: () {
                  // onTap(homePage);

                  // getCommonDialog(
                  //     context: context,
                  //     subTitle: "Log Out",
                  //     title: "Are you sure want to Log out ?",
                  //     function: () {
                  //       LoginData.sendLoginPage();
                  //     });

                  showDialog<void>(
                    context: context,
                    barrierDismissible: false,
                    // false = user must tap button, true = tap outside dialog
                    builder: (BuildContext dialogContext) {
                      return AlertDialog(
                        title: getCustomFont(
                            "Keluar",
                            getResizeFont(context, 70),
                            getFontColor(context),
                            1,
                            fontWeight: FontWeight.w600),
                        content: getCustomFont(
                            "Apakah anda yakin ingin keluar?",
                            getResizeFont(context, 50),
                            getFontColor(context),
                            1),
                        actions: <Widget>[
                          TextButton(
                            child: getCustomFont(
                                "Ya",
                                getResizeFont(context, 50),
                                getPrimaryColor(context),
                                1,
                                fontWeight: FontWeight.w500),
                            onPressed: () {
                              Navigator.of(dialogContext).pop();

                              LoginData.sendLoginPage();
                            },
                          ),
                          TextButton(
                            child: getCustomFont(
                                "Tidak",
                                getResizeFont(context, 50),
                                getPrimaryColor(context),
                                1,
                                fontWeight: FontWeight.w500),
                            onPressed: () {
                              Navigator.of(dialogContext).pop();

                              Navigator.of(dialogContext).pop();

                              // Dismiss alert dialog
                            },
                          ),
                        ],
                      );
                    },
                  );

                  // LoginData.sendLoginPage();

                  // loginController.logout();
                  // Get.toNamed(KeyUtil.loginWidget);
                },
              ),
            ),
            value: 'Keluar'),
      ],
      elevation: 1.0,
    );
  }

  Future<void> showChangePasswordDialog(BuildContext context) async {
    TextEditingController _textFieldController = TextEditingController();
    TextEditingController _textFieldController1 = TextEditingController();
    // print("res===${res.Responsive.isSmallDesktop(context)}====${res.Responsive.isDesktop(context)}");
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            // getTextWidget(context, 'NO', 50, getPrimaryColor(context),
            //   fontWeight: FontWeight.w500,),
            title: getTextWidget(
                context, 'Change Password', 70, getFontColor(context)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            backgroundColor: getBackgroundColor(context),

            contentPadding: EdgeInsets.zero,

            content: Container(
              padding: EdgeInsets.symmetric(horizontal: 25.h, vertical: 15.h),
              width:
                  Responsive.isDesktop(context) || Responsive.isDesktop(context)
                      ? 450.h
                      : double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: getTextWidget(context, 'Change Password', 0,
                            getFontColor(context)),
                      ),
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Icon(
                          Icons.close,
                          size: 20.h,
                          color: getFontColor(context),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  Text(
                    'New Password',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  getTextFiledWidget(
                    context,
                    "New Password",
                    _textFieldController,
                  ),
                  SizedBox(
                    height: 18.h,
                  ),
                  Text(
                    'Confirm Password',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  getTextFiledWidget(
                    context,
                    "Confirm Password",
                    _textFieldController1,
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  InkWell(
                    onTap: () {
                      String password1 = _textFieldController.text;
                      String password2 = _textFieldController1.text;
                      if (isNotEmpty(password1) && isNotEmpty(password2)) {
                        if (password1.length >= 6) {
                          if (password1 == password2) {
                            FirebaseData.changePassword(
                                password: password1,
                                function: () {
                                  Get.back();
                                },
                                context: context);
                          } else {
                            showCustomToast(
                                context: context,
                                message: "Password does not match");
                          }
                        } else {
                          showCustomToast(
                              context: context,
                              message:
                                  "You must have 6 characters in your password");
                        }
                      } else {
                        showCustomToast(
                            context: context, message: "Fill Detail..");
                      }
                    },
                    child: Container(
                      height: 55,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10.r)),
                          color: primaryColor),
                      child: Center(
                          child: getTextWidget(
                              context, "Update", 35, Colors.white,
                              fontWeight: FontWeight.w400)),
                    ),
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                ],
              ),
            ),
          );
        });
  }
}

int oldAction = actionDashBoard;
int lastAction = actionDashBoard;

changeAction(int action) {
  oldAction = selectedAction.value;

  if (!dummyActionList.contains(oldAction)) {
    lastAction = oldAction;
  }

  selectedAction(action);
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.iconData,
    required this.press,
    this.visibility,
    this.color,
    this.space,
    this.child,
  }) : super(key: key);

  final String title;
  final IconData iconData;
  final VoidCallback press;
  final Color? color;
  final Widget? child;
  final double? space;
  final bool? visibility;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(
            vertical: 25.h,
          ),
          child: InkWell(
            onTap: () {
              press();
            },
            child: Row(
              children: [
                Expanded(
                    child: getMaxLineFont(context, title, 50,
                        color == null ? getFontColor(context) : color!, 1,
                        fontWeight: FontWeight.w500)),
                child == null ? Container() : child!
              ],
            ),
          ),
        ),
        Visibility(
          visible: (visibility == null) ? true : visibility!,
          child: Container(
            color: getBorderColor(context),
            width: double.infinity,
            height: 0.5,
          ),
        )
      ],
    ).marginSymmetric(horizontal: space == null ? 35.w : space!);
  }
}
