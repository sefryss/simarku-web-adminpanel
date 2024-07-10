import 'package:ebookadminpanel/model/donation_book_model.dart';
import 'package:ebookadminpanel/util/common_blank_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ebookadminpanel/controller/home_controller.dart';
import 'package:ebookadminpanel/theme/color_scheme.dart';
import 'package:ebookadminpanel/ui/common/common.dart';
import 'package:intl/intl.dart';
import '../../../controller/data/LoginData.dart';
import '../../../main.dart';
import '../../../util/constants.dart';
import '../../../util/responsive.dart';
import '../../home/home_page.dart';
import '../subwidget/status_drop_down.dart';

class AddDonationBookScreen extends StatefulWidget {
  final Function function;
  final DonationBookModel? donationBookModel;

  AddDonationBookScreen({required this.function, this.donationBookModel});

  @override
  State<AddDonationBookScreen> createState() => _AddDonationBookScreenState();
}

class _AddDonationBookScreenState extends State<AddDonationBookScreen> {
  @override
  void initState() {
    super.initState();

    LoginData.getDeviceId();
  }

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.find();

    bool isEdit = widget.donationBookModel != null;
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
                  isEdit ? 'Detail Donasi Buku' : 'Tambah Donasi Buku',
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
                        flex: 1,
                        child: ListView(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getVerticalSpace(context, 30),
                            getCommonBackIcon(context, onTap: () {
                              changeAction(actionDonationBook);
                            }),
                            getVerticalSpace(context, 30),
                            Responsive.isMobile(context)
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      itemSubTitle('Judul Buku', context),
                                      getVerticalSpace(context, 10),
                                      getTextFiledWidget(
                                          context,
                                          isEnabled: false,
                                          "Masukkan judul...",
                                          donationBookController
                                              .nameController),
                                      getVerticalSpace(context, 30),
                                      itemSubTitle('Genre Buku', context),
                                      getVerticalSpace(context, 10),
                                      getTextFiledWidget(
                                        context,
                                        "Genre",
                                        donationBookController.genreController,
                                        isEnabled: false,
                                      ),
                                      getVerticalSpace(context, 30),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              itemSubTitle(
                                                  'Penulis Buku', context),
                                              getVerticalSpace(context, 10),
                                              getTextFiledWidget(
                                                  context,
                                                  isEnabled: false,
                                                  "Masukkan penulis...",
                                                  donationBookController
                                                      .authorController),
                                            ],
                                          )),
                                          getHorizontalSpace(context, 10),
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              itemSubTitle(
                                                  'Penerbit Buku', context),
                                              getVerticalSpace(context, 10),
                                              getTextFiledWidget(
                                                  context,
                                                  isEnabled: false,
                                                  "Masukkan penerbit...",
                                                  donationBookController
                                                      .publisherController),
                                            ],
                                          )),
                                          getHorizontalSpace(context, 10),
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
                                                itemSubTitle(
                                                    'Tanggal Rilis', context),
                                                getVerticalSpace(context, 10),
                                                DateTimePickerWidget(
                                                    context,
                                                    'Masukkan tanggal...',
                                                    donationBookController
                                                        .releaseDateController),
                                              ],
                                            ),
                                          ),
                                          getHorizontalSpace(context, 10),
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              itemSubTitle(
                                                  'Jumlah Halaman', context),
                                              getVerticalSpace(context, 10),
                                              getTextFiledWidget(
                                                  context,
                                                  isEnabled: false,
                                                  "Masukkan halaman...",
                                                  donationBookController
                                                      .pageController),
                                            ],
                                          )),
                                        ],
                                      ),
                                      getVerticalSpace(context, 30),
                                      itemSubTitle('Jenis Buku', context),
                                      getVerticalSpace(context, 10),
                                      Obx(() {
                                        return DonationBookTypeDropdown(
                                          homeController,
                                          value: homeController
                                              .donationBookType.value,
                                          onChanged: (value) {
                                            if (value !=
                                                homeController
                                                    .donationBookType.value) {
                                              homeController.donationBookType
                                                  .value = value;
                                            }
                                          },
                                        );
                                      }),
                                      Obx(() {
                                        return (donationBookController
                                                .pdfUrl.value.isNotEmpty)
                                            ? Container(
                                                margin:
                                                    EdgeInsets.only(top: 35.h),
                                                padding: EdgeInsets.all(22.h),
                                                width: double.infinity,
                                                decoration:
                                                    getDefaultDecoration(
                                                  bgColor:
                                                      getReportColor(context),
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
                                                              donationBookController
                                                                  .pdfUrl.value,
                                                              50,
                                                              getFontColor(
                                                                  context))),
                                                          getVerticalSpace(
                                                              context, 10),
                                                          getTextWidget(
                                                              context,
                                                              donationBookController
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
                                                          donationBookController
                                                              .pdfUrl
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
                                      itemSubTitle('Pemilik', context),
                                      getVerticalSpace(context, 10),
                                      getTextFiledWidget(
                                        context,
                                        "Pemilik",
                                        donationBookController.ownerController,
                                        isEnabled: false,
                                      ),
                                      getVerticalSpace(context, 30),
                                      itemSubTitle('Gambar Buku', context),
                                      getVerticalSpace(context, 10),
                                      getTextFiledWidget(
                                        context,
                                        "No file chosen",
                                        donationBookController.imageController,
                                        isEnabled: false,
                                      ),
                                      getVerticalSpace(context, 30),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Obx(() {
                                          return (donationBookController
                                                  .isImageOffline.value)
                                              ? ClipRRect(
                                                  borderRadius: BorderRadius
                                                      .circular((getResizeRadius(
                                                          context,
                                                          35))), //add border radius
                                                  child: (donationBookController
                                                          .isSvg)
                                                      ? Image.asset(
                                                          Constants.placeImage,
                                                          height: 100.h,
                                                          width: 100.h,
                                                          fit: BoxFit.contain,
                                                        )
                                                      : Image.memory(
                                                          donationBookController
                                                              .webImage,
                                                          height: 100.h,
                                                          width: 100.h,
                                                          fit: BoxFit.contain,
                                                        ),
                                                )
                                              : isEdit
                                                  ? ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              (getResizeRadius(
                                                                  context,
                                                                  35))), //add border radius
                                                      child: (widget
                                                              .donationBookModel!
                                                              .image!
                                                              .split(".")
                                                              .last
                                                              .startsWith(
                                                                  "svg"))
                                                          ? Image.asset(
                                                              Constants
                                                                  .placeImage,
                                                              height: 150.h,
                                                              width: 200.h,
                                                              fit: BoxFit
                                                                  .contain,
                                                            )
                                                          : Image.network(
                                                              widget
                                                                  .donationBookModel!
                                                                  .image!,
                                                              height: 150.h,
                                                              width: 200.h,
                                                              fit: BoxFit
                                                                  .contain,
                                                            ),
                                                    )
                                                  : Container();
                                        }),
                                      ),
                                      getVerticalSpace(context, 30),
                                      itemSubTitle('Sinopsis', context),
                                      getVerticalSpace(context, 10),
                                      Container(
                                        // margin: EdgeInsets.all(value),
                                        decoration: getDefaultDecoration(
                                            radius: getDefaultRadius(context),
                                            bgColor: getCardColor(context),
                                            // bgColor: getReportColor(context),
                                            borderColor:
                                                getBorderColor(context),
                                            borderWidth: 1),
                                        child: Column(
                                          children: [
                                            getVerticalSpace(context, 10),
                                            Container(
                                              margin: EdgeInsets.all(8.h),
                                              decoration: getDefaultDecoration(
                                                  radius:
                                                      getDefaultRadius(context),
                                                  bgColor:
                                                      getCardColor(context),
                                                  borderColor:
                                                      getBorderColor(context),
                                                  borderWidth: 1),
                                              child: QuillToolbar.simple(
                                                configurations:
                                                    QuillSimpleToolbarConfigurations(
                                                        controller:
                                                            donationBookController
                                                                .descController),
                                              ),
                                            ),
                                            Container(
                                              child: QuillEditor(
                                                focusNode: FocusNode(),
                                                scrollController:
                                                    ScrollController(),
                                                configurations:
                                                    QuillEditorConfigurations(
                                                        // readOnly: false,
                                                        controller:
                                                            donationBookController
                                                                .descController),

                                                // true for view only mode
                                              ).paddingSymmetric(
                                                  vertical: 15.h,
                                                  horizontal: 15),
                                            ).marginSymmetric(vertical: 15.h),
                                          ],
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              itemSubTitle(
                                                  'Judul Buku', context),
                                              getVerticalSpace(context, 10),
                                              getTextFiledWidget(
                                                  context,
                                                  isEnabled: false,
                                                  "Masukkan Judul...",
                                                  donationBookController
                                                      .nameController),
                                            ],
                                          )),
                                          // getHorizontalSpace(context, 10),
                                          getHorizontalSpace(context, 10),
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              itemSubTitle(
                                                  'Genre Buku', context),
                                              getVerticalSpace(context, 10),
                                              getTextFiledWidget(
                                                  context,
                                                  isEnabled: false,
                                                  "Masukkan Genre...",
                                                  donationBookController
                                                      .genreController),
                                            ],
                                          )),
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
                                              itemSubTitle(
                                                  'Penulis Buku', context),
                                              getVerticalSpace(context, 10),
                                              getTextFiledWidget(
                                                  context,
                                                  isEnabled: false,
                                                  "Masukkan penulis...",
                                                  donationBookController
                                                      .authorController),
                                            ],
                                          )),
                                          getHorizontalSpace(context, 10),
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              itemSubTitle(
                                                  'Penerbit Buku', context),
                                              getVerticalSpace(context, 10),
                                              getTextFiledWidget(
                                                  context,
                                                  isEnabled: false,
                                                  "Masukkan penerbit...",
                                                  donationBookController
                                                      .publisherController),
                                            ],
                                          )),
                                          getHorizontalSpace(context, 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                itemSubTitle(
                                                    'Tanggal Rilis', context),
                                                getVerticalSpace(context, 10),
                                                DateTimePickerWidget(
                                                    context,
                                                    'Masukkan tanggal...',
                                                    donationBookController
                                                        .releaseDateController),
                                              ],
                                            ),
                                          ),
                                          getHorizontalSpace(context, 10),
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              itemSubTitle(
                                                  'Jumlah Halaman', context),
                                              getVerticalSpace(context, 10),
                                              getTextFiledWidget(
                                                  context,
                                                  isEnabled: false,
                                                  "Masukkan halaman...",
                                                  donationBookController
                                                      .pageController),
                                            ],
                                          )),
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
                                                itemSubTitle(
                                                    'Jenis Buku', context),
                                                getVerticalSpace(context, 10),
                                                Obx(() {
                                                  return DonationBookTypeDropdown(
                                                    homeController,
                                                    value: homeController
                                                        .donationBookType.value,
                                                    onChanged: (value) {
                                                      if (value !=
                                                          homeController
                                                              .donationBookType
                                                              .value) {
                                                        homeController
                                                            .donationBookType
                                                            .value = value;
                                                      }
                                                    },
                                                  );
                                                }),
                                              ],
                                            ),
                                          ),
                                          getHorizontalSpace(context, 10),
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              itemSubTitle('Pemilik', context),
                                              getVerticalSpace(context, 10),
                                              getTextFiledWidget(
                                                  context,
                                                  isEnabled: false,
                                                  "Masukkan pemilik...",
                                                  donationBookController
                                                      .ownerController),
                                            ],
                                          )),
                                        ],
                                      ),
                                      Obx(() {
                                        return (donationBookController
                                                .pdfUrl.value.isNotEmpty)
                                            ? Container(
                                                margin:
                                                    EdgeInsets.only(top: 35.h),
                                                padding: EdgeInsets.all(22.h),
                                                width: double.infinity,
                                                decoration:
                                                    getDefaultDecoration(
                                                  bgColor:
                                                      getReportColor(context),
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
                                                              donationBookController
                                                                  .pdfUrl.value,
                                                              50,
                                                              getFontColor(
                                                                  context))),
                                                          getVerticalSpace(
                                                              context, 10),
                                                          getTextWidget(
                                                              context,
                                                              donationBookController
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
                                                          donationBookController
                                                              .pdfUrl
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              itemSubTitle(
                                                  'Gambar Buku', context),
                                              getVerticalSpace(context, 10),
                                              getTextFiledWidget(
                                                context,
                                                "No file chosen",
                                                donationBookController
                                                    .imageController,
                                                isEnabled: false,
                                              ),
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
                                                    return (donationBookController
                                                            .isImageOffline
                                                            .value)
                                                        ? ClipRRect(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    (getResizeRadius(
                                                                        context,
                                                                        35))), //add border radius
                                                            child:
                                                                (donationBookController
                                                                        .isSvg)
                                                                    ? Image
                                                                        .asset(
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
                                                                        donationBookController
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
                                                                        .donationBookModel!
                                                                        .image!
                                                                        .split(
                                                                            ".")
                                                                        .last
                                                                        .startsWith(
                                                                            "svg"))
                                                                    ? Image
                                                                        .asset(
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
                                                                            .donationBookModel!
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
                                              itemSubTitle('Sinopsis', context),
                                              getVerticalSpace(context, 10),
                                              Container(
                                                decoration:
                                                    getDefaultDecoration(
                                                        radius:
                                                            getDefaultRadius(
                                                                context),
                                                        bgColor: getCardColor(
                                                            context),
                                                        // bgColor: getReportColor(context),
                                                        borderColor:
                                                            getBorderColor(
                                                                context),
                                                        borderWidth: 1),
                                                child: Column(
                                                  children: [
                                                    getVerticalSpace(
                                                        context, 10),
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
                                                                      donationBookController
                                                                          .descController)),
                                                    ),
                                                    Container(
                                                      child: QuillEditor.basic(
                                                        configurations:
                                                            QuillEditorConfigurations(
                                                                controller:
                                                                    donationBookController
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
                          ],
                        ),
                      ),
                      getVerticalSpace(context, 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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

Widget DateTimePickerWidget(
    BuildContext context, String hintText, TextEditingController controller) {
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
        controller.text = DateFormat('MMM d, yyyy', 'id_ID').format(pickedDate);
      }
    },
    child: AbsorbPointer(
      child: TextFormField(
        enabled: false,
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
