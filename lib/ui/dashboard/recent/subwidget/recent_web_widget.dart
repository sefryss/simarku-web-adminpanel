import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ebookadminpanel/controller/data/FirebaseData.dart';
import 'package:ebookadminpanel/model/slider_model.dart';
import '../../../../controller/data/key_table.dart';
import '../../../../model/category_model.dart';
import '../../../../model/story_model.dart';
import '../../../../theme/color_scheme.dart';
import '../../../common/common.dart';

class RecentWebScreen extends StatelessWidget {
  RecentWebScreen({
    required this.list,
  });

  final List<DocumentSnapshot> list;

  @override
  Widget build(BuildContext context) {
    var padding = EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h);

    return Expanded(
        child: Container(
      child: Column(
        children: [
          getHeaderWidget(context),
          Expanded(
              child: ListView.separated(
            separatorBuilder: (context, index) {
              SliderModel model = SliderModel.fromFirestore(list[index]);
              return StreamBuilder<DocumentSnapshot?>(
                stream: FirebaseFirestore.instance
                    .collection(KeyTable.storyList)
                    .doc(model.storyId!)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    return separatorBuilder(
                      context,
                    );
                  } else {
                    return Container();
                  }
                },
              );
            },
            itemCount: list.length,
            itemBuilder: (context, index) {
              SliderModel model = SliderModel.fromFirestore(list[index]);

              print("model===${model.storyId}");



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
                              StoryModel.fromFirestore(snapshot.data!);

                          return Container(
                            padding: padding,
                            child: Row(
                              children: [
                                getHeaderCell('${index + 1}', context, 150),
                                Expanded(
                                    child: Row(
                                  children: [
                                    Expanded(
                                      child: StreamBuilder<DocumentSnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection(KeyTable.keyCategoryTable)
                                            .doc(storyModel.refId!)
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          return snapshot.data == null ||
                                                  snapshot.data!.data() == null
                                              ? Container()
                                              : Container(
                                                  alignment: Alignment.topLeft,
                                                  height: 50.h,
                                                  width: 75.h,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.r),
                                                    child: Image(
                                                      image: NetworkImage(
                                                          CategoryModel
                                                                  .fromFirestore(
                                                                      snapshot
                                                                          .data!)
                                                              .image!),
                                                    ),
                                                  ),
                                                );
                                        },
                                      ),
                                    ),
                                    Expanded(
                                        child: StreamBuilder<DocumentSnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection(KeyTable.keyCategoryTable)
                                          .doc(storyModel.refId!)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        return snapshot.data == null ||
                                                snapshot.data!.data() == null
                                            ? Container()
                                            : Container(
                                                child: getMaxLineFont(
                                                    context,
                                                    CategoryModel.fromFirestore(
                                                            snapshot.data!)
                                                        .name!,
                                                    50,
                                                    getFontColor(context),
                                                    1,
                                                    fontWeight: FontWeight.w500,
                                                    textAlign: TextAlign.start),
                                              );
                                      },
                                    ))
                                  ],
                                )),
                                Expanded(
                                    child: getHeaderTitle(
                                        context, '${storyModel.name!}')),
                              ],
                            ),
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
            },
          ))
        ],
      ),
    ));
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
          getHeaderCell('ID', context, 150),
          Expanded(
              child: Row(
            children: [
              Expanded(
                child: getHeaderTitle(context, 'Category Image'),
              ),
              Expanded(child: getHeaderTitle(context, 'Category Name'))
            ],
          )),
          Expanded(child: getHeaderTitle(context, 'Story Title')),
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
