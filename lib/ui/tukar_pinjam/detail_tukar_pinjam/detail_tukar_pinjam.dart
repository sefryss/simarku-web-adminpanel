import 'package:ebookadminpanel/controller/data/LoginData.dart';
import 'package:ebookadminpanel/main.dart';
import 'package:ebookadminpanel/model/tukar_pinjam_model.dart';
import 'package:ebookadminpanel/theme/color_scheme.dart';
import 'package:ebookadminpanel/ui/common/common.dart';
import 'package:ebookadminpanel/ui/home/home_page.dart';
import 'package:ebookadminpanel/util/common_blank_page.dart';
import 'package:ebookadminpanel/util/constants.dart';
import 'package:ebookadminpanel/util/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailTukarPinjam extends StatefulWidget {
  final Function function;
  final TukarPinjamModel? tukarPinjamModel;
  const DetailTukarPinjam({
    super.key,
    required this.function,
    required this.tukarPinjamModel,
  });

  @override
  State<DetailTukarPinjam> createState() => _DetailTukarPinjamState();
}

class _DetailTukarPinjamState extends State<DetailTukarPinjam> {
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
                  context, 'Detail Tukar Pinjam', 75, getFontColor(context),
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
                          children: [
                            getVerticalSpace(context, 30),
                            getCommonBackIcon(context, onTap: () {
                              changeAction(actionTukarPinjam);
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
                                            tukarPinjamController.sender,
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
                                            tukarPinjamController.senderBook,
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
                                            tukarPinjamController.receiver,
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
                                            tukarPinjamController.receiverBook,
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
                                            tukarPinjamController.timestamp,
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
                                              'Peminjaman Berakhir', context),
                                          getVerticalSpace(context, 10),
                                          getTextFiledWidget(
                                            context,
                                            "",
                                            tukarPinjamController.loanEndTime,
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
                                              'Durasi Peminjaman', context),
                                          getVerticalSpace(context, 10),
                                          getTextFiledWidget(
                                            context,
                                            "",
                                            tukarPinjamController.loanDuration,
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
                                            tukarPinjamController.status,
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
                                                  tukarPinjamController.sender,
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
                                                  tukarPinjamController
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
                                                  tukarPinjamController
                                                      .receiver,
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
                                                  tukarPinjamController
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
                                                  tukarPinjamController
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
                                                itemSubTitle(
                                                    'Peminjaman Berakhir',
                                                    context),
                                                getVerticalSpace(context, 10),
                                                getTextFiledWidget(
                                                  context,
                                                  "",
                                                  tukarPinjamController
                                                      .loanEndTime,
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
                                                    'Durasi Peminjaman',
                                                    context),
                                                getVerticalSpace(context, 10),
                                                getTextFiledWidget(
                                                  context,
                                                  "",
                                                  tukarPinjamController
                                                      .loanDuration,
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
                                                  tukarPinjamController.status,
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
