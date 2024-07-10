import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebookadminpanel/controller/data/LoginData.dart';
import 'package:ebookadminpanel/util/common_blank_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ebookadminpanel/controller/data/FirebaseData.dart';
import 'package:ebookadminpanel/model/story_model.dart';
import 'package:ebookadminpanel/theme/color_scheme.dart';
import 'package:ebookadminpanel/ui/category/entries_drop_down.dart';
import 'package:ebookadminpanel/ui/common/common.dart';
import 'package:ebookadminpanel/ui/homeslider/subwidget/slider_mobile_widget.dart';
import 'package:ebookadminpanel/ui/homeslider/subwidget/slider_web_widget.dart';
import '../../../controller/data/key_table.dart';
import '../../../controller/home_controller.dart';
import '../../model/slider_model.dart';
import '../../util/pref_data.dart';

class HomeSliderScreen extends StatefulWidget {
  final Function function;

  HomeSliderScreen({required this.function});

  @override
  State<HomeSliderScreen> createState() => _HomeSliderScreenState();
}

class _HomeSliderScreenState extends State<HomeSliderScreen> {
  RxInt position = 0.obs;

  RxInt totalItem = 10.obs;


  @override
  void initState() {
    super.initState();
    
    LoginData.getDeviceId();
  }
  
  HomeController homeController = Get.find();
  

  @override
  Widget build(BuildContext context) {
    final TextEditingController textEditingController = TextEditingController();
    RxString queryText = ''.obs;

    return SafeArea(
      child: CommonPage(widget: Container(
        margin: EdgeInsets.symmetric(
            horizontal: getDefaultHorSpace(context),
            vertical: getDefaultHorSpace(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getTextWidget(context, 'Home Slider', 75, getFontColor(context),
                fontWeight: FontWeight.w700),
            getVerticalSpace(context, 35),
            Expanded(
                child: getCommonContainer(
                    context: context,
                    verSpace: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getVerticalSpace(context, getCommonPadding(context)),
                        Row(
                          children: [
                            // isWeb(context)
                            //     ? Expanded(
                            //         child: Container(
                            //         child: getEntryWidget(context),
                            //       ))
                            //     : Container(),
                            Visibility(
                              child: Expanded(child: Container()),
                              visible: isWeb(context),
                            ),
                            Expanded(
                                child: getSearchTextFiledWidget(
                                    context, 'Search..', textEditingController,
                                    onChanged: (value) {
                                      queryText(value);
                                    })),
                            getHorizontalSpace(context, 15),
                            getButtonWidget(
                              context,
                              'Add New Slider',
                                  () {
                                if (homeController.sliderList.length < 3) {
                                  widget.function();
                                } else {
                                  showCustomToast(
                                      context: context,
                                      message:
                                      "you have already 3 slider added");
                                }
                              },
                              horPadding: 25.h,
                              horizontalSpace: 0,
                              verticalSpace: 0,
                              btnHeight: 42.h,
                            )
                          ],
                        ),
                        // isWeb(context)
                        //     ? Container()
                        //     : Container(
                        //         child: getEntryWidget(context),
                        //         margin: EdgeInsets.only(top: 15.h),
                        //       ),
                        getVerticalSpace(context, 25),

                        Expanded(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection(KeyTable.sliderList)
                                .orderBy(KeyTable.index, descending: true)
                                .snapshots(),
                            builder: (context, snapshot) {

                              if(snapshot.data != null){
                                List<DocumentSnapshot> docList = snapshot.data!.docs;


                                if(docList.isNotEmpty){
                                  return Column(
                                    children: [
                                      StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection(KeyTable.sliderList)
                                            .orderBy(KeyTable.index, descending: true)
                                            .snapshots(),
                                        builder: (context1, snapshot) {
                                          print("state===${snapshot.connectionState}");

                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return getProgressWidget(context);
                                          }
                                          if (snapshot.hasData &&
                                              snapshot.connectionState ==
                                                  ConnectionState.active) {
                                            List<DocumentSnapshot> list =
                                                snapshot.data!.docs;

                                            print("l-------${list.length}");

                                            return Obx(() {
                                              double i = list.length / 10;

                                              int d = list.length -
                                                  (totalItem.value * i.toInt()).toInt();

                                              if (d > 0) {
                                                i = i + 1;
                                              }
                                              List<DocumentSnapshot> paginationList = [];

                                              paginationList = list
                                                  .skip(position.value * totalItem.value)
                                                  .take(totalItem.value)
                                                  .toList();

                                              print("pos==${position.value}==${paginationList.length}");

                                              List<DocumentSnapshot> pageList = [];

                                              for(DocumentSnapshot item in paginationList){
                                                SliderModel slider = SliderModel.fromFirestore(item);

                                                if(slider.storyId!.isNotEmpty && slider.storyId != null){
                                                  pageList.add(item);
                                                }
                                              }

                                              return pageList.length > 0
                                                  ? Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    // getTextWidget(
                                                    //     context,
                                                    //     "Default Slider",
                                                    //     45,
                                                    //     getFontColor(context)),
                                                    // getVerticalSpace(context, 20),
                                                    isWeb(context)
                                                        ? SliderWebScreen(
                                                        list: pageList,
                                                        queryText: queryText,
                                                        function: (model) {
                                                          _showPopupMenu(
                                                              context, model);
                                                        },
                                                        onTapStatus: (model) {
                                                          updateStatus(
                                                              context, model);
                                                        })
                                                        : SliderMobileScreen(
                                                        list: pageList,
                                                        queryText: queryText,
                                                        function: (model) {
                                                          _showPopupMenu(
                                                              context, model);
                                                        },
                                                        onTapStatus: (model) {
                                                          updateStatus(
                                                              context, model);
                                                        }),
                                                    getVerticalSpace(
                                                        context,
                                                        (getCommonPadding(context) /
                                                            2)),
                                                  ],
                                                ),
                                              )
                                                  : Center(child: Container());
                                            });
                                          } else {
                                            return Container();
                                          }
                                        },
                                      ),



                                      StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection(KeyTable.sliderList)
                                            .where(KeyTable.storyId, isEqualTo: "")
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.active) {
                                            if (snapshot.data != null) {
                                              List<DocumentSnapshot> list =
                                                  snapshot.data!.docs;

                                              if(list.length > 0){
                                                return Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      getTextWidget(context, "Custom Slider",
                                                          45, getFontColor(context)),
                                                      getVerticalSpace(context, 20),
                                                      Container(
                                                        padding: EdgeInsets.symmetric(
                                                            horizontal: 15.w, vertical: 15.h),
                                                        decoration: getDefaultDecoration(
                                                            bgColor: getReportColor(context),
                                                            radius: 0),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                                width: 80.h,
                                                                alignment: Alignment.centerLeft,
                                                                child: getMaxLineFont(
                                                                    context,
                                                                    "Id",
                                                                    45,
                                                                    getFontColor(context),
                                                                    1,
                                                                    fontWeight: FontWeight.w600,
                                                                    textAlign:
                                                                    TextAlign.start)),
                                                            // getHeaderCell( 'Image',context,120),

                                                            Expanded(
                                                                child: getMaxLineFont(
                                                                    context,
                                                                    "Image",
                                                                    45,
                                                                    getFontColor(context),
                                                                    1,
                                                                    fontWeight: FontWeight.w600,
                                                                    textAlign:
                                                                    TextAlign.start)),

                                                            Expanded(
                                                                child: getMaxLineFont(
                                                                    context,
                                                                    "External Link",
                                                                    45,
                                                                    getFontColor(context),
                                                                    1,
                                                                    fontWeight: FontWeight.w600,
                                                                    textAlign:
                                                                    TextAlign.start)),
                                                            Container(
                                                                width: 50.h,
                                                                alignment: Alignment.centerLeft,
                                                                child: getMaxLineFont(
                                                                    context,
                                                                    "Action",
                                                                    45,
                                                                    getFontColor(context),
                                                                    1,
                                                                    fontWeight: FontWeight.w600,
                                                                    textAlign:
                                                                    TextAlign.start)),
                                                          ],
                                                        ),
                                                      ),
                                                      ListView.separated(
                                                        shrinkWrap: true,
                                                        itemCount: list.length,
                                                        separatorBuilder: (context, index) {
                                                          return Container(
                                                            height: 0.5,
                                                            width: double.infinity,
                                                            color: getBorderColor(context),
                                                            margin: EdgeInsets.symmetric(vertical: 4.h),
                                                          );
                                                        },
                                                        itemBuilder: (context, index) {

                                                          SliderModel model =
                                                          SliderModel.fromFirestore(
                                                              list[index]);

                                                          print("image----_${model.customImg}");

                                                          return Container(
                                                            padding: EdgeInsets.symmetric(
                                                                horizontal: 15.w,
                                                                vertical: 15.h),

                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                    width: 80.h,
                                                                    alignment:
                                                                    Alignment.centerLeft,
                                                                    child: getMaxLineFont(
                                                                        context,
                                                                        "${index + 1}",
                                                                        45,
                                                                        getFontColor(context),
                                                                        1,
                                                                        fontWeight:
                                                                        FontWeight.w600,
                                                                        textAlign:
                                                                        TextAlign.start)),
                                                                Expanded(
                                                                  child: SizedBox(
                                                                      width: 100.h,
                                                                      child: Container(
                                                                        height: 50.h,
                                                                        width: 75.h,
                                                                        alignment: Alignment.centerLeft,
                                                                        child: ClipRRect(
                                                                          // borderRadius: BorderRadius
                                                                          //     .circular(10.r),
                                                                          child: Image(
                                                                            image: NetworkImage(
                                                                                model.customImg!),
                                                                          ),
                                                                        ),
                                                                      )),),
                                                                Expanded(
                                                                    child: getMaxLineFont(
                                                                        context,
                                                                        "${model.link}",
                                                                        45,
                                                                        getFontColor(context),
                                                                        1,
                                                                        fontWeight:
                                                                        FontWeight.w600,
                                                                        textAlign:
                                                                        TextAlign.start)),

                                                                Container(
                                                                    width: 50.h,
                                                                    alignment:
                                                                    Alignment.center,
                                                                    child: GestureDetector(
                                                                        onTap: () {
                                                                          _showPopupMenu(
                                                                              context, model);
                                                                        },
                                                                        child: Icon(
                                                                          Icons.delete,
                                                                          color: getSubFontColor(
                                                                              context),
                                                                        )
                                                                    )),

                                                                // Positioned.fill(
                                                                //     child: Center(
                                                                //       child: GestureDetector(
                                                                //
                                                                //           ),
                                                                //     ))
                                                              ],
                                                            ),
                                                          );
                                                          // return Container(
                                                          //   margin: EdgeInsets.symmetric(
                                                          //       vertical: 10),
                                                          //   color: Colors.green,
                                                          //   height: 50,
                                                          // );
                                                        },
                                                      ),

                                                      getVerticalSpace(context,
                                                          (getCommonPadding(context) / 2)),
                                                      getVerticalSpace(context,
                                                          (getCommonPadding(context) / 2)),
                                                    ],
                                                  ),
                                                );
                                              }else{
                                                return Container();
                                              }
                                            } else {
                                              return Container();
                                            }
                                          } else {
                                            return Container();
                                          }
                                        },
                                      )
                                    ],
                                  );
                                }else{
                                  return Center(child: getNoData(context),);
                                }
                              }else{
                                return Container();
                              }

                            },),
                        )




                      ],
                    )))
          ],
        ),
      )),
    );
  }

  updateStatus(BuildContext context, StoryModel storyModel) {
    PrefData.checkAccess(
        context: context,
        function: () {
          getCommonDialog(
              context: context,
              title: storyModel.isActive!
                  ? 'Do you want to de-active this book?'
                  : 'Do you want to active this book?',
              function: () {
                FirebaseData.updateData(
                    context: context,
                    map: {'is_active': storyModel.isActive! ? false : true},
                    doc: storyModel.id!,
                    tableName: KeyTable.storyList,
                    isToast: false,
                    function: () {
                      FirebaseData.refreshSliderData();
                    });
              },
              subTitle: 'Book');
        });
  }

  _showPopupMenu(BuildContext context, SliderModel model) async {
    PrefData.checkAccess(
        context: context,
        function: () {
          getCommonDialog(
              context: context,
              title: 'Do you want to delete this book?',
              function: () {
                FirebaseData.deleteData(
                    tableName: KeyTable.sliderList,
                    doc: model.id!,
                    function: () {
                      FirebaseData.refreshSliderData();
                    });
              },
              subTitle: 'Delete');
        });
  }

  getEntryWidget(BuildContext context) {
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            getTextWidget(context, 'Show entries', 50, getFontColor(context),
                fontWeight: FontWeight.w500),
            getHorizontalSpace(context, 15),
            EntriesDropDown(
                onChanged: (value) {
                  totalItem(value);
                },
                value: totalItem.value),
          ],
        ));
  }
}

class MenuItem extends StatelessWidget {
  const MenuItem({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    this.visibility,
    this.color,
    this.space,
    this.child,
  }) : super(key: key);

  final String title;
  final Color? color;
  final Widget? child;
  final double? space;
  final bool? visibility;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(
            vertical: 12.h,
          ),
          child: Row(
            children: [
              Expanded(
                  child: getMaxLineFont(context, title, 45,
                      color == null ? getFontColor(context) : color!, 1,
                      fontWeight: FontWeight.w500)),
              child == null ? Container() : child!
            ],
          ),
        ),
        Visibility(
          visible: (visibility == null) ? true : visibility!,
          child: Container(
            color: getBorderColor(context),
            width: double.infinity,
            height: 0.5,
          ),
        )
      ],
    ).marginSymmetric(horizontal: space == null ? 35.w : space!);
  }
}
