// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebookadminpanel/model/rate_us_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../theme/color_scheme.dart';
import '../../common/common.dart';

class RatingMobileWidget extends StatelessWidget {
  var _tapPosition;

  final List<DocumentSnapshot> list;
  final RxString queryText;
  final Function(Offset, RateUsModel) function;
  final Function onTapStatus;

  RatingMobileWidget({
    required this.list,
    required this.queryText,
    required this.function,
    required this.onTapStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          RateUsModel rateUsModel = RateUsModel.fromFirestore(list[index]);

          bool cell = true;

          if (queryText.value.isNotEmpty &&
              !rateUsModel.userName
                  .toLowerCase()
                  .contains(queryText.value.toLowerCase())) {
            cell = false;
          }

          return cell
              ? Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15.w,
                        vertical: 25.h,
                      ),
                      child: Row(
                        children: [
                          getSubCell(
                            '${rateUsModel.userName}',
                            context,
                            130,
                          ),
                          getHorizontalSpace(context, 20),
                          getSubCell(
                            '${rateUsModel.rating}',
                            context,
                            200,
                          ),
                          getHorizontalSpace(context, 20),
                          Container(
                            width: 80.h,
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTapDown: _storePosition,
                              onTap: () {
                                function(
                                  _tapPosition,
                                  rateUsModel,
                                );
                              },
                              child: Icon(
                                Icons.more_vert,
                                color: getSubFontColor(context),
                                size: 25.h,
                              ),
                            ),
                          ),
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
                      ),
                    ),
                  ],
                )
              : Container();
        },
      ),
    );
  }

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  Widget getSubCell(String title, BuildContext context, double width) {
    return Container(
      width: width.h,
      alignment: Alignment.centerLeft,
      child: getMaxLineFont(
        context,
        title,
        45,
        getFontColor(context),
        1,
        fontWeight: FontWeight.w400,
        textAlign: TextAlign.start,
      ),
    );
  }
}
