import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebookadminpanel/model/genre_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ebookadminpanel/model/slider_model.dart';
import 'package:ebookadminpanel/theme/app_theme.dart';

import '../../../controller/data/FirebaseData.dart';
import '../../../controller/data/key_table.dart';
import '../../../model/category_model.dart';
import '../../../model/story_model.dart';
import '../../../theme/color_scheme.dart';
import '../../common/common.dart';

class SliderMobileScreen extends StatelessWidget {
  SliderMobileScreen(
      {required this.list,
      required this.queryText,
      required this.function,
      required this.onTapStatus});

  final List<DocumentSnapshot> list;
  final RxString queryText;
  final Function(SliderModel) function;
  final Function onTapStatus;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getHeaderWidget(context),
                  Column(crossAxisAlignment: CrossAxisAlignment.start,

                      children: List.generate(list.length, (index) {
                        SliderModel model =
                            SliderModel.fromFirestore(list[index]);
                        bool cell = true;

                        return StreamBuilder<DocumentSnapshot?>(
                          stream: FirebaseFirestore.instance
                              .collection(KeyTable.storyList)
                              .doc(model.storyId!)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.data != null &&
                                snapshot.data!.exists) {
                              StoryModel storyModel =
                                  StoryModel.fromFirestore(snapshot.data!);
                              return Obx(() {
                                if (queryText.value.isNotEmpty &&
                                    !storyModel.name!.toLowerCase()
                                        .contains(queryText.value)) {
                                  cell = false;
                                }

                                return cell
                                    ? FutureBuilder<bool>(
                                  future: FirebaseData.checkCategoryExists(
                                      storyModel.refId!),
                                        builder: (context, snapshot) {
                                          if (snapshot.data != null &&
                                              snapshot.data!) {
                                            return Stack(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 15.w,
                                                      vertical: 25.h),
                                                  child: Row(
                                                    children: [
                                                      getSubCell('${index + 1}',
                                                          context, 80),
                                                      StreamBuilder<DocumentSnapshot>(
                                                        stream:
                                                        FirebaseFirestore.instance.collection(
                                                            KeyTable.keyCategoryTable).doc(
                                                            storyModel.refId!).snapshots(),
                                                        builder:
                                                            (context, snapshot) {
                                                          return snapshot.data == null
                                                              ? Container()
                                                              : Container(
                                                            child: Row(
                                                              children: [
                                                                getHeaderCell(
                                                                    '${CategoryModel
                                                                        .fromFirestore(
                                                                        snapshot.data!)
                                                                        .name}',
                                                                    context,
                                                                    130),
                                                                // SizedBox(
                                                                //   width: 100.h,
                                                                //   child: Container(
                                                                //     height: 50.h,
                                                                //     width: 75.h,
                                                                //     alignment: Alignment.centerLeft,
                                                                //     child: ClipRRect(
                                                                //       // borderRadius: BorderRadius
                                                                //       //     .circular(10.r),
                                                                //       child: Image(
                                                                //         image: NetworkImage(
                                                                //             model.image??""),
                                                                //       ),
                                                                //     ),
                                                                //   ),
                                                                // ),



                                                                // getHorizontalSpace(
                                                                //   context,
                                                                //   10,
                                                                // ),



                                                                // Expanded(child: getMaxLineFont(
                                                                //     context, CategoryModel
                                                                //     .fromFirestore(snapshot
                                                                //     .data!)
                                                                //     .name!,
                                                                //     50, getFontColor(context),
                                                                //     1,
                                                                //     fontWeight: FontWeight.w500,
                                                                //     textAlign: TextAlign
                                                                //         .start)),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      ),

                                                      getSubCell('${storyModel.name!}', context, 200),

                                                      StreamBuilder<QuerySnapshot>(
                                                        stream:
                                                        FirebaseFirestore.instance.collection(
                                                            KeyTable.authorList).snapshots(),
                                                        builder:
                                                            (context, snapshot) {

                                                          if(snapshot.data == null){

                                                            return Container();

                                                          }else {

                                                            List<DocumentSnapshot> list = snapshot.data!.docs;


                                                            List genreList = storyModel.genreId!;
                                                            List<String> genreNames = [];


                                                            for(int i = 0;i<list.length;i++){

                                                              if(genreList.contains(list[i].id)){

                                                                genreNames.add(Genre.fromFirestore(list[i]).genre!);

                                                              }

                                                            }


                                                            return Container(
                                                              child: Row(
                                                                children: [
                                                                  getHeaderCell(
                                                                      '${genreNames.toString().replaceAll('[', '').replaceAll(']', '')}',
                                                                      context,
                                                                      130),
                                                                ],
                                                              ),
                                                            );
                                                          }
                                                        },
                                                      ),

                                                      getActiveDeActiveCell(
                                                          context, storyModel.isActive!,
                                                          storyModel),

                                                      Container(
                                                        width: 80.h,
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: GestureDetector(
                                                            onTap: () {
                                                              function(model);
                                                            },
                                                            child: Icon(
                                                              Icons.delete,
                                                              color:
                                                                  getSubFontColor(
                                                                      context),
                                                              size: 25.h,
                                                            )),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Positioned.fill(
                                                    child: Align(
                                                  alignment:
                                                      Alignment.bottomLeft,
                                                  child: Divider(
                                                    height: 0.5,
                                                    color: cell
                                                        ? getBorderColor(
                                                            context)
                                                        : Colors.transparent,
                                                  ).marginSymmetric(
                                                      vertical: 4.h),
                                                ))
                                              ],
                                            );
                                          }
                                          return Container();
                                        },
                                      )
                                    : Container();
                              });
                            } else {
                              return Container();
                            }
                          },
                        );
                      }))
                ],
              ))
        ],
      ),
    );
  }

  getSubCell(String title, BuildContext context, double width) {
    return Container(
        width: width.h,
        alignment: Alignment.centerLeft,
        child: getSubTitle(context, title));
  }

  getActiveDeActiveCell(BuildContext context, bool isActive,StoryModel storyModel) {
    return InkWell(
      child: Container(
          width: 120.h,
          alignment: Alignment.centerLeft,
          child: getButton(
              context,
              isActive ? 'Active' : 'Deactive',
              isActive ? "#00A010".toColor() : "#FD3E3E".toColor(),
              isActive ? "#E7FFE8".toColor() : "#FFF2F2".toColor())),
      onTap: (){
        onTapStatus(storyModel);
      },
    );
  }

  getSubTitle(BuildContext context, String title) {
    return getMaxLineFont(context, title, 45, getFontColor(context), 1,
        fontWeight: FontWeight.w400, textAlign: TextAlign.start);
  }

  getButton(BuildContext context, String string, Color color, Color bgColor) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 12.h),
      decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(getResizeRadius(context, 45))),
      child: getMaxLineFont(context, string, 45, color, 1,
          fontWeight: FontWeight.w400, textAlign: TextAlign.start),
    );
  }

  getHeaderWidget(BuildContext context) {
    var decoration =
        getDefaultDecoration(bgColor: getReportColor(context), radius: 0);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 15.w,
      ),
      decoration: decoration,
      height: 55.h,
      child: Row(
        // scrollDirection: Axis.horizontal,
        // physics: NeverScrollableScrollPhysics(),
        children: [
          getHeaderCell('ID', context, 80),
          getHeaderCell('Category', context, 130),
          // getHeaderCell( 'Image',context,100),
          getHeaderCell('Book Title', context, 200),
          getHeaderCell('Author', context, 100),
          getHeaderCell('Book Status', context, 120),
          getHeaderCell('Action', context, 80),
        ],
      ),
    );
  }

  getHeaderCell(String title, BuildContext context, double width) {
    return Container(
        width: width.h,
        alignment: Alignment.centerLeft,
        child: getHeaderTitle(context, title));
  }

  getHeaderTitle(BuildContext context, String title) {
    return getMaxLineFont(context, title, 45, getFontColor(context), 1,
        fontWeight: FontWeight.w600, textAlign: TextAlign.start);
  }
}
