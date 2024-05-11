import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebookadminpanel/model/authors_model.dart';
import 'package:ebookadminpanel/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ebookadminpanel/theme/app_theme.dart';

import '../../../controller/data/FirebaseData.dart';
import '../../../controller/data/key_table.dart';
import '../../../model/category_model.dart';
import '../../../model/story_model.dart';
import '../../../theme/color_scheme.dart';
import '../../common/common.dart';

// ignore: must_be_immutable
class WebWidget extends StatelessWidget{

  var _tapPosition;
  WebWidget({required this.list,required this.queryText,required this.function,required this.onTapStatus,required this.mainList});
  final List<DocumentSnapshot> list;
  final List<DocumentSnapshot> mainList;
  final RxString queryText;
  final Function(Offset,StoryModel) function;
  final Function onTapStatus;


  @override
  Widget build(BuildContext context) {
    var padding = EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h);

    return Expanded(
        child: Container(
          child: Column(
            children: [
              getHeaderWidget(
                  context),
              Expanded(
                  child: ListView
                      .builder(
                    // separatorBuilder: (context, index) {
                    //   StoryModel model =
                    //   StoryModel.fromFirestore(
                    //       list[index]);
                    //   return FutureBuilder<bool>(future: FirebaseData.checkCategoryExists(
                    //       model.refId!),builder: (context, snapshot) {
                    //     if (snapshot.data != null && snapshot.data!) {
                    //       return separatorBuilder(
                    //           context, queryText: queryText, value: model
                    //           .name!);
                    //     }
                    //
                    //     return Container();
                    //   },);
                    // },
                    itemCount:
                    list
                        .length,
                    itemBuilder:
                        (context, index) {
                      StoryModel
                      storyModel =
                      StoryModel.fromFirestore(
                          list[
                          index]);

                      return FutureBuilder<bool>(future: FirebaseData.checkCategoryExists(
                          storyModel.refId!),builder: (context, snapshot) {
                        if (snapshot.data != null && snapshot.data!) {
                          return Obx(() {
                            bool cell = true;

                            if (queryText
                                .value
                                .isNotEmpty &&
                                !storyModel
                                    .name!.toLowerCase()
                                    .contains(
                                    queryText
                                        .value)) {
                              cell = false;
                            }
                            return cell
                                ? Stack(
                                  children: [
                                    Container(
                              padding:
                              padding,
                              child:
                              Row(
                                    children: [
                                      getHeaderCell(
                                          '${mainList.indexOf(list[index])+1}',
                                          context,
                                          80),



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
                                                SizedBox(
                                                  width: 100.h,
                                                  child: Container(
                                                    height: 50.h,
                                                    width: 75.h,
                                                    alignment: Alignment.centerLeft,
                                                    child: ClipRRect(
                                                      // borderRadius: BorderRadius
                                                      //     .circular(10.r),
                                                      child: (storyModel.image!.isNotEmpty && storyModel.image!.split(".").last.startsWith("svg"))?Image.asset(Constants.placeImage):Image(
                                                        image: NetworkImage(
                                                            storyModel.image!),
                                                      ),
                                                    ),
                                                  ),
                                                ),
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

                                      Expanded(flex: 1,
                                          child: getHeaderTitle(
                                              context, '${storyModel.name!}')),


                                      Expanded(flex: 2,child: StreamBuilder<QuerySnapshot>(
                                        stream:
                                        FirebaseFirestore.instance.collection(
                                            KeyTable.authorList).snapshots(),
                                        builder:
                                            (context, snapshot) {
                                          if(snapshot.data == null) {
                                            return Container();
                                          }else {

                                            List<DocumentSnapshot> list = snapshot.data!.docs;


                                            List authorList = storyModel.authId!;
                                            List<String> authorsName = [];


                                            for(int i = 0;i<list.length;i++){

                                              if(authorList.contains(list[i].id)){

                                                authorsName.add(TopAuthors.fromFirestore(list[i]).authorName!);

                                              }

                                            }

                                            print("authName------${authorsName.toString()}------${authorsName.length}");








                                            // for(int i = 0;i<authorList.length;i++){
                                            //   print("loop-----true");
                                            //
                                            //   if(authors.contains(authorList[i])){
                                            //
                                            //     String id = authorList[i];
                                            //
                                            //       for(int j = 0;i<list.length;j++){
                                            //
                                            //         if(list[j].id == id){
                                            //
                                            //           TopAuthors auth = TopAuthors.fromFirestore(list[j]);
                                            //
                                            //           authorsName.add(auth.authorName!);
                                            //
                                            //
                                            //         }
                                            //
                                            //       }
                                            //
                                            //
                                            //   }
                                            //
                                            //
                                            // }


                                            return getHeaderCell(
                                                '${authorsName.toString().replaceAll('[', '').replaceAll(']', '')}',
                                                context,
                                                130);
                                          }
                                        },
                                      ),),
                                      getActiveDeActiveCell(
                                          context,
                                          storyModel.isActive!, storyModel),
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
                                                      function(
                                                          _tapPosition, storyModel);
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
                    },
                  ))
            ],
          ),
        ));
  }
  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
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
          getHeaderCell( 'Image',context,100),
          Expanded(flex: 1,child: getHeaderTitle(context, 'Book Title')),
          Expanded(flex: 2,child: getHeaderCell(
              'Author',
              context,
              100),),
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