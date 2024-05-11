
import 'package:ebookadminpanel/util/common_blank_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ebookadminpanel/controller/home_controller.dart';
import 'package:ebookadminpanel/model/story_model.dart';
import 'package:ebookadminpanel/theme/app_theme.dart';
import 'package:ebookadminpanel/theme/color_scheme.dart';
import 'package:ebookadminpanel/ui/common/common.dart';

import '../../../controller/data/LoginData.dart';
import '../../../main.dart';
import '../../../util/constants.dart';
import '../../../util/responsive.dart';
import '../../home/home_page.dart';
import '../category_drop_down.dart';
import '../subwidget/status_drop_down.dart';

class AddStoryScreen extends StatefulWidget {
  final Function function;
  final StoryModel? storyModel;

  AddStoryScreen({required this.function, this.storyModel});

  @override
  State<AddStoryScreen> createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {

  @override
  void initState() {
    super.initState();

    LoginData.getDeviceId();
  }
  @override
  Widget build(BuildContext context) {

    HomeController homeController = Get.find();

    bool isEdit = widget.storyModel != null;
    return SafeArea(
      child: CommonPage(widget: Container(
        margin: EdgeInsets.symmetric(
            horizontal: getDefaultHorSpace(context),
            vertical: getDefaultHorSpace(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getTextWidget(
                context,
                isEdit ? 'Edit Book' : 'Add Book',
                75,
                getFontColor(context),
                fontWeight: FontWeight.w700),
            getVerticalSpace(context, 35),
            Expanded(
              child: getCommonContainer(
                context: context,
                verSpace: 0,
                horSpace: isWeb(context) ? null : 15.h,

                // width: double.infinity,
                // height: double.infinity,
                // decoration: getDefaultDecoration(
                //     bgColor: getCardColor(context), radius: radius),
                // padding: EdgeInsets.all(padding),
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: ListView(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          getVerticalSpace(context, 30),

                          getCommonBackIcon(context,onTap: (){changeAction(actionStories);}),

                          getVerticalSpace(context, 30),


                          // Row(
                          //   children: [
                          //     Expanded(
                          //       child: getTextWidget(
                          //           context,
                          //           isEdit ? 'Edit Book' : 'Add Book',
                          //           75,
                          //           getFontColor(context),
                          //           fontWeight: FontWeight.w700),
                          //       flex: 1,
                          //     ),
                          //   ],
                          // ),
                          // getVerticalSpace(context, 40),
                          Responsive.isMobile(context)
                              ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              itemSubTitle('Book Title', context),
                              getVerticalSpace(context, 10),
                              getTextFiledWidget(context, "Enter title..",
                                  storyController.nameController),
                              getVerticalSpace(context, 30),
                              itemSubTitle('Select Category', context),
                              getVerticalSpace(context, 10),
                              Obx(() {
                                return homeController.category.value.isNotEmpty
                                    ? homeController.categoryList.length == 1
                                    ? getDisableDropDownWidget(
                                  context,
                                  homeController.categoryList[0].name!,
                                )
                                    : CategoryDropDown(
                                  homeController,
                                  value: homeController.category.value,
                                  onChanged: (value) {

                                    print("value--------${homeController.category.value}");
                                    if (value !=
                                        homeController.category.value) {
                                      homeController.category(value);
                                    }
                                  },
                                )
                                    : getDisableTextFiledWidget(
                                  context,
                                  homeController.isLoading.value
                                      ? "Loading.."
                                      : "No Data",
                                );
                              }),
                              getVerticalSpace(context, 30),
                              itemSubTitle('Select Author', context),
                              getVerticalSpace(context, 10),
                              getTextFiledWidget(context, "Author",
                                  storyController.authController,
                                  isEnabled: false,
                                  child: InkWell(
                                    onTap: () {

                                      if(homeController.authorList.isNotEmpty && homeController.authorList.length > 0){
                                        storyController.showAuthorDialog(context,homeController);
                                      }else{
                                        showCustomToast(context: context, message: "No Data");
                                      }

                                    },
                                    child: Container(
                                      height: double.infinity,
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.only(left: 8.h),
                                      // margin: EdgeInsets.all(7.h),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.h, vertical: 5.h),
                                      decoration: getDefaultDecoration(
                                          bgColor: getReportColor(context),
                                          borderColor: borderColor,
                                          radius: getResizeRadius(context, 10)),
                                      child: getTextWidget(
                                        context,
                                        'Select Author',
                                        40,
                                        getSubFontColor(context),
                                        customFont: "",
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  )),
                              getVerticalSpace(context, 30),
                              itemSubTitle('Type', context),
                              getVerticalSpace(context, 10),
                              Obx(() {
                                return PDFDropDown(
                                  homeController,
                                  value: homeController.pdf.value,
                                  onChanged: (value) {
                                    if (value !=
                                        homeController.pdf.value) {
                                      homeController.pdf(value);
                                    }
                                  },
                                );
                              }),
                              getVerticalSpace(context, 30),
                              Obx(() {
                                return (homeController.pdf.value ==
                                    Constants.url)
                                    ? itemSubTitle('URL', context)
                                    : itemSubTitle('Upload PDF', context);
                              }),
                              getVerticalSpace(context, 10),
                              Obx(() => (homeController.pdf.value == Constants.url)
                                  ? getTextFiledWidget(
                                  context,
                                  "Enter url..",
                                  storyController.pdfController)
                                  : Obx(() => getTextFiledWidget(
                                  context,
                                  "No file chosen",
                                  TextEditingController(
                                      text: storyController.pdfUrl.value),
                                  isEnabled: false,
                                  child: getCommonChooseFileBtn(context, (){storyController.openFile();}))),),

                              Obx(() {
                                return (storyController.pdfUrl.value.isNotEmpty)
                                    ? Container(
                                  margin: EdgeInsets.only(top: 35.h),
                                  padding: EdgeInsets.all(22.h),
                                  width: double.infinity,
                                  decoration: getDefaultDecoration(
                                    bgColor: getReportColor(context),
                                    radius: getResizeRadius(context, 25),
                                  ),
                                  child: Row(
                                    children: [
                                      imageAsset("pdf.png",
                                          height: 44.h, width: 32.h),
                                      getHorizontalSpace(context, 20),
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Obx(() => getTextWidget(
                                                context,
                                                storyController.pdfUrl.value,
                                                50,
                                                getFontColor(context))),
                                            getVerticalSpace(context, 10),
                                            getTextWidget(
                                                context,
                                                storyController.pdfSize.value,
                                                40,
                                                getFontColor(context))
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            storyController.pdfUrl.value = "";
                                          },
                                          child: imageAsset("trash.png",
                                              height: 24.h, width: 24.h))
                                    ],
                                  ),
                                )
                                    : Container();
                              }),
                              getVerticalSpace(context, 30),
                              itemSubTitle('Book Image', context),
                              getVerticalSpace(context, 10),
                              getTextFiledWidget(context, "No file chosen",
                                  storyController.imageController,
                                  isEnabled: false,
                                  child: getCommonChooseFileBtn(context, (){storyController.imgFromGallery();})),
                              getVerticalSpace(context, 30),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Obx(() {
                                  return (storyController.isImageOffline.value)
                                      ? ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        (getResizeRadius(context,
                                            35))), //add border radius
                                    child: (storyController.isSvg)?Image.asset(Constants.placeImage,height: 100.h,width: 100.h,fit: BoxFit.contain,):Image.memory(
                                      storyController.webImage,
                                      height: 100.h,
                                      width: 100.h,
                                      fit: BoxFit.contain,
                                    ),
                                  )
                                      : isEdit
                                      ? ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        (getResizeRadius(context,
                                            35))), //add border radius
                                    child: (widget.storyModel!.image!.split(".").last.startsWith("svg"))?Image.asset(Constants.placeImage,height: 150.h,width: 200.h,fit: BoxFit.contain,):Image.network(
                                      widget.storyModel!.image!,
                                      height: 150.h,
                                      width: 200.h,
                                      fit: BoxFit.contain,
                                    ),
                                  )
                                      : Container();
                                }),
                              ),
                              // getVerticalSpace(context, 30),
                              itemSubTitle('Description', context),
                              getVerticalSpace(context, 10),

                              Container(
                                // margin: EdgeInsets.all(value),
                                decoration: getDefaultDecoration(
                                    radius: getDefaultRadius(context),
                                    bgColor: getCardColor(context),
                                    // bgColor: getReportColor(context),
                                    borderColor: getBorderColor(context),
                                    borderWidth: 1),
                                child: Column(
                                  children: [
                                    getVerticalSpace(context, 10),
                                    Container(
                                      margin: EdgeInsets.all(8.h),
                                      decoration: getDefaultDecoration(
                                          radius: getDefaultRadius(context),
                                          bgColor: getCardColor(context),
                                          borderColor: getBorderColor(context),
                                          borderWidth: 1),
                                      child: QuillToolbar.simple(

                                        configurations: QuillSimpleToolbarConfigurations(
                                            controller: storyController.descController
                                        ),
                                        // iconTheme: QuillIconTheme(
                                        //     iconUnselectedFillColor: Colors.transparent
                                        // ),
                                        // controller: storyController.descController
                                      ),
                                    ),
                                    Container(
                                      child: QuillEditor(
                                        focusNode: FocusNode(),
                                        scrollController: ScrollController(),
                                        configurations: QuillEditorConfigurations(
                                          readOnly: false,
                                            controller: storyController.descController
                                        ),


                                        // true for view only mode
                                      ).paddingSymmetric(
                                          vertical: 15.h, horizontal: 15),
                                    ).marginSymmetric(vertical: 15.h),
                                  ],
                                ),
                              ),




                              getVerticalSpace(context, 30),
                              itemSubTitle('Is Popular?', context),
                              getVerticalSpace(context, 10),
                              Container(
                                height: 30.h,
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: Obx(() => CupertinoSwitch(
                                      activeColor: getPrimaryColor(context),
                                      value: storyController.isPopular.value,
                                      onChanged: (value) {
                                        storyController.isPopular.value = value;
                                      })),
                                ),
                              ),
                              getVerticalSpace(context, 30),
                              itemSubTitle('Is Featured?', context),
                              getVerticalSpace(context, 10),
                              Container(
                                height: 30.h,
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: Obx(() => CupertinoSwitch(
                                      activeColor: getPrimaryColor(context),
                                      value: storyController.isFeatured.value,
                                      onChanged: (value) {
                                        storyController.isFeatured.value = value;
                                      })),
                                ),
                              ),
                            ],
                          )
                              : Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          itemSubTitle('Book Title', context),
                                          getVerticalSpace(context, 10),
                                          getTextFiledWidget(context, "Enter title..",
                                              storyController.nameController),
                                        ],
                                      )),
                                  getHorizontalSpace(context, 10),
                                  Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          itemSubTitle('Select Category', context),
                                          getVerticalSpace(context, 10),
                                          Obx(() {
                                            return homeController
                                                .category.value.isNotEmpty
                                                ? homeController
                                                .categoryList.length ==
                                                1
                                                ? getDisableDropDownWidget(
                                              context,
                                              homeController
                                                  .categoryList[0].name!,
                                            )
                                                : CategoryDropDown(
                                              homeController,
                                              value: homeController
                                                  .category.value,
                                              onChanged: (value) {

                                                print("value--------${homeController.category.value}");
                                                if (value !=
                                                    homeController
                                                        .category.value) {
                                                  homeController
                                                      .category(value);
                                                }
                                              },
                                            )
                                                : getDisableTextFiledWidget(
                                              context,
                                              homeController.isLoading.value
                                                  ? "Loading.."
                                                  : "No Data",
                                            );
                                          })
                                        ],
                                      )),
                                  getHorizontalSpace(context, 10),
                                  Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          itemSubTitle('Select Author', context),
                                          getVerticalSpace(context, 10),
                                          getTextFiledWidget(context, "Author",
                                              storyController.authController,
                                              isEnabled: false,
                                              child: InkWell(
                                                onTap: () {

                                                  if(homeController.authorList.isNotEmpty && homeController.authorList.length > 0){
                                                    storyController.showAuthorDialog(context,homeController);
                                                  }else{
                                                    showCustomToast(context: context, message: "No Data");
                                                  }

                                                },
                                                child: Container(
                                                  height: double.infinity,
                                                  alignment: Alignment.center,
                                                  margin: EdgeInsets.only(left: 8.h),
                                                  // margin: EdgeInsets.all(7.h),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10.h, vertical: 5.h),
                                                  decoration: getDefaultDecoration(
                                                      bgColor: getReportColor(context),
                                                      borderColor: borderColor,
                                                      radius: getResizeRadius(context, 10)),
                                                  child: getTextWidget(
                                                    context,
                                                    'Select Author',
                                                    40,
                                                    getSubFontColor(context),
                                                    customFont: "",
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              )),
                                        ],
                                      )),
                                ],
                              ),
                              getVerticalSpace(context, 30),
                              Row(
                                children: [
                                  Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          itemSubTitle('Type', context),
                                          getVerticalSpace(context, 10),
                                          Obx(() {
                                            return PDFDropDown(
                                              homeController,
                                              value: homeController.pdf.value,
                                              onChanged: (value) {
                                                if (value !=
                                                    homeController.pdf.value) {
                                                  homeController.pdf(value);
                                                }
                                              },
                                            );
                                          }),
                                        ],
                                      )),
                                  getHorizontalSpace(context, 10),
                                  Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Obx(() {
                                            return (homeController.pdf.value ==
                                                Constants.url)
                                                ? itemSubTitle('URL', context)
                                                : itemSubTitle('Upload PDF', context);
                                          }),
                                          getVerticalSpace(context, 10),
                                          Obx(() => (homeController.pdf.value == Constants.url)
                                              ? getTextFiledWidget(
                                              context,
                                              "Enter url..",
                                              storyController.pdfController)
                                              : Obx(() => getTextFiledWidget(
                                              context,
                                              "No file chosen",
                                              TextEditingController(
                                                  text: storyController.pdfUrl.value),
                                              isEnabled: false,
                                              child: getCommonChooseFileBtn(context, (){storyController.openFile();}))),),
                                        ],
                                      )),
                                ],
                              ),

                              Obx(() {
                                return (storyController
                                    .pdfUrl.value.isNotEmpty)
                                    ? Container(
                                  margin: EdgeInsets.only(
                                      top: 35.h),
                                  padding:
                                  EdgeInsets.all(22.h),
                                  width: double.infinity,
                                  decoration:
                                  getDefaultDecoration(
                                    bgColor: getReportColor(
                                        context),
                                    radius: getResizeRadius(
                                        context, 25),
                                  ),
                                  child: Row(
                                    children: [
                                      imageAsset("pdf.png",
                                          height: 44.h,
                                          width: 32.h),
                                      getHorizontalSpace(
                                          context, 20),
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .center,
                                          children: [
                                            Obx(() => getTextWidget(
                                                context,
                                                storyController
                                                    .pdfUrl
                                                    .value,
                                                50,
                                                getFontColor(
                                                    context))),
                                            getVerticalSpace(
                                                context, 10),
                                            getTextWidget(
                                                context,
                                                storyController
                                                    .pdfSize
                                                    .value,
                                                40,
                                                getFontColor(
                                                    context))
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            storyController.pdfUrl
                                                .value = "";
                                          },
                                          child: imageAsset(
                                              "trash.png",
                                              height: 24.h,
                                              width: 24.h))
                                    ],
                                  ),
                                )
                                    : Container();
                              }),
                              getVerticalSpace(context, 30),
                              Row(
                                children: [
                                  Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          itemSubTitle('Book Image', context),
                                          getVerticalSpace(context, 10),
                                          getTextFiledWidget(
                                              context,
                                              "No file chosen",
                                              storyController.imageController,
                                              isEnabled: false,
                                              child: getCommonChooseFileBtn(context, (){storyController.imgFromGallery();})),
                                        ],
                                      )),
                                  getHorizontalSpace(context, 10),
                                  Expanded(
                                    child: Column(
                                      children: [

                                        itemSubTitle("", context),
                                        getVerticalSpace(context, 10),
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Obx(() {
                                            return (storyController.isImageOffline.value)
                                                ? ClipRRect(
                                              borderRadius: BorderRadius
                                                  .circular((getResizeRadius(
                                                  context,
                                                  35))), //add border radius
                                              child: (storyController.isSvg)?Image.asset(Constants.placeImage,height: 100.h,width: 100.h,fit: BoxFit.contain,):Image.memory(
                                                storyController.webImage,
                                                height: 100.h,
                                                width: 100.h,
                                                fit: BoxFit.contain,
                                              ),
                                            )
                                                : isEdit
                                                ? ClipRRect(
                                              borderRadius: BorderRadius
                                                  .circular((getResizeRadius(
                                                  context,
                                                  35))), //add border radius
                                              child: (widget.storyModel!.image!.split(".").last.startsWith("svg"))?Image.asset(Constants.placeImage,height: 100.h,width: 100.h,fit: BoxFit.contain,):Image.network(
                                                widget.storyModel!.image!,
                                                height: 100.h,
                                                width: 100.h,
                                                fit: BoxFit.contain,
                                              ),
                                            )
                                                : Container();
                                          }),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(child: Container())
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          getVerticalSpace(context, 30),
                                          itemSubTitle('Description', context),
                                          getVerticalSpace(context, 10),
                                          Container(
                                            decoration: getDefaultDecoration(
                                                radius: getDefaultRadius(context),
                                                bgColor: getCardColor(context),
                                                // bgColor: getReportColor(context),
                                                borderColor: getBorderColor(context),
                                                borderWidth: 1),
                                            child: Column(
                                              children: [
                                                getVerticalSpace(context, 10),
                                                Container(
                                                  decoration: getDefaultDecoration(
                                                      radius: getDefaultRadius(context),
                                                      bgColor: getCardColor(context),
                                                      borderColor: getBorderColor(context),
                                                      borderWidth: 1),
                                                  child: QuillToolbar.simple(
                                                      configurations: QuillSimpleToolbarConfigurations(controller: storyController.descController)



                                                    // configurations: QuillToolbarConfigurations(
                                                    //   // iconTheme: QuillIconTheme(
                                                    //   //     iconUnselectedFillColor: Colors.transparent
                                                    //   // ),
                                                    //   //   controller:
                                                    //   //   storyController.descController
                                                    // ),
                                                  ),
                                                ),
                                                Container(
                                                  child: QuillEditor.basic(


                                                    configurations: QuillEditorConfigurations(controller: storyController.descController),

                                                    // configurations: QuillEditorConfigurations(
                                                    //   readOnly:
                                                    //   false,
                                                    //
                                                    // ),
                                                    scrollController: ScrollController(),
                                                    focusNode: FocusNode(),
                                                  ).paddingSymmetric(
                                                      vertical: 15.h, horizontal: 15),
                                                ).marginSymmetric(vertical: 15.h),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )),
                                  getHorizontalSpace(context, 10),
                                  Expanded(
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: Column(
                                                children: [
                                                  itemSubTitle('Is Popular?', context),
                                                  getVerticalSpace(context, 10),
                                                  Container(
                                                    height: 30.h,
                                                    child: FittedBox(
                                                      fit: BoxFit.fitHeight,
                                                      child: Obx(() => CupertinoSwitch(
                                                          activeColor:
                                                          getPrimaryColor(context),
                                                          value:
                                                          storyController.isPopular.value,
                                                          onChanged: (value) {
                                                            storyController.isPopular.value =
                                                                value;
                                                          })),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                          Expanded(
                                              child: Column(

                                                children: [
                                                  itemSubTitle('Is Featured?', context),
                                                  getVerticalSpace(context, 10),
                                                  Container(
                                                    height: 30.h,
                                                    child: FittedBox(
                                                      fit: BoxFit.fitHeight,
                                                      child: Obx(() => CupertinoSwitch(
                                                          activeColor:
                                                          getPrimaryColor(context),
                                                          value:
                                                          storyController.isFeatured.value,
                                                          onChanged: (value) {
                                                            storyController.isFeatured.value =
                                                                value;
                                                          })),
                                                    ),
                                                  ),
                                                ],
                                              ))
                                        ],
                                      )),
                                ],
                              ),
                            ],
                          ),

                          // Obx(() => controller.isLoading.value
                          //     ? getProgressWidget(context)
                          //     : Container())
                        ],
                      ),
                    ),
                    getVerticalSpace(context, 20),


                    Row(
                      children: [
                        Obx(() => getButtonWidget(
                          context,
                          isEdit ? 'Update' : 'Save',
                          isProgress: storyController.isLoading.value,
                              () {
                            if (isEdit) {
                              storyController.editCategory(homeController, context,
                                      () {
                                    widget.function();
                                  });
                            } else {
                              storyController.addStory(context, homeController,
                                      () {
                                    widget.function();
                                  });
                            }
                          },
                          horPadding: 25.h,
                          horizontalSpace: 0,
                          verticalSpace: 0,
                          btnHeight: 40.h,
                        )),
                      ],
                    ),
                    getVerticalSpace(context, 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}

itemSubTitle(String s, BuildContext context, {Color? color}) {
  return getTextWidget(
    context,
    s,
    45,
    color == null ? getFontColor(context) : color,
    fontWeight: FontWeight.w500,
  );
}
