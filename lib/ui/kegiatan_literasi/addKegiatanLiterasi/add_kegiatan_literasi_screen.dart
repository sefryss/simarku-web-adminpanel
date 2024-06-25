import 'package:ebookadminpanel/main.dart';
import 'package:ebookadminpanel/model/kegiatan_literasi_model.dart';
import 'package:ebookadminpanel/util/common_blank_page.dart';
import 'package:ebookadminpanel/util/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ebookadminpanel/controller/home_controller.dart';
import 'package:ebookadminpanel/theme/color_scheme.dart';
import 'package:ebookadminpanel/ui/common/common.dart';
import '../../../controller/data/LoginData.dart';
import '../../../util/responsive.dart';

import '../../home/home_page.dart';

class AddKegiatanLiterasiScreen extends StatefulWidget {
  final Function function;
  final KegiatanLiterasiModel? kegiatanLiterasiModel;

  AddKegiatanLiterasiScreen(
      {required this.function, this.kegiatanLiterasiModel});

  @override
  State<AddKegiatanLiterasiScreen> createState() =>
      _AddKegiatanLiterasiScreenState();
}

class _AddKegiatanLiterasiScreenState extends State<AddKegiatanLiterasiScreen> {
  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.find();

    bool isEdit = widget.kegiatanLiterasiModel != null;
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
                isEdit ? 'Edit Kegiatan Literasi' : 'Tambah Kegiatan Literasi',
                75,
                getFontColor(context),
                fontWeight: FontWeight.w700),
            getVerticalSpace(context, 35),
            Expanded(
              child: getCommonContainer(
                context: context,
                verSpace: 0,
                horSpace: isWeb(context) ? null : 15.h,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          getVerticalSpace(context, 30),
                          getCommonBackIcon(context, onTap: () {
                            changeAction(actionKegiatanLiterasi);
                          }),

                          getVerticalSpace(context, 30),

                          Responsive.isMobile(context)
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    itemSubTitle('Kegiatan Literasi', context),
                                    getVerticalSpace(context, 10),
                                    getTextFiledWidget(
                                        context,
                                        "Masukkan Judul",
                                        kegiatanLiterasiController
                                            .titleController),
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
                                            value: kegiatanLiterasiController
                                                .activeStatus.value,
                                            onChanged: (value) {
                                              kegiatanLiterasiController
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
                                                  kegiatanLiterasiController
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
                                              itemSubTitle('Sumber', context),
                                              getVerticalSpace(context, 10),
                                              getTextFiledWidget(
                                                  context,
                                                  "Masukkan sumber...",
                                                  kegiatanLiterasiController
                                                      .sourceController),
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
                                              getTextFiledWidget(
                                                  context,
                                                  "Masukkan tanggal...",
                                                  kegiatanLiterasiController
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
                                                kegiatanLiterasiController
                                                    .imageController,
                                                isEnabled: false,
                                                child: getCommonChooseFileBtn(
                                                    context, () {
                                                  kegiatanLiterasiController
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
                                                  return (kegiatanLiterasiController
                                                          .isImageOffline.value)
                                                      ? ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  (getResizeRadius(
                                                                      context,
                                                                      35))), //add border radius
                                                          child:
                                                              (kegiatanLiterasiController
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
                                                                      kegiatanLiterasiController
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
                                                                      .kegiatanLiterasiModel!
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
                                                                          .kegiatanLiterasiModel!
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
                                        getHorizontalSpace(context, 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              itemSubTitle('Url', context),
                                              getVerticalSpace(context, 10),
                                              getTextFiledWidget(
                                                  context,
                                                  "Masukkan url...",
                                                  kegiatanLiterasiController
                                                      .urlController),
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
                                                                    kegiatanLiterasiController
                                                                        .descController)),
                                                  ),
                                                  Container(
                                                    child: QuillEditor.basic(
                                                      configurations:
                                                          QuillEditorConfigurations(
                                                              controller:
                                                                  kegiatanLiterasiController
                                                                      .descController),
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
                              isEdit ? 'Ubah' : 'Simpan',
                              isProgress:
                                  kegiatanLiterasiController.isLoading.value,
                              () {
                                if (isEdit) {
                                  kegiatanLiterasiController
                                      .editKegiatanLiterasi(
                                          homeController, context, () {
                                    print(
                                        "edit------${kegiatanLiterasiController.kegiatanLiterasiModel!.title}");
                                    widget.function();
                                  });
                                } else {
                                  kegiatanLiterasiController
                                      .addKegiatanLiterasi(
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
