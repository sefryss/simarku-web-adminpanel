import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebookadminpanel/model/story_model.dart';
import 'package:ebookadminpanel/model/tukar_pinjam_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ebookadminpanel/theme/app_theme.dart';

import '../../../controller/data/key_table.dart';

import '../../../theme/color_scheme.dart';
import '../../common/common.dart';

// ignore: must_be_immutable
class MobileWidget extends StatelessWidget {
  var _tapPosition;
  MobileWidget({
    required this.list,
    required this.queryText,
    required this.function,
    required this.onTapStatus,
    required this.mainList,
  });
  final List<DocumentSnapshot> list;
  final List<DocumentSnapshot> mainList;
  final RxString queryText;
  final Function(Offset, TukarPinjamModel) function;
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
                  TukarPinjamModel tukarPinjamModel =
                      TukarPinjamModel.fromFirestore(list[index]);

                  return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection(KeyTable.tukarPinjam)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Obx(() {
                          bool cell = true;

                          if (queryText.value.isNotEmpty &&
                              !tukarPinjamModel.senderId
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

                                          Expanded(
                                            child: StreamBuilder<QuerySnapshot>(
                                              stream: FirebaseFirestore.instance
                                                  .collection(
                                                      KeyTable.storyList)
                                                  .snapshots(),
                                              builder: (context, snapshot) {
                                                if (snapshot.data == null) {
                                                  return Container();
                                                } else {
                                                  List<DocumentSnapshot> list =
                                                      snapshot.data!.docs;

                                                  String? bookList =
                                                      tukarPinjamModel
                                                          .senderBookId;

                                                  List<String> bookName = [];

                                                  for (int i = 0;
                                                      i < list.length;
                                                      i++) {
                                                    if (bookList
                                                        .contains(list[i].id)) {
                                                      bookName.add(StoryModel
                                                              .fromFirestore(
                                                                  list[i])
                                                          .name!);
                                                    }
                                                  }

                                                  print(
                                                      "bookName------${bookName.toString()}------${bookName.length}");

                                                  return getHeaderCell(
                                                    '${bookName.toString().replaceAll('[', '').replaceAll(']', '')}',
                                                    context,
                                                    130,
                                                  );
                                                }
                                              },
                                            ),
                                          ),

                                          getHorizontalSpace(context, 30),
                                          Expanded(
                                            child: StreamBuilder<QuerySnapshot>(
                                              stream: FirebaseFirestore.instance
                                                  .collection(
                                                      KeyTable.storyList)
                                                  .snapshots(),
                                              builder: (context, snapshot) {
                                                if (snapshot.data == null) {
                                                  return Container();
                                                } else {
                                                  List<DocumentSnapshot> list =
                                                      snapshot.data!.docs;

                                                  String? bookList =
                                                      tukarPinjamModel
                                                          .receiverBookId;

                                                  List<String> bookName = [];

                                                  for (int i = 0;
                                                      i < list.length;
                                                      i++) {
                                                    if (bookList
                                                        .contains(list[i].id)) {
                                                      bookName.add(StoryModel
                                                              .fromFirestore(
                                                                  list[i])
                                                          .name!);
                                                    }
                                                  }

                                                  print(
                                                      "bookName------${bookName.toString()}------${bookName.length}");

                                                  return getHeaderCell(
                                                    '${bookName.toString().replaceAll('[', '').replaceAll(']', '')}',
                                                    context,
                                                    130,
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                          getHeaderCell(
                                              '${tukarPinjamModel.status}',
                                              context,
                                              120),
                                          // getActiveDeActiveCell(context,
                                          //     tukarMilikModel.isActive!, tukarMilikModel),
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
                                                          tukarPinjamModel);
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

  getActiveDeActiveCell(
      BuildContext context, bool isActive, TukarPinjamModel tukarMilikModel) {
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
        onTapStatus(tukarMilikModel);
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
          getHeaderCell('ID', context, 50),
          getHeaderCell('Judul Buku Pengirim', context, 215),
          Expanded(
              flex: 1, child: getHeaderTitle(context, 'Judul Buku Penerima')),
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
