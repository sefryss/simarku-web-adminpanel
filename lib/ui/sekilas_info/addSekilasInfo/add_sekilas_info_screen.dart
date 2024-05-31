import 'package:ebookadminpanel/main.dart';
import 'package:ebookadminpanel/model/sekilas_info_model.dart';
import 'package:ebookadminpanel/util/common_blank_page.dart';
import 'package:ebookadminpanel/util/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ebookadminpanel/controller/home_controller.dart';
import 'package:ebookadminpanel/theme/color_scheme.dart';
import 'package:ebookadminpanel/ui/common/common.dart';
import 'package:intl/intl.dart';
import '../../../controller/data/LoginData.dart';
import '../../../util/responsive.dart';

import '../../home/home_page.dart';

class AddSekilasInfoScreen extends StatefulWidget {
  final Function function;
  final SekilasInfoModel? sekilasInfoModel;

  AddSekilasInfoScreen({required this.function, this.sekilasInfoModel});

  @override
  State<AddSekilasInfoScreen> createState() => _AddSekilasInfoScreenState();
}

class _AddSekilasInfoScreenState extends State<AddSekilasInfoScreen> {
  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.find();

    bool isEdit = widget.sekilasInfoModel != null;
    return SafeArea(
      child: CommonPage(
          widget: Container(
        margin: EdgeInsets.symmetric(
            horizontal: getDefaultHorSpace(context),
            vertical: getDefaultHorSpace(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getTextWidget(
                context,
                isEdit ? 'Edit Sekilas Info' : 'Tambah Sekilas Info',
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
                      child: ListView(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          getVerticalSpace(context, 30),
                          getCommonBackIcon(context, onTap: () {
                            changeAction(actionSekilasInfo);
                          }),

                          getVerticalSpace(context, 30),

                          // Row(
                          //   children: [
                          //     Expanded(
                          //       child: getTextWidget(
                          //           context,
                          //           isEdit ? 'Edit Author' : 'Add Author',
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
                                    itemSubTitle('Sekilas Info', context),
                                    getVerticalSpace(context, 10),
                                    getTextFiledWidget(
                                        context,
                                        "Masukkan Judul",
                                        sekilasInfoController.titleController),
                                    getVerticalSpace(context, 30),
                                    itemSubTitle('Status', context),
                                    getVerticalSpace(context, 10),
                                    Container(
                                      height: 30.h,
                                      child: FittedBox(
                                        fit: BoxFit.fitHeight,
                                        child: Obx(() => CupertinoSwitch(
                                            activeColor:
                                                getPrimaryColor(context),
                                            value: sekilasInfoController
                                                .activeStatus.value,
                                            onChanged: (value) {
                                              sekilasInfoController
                                                  .activeStatus.value = value;
                                            })),
                                      ),
                                    ),
                                    getVerticalSpace(context, 30),
                                  ],
                                )
                              : Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              itemSubTitle('Judul', context),
                                              getVerticalSpace(context, 10),
                                              getTextFiledWidget(
                                                  context,
                                                  "Masukkan Judul",
                                                  sekilasInfoController
                                                      .titleController),
                                            ],
                                          ),
                                        ),
                                        getHorizontalSpace(context, 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              itemSubTitle('Penulis', context),
                                              getVerticalSpace(context, 10),
                                              getTextFiledWidget(
                                                  context,
                                                  "Masukkan penulis...",
                                                  sekilasInfoController
                                                      .authorController),
                                            ],
                                          ),
                                        ),
                                        getHorizontalSpace(context, 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              itemSubTitle('Tanggal', context),
                                              getVerticalSpace(context, 10),
                                              DateTimePickerWidget(
                                                  context,
                                                  'Masukkan tanggal...',
                                                  sekilasInfoController
                                                      .dateController),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    getVerticalSpace(context, 30),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            itemSubTitle('Gambar', context),
                                            getVerticalSpace(context, 10),
                                            getTextFiledWidget(
                                                context,
                                                "No file chosen",
                                                sekilasInfoController
                                                    .imageController,
                                                isEnabled: false,
                                                child: getCommonChooseFileBtn(
                                                    context, () {
                                                  sekilasInfoController
                                                      .imgFromGallery();
                                                })),
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
                                                  return (sekilasInfoController
                                                          .isImageOffline.value)
                                                      ? ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  (getResizeRadius(
                                                                      context,
                                                                      35))), //add border radius
                                                          child:
                                                              (sekilasInfoController
                                                                      .isSvg)
                                                                  ? Image.asset(
                                                                      Constants
                                                                          .placeImage,
                                                                      height:
                                                                          100.h,
                                                                      width:
                                                                          100.h,
                                                                      fit: BoxFit
                                                                          .contain,
                                                                    )
                                                                  : Image
                                                                      .memory(
                                                                      sekilasInfoController
                                                                          .webImage,
                                                                      height:
                                                                          100.h,
                                                                      width:
                                                                          100.h,
                                                                      fit: BoxFit
                                                                          .contain,
                                                                    ),
                                                        )
                                                      : isEdit
                                                          ? ClipRRect(
                                                              borderRadius: BorderRadius.circular(
                                                                  (getResizeRadius(
                                                                      context,
                                                                      35))), //add border radius
                                                              child: (widget
                                                                      .sekilasInfoModel!
                                                                      .image!
                                                                      .split(
                                                                          ".")
                                                                      .last
                                                                      .startsWith(
                                                                          "svg"))
                                                                  ? Image.asset(
                                                                      Constants
                                                                          .placeImage,
                                                                      height:
                                                                          100.h,
                                                                      width:
                                                                          100.h,
                                                                      fit: BoxFit
                                                                          .contain,
                                                                    )
                                                                  : Image
                                                                      .network(
                                                                      widget
                                                                          .sekilasInfoModel!
                                                                          .image!,
                                                                      height:
                                                                          100.h,
                                                                      width:
                                                                          100.h,
                                                                      fit: BoxFit
                                                                          .contain,
                                                                    ),
                                                            )
                                                          : Container();
                                                }),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            getVerticalSpace(context, 30),
                                            itemSubTitle('Deskripsi', context),
                                            getVerticalSpace(context, 10),
                                            Container(
                                              decoration: getDefaultDecoration(
                                                  radius:
                                                      getDefaultRadius(context),
                                                  bgColor:
                                                      getCardColor(context),
                                                  // bgColor: getReportColor(context),
                                                  borderColor:
                                                      getBorderColor(context),
                                                  borderWidth: 1),
                                              child: Column(
                                                children: [
                                                  getVerticalSpace(context, 10),
                                                  Container(
                                                    decoration:
                                                        getDefaultDecoration(
                                                            radius:
                                                                getDefaultRadius(
                                                                    context),
                                                            bgColor:
                                                                getCardColor(
                                                                    context),
                                                            borderColor:
                                                                getBorderColor(
                                                                    context),
                                                            borderWidth: 1),
                                                    child: QuillToolbar.simple(
                                                        configurations:
                                                            QuillSimpleToolbarConfigurations(
                                                                controller:
                                                                    sekilasInfoController
                                                                        .descController)

                                                        // configurations: QuillToolbarConfigurations(
                                                        //   // iconTheme: QuillIconTheme(
                                                        //   //     iconUnselectedFillColor: Colors.transparent
                                                        //   // ),
                                                        //   //   controller:
                                                        //   //   sekilasInfoController.descController
                                                        // ),
                                                        ),
                                                  ),
                                                  Container(
                                                    child: QuillEditor.basic(
                                                      configurations:
                                                          QuillEditorConfigurations(
                                                              controller:
                                                                  sekilasInfoController
                                                                      .descController),

                                                      // configurations: QuillEditorConfigurations(
                                                      //   readOnly:
                                                      //   false,
                                                      //
                                                      // ),
                                                      scrollController:
                                                          ScrollController(),
                                                      focusNode: FocusNode(),
                                                    ).paddingSymmetric(
                                                        vertical: 15.h,
                                                        horizontal: 15),
                                                  ).marginSymmetric(
                                                      vertical: 15.h),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )),
                                        getHorizontalSpace(context, 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              itemSubTitle('Sumber', context),
                                              getVerticalSpace(context, 10),
                                              getTextFiledWidget(
                                                  context,
                                                  "Masukkan sumber...",
                                                  sekilasInfoController
                                                      .sourceController),
                                            ],
                                          ),
                                        ),
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
                              isProgress: sekilasInfoController.isLoading.value,
                              () {
                                if (isEdit) {
                                  sekilasInfoController.editSekilasInfo(
                                      homeController, context, () {
                                    print(
                                        "edit------${sekilasInfoController.sekilasInfoModel!.title}");
                                    widget.function();
                                  });
                                } else {
                                  sekilasInfoController.addSekilasInfo(
                                      context, homeController, () {
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

  @override
  void initState() {
    super.initState();

    LoginData.getDeviceId();
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

Widget DateTimePickerWidget(
    BuildContext context, String hintText, TextEditingController controller) {
  double height = 45.h;
  if (Responsive.isTablet(context)) {
    height = 55.h;
  }
  double radius = getDefaultRadius(context);
  double fontSize = getResizeFont(context, 40);

  return GestureDetector(
    onTap: () async {
      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (pickedDate != null) {
        controller.text =
            DateFormat('EEEE, d MMM yyyy', 'id_ID').format(pickedDate);
      }
    },
    child: AbsorbPointer(
      child: TextFormField(
        controller: controller,
        style: TextStyle(
          fontFamily: Constants.fontsFamily,
          color: getFontColor(context),
          fontWeight: FontWeight.w400,
          fontSize: fontSize,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 10.h),
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
            borderSide: BorderSide(
              color: getPrimaryColor(context),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
            borderSide: BorderSide(
              color: getBorderColor(context),
            ),
          ),
          errorBorder: InputBorder.none,
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
            borderSide: BorderSide(
              color: getBorderColor(context),
            ),
          ),
          filled: true,
          fillColor: getCardColor(context),
          focusColor: Colors.green,
          hintText: hintText,
          hintStyle: TextStyle(
            fontFamily: Constants.fontsFamily,
            color: getSubFontColor(context),
            fontWeight: FontWeight.w400,
            fontSize: fontSize,
          ),
          suffixIcon: Icon(Icons.calendar_today),
        ),
      ),
    ),
  );
}
