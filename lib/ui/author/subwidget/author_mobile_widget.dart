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
class AuthorMobileWidget extends StatelessWidget{

  var _tapPosition;
  AuthorMobileWidget({required this.list,required this.queryText,required this.function,required this.onTapStatus});
  final List<DocumentSnapshot> list;
  final RxString queryText;
  final Function(Offset,TopAuthors) function;
  final Function onTapStatus;


  @override
  Widget build(BuildContext context) {


    return Expanded(
      child: ListView(
        children: [
          SingleChildScrollView(
              scrollDirection:
              Axis.horizontal,
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  getHeaderWidget(
                      context),

                  Column(
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                      children: List.generate(
                          list.length,
                              (index) {
                            TopAuthors authorModel = TopAuthors.fromFirestore(list[index]);
                            bool cell = true;
                            return FutureBuilder<bool>(future: FirebaseData.checkCategoryExists(
                                  authorModel.refId!),builder: (context, snapshot) {
                                if (snapshot.data != null && snapshot.data!) {
                                  return
                                    Obx(() {
                                          if (queryText.value.isNotEmpty &&
                                              !authorModel.authorName!.toLowerCase().contains(queryText.value)) {
                                            cell =
                                            false;
                                          }

                                          return cell
                                              ? Stack(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 25.h),
                                                child: Row(

                                                  children: [
                                                    SizedBox(
                                                      width: 100.h,
                                                      child: Container(
                                                        alignment: Alignment.centerLeft,
                                                        height: 50.h,
                                                        width: 50.h,
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius
                                                              .circular(50.h / 2),
                                                          child: (authorModel.image!.isNotEmpty && authorModel.image!.split(".").last.startsWith("svg"))?Image.asset("${Constants.assetPath}",height: 50.h,width: 50.h,):Image(
                                                            width: 50.h,
                                                            height: 50.h,
                                                            image: NetworkImage(authorModel.image ?? ""),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    getSubCell('${authorModel.authorName}', context, 130),
                                                    getSubCell('${authorModel.designation}', context, 120),

                                                    getSubCell(removeAllHtmlTags(authorModel.desc ?? ""), context, 325,isMaxLine: true),
                                                    getHorizontalSpace(context, 20),
                                                    getActiveDeActiveCell(context, authorModel.isActive! , authorModel),
                                                    // getActiveDeActiveCell( context, storyModel.isActive!),

                                                    Container(
                                                      width: 80.h,
                                                      alignment: Alignment.centerLeft,
                                                      child: GestureDetector(
                                                          onTapDown: _storePosition,
                                                          onTap: () {

                                                            function(_tapPosition,authorModel);
                                                          },
                                                          child: Icon(
                                                            Icons.more_vert,
                                                            color: getSubFontColor(context),
                                                            size: 25.h,
                                                          )),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Positioned.fill(child: Align(alignment: Alignment.bottomLeft,
                                                child: Divider(
                                                  height: 0.5,
                                                  color: cell?getBorderColor(context):Colors.transparent,
                                                ).marginSymmetric(vertical: 4.h),))
                                            ],
                                          )
                                              : Container();
                                        });
                                }
                                return Container();
                              },)
                              ;
                          }))
                ],
              ))
        ],
      ),
    );
  }
  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }


  getSubCell(String title, BuildContext context, double width,{bool isMaxLine = false}) {
    return Container(
        width: width.h,
        alignment: Alignment.centerLeft,
        child: (isMaxLine)?getMaxLineSubTitle(context, title):getSubTitle(context, title));
  }
  getActiveDeActiveCell(BuildContext context, bool isActive,TopAuthors model) {
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
        onTapStatus(model);
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
          getHeaderCell('Image', context, 100),
          getHeaderCell('Name', context, 130),
          getHeaderCell('Designation', context, 120),
          getHeaderCell('Description', context, 350),
          getHeaderCell('Status', context, 120),
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