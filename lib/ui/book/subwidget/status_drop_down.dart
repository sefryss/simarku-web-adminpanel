import 'package:ebookadminpanel/theme/color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ebookadminpanel/controller/home_controller.dart';

import '../../../util/responsive.dart';
import '../../common/common.dart';


class PDFDropDown extends StatelessWidget {
  final Function? onChanged;
  final String? value;

  final  HomeController homeController;
  PDFDropDown(this.homeController,{
    Key? key,
    this.onChanged,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

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
        hint: getTextWidget(context,'Select Status',fontSize,getSubFontColor(context),fontWeight: FontWeight.w400),
        isExpanded: true,
        icon: imageAsset('down.png', height: 12.h, width: 12.h,color: getFontColor(context)).paddingSymmetric(horizontal: 10.h),

        items: homeController.pdfOptionList.map((element){

          print("listLen----${homeController.pdfOptionList.length}------${element}");
          return DropdownMenuItem<String>(
            value: element,
            child: getTextWidget(context,element,fontSize,getFontColor(context),fontWeight: FontWeight.w400),

          );
        }).toList(),

        value: (homeController.pdf.value.isEmpty)?homeController.pdfOptionList[0]:homeController.pdf.value,
        underline: Container(),
        onChanged: (value) {
          onChanged!(value);
          homeController.pdf(value);
        },
      ),
    ));
  }

}

