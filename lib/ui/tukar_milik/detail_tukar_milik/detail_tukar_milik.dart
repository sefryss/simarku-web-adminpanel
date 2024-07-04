import 'package:ebookadminpanel/controller/data/LoginData.dart';
import 'package:ebookadminpanel/main.dart';
import 'package:ebookadminpanel/model/tukar_milik_model.dart';
import 'package:ebookadminpanel/theme/color_scheme.dart';
import 'package:ebookadminpanel/ui/common/common.dart';
import 'package:ebookadminpanel/ui/home/home_page.dart';
import 'package:ebookadminpanel/util/common_blank_page.dart';
import 'package:ebookadminpanel/util/constants.dart';
import 'package:ebookadminpanel/util/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailTukarMilik extends StatefulWidget {
  final Function function;
  final TukarMilikModel? tukarMilikModel;
  const DetailTukarMilik({
    super.key,
    required this.function,
    required this.tukarMilikModel,
  });

  @override
  State<DetailTukarMilik> createState() => _DetailTukarMilikState();
}

class _DetailTukarMilikState extends State<DetailTukarMilik> {
  @override
  void initState() {
    super.initState();

    LoginData.getDeviceId();
  }

  @override
  Widget build(BuildContext context) {
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
                  context, 'Detail Tukar Milik', 75, getFontColor(context),
                  fontWeight: FontWeight.w700),
              getVerticalSpace(context, 30),
              Expanded(
                child: getCommonContainer(
                  context: context,
                  verSpace: 0,
                  horSpace: isWeb(context) ? null : 15.h,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            getVerticalSpace(context, 30),
                            getCommonBackIcon(context, onTap: () {
                              changeAction(actionTukarMilik);
                            }),
                            getVerticalSpace(context, 30),
                            Responsive.isMobile(context)
                                ? Column(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          itemSubTitle('Pengirim', context),
                                          getVerticalSpace(context, 10),
                                          getTextFiledWidget(
                                            context,
                                            "",
                                            tukarMilikController.sender,
                                            isEnabled: false,
                                          ),
                                        ],
                                      ),
                                      getVerticalSpace(context, 30),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          itemSubTitle(
                                              'Buku Pengirim', context),
                                          getVerticalSpace(context, 10),
                                          getTextFiledWidget(
                                            context,
                                            "",
                                            tukarMilikController.senderBook,
                                            isEnabled: false,
                                          ),
                                        ],
                                      ),
                                      getVerticalSpace(context, 30),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          itemSubTitle('Penerima', context),
                                          getVerticalSpace(context, 10),
                                          getTextFiledWidget(
                                            context,
                                            "",
                                            tukarMilikController.receiver,
                                            isEnabled: false,
                                          ),
                                        ],
                                      ),
                                      getVerticalSpace(context, 30),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          itemSubTitle(
                                              'Buku Penerima', context),
                                          getVerticalSpace(context, 10),
                                          getTextFiledWidget(
                                            context,
                                            "",
                                            tukarMilikController.receiverBook,
                                            isEnabled: false,
                                          ),
                                        ],
                                      ),
                                      getVerticalSpace(context, 30),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          itemSubTitle('Diajukan', context),
                                          getVerticalSpace(context, 10),
                                          getTextFiledWidget(
                                            context,
                                            "",
                                            tukarMilikController.timestamp,
                                            isEnabled: false,
                                          ),
                                        ],
                                      ),
                                      getVerticalSpace(context, 30),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          itemSubTitle('Status', context),
                                          getVerticalSpace(context, 10),
                                          getTextFiledWidget(
                                            context,
                                            "",
                                            tukarMilikController.status,
                                            isEnabled: false,
                                          ),
                                        ],
                                      ),
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
                                                itemSubTitle(
                                                    'Pengirim', context),
                                                getVerticalSpace(context, 10),
                                                getTextFiledWidget(
                                                  context,
                                                  "",
                                                  tukarMilikController.sender,
                                                  isEnabled: false,
                                                ),
                                              ],
                                            ),
                                          ),
                                          getHorizontalSpace(context, 30),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                itemSubTitle(
                                                    'Buku Pengirim', context),
                                                getVerticalSpace(context, 10),
                                                getTextFiledWidget(
                                                  context,
                                                  "",
                                                  tukarMilikController
                                                      .senderBook,
                                                  isEnabled: false,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      getVerticalSpace(context, 30),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                itemSubTitle(
                                                    'Penerima', context),
                                                getVerticalSpace(context, 10),
                                                getTextFiledWidget(
                                                  context,
                                                  "",
                                                  tukarMilikController.receiver,
                                                  isEnabled: false,
                                                ),
                                              ],
                                            ),
                                          ),
                                          getHorizontalSpace(context, 30),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                itemSubTitle(
                                                    'Buku Penerima', context),
                                                getVerticalSpace(context, 10),
                                                getTextFiledWidget(
                                                  context,
                                                  "",
                                                  tukarMilikController
                                                      .receiverBook,
                                                  isEnabled: false,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      getVerticalSpace(context, 30),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                itemSubTitle(
                                                    'Diajukan', context),
                                                getVerticalSpace(context, 10),
                                                getTextFiledWidget(
                                                  context,
                                                  "",
                                                  tukarMilikController
                                                      .timestamp,
                                                  isEnabled: false,
                                                ),
                                              ],
                                            ),
                                          ),
                                          getHorizontalSpace(context, 30),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                itemSubTitle('Status', context),
                                                getVerticalSpace(context, 10),
                                                getTextFiledWidget(
                                                  context,
                                                  "",
                                                  tukarMilikController.status,
                                                  isEnabled: false,
                                                ),
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

  itemSubTitle(String s, BuildContext context, {Color? color}) {
    return getTextWidget(
      context,
      s,
      45,
      color == null ? getFontColor(context) : color,
      fontWeight: FontWeight.w500,
    );
  }
}
