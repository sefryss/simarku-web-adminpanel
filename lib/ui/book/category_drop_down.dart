import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ebookadminpanel/controller/home_controller.dart';
import 'package:ebookadminpanel/model/category_model.dart';

import '../../theme/color_scheme.dart';
import '../../util/responsive.dart';
import '../common/common.dart';





class CategoryDropDown extends StatelessWidget {
  final Function? onChanged;
  final String? value;

  final  HomeController homeController;
  CategoryDropDown(this.homeController,{
    Key? key,
    this.onChanged,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    if(homeController.categoryList.length > 0){
      if(value == null){
        onChanged!(homeController.categoryList[0].id);
        homeController.category(homeController.categoryList[0].id);
      }else{
        onChanged!(value);
        homeController.category(value);
      }

    }
    return  homeController.categoryList.length > 0
        ?  getDropDown(
      context: context,
      dataController: homeController,

    )

        : Container();
  }
  getDropDown(
      {required HomeController dataController,


        required BuildContext context,
      }) {




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
          // bgColor: getReportColor(context),
          borderColor: getBorderColor(context),
          borderWidth: 1),



      alignment: Alignment.centerLeft,
      child: DropdownButton<String>(
        hint: getTextWidget(context,'Select Category',fontSize,getSubFontColor(context),fontWeight: FontWeight.w400),
        isExpanded: true,
        icon: imageAsset('down.png', height: 12.h, width: 12.h,color: getFontColor(context)).paddingSymmetric(horizontal: 10.h),

        items: homeController.categoryList.map((val) {
          CategoryModel model = val;
          return DropdownMenuItem<String>(
            value: model.id!,
            child: getTextWidget(context,model.name!,fontSize,getFontColor(context),fontWeight: FontWeight.w400),

          );
        }).toList(),
        value: homeController.category.value,
        underline: Container(),
        onChanged: (value) {
          onChanged!(value);
          homeController.category(value);


        },
      ),
    ),);
  }

}

