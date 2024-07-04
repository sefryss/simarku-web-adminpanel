import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebookadminpanel/model/genre_model.dart';
import 'package:ebookadminpanel/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ebookadminpanel/theme/app_theme.dart';

import '../../../controller/data/FirebaseData.dart';
import '../../../controller/data/key_table.dart';
import '../../../model/category_model.dart';
import '../../../model/story_model.dart';
import '../../../theme/color_scheme.dart';
import '../../../util/constants.dart';
import '../../common/common.dart';

// ignore: must_be_immutable
class MobileWidget extends StatelessWidget {
  var _tapPosition;
  MobileWidget(
      {required this.list,
      required this.queryText,
      required this.function,
      required this.onTapStatus,
      required this.mainList});
  final List<DocumentSnapshot> list;
  final List<DocumentSnapshot> mainList;
  final RxString queryText;
  final Function(Offset, StoryModel) function;
  final Function onTapStatus;

  @override
  Widget build(BuildContext context) {
    var padding = EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h);

    return Expanded(
      child: Container(
        child: Column(
          children: [
            getHeaderWidget(context),
            Expanded(
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  StoryModel storyModel = StoryModel.fromFirestore(list[index]);

                  return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection(KeyTable.storyList)
                        .orderBy(KeyTable.refId, descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Obx(() {
                          bool cell = true;

                          if (queryText.value.isNotEmpty &&
                              !storyModel.name!
                                  .toLowerCase()
                                  .contains(queryText.value)) {
                            cell = false;
                          }
                          return cell
                              ? Stack(
                                  children: [
                                    Container(
                                      padding: padding,
                                      child: Row(
                                        children: [
                                          getHeaderCell(
                                              '${mainList.indexOf(list[index]) + 1}',
                                              context,
                                              50),
                                          getHeaderCell(
                                              '${getCategoryString(storyModel.category!)}',
                                              context,
                                              100),
                                          getHorizontalSpace(context, 10),
                                          SizedBox(
                                            width: 80.h,
                                            child: Container(
                                              height: 50.h,
                                              width: 75.h,
                                              alignment: Alignment.centerLeft,
                                              child: ClipRRect(
                                                child: (storyModel.image!
                                                            .isNotEmpty &&
                                                        storyModel.image!
                                                            .split(".")
                                                            .last
                                                            .startsWith("svg"))
                                                    ? Image.asset(
                                                        Constants.placeImage)
                                                    : Image(
                                                        image: NetworkImage(
                                                            storyModel.image!),
                                                      ),
                                              ),
                                            ),
                                          ),
                                          getHorizontalSpace(context, 10),
                                          Expanded(
                                              flex: 1,
                                              child: getHeaderTitle(context,
                                                  '${storyModel.name!}')),
                                          getHorizontalSpace(context, 10),
                                          getActiveDeActiveCell(context,
                                              storyModel.isActive!, storyModel),
                                          Stack(
                                            children: [
                                              getMaxLineFont(context, 'Action',
                                                  50, Colors.transparent, 1,
                                                  fontWeight: FontWeight.w600,
                                                  textAlign: TextAlign.start),
                                              Positioned.fill(
                                                  child: Center(
                                                child: GestureDetector(
                                                    onTapDown: _storePosition,
                                                    onTap: () {
                                                      function(_tapPosition,
                                                          storyModel);
                                                    },
                                                    child: Icon(
                                                      Icons.more_vert,
                                                      color: getSubFontColor(
                                                          context),
                                                    )),
                                              ))
                                            ],
                                          )
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
                                            : Colors.transparent,
                                      ).marginSymmetric(vertical: 4.h),
                                    ))
                                  ],
                                )
                              : Container();
                        });
                      }
                      return Container();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  getSubCell(String title, BuildContext context, double width) {
    return Container(
        width: width.h,
        alignment: Alignment.centerLeft,
        child: getSubTitle(context, title));
  }

  getActiveDeActiveCell(BuildContext context, bool isActive, StoryModel model) {
    return InkWell(
      child: Container(
          width: 120.h,
          alignment: Alignment.centerLeft,
          child: getButton(
              context,
              isActive ? 'Active' : 'Deactive',
              isActive ? "#00A010".toColor() : "#FD3E3E".toColor(),
              isActive ? "#E7FFE8".toColor() : "#FFF2F2".toColor())),
      onTap: () {
        onTapStatus(model);
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
          getHeaderCell('ID', context, 50),
          getHeaderCell('Kategori', context, 100),
          getHeaderCell('Gambar', context, 100),
          getHeaderCell('Judul Buku', context, 210),
          getHeaderCell('Status', context, 100),
          getHeaderTitle(context, 'Action'),
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
