import 'package:ebookadminpanel/theme/color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ebookadminpanel/controller/home_controller.dart';
import '../../../util/responsive.dart';
import '../../common/common.dart';
import 'package:ebookadminpanel/model/story_model.dart';

class BookTypeDropdown extends StatelessWidget {
  final Function(BookType)? onChanged;
  final BookType? value;

  final HomeController homeController;

  BookTypeDropdown(this.homeController, {
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
    required HomeController dataController
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
        borderWidth: 1
      ),
      alignment: Alignment.centerLeft,
      child: DropdownButton<BookType>(
        hint: getTextWidget(
          context, 'Select Book Type', fontSize, getSubFontColor(context),
          fontWeight: FontWeight.w400
        ),
        isExpanded: true,
        icon: imageAsset(
          'down.png', height: 12.h, width: 12.h, color: getFontColor(context)
        ).paddingSymmetric(horizontal: 10.h),
        items: dataController.bookTypeList.map((BookType bookType) {
          return DropdownMenuItem<BookType>(
            value: bookType,
            child: getTextWidget(
              context,
              getBookTypeString(bookType), // Use getBookTypeString for display
              fontSize,
              getFontColor(context),
              fontWeight: FontWeight.w400
            ),
          );
        }).toList(),
        value: dataController.bookType.value,
        underline: Container(),
        onChanged: (BookType? newValue) {
          if (newValue != null && newValue != dataController.bookType.value) {
            dataController.bookType.value = newValue;
            onChanged?.call(newValue);
          }
        },
      ),
    ));
  }
}

// extension BookTypeExtension on BookType {
//   static BookType fromString(String value) {
//     switch (value) {
//       case 'physichBook': // Ensure these match the enum names exactly
//         return BookType.physichBook;
//       case 'ebook':
//         return BookType.ebook;
//       default:
//         throw ArgumentError('Invalid BookType string: $value');
//     }
//   }
// }

String getBookTypeString(BookType bookType) {
  switch (bookType) {
    case BookType.physichBook:
      return 'Buku Fisik';
    case BookType.ebook:
      return 'E-Book';
    default:
      return '';
  }
}
