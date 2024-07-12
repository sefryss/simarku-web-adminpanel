import 'package:ebookadminpanel/controller/home_controller.dart';
import 'package:ebookadminpanel/main.dart';
import 'package:ebookadminpanel/model/feedback_model.dart';
import 'package:ebookadminpanel/util/common_blank_page.dart';
import 'package:ebookadminpanel/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ebookadminpanel/theme/color_scheme.dart';
import 'package:ebookadminpanel/ui/common/common.dart';
import '../../../controller/data/LoginData.dart';
import '../../../util/responsive.dart';

import '../../home/home_page.dart';

class AddFeedbackScreen extends StatefulWidget {
  final Function function;
  final FeedbackModel? feedbackModel;

  AddFeedbackScreen({required this.function, this.feedbackModel});

  @override
  State<AddFeedbackScreen> createState() => _AddFeedbackScreenState();
}

class _AddFeedbackScreenState extends State<AddFeedbackScreen> {
  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.find();

    bool isEdit = widget.feedbackModel != null;
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
                isEdit ? 'Detail Umpan Balik' : 'Tambah Umpan Balik',
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
                            changeAction(actionFeedback);
                          }),
                          getVerticalSpace(context, 30),
                          Responsive.isMobile(context)
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    itemSubTitle('Nama Pengguna ', context),
                                    getVerticalSpace(context, 10),
                                    getTextFiledWidget(
                                      context,
                                      "User",
                                      feedbackController.userNameController,
                                      isEnabled: false,
                                    ),
                                    getVerticalSpace(context, 30),
                                    itemSubTitle('Umpan Balik', context),
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
                                                radius:
                                                    getDefaultRadius(context),
                                                bgColor: getCardColor(context),
                                                borderColor:
                                                    getBorderColor(context),
                                                borderWidth: 1),
                                            child: QuillToolbar.simple(
                                              configurations:
                                                  QuillSimpleToolbarConfigurations(
                                                      controller:
                                                          feedbackController
                                                              .feedbackController),
                                              // iconTheme: QuillIconTheme(
                                              //     iconUnselectedFillColor: Colors.transparent
                                              // ),
                                              // controller: donationBookController.descController
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
                                                          feedbackController
                                                              .feedbackController),

                                              // true for view only mode
                                            ).paddingSymmetric(
                                                vertical: 15.h, horizontal: 15),
                                          ).marginSymmetric(vertical: 15.h),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        itemSubTitle('Nama Pengguna', context),
                                        getVerticalSpace(context, 10),
                                        getTextFiledWidget(
                                          context,
                                          "User",
                                          feedbackController.userNameController,
                                          isEnabled: false,
                                        ),
                                      ],
                                    ),
                                    getVerticalSpace(context, 30),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        itemSubTitle('Umpan Balik', context),
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
                                                decoration:
                                                    getDefaultDecoration(
                                                        radius:
                                                            getDefaultRadius(
                                                                context),
                                                        bgColor: getCardColor(
                                                            context),
                                                        borderColor:
                                                            getBorderColor(
                                                                context),
                                                        borderWidth: 1),
                                                child: QuillToolbar.simple(
                                                  configurations:
                                                      QuillSimpleToolbarConfigurations(
                                                          controller:
                                                              feedbackController
                                                                  .feedbackController),
                                                  // iconTheme: QuillIconTheme(
                                                  //     iconUnselectedFillColor: Colors.transparent
                                                  // ),
                                                  // controller: donationBookController.descController
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
                                                              feedbackController
                                                                  .feedbackController),

                                                  // true for view only mode
                                                ).paddingSymmetric(
                                                    vertical: 15.h,
                                                    horizontal: 15),
                                              ).marginSymmetric(vertical: 15.h),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                    // getVerticalSpace(context, 20),
                    // Row(
                    //   children: [
                    //     Obx(() => getButtonWidget(
                    //           context,
                    //           isEdit ? 'Ubah' : 'Simpan',
                    //           isProgress: feedbackController.isLoading.value,
                    //           () {
                    //             if (isEdit) {
                    //               feedbackController.editFeedback(
                    //                   homeController, context, () {
                    //                 print(
                    //                     "edit------${feedbackController.feedbackModel!.feedback}");
                    //                 widget.function();
                    //               });
                    //             } else {
                    //               feedbackController
                    //                   .addFeedback(homeController, context, () {
                    //                 widget.function();
                    //               });
                    //             }
                    //           },
                    //           horPadding: 25.h,
                    //           horizontalSpace: 0,
                    //           verticalSpace: 0,
                    //           btnHeight: 40.h,
                    //         )),
                    //   ],
                    // ),
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
