import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ebookadminpanel/model/slider_model.dart';

import '../../../../controller/data/FirebaseData.dart';
import '../../../../controller/data/key_table.dart';
import '../../../../model/story_model.dart';
import '../../../../theme/color_scheme.dart';
import '../../../common/common.dart';

class RecentMobileScreen extends StatelessWidget {
  RecentMobileScreen({
    required this.list,
  });

  final List<DocumentSnapshot> list;

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
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(list.length, (index) {
                        SliderModel model =
                            SliderModel.fromFirestore(list[index]);
                        bool cell = true;

                        return FutureBuilder<bool>(
                          future: FirebaseData.checkIfDocExists(
                              model.storyId!, KeyTable.storyList),
                          builder: (context, snapshot) {




                            if (snapshot.data != null && snapshot.data!) {


                              return StreamBuilder<DocumentSnapshot?>(
                                stream: FirebaseFirestore.instance
                                    .collection(KeyTable.storyList)
                                    .doc(model.storyId!)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.data != null) {
                                    StoryModel storyModel =
                                        StoryModel.fromFirestore(
                                            snapshot.data!);
                                    return Stack(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15.w, vertical: 25.h),
                                          child: Row(
                                            children: [
                                              getSubCell(
                                                  '${index + 1}', context, 80),
                                              Container(
                                                width: 150.h,
                                                child: StreamBuilder<
                                                    DocumentSnapshot>(
                                                  stream: FirebaseFirestore
                                                      .instance
                                                      .collection(
                                                          KeyTable.keyCategoryTable)
                                                      .doc(storyModel.refId!)
                                                      .snapshots(),
                                                  builder: (context, snapshot) {
                                                    return snapshot.data ==
                                                                null ||
                                                            snapshot.data!
                                                                    .data() ==
                                                                null
                                                        ? Container()
                                                        : Container(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            height: 50.h,
                                                            width: 75.h,
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.r),
                                                              child: Image(
                                                                image: NetworkImage(
                                                                    storyModel
                                                                        .image!),
                                                              ),
                                                            ),
                                                          );
                                                  },
                                                ),
                                              ),
                                              Container(
                                                width: 200.h,
                                                child: StreamBuilder<
                                                    DocumentSnapshot>(
                                                  stream: FirebaseFirestore
                                                      .instance
                                                      .collection(
                                                          KeyTable.keyCategoryTable)
                                                      .doc(storyModel.refId!)
                                                      .snapshots(),
                                                  builder: (context, snapshot) {
                                                    return snapshot.data ==
                                                                null ||
                                                            snapshot.data!
                                                                    .data() ==
                                                                null
                                                        ? Container()
                                                        : getMaxLineFont(
                                                            context,
                                                            storyModel.name!,
                                                            50,
                                                            getFontColor(
                                                                context),
                                                            1,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            textAlign: TextAlign
                                                                .start);
                                                  },
                                                ),
                                              ),
                                              getSubCell('${storyModel.name}',
                                                  context, 200),
                                            ],
                                          ),
                                        ),
                                        Positioned.fill(
                                            child: Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Divider(
                                            height: 0.5,
                                            color: cell
                                                ? getBorderColor(context)
                                                // ignore: dead_code
                                                : Colors.transparent,
                                          ).marginSymmetric(vertical: 4.h),
                                        ))
                                      ],
                                    );
                                  } else {
                                    return Container();
                                  }
                                },
                              );
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
          getHeaderCell('Category Image', context, 150),
          getHeaderCell('Category Name', context, 200),
          getHeaderCell('Story Title', context, 200),
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
