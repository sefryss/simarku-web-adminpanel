import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebookadminpanel/util/common_blank_page.dart';
import 'package:ebookadminpanel/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ebookadminpanel/controller/data/FirebaseData.dart';
import 'package:ebookadminpanel/main.dart';
import 'package:ebookadminpanel/model/category_model.dart';
import 'package:ebookadminpanel/theme/color_scheme.dart';
import 'package:ebookadminpanel/ui/category/entries_drop_down.dart';
import 'package:ebookadminpanel/ui/common/common.dart';
import '../../../controller/data/key_table.dart';
import '../../../controller/home_controller.dart';
import '../../controller/data/LoginData.dart';
import '../../util/pref_data.dart';

class CategoryScreen extends StatefulWidget {
  final Function function;

  CategoryScreen({required this.function});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    super.initState();

    LoginData.getDeviceId();
  }

  RxInt position = 0.obs;

  RxInt totalItem = 10.obs;

  RxInt ind = 0.obs;

  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final TextEditingController textEditingController = TextEditingController();
    RxString queryText = ''.obs;

    return SafeArea(
      child: CommonPage(
          widget: Container(
        margin: EdgeInsets.symmetric(
            horizontal: getDefaultHorSpace(context),
            vertical: getDefaultHorSpace(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getTextWidget(context, 'Categories', 75, getFontColor(context),
                fontWeight: FontWeight.w700),
            getVerticalSpace(context, 35),
            Expanded(
                child: getCommonContainer(
                    context: context,
                    verSpace: 0,
                    horSpace: isWeb(context) ? null : 15.h,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getVerticalSpace(context, getCommonPadding(context)),
                        Row(
                          children: [
                            isWeb(context)
                                ? Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      child: getEntryWidget(context),
                                    ),
                                  )
                                : Container(),
                            getHorizontalSpace(context, isWeb(context) ? 0 : 0),
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
                              'Add New Category',
                              () {
                                // HomeController homeController = Get.find<HomeController>();
                                //
                                // if(homeController.storyModel != null){
                                //   homeController.storyModel = null;
                                // }
                                //
                                //
                                // storyController.clearData();
                                //
                                //
                                // // Future.delayed(Duration.zero,() {
                                // //   // Get.delete<StoryController>();
                                // //
                                // //   print("homecontroller-----${homeController.storyModel}");
                                // //
                                // //   // Get.put(StoryController(storyModel: homeController.storyModel,homeController: homeController));
                                // // },);

                                widget.function();
                              },
                              horPadding: 25.h,
                              horizontalSpace: 0,
                              verticalSpace: 0,
                              btnHeight: 42.h,
                            )
                          ],
                        ),
                        isWeb(context)
                            ? Container()
                            : Container(
                                child: getEntryWidget(context),
                                margin: EdgeInsets.only(top: 15.h),
                              ),
                        getVerticalSpace(context, 25),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection(KeyTable.keyCategoryTable)
                              .orderBy(KeyTable.refId, descending: true)
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
                              List<DocumentSnapshot> list = snapshot.data!.docs;

                              // int index = list.;

                              print("index----${ind.value}");

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

                                print(
                                    "pos==${position.value}==${paginationList.length}");

                                return paginationList.length > 0
                                    ? Expanded(
                                        flex: 1,
                                        child: Column(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 15.w,
                                                  vertical: 15.h),
                                              decoration: getDefaultDecoration(
                                                  bgColor:
                                                      getReportColor(context),
                                                  radius: 0),
                                              child: Row(
                                                children: [
                                                  Container(
                                                      width: isWeb(context)
                                                          ? 130.h
                                                          : 80.h,
                                                      child: getMaxLineFont(
                                                          context,
                                                          'ID',
                                                          50,
                                                          getFontColor(context),
                                                          1,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          textAlign:
                                                              TextAlign.start)),
                                                  Expanded(
                                                      child: Row(
                                                    children: [
                                                      Container(
                                                        width: 150.h,
                                                        child: getMaxLineFont(
                                                            context,
                                                            'Image',
                                                            50,
                                                            getFontColor(
                                                                context),
                                                            1,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            textAlign: TextAlign
                                                                .start),
                                                      ),
                                                      getHorizontalSpace(
                                                        context,
                                                        10,
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: getMaxLineFont(
                                                            context,
                                                            'Category',
                                                            50,
                                                            getFontColor(
                                                                context),
                                                            1,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            textAlign: TextAlign
                                                                .start),
                                                      ),
                                                    ],
                                                  )),
                                                  getMaxLineFont(
                                                      context,
                                                      'Action',
                                                      50,
                                                      getFontColor(context),
                                                      1,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      textAlign:
                                                          TextAlign.start)
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                                child: ListView.separated(
                                              itemCount: paginationList.length,
                                              controller: _controller,
                                              shrinkWrap: true,
                                              separatorBuilder:
                                                  (context, index) {
                                                return Obx(() {
                                                  CategoryModel model =
                                                      CategoryModel
                                                          .fromFirestore(
                                                              paginationList[
                                                                  index]);

                                                  bool cell = true;

                                                  if (queryText
                                                          .value.isNotEmpty &&
                                                      !model.name!
                                                          .toLowerCase()
                                                          .contains(queryText
                                                              .value
                                                              .toLowerCase())) {
                                                    cell = false;
                                                  }

                                                  print("cell===$cell");
                                                  return cell
                                                      ? separatorBuilder(
                                                          context,
                                                          value: model.name,
                                                          queryText: queryText)
                                                      : Container();
                                                });
                                              },
                                              itemBuilder: (context, index) {
                                                return Obx(() {
                                                  bool cell = true;
                                                  CategoryModel model =
                                                      CategoryModel
                                                          .fromFirestore(
                                                              paginationList[
                                                                  index]);

                                                  if (queryText
                                                          .value.isNotEmpty &&
                                                      !model.name!
                                                          .toLowerCase()
                                                          .contains(queryText
                                                              .value
                                                              .toLowerCase())) {
                                                    cell = false;
                                                  }
                                                  return cell
                                                      ? Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      15.w,
                                                                  vertical:
                                                                      15.h),
                                                          decoration:
                                                              getDefaultDecoration(
                                                                  bgColor:
                                                                      getCardColor(
                                                                          context),
                                                                  radius: 0),
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                  width: isWeb(
                                                                          context)
                                                                      ? 130.h
                                                                      : 80.h,
                                                                  child: getMaxLineFont(
                                                                      context,
                                                                      '${list.indexOf(paginationList[index]) + 1}',
                                                                      // (position.value != 0)?'${position.value}${index + 1}':"${d}",
                                                                      50,
                                                                      getFontColor(context),
                                                                      1,
                                                                      fontWeight: FontWeight.w600,
                                                                      textAlign: TextAlign.start)),
                                                              Expanded(
                                                                  child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Container(
                                                                    width:
                                                                        150.h,
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          50.h,
                                                                      width:
                                                                          75.h,
                                                                      child:
                                                                          ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10.r),
                                                                        child: (model.image!.isNotEmpty &&
                                                                                model.image!.split(".").last.startsWith("svg"))
                                                                            ? Image.asset(Constants.placeImage)
                                                                            : Image(
                                                                                image: NetworkImage(model.image!),
                                                                              ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  getHorizontalSpace(
                                                                    context,
                                                                    10,
                                                                  ),
                                                                  Expanded(
                                                                      child: getMaxLineFont(
                                                                          context,
                                                                          model
                                                                              .name!,
                                                                          50,
                                                                          getFontColor(
                                                                              context),
                                                                          1,
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          textAlign:
                                                                              TextAlign.start)),
                                                                ],
                                                              )),
                                                              Stack(
                                                                children: [
                                                                  getMaxLineFont(
                                                                      context,
                                                                      'Action',
                                                                      50,
                                                                      Colors
                                                                          .transparent,
                                                                      1,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start),
                                                                  Positioned
                                                                      .fill(
                                                                          child:
                                                                              Center(
                                                                    child: GestureDetector(
                                                                        onTapDown: _storePosition,
                                                                        onTap: () {
                                                                          _showPopupMenu(context, onTapDelete:
                                                                              () {
                                                                            PrefData.checkAccess(
                                                                                context: context,
                                                                                function: () {
                                                                                  getCommonDialog(
                                                                                      context: context,
                                                                                      title: 'Do you want to delete this category?',
                                                                                      function: () async {
                                                                                        await FirebaseData.deleteData(
                                                                                            tableName: KeyTable.keyCategoryTable,
                                                                                            doc: model.id!,
                                                                                            function: () {
                                                                                              FirebaseData.refreshCategoryData();
                                                                                            });

                                                                                        await FirebaseData.deleteBatch(() {
                                                                                          FirebaseData.refreshCategoryData();
                                                                                          FirebaseData.refreshStoryData();
                                                                                        }, model.id!, KeyTable.storyList, KeyTable.refId);

                                                                                        await FirebaseData.deleteBatch(() {
                                                                                          FirebaseData.refreshAuthorData();
                                                                                        }, model.id!, KeyTable.authorList, KeyTable.refId);
                                                                                      },
                                                                                      subTitle: 'Delete');
                                                                                });
                                                                          }, onTapEdit:
                                                                              () {
                                                                            HomeController
                                                                                homeController =
                                                                                Get.find();
                                                                            homeController.setCategoryModel(model);
                                                                          });
                                                                        },
                                                                        child: Icon(
                                                                          Icons
                                                                              .more_vert,
                                                                          color:
                                                                              getSubFontColor(context),
                                                                        )),
                                                                  ))
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      : Container();
                                                });
                                              },
                                            )),
                                            getVerticalSpace(
                                                context,
                                                (getCommonPadding(context) /
                                                    2)),
                                            Container(
                                              // height: 55.h,
                                              width: double.infinity,

                                              child: Center(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        print(
                                                            "posi===${position.value}===${i - 1}");
                                                        if (position.value >
                                                            0) {
                                                          position.value =
                                                              position.value -
                                                                  1;
                                                        }
                                                      },
                                                      child: getSvgImage1(
                                                        'left.svg',
                                                        height: 20.h,
                                                        width: 20.h,
                                                      ),

                                                      // child: Icon(
                                                      //   Icons.chevron_left,
                                                      //   color: subPrimaryColor(context),
                                                      // )
                                                    ),
                                                    getHorizontalSpace(
                                                        context, 10),
                                                    Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children:
                                                              List.generate(
                                                                  i.toInt(),
                                                                  (index) =>
                                                                      InkWell(
                                                                        child:
                                                                            Container(
                                                                          margin:
                                                                              EdgeInsets.symmetric(horizontal: 5.h),
                                                                          height:
                                                                              35.h,
                                                                          width:
                                                                              35.h,

                                                                          decoration: getDefaultDecoration(
                                                                              bgColor: position.value == index ? getPrimaryColor(context) : Colors.transparent,
                                                                              radius: getResizeRadius(context, 15)),
                                                                          // decoration: BoxDecoration(
                                                                          //     shape: BoxShape
                                                                          //         .circle,
                                                                          //     color: position
                                                                          //         .value ==
                                                                          //         index
                                                                          //         ? getPrimaryColor(context)
                                                                          //         : getBorderColor(
                                                                          //         context)),
                                                                          child:
                                                                              Center(
                                                                            child: getTextWidget(
                                                                                context,
                                                                                '${index + 1}',
                                                                                50,
                                                                                position.value == index ? Colors.white : subPrimaryColor(context)),
                                                                          ),
                                                                        ),
                                                                        onTap:
                                                                            () {
                                                                          position.value =
                                                                              index;
                                                                          _controller
                                                                              .jumpTo(0);
                                                                        },
                                                                      )),
                                                        ),
                                                      ),
                                                    ),
                                                    getHorizontalSpace(
                                                        context, 10),
                                                    InkWell(
                                                      onTap: () {
                                                        print(
                                                            "posi===${position.value}===${i - 1}");
                                                        if (position.value <
                                                            (i.toInt() - 1)) {
                                                          position.value =
                                                              position.value +
                                                                  1;
                                                        }
                                                      },

                                                      child: getSvgImage1(
                                                        'right.svg',
                                                        height: 18.h,
                                                        width: 18.h,
                                                      ),
                                                      // child: Icon(
                                                      //   Icons.chevron_right,
                                                      //   color: subPrimaryColor(context),
                                                      // )
                                                    ),
                                                    getHorizontalSpace(
                                                        context, 25),
                                                    Expanded(
                                                        child: Container(
                                                            // child: isWeb(context)
                                                            //     ? getEntryWidget(
                                                            //     context)
                                                            //     : Container(),
                                                            ))
                                                  ],
                                                ),
                                              ),
                                            ),
                                            getVerticalSpace(
                                                context,
                                                (getCommonPadding(context) /
                                                    2)),
                                          ],
                                        ),
                                      )
                                    : Center(child: getNoData(context));
                              });
                            } else {
                              return Container();
                            }
                          },
                        )
                      ],
                    ))),
            getVerticalSpace(context, isWeb(context) ? 0 : 35),
          ],
        ),
      )),
    );
  }

  getEntryWidget(BuildContext context) {
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.end,
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

  var _tapPosition;

  _showPopupMenu(BuildContext context,
      {required Function onTapEdit, required Function onTapDelete}) async {
    final RenderBox? overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    await showMenu(
      context: context,
      position: RelativeRect.fromRect(
          _tapPosition & Size(0.h, 0.h), // smaller rect, the touch area
          Offset.zero & overlay!.size // Bigger rect, the entire screen
          ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      color: themeController.checkDarkTheme()
          ? getBackgroundColor(context)
          : getCardColor(context),
      items: [
        PopupMenuItem<String>(
            child: Container(
              child: MenuItem(
                title: "Edit",
                space: 0,
              ),
            ),
            onTap: () {
              onTapEdit();
            },
            value: 'Edit'),
        PopupMenuItem<String>(
            child: Container(
              child: MenuItem(
                title: "Delete",
                space: 0,
                visibility: false,
              ),
            ),
            onTap: () {
              onTapDelete();
            },
            value: 'Delete'),
      ],
      elevation: 1.0,
    );
  }

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
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
              // child == null ? Container() : child!
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
