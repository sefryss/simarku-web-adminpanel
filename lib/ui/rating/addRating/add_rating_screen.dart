import 'package:ebookadminpanel/controller/home_controller.dart';
import 'package:ebookadminpanel/main.dart';
import 'package:ebookadminpanel/model/rate_us_model.dart';
import 'package:ebookadminpanel/util/common_blank_page.dart';
import 'package:ebookadminpanel/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
            getTextWidget(context, isEdit ? 'Detail Rating' : 'Tambah Rating',
                75, getFontColor(context),
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
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        itemSubTitle('Nama Pengguna', context),
                                        getVerticalSpace(context, 10),
                                        getTextFiledWidget(
                                          context,
                                          "User",
                                          ratingController.userNameController,
                                          isEnabled: false,
                                        ),
                                      ],
                                    ),
                                    getVerticalSpace(context, 30),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        itemSubTitle('Rating', context),
                                        getVerticalSpace(context, 10),
                                        getTextFiledWidget(
                                          context,
                                          "Rating",
                                          ratingController.ratingController,
                                          isEnabled: false,
                                        ),
                                      ],
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
                                          ratingController.userNameController,
                                          isEnabled: false,
                                        ),
                                      ],
                                    ),
                                    getVerticalSpace(context, 30),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        itemSubTitle('Rating', context),
                                        getVerticalSpace(context, 10),
                                        getTextFiledWidget(
                                          context,
                                          "Rating",
                                          ratingController.ratingController,
                                          isEnabled: false,
                                        ),
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
