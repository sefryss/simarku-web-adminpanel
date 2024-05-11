import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ebookadminpanel/controller/home_controller.dart';
import 'package:ebookadminpanel/model/story_model.dart';

import '../../theme/color_scheme.dart';
import '../../util/responsive.dart';
import '../common/common.dart';





class StoryDropDown extends StatelessWidget {
  final Function? onChanged;
  final String? value;

  final  HomeController homeController;
  StoryDropDown(this.homeController,{
    Key? key,
    this.onChanged,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    if(homeController.storyList.length > 0){
      if(value == null){
        onChanged!(homeController.storyList[0].id);
        homeController.story(homeController.storyList[0].id);
      }else{
        onChanged!(value);
        homeController.story(value);
      }
    }
    return  homeController.storyList.length > 0
        ?  getDropDown(context: context, dataController: homeController,) : Container();
  }
  getDropDown(
      {required HomeController dataController,
        required BuildContext context,
      }) {

    // double radius = (Responsive.isMobile(context))?30.r:12.r;
    double radius = getDefaultRadius(context);
    double fontSize = 40;
    double height = 45.h;

    if (Responsive.isTablet(context)) {
      height = 55.h;
    }

    return Obx(() => Container(
      height: height,

      padding: EdgeInsets.symmetric(horizontal: 5.h),
      decoration: getDefaultDecoration(
          radius: radius,
          bgColor: getCardColor(context),
          borderColor: getBorderColor(context),
          borderWidth: 1),



      alignment: Alignment.centerLeft,
      child: DropdownButton<String>(
        hint: getTextWidget(context,'Select Book',fontSize,getSubFontColor(context),fontWeight: FontWeight.w400),
        isExpanded: true,
        icon: imageAsset('down.png', height: 12.h, width: 12.h,color: getFontColor(context)).paddingSymmetric(horizontal: 10.h),

        items: homeController.storyList.map((val) {
          StoryModel model = val;
          return DropdownMenuItem<String>(
            value: model.id!,
            child: getTextWidget(context,model.name!,fontSize,getFontColor(context),fontWeight: FontWeight.w400),
          );
        }).toList(),
        value: (homeController.story.value.isEmpty)?null:homeController.story.value,
        underline: Container(),
        onChanged: (value) {
          onChanged!(value);
          homeController.story(value);
        },
      ),
    ),);
  }

}

