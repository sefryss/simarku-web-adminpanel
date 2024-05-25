import 'package:ebookadminpanel/model/story_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ebookadminpanel/controller/home_controller.dart';
import '../../theme/color_scheme.dart';
import '../../util/responsive.dart';
import '../common/common.dart';

class CategoryDropDown extends StatelessWidget {
  final Function(Category)? onChanged;
  final Category? value;

  final HomeController homeController;

  CategoryDropDown(
    this.homeController, {
    Key? key,
    this.onChanged,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return getDropDown(context: context, dataController: homeController);
  }

  Widget getDropDown({
    required BuildContext context,
    required HomeController dataController,
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
              borderColor: getBorderColor(context),
              borderWidth: 1),
          alignment: Alignment.centerLeft,
          child: DropdownButton<Category>(
            hint: getTextWidget(
                context, 'Select Category', fontSize, getSubFontColor(context),
                fontWeight: FontWeight.w400),
            isExpanded: true,
            icon: imageAsset('down.png',
                    height: 12.h, width: 12.h, color: getFontColor(context))
                .paddingSymmetric(horizontal: 10.h),
            items: dataController.categoryList.map((Category category) {
              return DropdownMenuItem<Category>(
                value: category,
                child: getTextWidget(
                    context,
                    getCategoryString(
                        category), // Use getCategoryString for display
                    fontSize,
                    getFontColor(context),
                    fontWeight: FontWeight.w400),
              );
            }).toList(),
            value: dataController.category.value,
            underline: Container(),
            onChanged: (Category? newValue) {
              if (newValue != null &&
                  newValue != dataController.category.value) {
                dataController.category.value = newValue;
                onChanged?.call(newValue);
              }
            },
          ),
        ));
  }
}

// Ensure this function matches your implementation
String getCategoryString(Category category) {
  switch (category) {
    case Category.bebasBaca:
      return 'Bebas Baca';
    case Category.tukarMilik:
      return 'Tukar Milik';
    case Category.tukarPinjam:
      return 'Tukar Pinjam';
    default:
      return '';
  }
}
