import 'package:ebookadminpanel/controller/data/LoginData.dart';
import 'package:ebookadminpanel/main.dart';
import 'package:ebookadminpanel/model/user_model.dart';
import 'package:ebookadminpanel/theme/color_scheme.dart';
import 'package:ebookadminpanel/ui/common/common.dart';
import 'package:ebookadminpanel/ui/home/home_page.dart';
import 'package:ebookadminpanel/util/common_blank_page.dart';
import 'package:ebookadminpanel/util/constants.dart';
import 'package:ebookadminpanel/util/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailUser extends StatefulWidget {
  final Function function;
  final UserModel? userModel;
  const DetailUser({
    super.key,
    required this.function,
    required this.userModel,
  });

  @override
  State<DetailUser> createState() => _DetailUserState();
}

class _DetailUserState extends State<DetailUser> {
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
                  context, 'Detail Pengguna', 75, getFontColor(context),
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
                              changeAction(actionUser);
                            }),
                            getVerticalSpace(context, 30),
                            Responsive.isMobile(context)
                                ? Column(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          itemSubTitle(
                                              'Nama Pengguna', context),
                                          getVerticalSpace(context, 10),
                                          getTextFiledWidget(
                                            context,
                                            "",
                                            userController.fullName,
                                            isEnabled: false,
                                          ),
                                        ],
                                      ),
                                      getVerticalSpace(context, 30),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          itemSubTitle('Role', context),
                                          getVerticalSpace(context, 10),
                                          getTextFiledWidget(
                                            context,
                                            "",
                                            userController.role,
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
                                              'Nomor Identitas', context),
                                          getVerticalSpace(context, 10),
                                          getTextFiledWidget(
                                            context,
                                            "",
                                            userController.nikNumber,
                                            isEnabled: false,
                                          ),
                                        ],
                                      ),
                                      getVerticalSpace(context, 30),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          itemSubTitle('Email', context),
                                          getVerticalSpace(context, 10),
                                          getTextFiledWidget(
                                            context,
                                            "",
                                            userController.email,
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
                                              'Nomor Telepon', context),
                                          getVerticalSpace(context, 10),
                                          getTextFiledWidget(
                                            context,
                                            "",
                                            userController.phoneNumber,
                                            isEnabled: false,
                                          ),
                                        ],
                                      ),
                                      getVerticalSpace(context, 30),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          itemSubTitle('Alamat', context),
                                          getVerticalSpace(context, 10),
                                          getTextFiledWidget(
                                            context,
                                            "",
                                            userController.address,
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
                                                    'Nama Pengguna', context),
                                                getVerticalSpace(context, 10),
                                                getTextFiledWidget(
                                                  context,
                                                  "",
                                                  userController.fullName,
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
                                                itemSubTitle('Role', context),
                                                getVerticalSpace(context, 10),
                                                getTextFiledWidget(
                                                  context,
                                                  "",
                                                  userController.role,
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
                                                    'Nomor Identitas', context),
                                                getVerticalSpace(context, 10),
                                                getTextFiledWidget(
                                                  context,
                                                  "",
                                                  userController.nikNumber,
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
                                                itemSubTitle('Email', context),
                                                getVerticalSpace(context, 10),
                                                getTextFiledWidget(
                                                  context,
                                                  "",
                                                  userController.email,
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
                                                    'Nomor Telepon', context),
                                                getVerticalSpace(context, 10),
                                                getTextFiledWidget(
                                                  context,
                                                  "",
                                                  userController.phoneNumber,
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
                                                itemSubTitle('Alamat', context),
                                                getVerticalSpace(context, 10),
                                                getTextFiledWidget(
                                                  context,
                                                  "",
                                                  userController.address,
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
