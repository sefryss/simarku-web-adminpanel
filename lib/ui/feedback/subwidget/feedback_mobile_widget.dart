import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebookadminpanel/controller/data/key_table.dart';
import 'package:ebookadminpanel/model/feedback_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../theme/color_scheme.dart';
import '../../common/common.dart';

class FeedbackMobileWidget extends StatelessWidget {
  var _tapPosition;

  final List<DocumentSnapshot> list;
  final RxString queryText;
  final Function(Offset, FeedbackModel) function;
  final Function onTapStatus;

  FeedbackMobileWidget({
    required this.list,
    required this.queryText,
    required this.function,
    required this.onTapStatus,
  });

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
              // DocumentSnapshot doc = list[index];
              // FeedbackModel feedbackModel = FeedbackModel.fromFirestore(doc);

              FeedbackModel feedbackModel =
                  FeedbackModel.fromFirestore(list[index]);

              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection(KeyTable.feedback)
                    // .doc(feedbackModel.userId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // RateUsModel rateUsModel =
                    //     RateUsModel.fromFirestore(snapshot.hasData!);

                    return Obx(() {
                      bool cell = true;

                      if (queryText.value.isNotEmpty &&
                          !feedbackModel.userName
                              .toLowerCase()
                              .contains(queryText.value.toLowerCase())) {
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
                                              '${index + 1}', context, 50),
                                          getHeaderCell(
                                              '${feedbackModel.userName}',
                                              context,
                                              130),
                                          getHorizontalSpace(context, 30),
                                          getHeaderCell(
                                              '${feedbackModel.feedback}',
                                              context,
                                              200),
                                        ],
                                      ),
                                      Row(
                                        children: [
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
                                                      function(
                                                        _tapPosition,
                                                        feedbackModel,
                                                      );
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
              getHeaderCell('Nama User', context, 155),
              getHeaderCell('Feedback', context, 180),
            ],
          ),
          Row(
            children: [
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
