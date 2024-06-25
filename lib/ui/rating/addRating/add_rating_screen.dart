import 'package:ebookadminpanel/main.dart';
import 'package:ebookadminpanel/model/rate_us_model.dart';
import 'package:ebookadminpanel/theme/app_theme.dart';
import 'package:ebookadminpanel/util/common_blank_page.dart';
import 'package:ebookadminpanel/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ebookadminpanel/controller/home_controller.dart';
import 'package:ebookadminpanel/theme/color_scheme.dart';
import 'package:ebookadminpanel/ui/common/common.dart';
import '../../../controller/data/LoginData.dart';
import '../../../util/responsive.dart';

import '../../home/home_page.dart';

class AddRatingScreen extends StatefulWidget {
  final Function function;
  final RateUsModel? rateUsModel;

  AddRatingScreen({required this.function, this.rateUsModel});

  @override
  State<AddRatingScreen> createState() => _AddRatingScreenState();
}

class _AddRatingScreenState extends State<AddRatingScreen> {
  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.find();

    bool isEdit = widget.rateUsModel != null;
    return SafeArea(
      child: CommonPage(
          widget: Container(
        margin: EdgeInsets.symmetric(
            horizontal: getDefaultHorSpace(context),
            vertical: getDefaultHorSpace(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getTextWidget(context, isEdit ? 'Edit Rating' : 'Tambah Rating', 75,
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
                            changeAction(actionRating);
                          }),
                          getVerticalSpace(context, 30),
                          Responsive.isMobile(context)
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    itemSubTitle('Rating', context),
                                    getVerticalSpace(context, 10),
                                    // getTextFiledWidget(
                                    //     context,
                                    //     "Masukkan Judul",
                                    //     kegiatanLiterasiController
                                    //         .titleController),
                                    // getVerticalSpace(context, 30),
                                    // itemSubTitle('Status', context),
                                    // getVerticalSpace(context, 10),
                                    // Container(
                                    //   height: 30.h,
                                    //   child: FittedBox(
                                    //     fit: BoxFit.fitHeight,
                                    //     child: Obx(() => CupertinoSwitch(
                                    //         activeColor:
                                    //             getPrimaryColor(context),
                                    //         value: kegiatanLiterasiController
                                    //             .activeStatus.value,
                                    //         onChanged: (value) {
                                    //           kegiatanLiterasiController
                                    //               .activeStatus.value = value;
                                    //         })),
                                    //   ),
                                    // ),
                                    // getVerticalSpace(context, 30),
                                  ],
                                )
                              : Column(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        itemSubTitle('Pilih User', context),
                                        getVerticalSpace(context, 10),
                                        getTextFiledWidget(context, "User",
                                            ratingController.userNameController,
                                            isEnabled: false,
                                            child: InkWell(
                                              onTap: () async {
                                                await ratingController
                                                    .showOwnerDialog(
                                                  context,
                                                );
                                                // if (homeController.genreList
                                                //         .isNotEmpty &&
                                                //     homeController.genreList
                                                //             .length >
                                                //         0) {
                                                //   donationBookController
                                                //       .showUserDialog(
                                                //           context,
                                                //           homeController);
                                                // } else {
                                                //   showCustomToast(
                                                //       context: context,
                                                //       message: "No Data");
                                                // }
                                              },
                                              child: Container(
                                                height: double.infinity,
                                                alignment: Alignment.center,
                                                margin:
                                                    EdgeInsets.only(left: 8.h),
                                                // margin: EdgeInsets.all(7.h),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.h,
                                                    vertical: 5.h),
                                                decoration:
                                                    getDefaultDecoration(
                                                        bgColor: getReportColor(
                                                            context),
                                                        borderColor:
                                                            borderColor,
                                                        radius: getResizeRadius(
                                                            context, 10)),
                                                child: getTextWidget(
                                                  context,
                                                  'Pilih User',
                                                  40,
                                                  getSubFontColor(context),
                                                  customFont: "",
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            )),
                                      ],
                                    ),
                                    getVerticalSpace(context, 30),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        itemSubTitle('Rating', context),
                                        getVerticalSpace(context, 10),
                                        getTextFiledWidget(context, "Rating",
                                            ratingController.ratingController),
                                      ],
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                    getVerticalSpace(context, 20),
                    Row(
                      children: [
                        Obx(() => getButtonWidget(
                              context,
                              isEdit ? 'Ubah' : 'Simpan',
                              isProgress: feedbackController.isLoading.value,
                              () {
                                if (isEdit) {
                                  feedbackController.editFeedback(
                                      homeController, context, () {
                                    print(
                                        "edit------${feedbackController.feedbackModel!.feedback}");
                                    widget.function();
                                  });
                                } else {
                                  feedbackController
                                      .addFeedback(homeController, context, () {
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
