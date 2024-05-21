import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebookadminpanel/controller/data/LoginData.dart';
import 'package:ebookadminpanel/controller/data/key_table.dart';
import 'package:ebookadminpanel/ui/home/home_page.dart';
import 'package:ebookadminpanel/util/common_blank_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ebookadminpanel/controller/home_controller.dart';
import 'package:ebookadminpanel/main.dart';
import 'package:ebookadminpanel/theme/color_scheme.dart';
import 'package:ebookadminpanel/ui/common/common.dart';
import 'package:ebookadminpanel/util/constants.dart';
import 'package:ebookadminpanel/util/responsive.dart';
import '../../controller/data/FirebaseData.dart';
import '../../model/dashboard_screen_data_model.dart';

class DashboardScreen extends StatefulWidget {
  final Function function;

  DashboardScreen({required this.function});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<DashBoardData> dashboard = getDashboardData();

  HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    setScreenSize(context);

    return SafeArea(
      child: CommonPage(
          widget: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getVerticalSpace(context, 35),
            getTextWidget(context, 'DashBoard', 75, getFontColor(context),
                    fontWeight: FontWeight.w900)
                .marginSymmetric(horizontal: getDefaultHorSpace(context)),
            getVerticalSpace(context, 35),
            Expanded(
                child: Container(
                    child: GridView.builder(
                        padding: EdgeInsets.symmetric(
                            horizontal: getDefaultHorSpace(context)),
                        physics: BouncingScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: kIsWeb
                                ? (MediaQuery.of(context).size.width < 1338)
                                    ? 2
                                    : 3
                                : 2,
                            mainAxisExtent: 180.h,
                            mainAxisSpacing: kIsWeb ? 25.h : 20.h,
                            crossAxisSpacing: kIsWeb ? 25.h : 20.h),
                        itemCount: dashboard.length,
                        itemBuilder: (BuildContext context, int index) {
                          DashBoardData dashBoardData = dashboard[index];
                          print(kIsWeb &&
                              MediaQuery.of(context).size.width > 1018);
                          print(
                              "width is ================================= ${MediaQuery.of(context).size.width}");
                          print(
                              "height is ================================= ${MediaQuery.of(context).size.height}");

                          double iconSize =
                              (MediaQuery.of(context).size.width < 1338)
                                  ? 25.h
                                  : 40.h;
                          double fontSize =
                              (MediaQuery.of(context).size.width < 1338)
                                  ? 15
                                  : 17.sp;
                          double fontSize1 =
                              (MediaQuery.of(context).size.width < 1338)
                                  ? 35
                                  : 40.h;
                          return Container(
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(0, 16),
                                      blurRadius: 31,
                                      color:
                                          Color(0XFFACBFC1).withOpacity(0.10))
                                ],
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16.h),
                                ),
                                color: getSubCardColor(context)),
                            child: Column(
                              children: [
                                Container(
                                  height: 96.h,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(16.h),
                                          topRight: Radius.circular(16.h)),
                                      color: dashBoardData.backgroundColor),
                                  child: Row(
                                    children: [
                                      getSvgImage(dashBoardData.icon!,
                                          height: iconSize, width: iconSize),
                                      getHorSpace(12.h),
                                      Expanded(
                                          child: getMultilineCustomFont(
                                              dashBoardData.title!,
                                              fontSize,
                                              Colors.black,
                                              fontWeight: FontWeight.w300,
                                              overflow: TextOverflow.visible)),
                                      StreamBuilder<QuerySnapshot>(
                                        stream: (dashBoardData.isPopular ??
                                                false)
                                            ? FirebaseFirestore.instance
                                                .collection(
                                                    dashBoardData.tableName!)
                                                .where(KeyTable.isPopular,
                                                    isEqualTo: true)
                                                .snapshots()
                                            : (dashBoardData.isFeatured ??
                                                    false)
                                                ? FirebaseFirestore.instance
                                                    .collection(dashBoardData
                                                        .tableName!)
                                                    .where(KeyTable.isFeatured,
                                                        isEqualTo: true)
                                                    .snapshots()
                                                : FirebaseFirestore.instance
                                                    .collection(dashBoardData
                                                        .tableName!)
                                                    .snapshots(),
                                        builder: (context1, snapshot) {
                                          print(
                                              "state===${snapshot.connectionState}");

                                          int i = 0;

                                          if (snapshot.hasData &&
                                              snapshot.connectionState ==
                                                  ConnectionState.active) {
                                            List<DocumentSnapshot> list =
                                                snapshot.data!.docs;

                                            i = list.length;
                                          }

                                          return getCustomFont(
                                              '$i', fontSize1, Colors.black, 1,
                                              fontWeight: FontWeight.w700);
                                        },
                                      ),
                                    ],
                                  ).paddingSymmetric(horizontal: 15.h),
                                ),
                                getVerSpace(28.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          changeAction(dashBoardData.action ??
                                              oldAction);
                                        },
                                        child: getCustomFont(
                                            "View All",
                                            getResizeFont(context, 50),
                                            getFontColor(context),
                                            1,
                                            fontWeight: FontWeight.w500)),
                                    InkWell(
                                      onTap: () {
                                        changeAction(dashBoardData.addAction ??
                                            oldAction);
                                      },
                                      child: Container(
                                        height: 36.h,
                                        width: 36.h,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: dashBoardData.buttonColor),
                                        child: getSvgImage("add_icon.svg")
                                            .paddingAll(8.18.h),
                                      ),
                                    )
                                  ],
                                ).paddingSymmetric(horizontal: 20.h),
                              ],
                            ),
                          );
                        }))),
            getVerticalSpace(context, 35),
          ],
        ),
      )),
    );
  }

  itemWidget({
    required context,
    required title,
    required value,
    required icon,
    required bgColor,
    // required Function actionAddNew,
    // required Function actionViewAll
  }) {
    Widget subWidget = ClipRRect(
      borderRadius: BorderRadius.circular((getResizeRadius(context, 35))),
      child: Column(
        children: [
          Container(
            // height: 50.h,
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.h),
            child: Row(
              children: [
                imageSvg(icon,
                    height: 35.h,
                    width: 35.h,
                    folder: themeController.checkDarkTheme()
                        ? Constants.assetDarkSvgPath
                        : Constants.assetSvgPath),
                SizedBox(
                  width: 12.h,
                ),
                Expanded(
                    child: getTextWidget(
                        context, title, 48, getFontColor(context),
                        fontWeight: FontWeight.w500)),
                getTextWidget(context, value, 110, getFontColor(context),
                    fontWeight: FontWeight.bold)
              ],
            ),
            // decoration: getSideDecoration(
            //     bgColor: '#CDF5FB'.toColor(),
            //     radius: getResizeRadius(context, 30),
            //     topLeft: true,
            //     topRight: true,
            //
            // ),
          ),
          // Container(
          //   padding: EdgeInsets.symmetric(vertical: 20.h,horizontal: 20.h),
          //
          //   child: Row(
          //     children: [
          //
          //
          //
          //
          //
          //       Expanded(child: InkWell(
          //         onTap: (){
          //           actionViewAll();
          //         },
          //         child: getTextWidget(context,'View All', 45, getFontColor(context)
          //             ,fontWeight: FontWeight.w500),
          //       )),
          //
          //
          //       InkWell(
          //         onTap: (){
          //           actionAddNew();
          //         },
          //         child: Container(width: 35.h,height: 35.h,
          //           decoration: BoxDecoration(shape: BoxShape.circle,color: getPrimaryColor(context)),
          //           alignment: Alignment.center,
          //           child: Icon(Icons.add,color: Colors.white,size: 25.h,),),
          //       )
          //
          //     ],
          //   ),
          //
          //   // height: 50.h,
          //   // decoration: getSideDecoration(
          //   //     bgColor: '#CDF5FB'.toColor(),
          //   //     radius: getResizeRadius(context, 30),
          //   //     bottomLeft: true,
          //   //     bottomRight: true,
          //   //     isShadow: false
          //   // ),
          // ),
        ],
      ),
    );
    // Stack(
    //   children: [
    //     Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         getTextWidget(context, value, 80, getFontColor(context),
    //             fontWeight: FontWeight.w700),
    //         SizedBox(
    //           height: 12.h,
    //         ),
    //         getTextWidget(context, title, 55, getFontColor(context),
    //             fontWeight: FontWeight.w600),
    //         SizedBox(
    //           height: 18.h,
    //         ),
    //         Row(
    //           children: [
    //             button('Add New', () {
    //               actionAddNew();
    //             }),
    //             getHorizontalSpace(8),
    //             button('View All', () {
    //               actionViewAll();
    //             }),
    //           ],
    //         )
    //       ],
    //     ).paddingOnly(left: 15.h, top: 18.h, bottom: 18.h, right: 15.h),
    //     Align(
    //       alignment: Alignment.topRight,
    //       child: ClipRRect(
    //           borderRadius: BorderRadius.only(
    //               topRight: Radius.circular(getResizeRadius(context, 19))),
    //           child: Container(
    //             height: 100.h,
    //             width: 90.h,
    //             child: Stack(
    //               children: [
    //                 Image.asset(
    //                   Constants.assetPath + bgColor,
    //                   height: double.infinity,
    //                   width: double.infinity,
    //                   fit: BoxFit.cover,
    //                 ),
    //                 Center(
    //                   child: imageSvg(
    //                     icon,
    //                     height: 48.h,
    //                     width: 48.h,
    //                   ),
    //                 ).marginOnly(left: 10.h)
    //               ],
    //             ),
    //           )),
    //     )
    //   ],
    // );

    return InkWell(
      onTap: () {},
      child: Responsive.isDesktop(context)
          ? Container(
              width: 300.h,
              // decoration: getDefaultDecoration(
              //     bgColor: getCardColor(context),
              //     radius: getResizeRadius(context, 30),
              //     isShadow: true),
              decoration: BoxDecoration(
                  color: getSubCardColor(context),
                  borderRadius: BorderRadius.all(
                      Radius.circular(getResizeRadius(context, 35)))),
              child: subWidget)
          : Container(
              decoration: BoxDecoration(
                  color: getSubCardColor(context),
                  borderRadius: BorderRadius.all(
                      Radius.circular(getResizeRadius(context, 35)))),
              child: subWidget,
            ),
    );
  }

  @override
  void initState() {
    super.initState();

    LoginData.getDeviceId();
  }
}
// Figma Flutter Generator Group1437Widget - GROUP
