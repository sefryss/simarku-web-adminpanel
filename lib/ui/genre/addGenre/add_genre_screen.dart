import 'package:ebookadminpanel/main.dart';
import 'package:ebookadminpanel/model/genre_model.dart';
import 'package:ebookadminpanel/util/common_blank_page.dart';
import 'package:ebookadminpanel/util/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ebookadminpanel/controller/home_controller.dart';
import 'package:ebookadminpanel/theme/color_scheme.dart';
import 'package:ebookadminpanel/ui/common/common.dart';
import '../../../controller/data/LoginData.dart';
import '../../../util/responsive.dart';

import '../../home/home_page.dart';

class AddGenreScreen extends StatefulWidget {
  final Function function;
  final Genre? genreModel;

  AddGenreScreen({required this.function, this.genreModel});

  @override
  State<AddGenreScreen> createState() => _AddGenreScreenState();
}

class _AddGenreScreenState extends State<AddGenreScreen> {
  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.find();

    bool isEdit = widget.genreModel != null;
    return SafeArea(
      child: CommonPage(
          widget: Container(
        margin: EdgeInsets.symmetric(
            horizontal: getDefaultHorSpace(context),
            vertical: getDefaultHorSpace(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getTextWidget(context, isEdit ? 'Edit Genre' : 'Tambah Genre', 75,
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
                            changeAction(actionGenre);
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
                                    itemSubTitle('Genre', context),
                                    getVerticalSpace(context, 10),
                                    getTextFiledWidget(
                                        context,
                                        "Masukkan Genre",
                                        genreController.genreNameController),
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
                                            value: genreController
                                                .activeStatus.value,
                                            onChanged: (value) {
                                              genreController
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
                                            itemSubTitle('Genre', context),
                                            getVerticalSpace(context, 10),
                                            getTextFiledWidget(
                                                context,
                                                "Masukkan Genre",
                                                genreController
                                                    .genreNameController),
                                          ],
                                        )),
                                      ],
                                    ),
                                    getVerticalSpace(context, 30),
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
                              isProgress: genreController.isLoading.value,
                              () {
                                if (isEdit) {
                                  genreController
                                      .editGenre(homeController, context, () {
                                    print(
                                        "edit------${genreController.genreModel!.genre}");
                                    widget.function();
                                  });
                                } else {
                                  genreController
                                      .addGenre(context, homeController, () {
                                    widget.function();
                                  });
                                }
                              },
                              horPadding: 25.h,
                              horizontalSpace: 0,
                              verticalSpace: 0,
                              btnHeight: 50.h,
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
