import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:ebookadminpanel/controller/home_controller.dart';
import 'package:ebookadminpanel/main.dart';
import 'package:ebookadminpanel/ui/common/common.dart';
import 'package:ebookadminpanel/util/constants.dart';
import 'package:ebookadminpanel/util/responsive.dart';

import '../../../theme/app_theme.dart';
import '../../../theme/color_scheme.dart';

class SideMenu extends StatelessWidget {
  final Function function;

  SideMenu({
    Key? key,
    required this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 5,
      backgroundColor: getCardColor(context),
      child: Obx(() {
        // ignore: unused_local_variable
        HomeController homeController = Get.find();
        int i = selectedAction.value;

        return ListView(
          children: [
            Responsive.isDesktop(context)
                ? Container(
                    height: 20.h,
                  )
                : Container(
                    height: 36.h,
                  ),

            DrawerExpansionTile(
              // key: Key("selected ${selectedIndex}"),
              title: "Dashboard",
              svgSrc: (i == actionDashBoard) ? "home_active.svg" : "home.svg",
              // isSelected:checkAction (i , actionDashBoard),
              isSelected: (i == actionDashBoard),
              isDropDown: false,
              pressList: () {},
              pressAdd: () {},
              press: () {
                function(actionDashBoard);
              },
              index: 0,
            ),

            // DrawerListTile(
            //   title: "Dashboard",
            //   svgSrc: "home.svg",
            //   isSelected: (i == actionDashBoard),
            //   press: () {
            //     function(actionDashBoard);
            //   },
            // ),

            // DrawerExpansionTile(
            //   // key: Key("selected ${selectedIndex}"),
            //   title: "Categories",
            //   svgSrc: (i == actionAddCategory ||
            //           i == actionCategories ||
            //           i == actionEditCategory ||
            //           checkAction(i, dummyActionCategories))
            //       ? "category_active.svg"
            //       : "menu.svg",
            //   isSelected: i == actionAddCategory ||
            //       i == actionCategories ||
            //       i == actionEditCategory ||
            //       checkAction(i, dummyActionCategories),
            //   isDropDown: true,
            //   isAddSelected: i == actionAddCategory,
            //   isListSelected: i == actionCategories,
            //   pressList: () {
            //     function(actionCategories);
            //   },
            //   pressAdd: () {
            //     function(actionAddCategory);
            //   },
            //   press: () {
            //     function(actionCategories);
            //     // function(dummyActionCategories);

            //     print("i---------$i-------$actionCategories");
            //   },
            //   index: 1,
            // ),

            // // DrawerListTile(
            // //   title: "Categories",
            // //   svgSrc: "menu.svg",
            // //   isSelected: i == actionCategories ||
            // //       i == actionAddCategory ||
            // //       i == actionEditCategory,
            // //   press: () {
            // //     function(actionCategories);
            // //   },
            // //   isDropDown: true,
            // // ),

            // DrawerExpansionTile(
            //   // key: Key("selected ${selectedIndex}"),
            //   title: "Author",
            //   svgSrc: (i == actionAuthor ||
            //           i == actionEditAuthor ||
            //           i == actionAddAuthor ||
            //           checkAction(i, dummyActionAuthor))
            //       ? "user_active.svg"
            //       : "user.svg",
            //   isSelected: i == actionAuthor ||
            //       i == actionEditAuthor ||
            //       i == actionAddAuthor ||
            //       checkAction(i, dummyActionAuthor),
            //   isDropDown: true,
            //   isListSelected: i == actionAuthor,
            //   isAddSelected: i == actionAddAuthor,
            //   pressList: () {
            //     function(actionAuthor);
            //   },
            //   pressAdd: () {
            //     function(actionAddAuthor);
            //   },
            //   press: () {
            //     function(actionAuthor);
            //     // function(dummyActionAuthor);
            //   },
            //   index: 4,
            // ),

            DrawerExpansionTile(
              // key: Key("selected ${selectedIndex}"),
              title: "Genre",
              svgSrc: (i == actionGenre ||
                      i == actionEditGenre ||
                      i == actionAddGenre ||
                      checkAction(i, dummyActionGenre))
                  ? "category_active.svg"
                  : "menu.svg",
              isSelected: i == actionGenre ||
                  i == actionEditGenre ||
                  i == actionAddGenre ||
                  checkAction(i, dummyActionGenre),
              isDropDown: true,
              isListSelected: i == actionGenre,
              isAddSelected: i == actionAddGenre,
              pressList: () {
                function(actionGenre);
              },
              pressAdd: () {
                function(actionAddGenre);
              },
              press: () {
                function(actionGenre);
                // function(dummyActionAuthor);
              },
              index: 7,
            ),

            DrawerExpansionTile(
              // key: Key("selected ${selectedIndex}"),
              title: "Buku",
              svgSrc: (i == actionAddStory ||
                      i == actionEditStory ||
                      i == actionStories ||
                      checkAction(i, dummyActionStories))
                  ? "stories_active.svg"
                  : "stories.svg",
              isSelected: i == actionAddStory ||
                  i == actionEditStory ||
                  i == actionStories ||
                  checkAction(i, dummyActionStories),
              isDropDown: true,
              isListSelected: i == actionStories,
              isAddSelected: i == actionAddStory,
              pressList: () {
                function(actionStories);
              },
              pressAdd: () {
                function(actionAddStory);
              },
              press: () {
                function(actionStories);
                // function(dummyActionStories);
              },
              index: 2,
            ),

            DrawerExpansionTile(
              // key: Key("selected ${selectedIndex}"),
              title: "Donasi Buku",
              svgSrc: (i == actionDonationBook ||
                      i == actionEditDonationBook ||
                      i == actionAddDonationBook ||
                      checkAction(i, dummyActionDonationBook))
                  ? "icon_donation_fill.svg"
                  : "icon_donation_outline.svg",
              isSelected: i == actionDonationBook ||
                  //     i == actionEditDonationBook ||
                  //     i == actionAddDonationBook ||
                  checkAction(i, dummyActionDonationBook),
              isDropDown: false,
              isListSelected: i == actionDonationBook,
              // isAddSelected: i == actionAddDonationBook,
              pressList: () {
                function(actionDonationBook);
              },
              pressAdd: () {
                // function(actionAddDonationBook);
              },
              press: () {
                function(actionDonationBook);
                // function(dummyActionAuthor);
              },
              index: 10,
            ),

            DrawerExpansionTile(
              // key: Key("selected ${selectedIndex}"),
              title: "Kegiatan Literasi",
              svgSrc: (i == actionKegiatanLiterasi ||
                      i == actionEditKegiatanLiterasi ||
                      i == actionAddKegiatanLiterasi ||
                      checkAction(i, dummyActionKegiatanLiterasi))
                  ? "icon_kegiatan_literasi_fill.svg"
                  : "icon_kegiatan_literasi_outline.svg",
              isSelected: i == actionKegiatanLiterasi ||
                  i == actionEditKegiatanLiterasi ||
                  i == actionAddKegiatanLiterasi ||
                  checkAction(i, dummyActionKegiatanLiterasi),
              isDropDown: true,
              isListSelected: i == actionKegiatanLiterasi,
              isAddSelected: i == actionAddKegiatanLiterasi,
              pressList: () {
                function(actionKegiatanLiterasi);
              },
              pressAdd: () {
                function(actionAddKegiatanLiterasi);
              },
              press: () {
                function(actionKegiatanLiterasi);
                // function(dummyActionAuthor);
              },
              index: 9,
            ),

            DrawerExpansionTile(
              // key: Key("selected ${selectedIndex}"),
              title: "Sekilas Info",
              svgSrc: (i == actionSekilasInfo ||
                      i == actionEditSekilasInfo ||
                      i == actionAddSekilasInfo ||
                      checkAction(i, dummyActionSekilasInfo))
                  ? "sekilas_ilmu_fill.svg"
                  : "newspaper.svg",
              isSelected: i == actionSekilasInfo ||
                  i == actionEditSekilasInfo ||
                  i == actionAddSekilasInfo ||
                  checkAction(i, dummyActionSekilasInfo),
              isDropDown: true,
              isListSelected: i == actionSekilasInfo,
              isAddSelected: i == actionAddSekilasInfo,
              pressList: () {
                function(actionSekilasInfo);
              },
              pressAdd: () {
                function(actionAddSekilasInfo);
              },
              press: () {
                function(actionSekilasInfo);
                // function(dummyActionAuthor);
              },
              index: 8,
            ),

            DrawerExpansionTile(
              // key: Key("selected ${selectedIndex}"),
              title: "Umpan Balik",
              svgSrc:
                  (i == actionFeedback || checkAction(i, dummyActionFeedback))
                      ? "icon_feedback_fill.svg"
                      : "icon_feedback_outline.svg",
              isSelected: i == actionFeedback ||
                  //     i == actionEditDonationBook ||
                  //     i == actionAddDonationBook ||
                  checkAction(i, dummyActionFeedback),
              isDropDown: false,
              isListSelected: i == actionFeedback,
              // isAddSelected: i == actionAddDonationBook,
              pressList: () {
                function(actionFeedback);
              },
              pressAdd: () {
                // function(actionAddDonationBook);
              },
              press: () {
                function(actionFeedback);
                // function(dummyActionAuthor);
              },
              index: 11,
            ),

            DrawerExpansionTile(
              // key: Key("selected ${selectedIndex}"),
              title: "Rating",
              svgSrc: (i == actionRating || checkAction(i, dummyActionRating))
                  ? "icon_rating_fill.svg"
                  : "icon_rating_outline.svg",
              isSelected: i == actionRating ||
                  //     i == actionEditDonationBook ||
                  //     i == actionAddDonationBook ||
                  checkAction(i, dummyActionRating),
              isDropDown: false,
              isListSelected: i == actionRating,
              // isAddSelected: i == actionAddDonationBook,
              pressList: () {
                function(actionRating);
              },
              pressAdd: () {
                // function(actionAddDonationBook);
              },
              press: () {
                function(actionRating);
                // function(dummyActionAuthor);
              },
              index: 10,
            ),

            DrawerExpansionTile(
              // key: Key("selected ${selectedIndex}"),
              title: "Pesan",
              svgSrc: (i == actionChat || checkAction(i, dummyActionChat))
                  ? "icon_chat_fill.svg"
                  : "icon_chat_outline.svg",
              isSelected: i == actionChat ||
                  //     i == actionEditDonationBook ||
                  //     i == actionAddDonationBook ||
                  checkAction(i, dummyActionChat),
              isDropDown: false,
              isListSelected: i == actionChat,
              // isAddSelected: i == actionAddDonationBook,
              pressList: () {
                function(actionChat);
              },
              pressAdd: () {
                // function(actionAddDonationBook);
              },
              press: () {
                function(actionChat);
                // function(dummyActionAuthor);
              },
              index: 10,
            ),

             DrawerExpansionTile(
              // key: Key("selected ${selectedIndex}"),
              title: "Tukar Milik",
              svgSrc: (i == actionTukarMilik ||
                      i == actionEditTukarMilik ||
                  
                      checkAction(i, dummyActionTukarMilik))
                  ? "icon_donation_fill.svg"
                  : "icon_donation_outline.svg",
              isSelected: i == actionTukarMilik ||
                  //     i == actionEditDonationBook ||
                  //     i == actionAddDonationBook ||
                  checkAction(i, dummyActionTukarMilik),
              isDropDown: false,
              isListSelected: i == actionTukarMilik,
              // isAddSelected: i == actionAddDonationBook,
              pressList: () {
                function(actionTukarMilik);
              },
              pressAdd: () {
                // function(actionAddDonationBook);
              },
              press: () {
                function(actionTukarMilik);
                // function(dummyActionAuthor);
              },
              index: 10,
            ),

            // DrawerListTile(
            //   title: "Stories",
            //   svgSrc: "stories.svg",
            //   isSelected: i == actionStories ||
            //       i == actionAddStory ||
            //       i == actionEditStory,
            //   press: () {
            //     function(actionStories);
            //   },
            //   isDropDown: true,
            // ),

            // DrawerExpansionTile(
            //   // key: Key("selected ${selectedIndex}"),
            //   title: "Home Slider",
            //   svgSrc: (i == actionAddSlider ||
            //           i == actionHomeSlider ||
            //           checkAction(i, dummyActionHomeSlider))
            //       ? "slider_active.svg"
            //       : "slider.svg",
            //   isSelected: i == actionAddSlider ||
            //       i == actionHomeSlider ||
            //       checkAction(i, dummyActionHomeSlider),
            //   isDropDown: true,
            //   isAddSelected: i == actionAddSlider,
            //   isListSelected: i == actionHomeSlider,
            //   pressList: () {
            //     function(actionHomeSlider);
            //   },
            //   pressAdd: () {
            //     if (homeController.sliderList.length < 3) {
            //       function(actionAddSlider);
            //     } else {
            //       showCustomToast(
            //           context: context,
            //           message: "you have already 3 slider added");
            //     }
            //   },
            //   press: () {
            //     function(actionHomeSlider);
            //     // function(dummyActionHomeSlider);
            //   },
            //   index: 3,
            // ),

            // DrawerListTile(
            //   title: "Home Slider",
            //   svgSrc: "slider.svg",
            //   isSelected: i == actionHomeSlider || i == actionAddSlider,
            //   press: () {
            //     function(actionHomeSlider);
            //   },
            //   isDropDown: true,
            // ),

            // DrawerExpansionTile(
            //   // key: Key("selected ${selectedIndex}"),
            //   title: "Send Notification",
            //   svgSrc: (i == actionSendNotification)
            //       ? "notification_active.svg"
            //       : "notification.svg",
            //   isSelected: i == actionSendNotification,
            //   isDropDown: false,
            //   pressList: () {},
            //   pressAdd: () {},
            //   press: () {
            //     function(actionSendNotification);
            //   },
            //   index: 5,
            // ),

            // DrawerListTile(
            //   title: "Send Notification",
            //   svgSrc: "notification.svg",
            //   isSelected: i == actionSendNotification,
            //   press: () {
            //     function(actionSendNotification);
            //   },
            // ),

            // DrawerExpansionTile(
            //   // key: Key("selected ${selectedIndex}"),
            //   title: "Settings",
            //   svgSrc:
            //       (i == actionSettings) ? "setting_active.svg" : "setting.svg",
            //   isSelected: i == actionSettings,
            //   isDropDown: false,
            //   pressList: () {},
            //   pressAdd: () {},
            //   press: () {
            //     function(actionSettings);
            //   },
            //   index: 6,
            // ),

            // DrawerListTile(
            //   title: "Settings",
            //   svgSrc: "setting.svg",
            //   isSelected: i == actionSettings,
            //   press: () {
            //     function(actionSettings);
            //   },
            // ),
          ],
        );
      }),
    );
  }

  checkAction(int i, int action) {
    // if(dummyActionList.contains(action)){
    //   i = oldAction;
    //
    // }else{
    //   i = action;
    //
    //
    // }

    // if(i == dummyAction){
    //   return false;
    // }
    return (i == action);
  }
}

RxInt selectedIndex = 0.obs;

// ignore: must_be_immutable
class DrawerExpansionTile extends StatelessWidget {
  DrawerExpansionTile(
      {Key? key,
      // For selecting those three line once press "Command+D"
      required this.title,
      required this.svgSrc,
      required this.isSelected,
      required this.isDropDown,
      // required this.isOn,
      required this.pressList,
      required this.pressAdd,
      required this.press,
      required this.index,
      this.isListSelected,
      this.isAddSelected})
      : super(key: key);

  final String title, svgSrc;
  final bool isSelected;
  final bool isDropDown;

  // final bool isOn;
  final VoidCallback pressList;
  final VoidCallback pressAdd;
  final VoidCallback press;

  bool? isListSelected;
  bool? isAddSelected;
  int? index;

  Widget build(BuildContext context) {
    print("isSelected---_${isSelected}-----${title}");
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.h),
      // padding: EdgeInsets.symmetric(horizontal: 15.h),

      decoration: BoxDecoration(
          // color: Colors.transparent,
          color: isSelected
              ? themeController.checkDarkTheme()
                  ? darkSubCardColor
                  : alphaColor
              : Colors.transparent,
          borderRadius: BorderRadius.all(
            Radius.circular(getResizeRadius(context, 10)),
          ),
          border: (isSelected)
              ? Border.fromBorderSide(BorderSide(
                  color: getOpacityColor(context),
                  width: 1.h,
                ))
              : null),

      child: Theme(
        data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
            colorScheme: ColorScheme.light(primary: getPrimaryColor(context))),
        child: ExpansionTile(
          key: Key(selectedIndex.toString()),

          title: getMaxLineFont(
              context,
              title,
              50,
              isSelected ? getPrimaryColor(context) : getSubFontColor(context),
              1,
              fontWeight: FontWeight.w500),
          leading: Container(
            height: 50.h,
            width: 40.h,
            child: Row(
              children: [
                isSelected
                    ? Container(
                        margin: EdgeInsets.symmetric(vertical: 5.h),
                        width: 5.h,
                        decoration: BoxDecoration(
                            color: getPrimaryColor(context),
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(
                                    getResizeRadius(context, 12)),
                                bottomRight: Radius.circular(
                                    getResizeRadius(context, 12)))),
                      )
                    : SizedBox(
                        width: 5.h,
                      ),
                getHorSpace(10.h),
                Container(
                  height: 18.h,
                  width: 18.h,
                  child: imageSvg(
                    svgSrc,
                    height: 18.h,
                    width: 18.h,

                    // color: isSelected
                    //     ? getPrimaryColor(context)
                    //     : getSubFontColor(context)
                  ),
                ),
              ],
            ),
          ),
          tilePadding: EdgeInsets.only(right: 10.h),

          //add icon
          // childrenPadding: EdgeInsets.only(left: 60),
          // trailing: imageSvg("right.svg", height: 18.h, width: 18.h),

          initiallyExpanded: index == selectedIndex.value,
          // backgroundColor: isSelected?getPrimaryColor(context):Colors.transparent,

          // initiallyExpanded: false,

          // collapsedBackgroundColor: isSelected
          //     ? themeController.checkDarkTheme()
          //         ? darkSubCardColor
          //         : alphaColor
          //     : Colors.transparent,

          // controlAffinity: ListTileControlAffinity.trailing,

          // collapsedBackgroundColor: Colors.grey,

          textColor:
              isSelected ? getPrimaryColor(context) : getSubFontColor(context),
          onExpansionChanged: (value) {
            if (value) {
              selectedIndex.value = index!;
            } else {
              selectedIndex.value = -1;
            }

            print("value-----${selectedIndex}----${index}----${value}");
            print("selected-----${value}----${selectedIndex}");

            press();

            print("value-----${selectedIndex}----${index}----${value}");
          },
          controlAffinity: (isDropDown)
              ? ListTileControlAffinity.trailing
              : ListTileControlAffinity.leading,

          //children padding
          children: (isDropDown)
              ? [
                  Container(
                    color: isListSelected ?? false
                        ? themeController.checkDarkTheme()
                            ? darkSubCardColor
                            : alphaColor
                        : getCardColor(context),
                    padding: EdgeInsets.symmetric(horizontal: 20.h),
                    child: ListTile(
                      onTap: () {
                        pressList();
                      },
                      hoverColor: themeController.checkDarkTheme()
                          ? darkSubCardColor
                          : alphaColor,
                      selected: isListSelected ?? false,
                      selectedColor: isListSelected ?? false
                          ? themeController.checkDarkTheme()
                              ? darkSubCardColor
                              : alphaColor
                          : Colors.transparent,
                      selectedTileColor: isListSelected ?? false
                          ? themeController.checkDarkTheme()
                              ? darkSubCardColor
                              : alphaColor
                          : Colors.transparent,
                      title: getMaxLineFont(
                          context,
                          "List",
                          50,
                          isListSelected ?? false
                              ? getPrimaryColor(context)
                              : getSubFontColor(context),
                          1,
                          fontWeight: FontWeight.w500),
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        height: 50.h,
                        width: 40.h,
                        child: Row(
                          children: [
                            isListSelected ?? false
                                ? Container(
                                    margin: EdgeInsets.symmetric(vertical: 5.h),
                                    width: 5.h,
                                    decoration: BoxDecoration(
                                        color: getPrimaryColor(context),
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(
                                                getResizeRadius(context, 12)),
                                            bottomRight: Radius.circular(
                                                getResizeRadius(context, 12)))),
                                  )
                                : SizedBox(
                                    width: 5.h,
                                  ),
                            getHorSpace(10.h),
                            imageAsset(
                              "list.png",
                              height: 18.h,
                              width: 18.h,
                              color: isListSelected ?? false
                                  ? getPrimaryColor(context)
                                  : getSubFontColor(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: isAddSelected ?? false
                        ? themeController.checkDarkTheme()
                            ? darkSubCardColor
                            : alphaColor
                        : getCardColor(context),
                    padding: EdgeInsets.symmetric(horizontal: 20.h),
                    child: ListTile(
                      onTap: () {
                        pressAdd();
                      },
                      hoverColor: themeController.checkDarkTheme()
                          ? darkSubCardColor
                          : alphaColor,
                      selected: isAddSelected ?? false,
                      contentPadding: EdgeInsets.zero,
                      selectedColor: isAddSelected ?? false
                          ? themeController.checkDarkTheme()
                              ? darkSubCardColor
                              : alphaColor
                          : Colors.transparent,
                      selectedTileColor: isAddSelected ?? false
                          ? themeController.checkDarkTheme()
                              ? darkSubCardColor
                              : alphaColor
                          : Colors.transparent,
                      title: getMaxLineFont(
                          context,
                          "Tambah",
                          50,
                          isAddSelected ?? false
                              ? getPrimaryColor(context)
                              : getSubFontColor(context),
                          1,
                          fontWeight: FontWeight.w500),
                      leading: Container(
                        height: 50.h,
                        width: 40.h,
                        child: Row(
                          children: [
                            isAddSelected ?? false
                                ? Container(
                                    margin: EdgeInsets.symmetric(vertical: 5.h),
                                    width: 5.h,
                                    decoration: BoxDecoration(
                                        color: getPrimaryColor(context),
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(
                                                getResizeRadius(context, 12)),
                                            bottomRight: Radius.circular(
                                                getResizeRadius(context, 12)))),
                                  )
                                : SizedBox(
                                    width: 5.h,
                                  ),
                            getHorSpace(10.h),
                            imageAsset(
                              "more.png",
                              height: 18.h,
                              width: 18.h,
                              color: isAddSelected ?? false
                                  ? getPrimaryColor(context)
                                  : getSubFontColor(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ]
              : [],
        ),
      ),

      // child: InkWell(
      //   onTap: () {
      //     pressList();
      //   },
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       Row(
      //         children: [
      //           imageSvg(svgSrc,
      //               height: 18.h,
      //               width: 18.h,
      //               color: isSelected
      //                   ? getPrimaryColor(context)
      //                   : getSubFontColor(context)),
      //           Responsive.isDesktop(context)?10.w.horizontalSpace:  50.h.horizontalSpace,
      //
      //           getMaxLineFont(
      //               context,
      //               title,
      //               50,
      //               isSelected
      //                   ? getPrimaryColor(context)
      //                   : getSubFontColor(context),
      //               1,
      //               fontWeight:  FontWeight.w500),
      //         ],
      //       ),
      //       imageSvg("right.svg", height: 18.h, width: 18.h):Container()
      //     ],
      //   ),
      // ),
    );
  }
}
