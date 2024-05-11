import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../theme/color_scheme.dart';
import '../common/common.dart';



List entryList=[10,15,20];


class EntriesDropDown extends StatelessWidget {
  final Function onChanged;
  final int value;


  EntriesDropDown({
    Key? key,
   required this.onChanged,
   required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {


      return getDropDown(
        context: context,
        value: value,

      );

  }
  getDropDown(
      {



        required int value,
        required BuildContext context,
      }) {





    return Container(
      height: 40.h,
      width: 100.h,

      padding: EdgeInsets.symmetric(horizontal: 12.h),
      decoration: getDefaultDecoration(borderColor: getBorderColor(context),borderWidth:1.8,radius: getResizeRadius(context,20)),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(50),
      //     border: Border.all(color: Colors.grey.shade300,width: 1),
      //     color: getBackgroundColor(context)
      //
      //
      // ),




      child: DropdownButton<int>(
        hint: getTextWidget(context, '',0, Colors.transparent),

        icon: imageAsset('down.png', height: 14.h, width: 14.h,color: getFontColor(context)).paddingSymmetric(horizontal: 10.h),
        // icon: imageSvg('down.svg', height: 8.h, width: 8.h),

        isExpanded: true,
        items: entryList.map((val) {
          return DropdownMenuItem<int>(
            value: val,
            child: getTextWidget(context,val.toString(),42,getFontColor(context),fontWeight: FontWeight.w500,),
          );
        }).toList(),
        value: value,

        underline: Container(),
        onChanged: (value) {
          onChanged(value);

        },
      ),
    );
  }

}

