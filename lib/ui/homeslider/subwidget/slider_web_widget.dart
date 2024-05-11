import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ebookadminpanel/model/slider_model.dart';
import 'package:ebookadminpanel/theme/app_theme.dart';

import '../../../controller/data/FirebaseData.dart';
import '../../../controller/data/key_table.dart';
import '../../../model/authors_model.dart';
import '../../../model/category_model.dart';
import '../../../model/story_model.dart';
import '../../../theme/color_scheme.dart';
import '../../common/common.dart';

class SliderWebScreen extends StatelessWidget{

  SliderWebScreen({required this.list,required this.queryText,required this.function,required this.onTapStatus});
  final List<DocumentSnapshot> list;
  final RxString queryText;
  final Function(SliderModel) function;
  final Function onTapStatus;


  @override
  Widget build(BuildContext context) {
    var padding = EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h);

    return Expanded(
        child: Column(
          children: [
            getHeaderWidget(
                context),
            Expanded(
                child: ListView
                    .builder(
                  shrinkWrap: true,
                  // separatorBuilder: (context, index) {
                  //   SliderModel model =
                  //   SliderModel.fromFirestore(list[index]);
                  //   return FutureBuilder<bool>(future:
                  //   FirebaseData.checkExist(model.storyId!, KeyTable.storyList),builder: (context, snapshot) {
                  //     if(snapshot.data != null && snapshot.data!){
                  //
                  //       return StreamBuilder<DocumentSnapshot?>(stream:
                  //       FirebaseFirestore.instance
                  //           .collection(KeyTable.storyList)
                  //           .doc(model.storyId!)
                  //           .snapshots(),
                  //           builder: (context, snapshot) {
                  //             if (snapshot.data != null &&
                  //                 snapshot.data!.exists) {
                  //               return separatorBuilder(
                  //                   context, queryText: queryText,
                  //                   value: StoryModel
                  //                       .fromFirestore(snapshot.data!)
                  //                       .name!);
                  //             } else {
                  //               return Container();
                  //             }
                  //           }
                  //
                  //
                  //       );
                  //
                  //     }
                  //
                  //
                  //     return Container();
                  //   },);
                  //
                  // },
                  itemCount:
                  list.length,
                  itemBuilder:
                      (context, index) {

                        SliderModel model = SliderModel.fromFirestore(list[index]);

                        return FutureBuilder<bool>(future: FirebaseData.checkExist(model.storyId!,
                            KeyTable.storyList), builder: (context, snapshot) {

                          print("snapshot----${snapshot.data}");

                          if(snapshot.data != null && snapshot.data!){

                            return   StreamBuilder<DocumentSnapshot?>(stream:
                              FirebaseFirestore.instance
                                  .collection(KeyTable.storyList)
                                  .doc(model.storyId!)
                                  .snapshots(),

                                builder: (context, snapshot) {

                                  if(snapshot.data != null ) {

                                    StoryModel storyModel = StoryModel.fromFirestore(snapshot.data!);
                                    return FutureBuilder<bool>(future: FirebaseData.checkCategoryExists(
                                        storyModel.refId!),builder: (context, snapshot) {
                                      if (snapshot.data != null && snapshot.data!) {
                                        return Obx(() {
                                          bool cell = true;

                                          if (queryText.value.isNotEmpty &&
                                              !storyModel.name!.toLowerCase().contains(
                                                  queryText.value)) {

                                            cell = false;

                                          }

                                          return cell
                                              ?
                                          Stack(
                                            children: [
                                              Container(
                                                padding:
                                                padding,
                                                child:
                                                Row(
                                                  children: [
                                                    getHeaderCell(
                                                        '${index + 1}', context, 80),
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
                                                              //   width: 120.h,
                                                              //   child: Container(
                                                              //     height: 50.h,
                                                              //     width: 60.h,
                                                              //     alignment: Alignment.centerLeft,
                                                              //     child: ClipRRect(
                                                              //       borderRadius: BorderRadius
                                                              //           .circular(6.r),
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
                                                    Expanded(flex: 2,
                                                        child: getHeaderTitle(context,
                                                            '${storyModel.name!}')),






                                                    Expanded(flex: 3,child: FutureBuilder<QuerySnapshot>(
                                                      future:
                                                      FirebaseFirestore.instance.collection(
                                                          KeyTable.authorList).get(),
                                                      builder:
                                                          (context, snapshot1) {
                                                        if(snapshot1.data != null){


                                                          List<DocumentSnapshot> list = snapshot1.data!.docs;


                                                          List authorList = storyModel.authId!;
                                                          List<String> authorsName = [];


                                                          for(int i = 0;i<list.length;i++){

                                                            if(authorList.contains(list[i].id)){

                                                              authorsName.add(TopAuthors.fromFirestore(list[i]).authorName!);

                                                            }

                                                          }

                                                          return getHeaderTitle(
                                                            context,
                                                              authorsName.toString().replaceAll('[', '').replaceAll(']', ''),

                                                              );
                                                        }else{
                                                          return Container();
                                                        }
                                                      },
                                                    ),),



                                                    getHorizontalSpace(context, 10),
                                                    getActiveDeActiveCell(
                                                        context, storyModel.isActive!,
                                                        storyModel),
                                                    Stack(
                                                      children: [
                                                        getMaxLineFont(
                                                            context, 'Action', 50,
                                                            Colors.transparent, 1,
                                                            fontWeight: FontWeight.w600,
                                                            textAlign: TextAlign.start),
                                                        Positioned.fill(
                                                            child: Center(
                                                              child: GestureDetector(
                                                                  onTap: () {
                                                                    function(model);
                                                                  },
                                                                  child: Icon(
                                                                    Icons.delete,
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
                                                  child:
                                                  Align(
                                                    alignment: Alignment.bottomLeft,
                                                    child: Divider(
                                                      height: 0.5,
                                                      color: cell?getBorderColor(context):Colors.transparent,
                                                    ).marginSymmetric(vertical: 4.h),)
                                              )
                                            ],
                                          )
                                              : Container();
                                        });
                                      }

                                      return Container();
                                    },);
                                  }else{
                                    return Container();
                                  }
                                },);

                          }


                          return Container();
                        },);

                  },
                ))
          ],
        ));
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
          getHeaderCell('ID', context, 80),
          getHeaderCell('Category', context, 130),
          // getHeaderCell( 'Image',context,120),
          Expanded(flex: 2,child: getHeaderTitle(context, 'Book Title')),
          Expanded(flex: 3,child: getHeaderCell(
              'Author',
              context,
              100),),
          getHorizontalSpace(context, 10),
          getHeaderCell(
              'Book Status'
                  '',
              context,
              120),
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