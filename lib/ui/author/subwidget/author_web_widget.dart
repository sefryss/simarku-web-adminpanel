import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebookadminpanel/model/authors_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ebookadminpanel/theme/app_theme.dart';
import '../../../controller/data/FirebaseData.dart';
import '../../../theme/color_scheme.dart';
import '../../../util/constants.dart';
import '../../common/common.dart';

// ignore: must_be_immutable
class AuthorWebWidget extends StatelessWidget {
  var _tapPosition;
  AuthorWebWidget(
      {required this.list,
      required this.queryText,
      required this.function,
      required this.onTapStatus});
  final List<DocumentSnapshot> list;
  final RxString queryText;
  final Function(Offset, TopAuthors) function;
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
            // separatorBuilder: (context, index) {
            //   TopAuthors model =
            //   TopAuthors.fromFirestore(list[index]);
            //   return FutureBuilder<bool>(future: FirebaseData.checkCategoryExists(
            //       model.refId!),builder: (context, snapshot) {
            //     if (snapshot.data != null && snapshot.data!) {
            //       return separatorBuilder(
            //           context, queryText: queryText, value: model.authorName!);
            //     }
            //
            //     return Container();
            //   },);
            // },
            itemCount: list.length,
            itemBuilder: (context, index) {
              TopAuthors authorModel = TopAuthors.fromFirestore(list[index]);

              return FutureBuilder<bool>(
                future: FirebaseData.checkCategoryExists(authorModel.refId!),
                builder: (context, snapshot) {
                  if (snapshot.data != null && snapshot.data!) {
                    return Obx(() {
                      bool cell = true;

                      if (queryText.value.isNotEmpty &&
                          !authorModel.authorName!
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
                                      // getHeaderCell(
                                      //     '${index + 1}',
                                      //     context,
                                      //     130),

                                      SizedBox(
                                        width: 100.h,
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 50.h,
                                          width: 50.h,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50.h / 2),
                                            child: (authorModel
                                                        .image!.isNotEmpty &&
                                                    authorModel.image!
                                                        .split(".")
                                                        .last
                                                        .startsWith("svg"))
                                                ? Image.asset(
                                                    Constants.placeImage,
                                                    height: 50.h,
                                                    width: 50.h,
                                                  )
                                                : Image(
                                                    width: 50.h,
                                                    height: 50.h,
                                                    image: NetworkImage(
                                                        authorModel.image ??
                                                            ""),
                                                    fit: BoxFit.cover,
                                                  ),
                                          ),
                                        ),
                                      ),
                                      getHeaderCell('${authorModel.authorName}',
                                          context, 130),
                                      getHeaderCell(
                                          '${authorModel.designation}',
                                          context,
                                          150),
                                      getHorSpace(10.h),
                                      Expanded(
                                        flex: 1,
                                        child: getMaxLineFont(
                                            context,
                                            removeAllHtmlTags(
                                                authorModel.desc ?? ""),
                                            50,
                                            getFontColor(context),
                                            3,
                                            fontWeight: FontWeight.w500,
                                            textAlign: TextAlign.start,
                                            txtHeight: 1.5.h),
                                      ),
                                      getHorizontalSpace(context, 10),

                                      SizedBox(
                                        width: 120.h,
                                        child: getActiveDeActiveCell(context,
                                            authorModel.isActive!, authorModel),
                                      ),
                                      Stack(
                                        children: [
                                          getMaxLineFont(context, 'Action', 50,
                                              Colors.transparent, 1,
                                              fontWeight: FontWeight.w600,
                                              textAlign: TextAlign.start),
                                          Positioned.fill(
                                              child: Center(
                                            child: GestureDetector(
                                                onTapDown: _storePosition,
                                                onTap: () {
                                                  function(_tapPosition,
                                                      authorModel);
                                                },
                                                child: Icon(
                                                  Icons.more_vert,
                                                  color:
                                                      getSubFontColor(context),
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
          ))
        ],
      ),
    ));
  }

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  getActiveDeActiveCell(
      BuildContext context, bool isActive, TopAuthors authorModel) {
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
        onTapStatus(authorModel);
      },
    );
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
        children: [
          // getHeaderCell('ID', context, 130),
          getHeaderCell('Image', context, 100),
          getHeaderCell('Name', context, 130),
          getHeaderCell(
              'Designation'
              '',
              context,
              150),
          getHorSpace(10.h),
          Expanded(child: getHeaderTitle(context, 'Description')),
          getHeaderCell('Status', context, 120),
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
