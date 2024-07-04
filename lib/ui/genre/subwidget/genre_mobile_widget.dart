import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebookadminpanel/controller/data/key_table.dart';
import 'package:ebookadminpanel/model/genre_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ebookadminpanel/theme/app_theme.dart';
import '../../../theme/color_scheme.dart';
import '../../common/common.dart';

// ignore: must_be_immutable
class GenreMobileWidget extends StatelessWidget {
  var _tapPosition;
  GenreMobileWidget({
    required this.list,
    required this.mainList,
    required this.queryText,
    required this.function,
    required this.onTapStatus,
  });
  final List<DocumentSnapshot> list;
  final List<DocumentSnapshot> mainList;
  final RxString queryText;
  final Function(Offset, Genre) function;
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
              Genre genreModel = Genre.fromFirestore(list[index]);

              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection(KeyTable.genreList)
                    .orderBy(KeyTable.refId, descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Obx(() {
                      bool cell = true;

                      if (queryText.value.isNotEmpty &&
                          !genreModel.genre!
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          getHeaderCell(
                                              '${mainList.indexOf(list[index]) + 1}',
                                              context,
                                              50),
                                          getHorizontalSpace(context, 5),
                                          getHeaderCell('${genreModel.genre}',
                                              context, 130),
                                          getHorizontalSpace(context, 10),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 120.h,
                                            child: getActiveDeActiveCell(
                                                context,
                                                genreModel.isActive!,
                                                genreModel),
                                          ),
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
                                                          genreModel);
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
          ))
        ],
      ),
    ));
  }

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  getSubCell(String title, BuildContext context, double width,
      {bool isMaxLine = false}) {
    return Container(
        width: width.h,
        alignment: Alignment.centerLeft,
        child: (isMaxLine)
            ? getMaxLineSubTitle(context, title)
            : getSubTitle(context, title));
  }

  getActiveDeActiveCell(BuildContext context, bool isActive, Genre genreModel) {
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
        onTapStatus(genreModel);
      },
    );
  }

  getSubTitle(BuildContext context, String title) {
    return getMaxLineFont(context, title, 45, getFontColor(context), 1,
        fontWeight: FontWeight.w400, textAlign: TextAlign.start);
  }

  getMaxLineSubTitle(BuildContext context, String title) {
    return getMaxLineFont(context, title, 45, getFontColor(context), 3,
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
    var padding = EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h);
    var decoration =
        getDefaultDecoration(bgColor: getReportColor(context), radius: 0);
    return Container(
      padding: padding,
      decoration: decoration,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              getHeaderCell('ID', context, 50),
              getHeaderCell('Genre', context, 130),
            ],
          ),
          Row(
            children: [
              getHeaderCell('Status', context, 120),
              getHeaderTitle(context, 'Action'),
            ],
          )
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
