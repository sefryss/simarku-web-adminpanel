import 'package:ebookadminpanel/util/pref_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ebookadminpanel/controller/home_controller.dart';
import 'package:ebookadminpanel/model/story_model.dart';
import 'package:ebookadminpanel/theme/color_scheme.dart';
import 'package:ebookadminpanel/ui/common/common.dart';
import '../../../controller/home_slider_controller.dart';
import '../../../theme/app_theme.dart';
import '../story_drop_down.dart';

class AddSliderScreen extends StatelessWidget {
  final Function function;
  final StoryModel? storyModel;

  AddSliderScreen({required this.function, this.storyModel});

  @override
  Widget build(BuildContext context) {
    RxBool custom = false.obs;
    double radius = getCommonRadius(context);
    double padding = getCommonPadding(context);

    HomeController homeController = Get.find();

    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: getDefaultHorSpace(context),
            vertical: getDefaultHorSpace(context)),
        child: GetBuilder<HomeSliderController>(
          init: HomeSliderController(),
          builder: (controller) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getTextWidget(
                    context, 'Add Book To Slider', 75, getFontColor(context),
                    fontWeight: FontWeight.w700),
                getVerticalSpace(context, 40),
                // Container(
                //   width: 300.h,
                //   padding: EdgeInsets.all(5.h),
                //   decoration: getDefaultDecoration(
                //     bgColor: primaryColor.withOpacity(0.4),
                //     radius: 20.h,
                //   ),
                //   child: Row(
                //     children: [
                //       Expanded(
                //         flex: 1,
                //         child: GestureDetector(
                //           onTap: () {
                //             custom.value = false;
                //           },
                //           child: Obx(() => Container(
                //                 padding: EdgeInsets.symmetric(
                //                     horizontal: 20.h, vertical: 5.h),
                //                 decoration: getDefaultDecoration(
                //                   bgColor: (custom.value)
                //                       ? Colors.transparent
                //                       : primaryColor,
                //                   radius: 15.h,
                //                 ),
                //                 child: getTextWidget(
                //                     context,
                //                     "Default",
                //                     40,
                //                     (custom.value)
                //                         ? Colors.black
                //                         : Colors.white,
                //                     textAlign: TextAlign.center),
                //               )),
                //         ),
                //       ),
                //       Expanded(
                //         flex: 1,
                //         child: GestureDetector(
                //           onTap: () {
                //             custom.value = true;
                //           },
                //           child: Obx(() => Container(
                //                 padding: EdgeInsets.symmetric(
                //                     horizontal: 20.h, vertical: 5.h),
                //                 decoration: getDefaultDecoration(
                //                   bgColor: (custom.value)
                //                       ? primaryColor
                //                       : Colors.transparent,
                //                   // bgColor: primaryColor,
                //                   radius: 15.h,
                //                 ),
                //                 child: getTextWidget(
                //                     context,
                //                     "Custom",
                //                     40,
                //                     (custom.value)
                //                         ? Colors.white
                //                         : Colors.black,
                //                     textAlign: TextAlign.center),
                //               )),
                //         ),
                //       )
                //     ],
                //   ),
                // ),
                // getVerticalSpace(context, 20),
                Container(
                  decoration: getDefaultDecoration(
                      bgColor: getCardColor(context), radius: radius),
                  padding: EdgeInsets.all(padding),
                  child: Obx(() => (custom.value)
                      ? ListView(
                    shrinkWrap: true,
                    children: [
                      itemSubTitle('Enter link', context),
                      getVerticalSpace(context, 10),
                      getTextFiledWidget(context, "https://google.com",
                          controller.linkController),

                      getVerticalSpace(context, 30),

                      itemSubTitle('Select Image', context),
                      getVerticalSpace(context, 10),
                      getTextFiledWidget(context, "No file chosen",
                          controller.customImageController,
                          isEnabled: false,
                          child: InkWell(
                            onTap: () {
                              controller.customImgFromGallery();
                            },
                            child: Container(
                              height: double.infinity,
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(left: 7.h),
                              // margin: EdgeInsets.all(7.h),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5.h, vertical: 5.h),
                              decoration: getDefaultDecoration(
                                  bgColor: borderColor,
                                  radius: getResizeRadius(context, 10)),
                              child: getTextWidget(
                                context,
                                'Choose file',
                                35,
                                primaryFontColor,
                                customFont: "",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )),
                      getVerticalSpace(context, 30),
                      Row(
                        children: [
                          Obx(() => getButtonWidget(
                            context,
                            'Submit',
                            isProgress: controller.isLoading.value,
                                () {
                                  PrefData.checkAccess(context: context, function: (){
                                    controller.addCustomSlider(
                                        context, homeController, () {
                                      function();
                                    });
                                  });
                            },
                            horPadding: 25.h,
                            horizontalSpace: 0,
                            verticalSpace: 0,
                            btnHeight: 40.h,
                          )),
                          Expanded(child: Container())
                        ],
                      ),
                      getVerticalSpace(context, 30),
                      getCustomFont("(Maximum add 3 Slider)",
                          getResizeFont(context, 50), Colors.red, 1,
                          textAlign: TextAlign.right)

                    ],
                  )



                      : ListView(
                    shrinkWrap: true,
                    children: [
                      itemSubTitle('Select Book', context),
                      getVerticalSpace(context, 10),

                      Obx(() {
                        return homeController.story.value.isNotEmpty
                            ? homeController.storyList.length == 1
                            ? getDisableDropDownWidget(
                          context,
                          homeController.storyList[0].name!,
                        )
                            : StoryDropDown(
                          homeController,
                          value: homeController.story.value,
                          onChanged: (value) {
                            print("val---${value}");
                            if (value !=
                                homeController.story.value) {
                              homeController.story(value);
                            }
                          },
                        )
                            : getDisableTextFiledWidget(
                          context,
                          homeController.isLoading.value
                              ? "Loading.."
                              : "No Data",
                        );
                      }),

                      getVerticalSpace(context, 30),

                      itemSubTitle('Slider Background image', context),
                      getVerticalSpace(context, 10),

                      getTextFiledWidget(
                          context,
                          "No file chosen",
                          controller.imageController,
                          isEnabled: false,
                          child: InkWell(
                            onTap: () {
                              controller.imgFromGallery();
                            },
                            child: Container(
                              height: double.infinity,
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(left: 7.h),
                              // margin: EdgeInsets.all(7.h),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5.h, vertical: 5.h),
                              decoration: getDefaultDecoration(
                                  bgColor: borderColor,
                                  radius: getResizeRadius(context, 10)),
                              child: getTextWidget(
                                context,
                                'Choose file',
                                35,
                                primaryFontColor,
                                customFont: "",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )),

                      getVerticalSpace(context, 30),


                      // itemSubTitle('Enter color', context),
                      // getVerticalSpace(context, 10),
                      //
                      // getTextFiledWidget(context, "Enter Color...",
                      //     controller.colorController),
                      //
                      // getVerticalSpace(context, 30),


                      Row(
                        children: [
                          Obx(() => getButtonWidget(
                            context,
                            'Submit',
                            isProgress: controller.isLoading.value,
                                () {
                              PrefData.checkAccess(context: context, function: (){
                                controller.addSlider(
                                    context, homeController, () {
                                  function();
                                });
                              });
                            },
                            horPadding: 25.h,
                            horizontalSpace: 0,
                            verticalSpace: 0,
                            btnHeight: 40.h,
                          )),
                          Expanded(child: Container())
                        ],
                      ),
                      getVerticalSpace(context, 30),
                      getCustomFont("(Maximum add 3 Slider)",
                          getResizeFont(context, 50), Colors.red, 1,
                          textAlign: TextAlign.right)
                    ],
                  )),
                ),
                Expanded(
                  child: Container(),
                  flex: 1,
                )
              ],
            );
          },
        ),
      ),
    );
  }

  itemSubTitle(String s, BuildContext context) {
    return getTextWidget(
      context,
      s,
      45,
      getFontColor(context),
      fontWeight: FontWeight.w500,
    );
  }
}
