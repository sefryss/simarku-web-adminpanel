import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebookadminpanel/model/genre_model.dart';
import 'package:ebookadminpanel/ui/genre/subwidget/genre_mobile_widget.dart';
import 'package:ebookadminpanel/ui/genre/subwidget/genre_web_widget.dart';
import 'package:ebookadminpanel/util/common_blank_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ebookadminpanel/controller/data/FirebaseData.dart';
import 'package:ebookadminpanel/main.dart';
import 'package:ebookadminpanel/theme/color_scheme.dart';
import 'package:ebookadminpanel/ui/category/entries_drop_down.dart';
import 'package:ebookadminpanel/ui/common/common.dart';
import '../../../controller/data/key_table.dart';
import '../../../controller/home_controller.dart';
import '../../controller/data/LoginData.dart';
import '../../util/pref_data.dart';

class GenreScreen extends StatefulWidget {
  final Function function;

  GenreScreen({required this.function});

  @override
  State<GenreScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  RxInt position = 0.obs;

  RxInt totalItem = 10.obs;

  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();

    LoginData.getDeviceId();
  }

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
            getTextWidget(context, 'Genre', 75, getFontColor(context),
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
                            isWeb(context)
                                ? Expanded(
                                    child: Container(
                                    child: getEntryWidget(context),
                                  ))
                                : Container(),
                            getHorizontalSpace(context, isWeb(context) ? 0 : 0),
                            Visibility(
                              child: Expanded(child: Container()),
                              visible: isWeb(context),
                            ),
                            Expanded(
                                child: getSearchTextFiledWidget(
                                    context, 'Cari...', textEditingController,
                                    onChanged: (value) {
                              queryText(value);
                            })),
                            getHorizontalSpace(context, 15),
                            getButtonWidget(
                              context,
                              'Tambah Genre',
                              () {
                                HomeController homeController =
                                    Get.find<HomeController>();

                                if (homeController.genreModel != null) {
                                  homeController.genreModel = null;
                                }

                                genreController.clearGenreData();

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
                              .collection(KeyTable.genreList)
                              .orderBy(KeyTable.index, descending: false)
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

                              print("list----${list.length}");

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
                                        // flex: 1,
                                        child: Column(
                                          children: [
                                            isWeb(context)
                                                ? GenreWebWidget(
                                                    mainList: list,
                                                    list: paginationList,
                                                    queryText: queryText,
                                                    function:
                                                        (detail, genreModel) {
                                                      _showPopupMenu(context,
                                                          detail, genreModel);
                                                    },
                                                    onTapStatus: (model) {
                                                      print(
                                                          "called------update");
                                                      updateStatus(
                                                          context, model);
                                                    })
                                                : GenreMobileWidget(
                                                    mainList: list,
                                                    list: paginationList,
                                                    queryText: queryText,
                                                    function: (detail, model) {
                                                      _showPopupMenu(context,
                                                          detail, model);
                                                    },
                                                    onTapStatus: (model) {
                                                      updateStatus(
                                                          context, model);
                                                    }),
                                            getVerticalSpace(
                                                context,
                                                (getCommonPadding(context) /
                                                    2)),
                                            Container(
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
                                                    ),
                                                    getHorizontalSpace(
                                                        context, 25),
                                                    Expanded(child: Container())
                                                  ],
                                                ).marginOnly(
                                                    right: getCommonPadding(
                                                        context)),
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
                    )))
          ],
        ),
      )),
    );
  }

  updateStatus(BuildContext context, Genre genreModel) {
    PrefData.checkAccess(
        context: context,
        function: () {
          getCommonDialog(
              context: context,
              title: genreModel.isActive!
                  ? 'Apakah ingin menonaktifkan genre ini?'
                  : 'Apakah ingin mengaktifkan genre ini?',
              function: () {
                print("dataupdated");
                FirebaseData.updateData(
                    context: context,
                    map: {'is_active': genreModel.isActive! ? false : true},
                    doc: genreModel.id!,
                    tableName: KeyTable.genreList,
                    isToast: false,
                    function: () {});
              },
              subTitle: 'Genre');
        });
  }

  _showPopupMenu(BuildContext context, var detail, Genre genreModel) async {
    final RenderBox? overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    await showMenu(
      context: context,
      position: RelativeRect.fromRect(
          detail & Size(0.h, 0.h), // smaller rect, the touch area
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
              HomeController homeController = Get.find();

              genreController.isStatus = true;

              homeController.setGenreModel(genreModel);
            },
            value: 'Edit'),
        PopupMenuItem<String>(
            child: Container(
              child: MenuItem(
                title: "Hapus",
                space: 0,
                visibility: false,
              ),
            ),
            onTap: () {
              PrefData.checkAccess(
                  context: context,
                  function: () {
                    getCommonDialog(
                        context: context,
                        title: 'Apakah ingin menghapus genre ini?',
                        function: () async {
                          await FirebaseData.deleteData(
                              tableName: KeyTable.genreList,
                              doc: genreModel.id!,
                              function: () {
                                FirebaseData.refreshGenreData();
                              });

                          await FirebaseData.deleteAuthorBatch(() {
                            FirebaseData.refreshGenreData();
                            FirebaseData.refreshStoryData();
                          }, genreModel.id!, KeyTable.storyList,
                              KeyTable.genreId, context);
                        },
                        subTitle: 'Hapus');
                  });

              // PrefData.checkAccess(
              //     context: context,
              //     function: () {
              //       getCommonDialog(
              //           context: context,
              //           title: 'Do you want to delete Author?',
              //           function: () {
              //             FirebaseData.deleteData(
              //                 tableName: KeyTable.authorList,
              //                 doc: authorModel.id!,
              //                 function: () {
              //                   FirebaseData.deleteRecentStory(
              //                       context: context,
              //                       function: (doc) {
              //                         FirebaseData.deleteStory(context: context, function: (doc){
              //                           FirebaseData.deleteData(
              //                               tableName: KeyTable.storyList,
              //                               doc: doc,
              //                               function: () {
              //                                 FirebaseData.deleteBatch(() {
              //                                   FirebaseData.refreshStoryData();
              //                                   FirebaseData.refreshSliderData();
              //                                 },
              //                                     authorModel.id!,
              //                                     KeyTable.sliderList,
              //                                     KeyTable.storyId);
              //                               });
              //                         }, storyId: authorModel.id ?? "");
              //                       },
              //                       storyId: authorModel.id!);
              //                 });
              //           },
              //           subTitle: 'Delete');
              //     });
            },
            value: 'Hapus'),
      ],
      elevation: 1,
    );
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
