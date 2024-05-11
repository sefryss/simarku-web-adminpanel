import 'package:ebookadminpanel/model/authors_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ebookadminpanel/controller/home_controller.dart';

import '../../theme/color_scheme.dart';
import '../../util/responsive.dart';
import '../common/common.dart';





class AuthorDropDown extends StatelessWidget {
  final Function? onChanged;
  final String? value;

  final  HomeController homeController;
  AuthorDropDown(this.homeController,{
    Key? key,
    this.onChanged,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    if(homeController.authorList.length > 0){
      if(value == null){
        onChanged!(homeController.authorList[0].id);
        homeController.author(homeController.authorList[0].id);
      }else{
        onChanged!(value);
        homeController.author(value);
      }

    }
    return  homeController.authorList.length > 0
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
          bgColor: getReportColor(context),
          borderColor: getBorderColor(context),
          borderWidth: 1),



      alignment: Alignment.centerLeft,
      child: DropdownButton<String>(
        hint: getTextWidget(context,'Select Author',fontSize,getSubFontColor(context),fontWeight: FontWeight.w400),
        isExpanded: true,
        icon: imageAsset('down.png', height: 12.h, width: 12.h,color: getFontColor(context)).paddingSymmetric(horizontal: 10.h),

        items: homeController.authorList.map((val) {
          TopAuthors model = val;
          return DropdownMenuItem<String>(
            value: model.id!,
            child: getTextWidget(context,model.authorName!,fontSize,getFontColor(context),fontWeight: FontWeight.w400),

          );
        }).toList(),
        value: homeController.author.value,
        underline: Container(),
        onChanged: (value) {
          onChanged!(value);
          homeController.author(value);
        },
      ),
    ),);
  }

}

