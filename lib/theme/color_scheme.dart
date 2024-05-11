import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

extension CustomColorScheme on ColorScheme {
  Color get baseColor =>
      '#072846'.toColor();

  Color get reportCellColor => brightness == Brightness.light
      ? '#F8F8F8'.toColor()
      : '#2E2E2E'.toColor();

  Color get appBackgroundColor =>
      brightness == Brightness.light ? backgroundColor : darkBackgroundColor;

  Color get fontColor =>
      brightness == Brightness.light ? textColor : Colors.white;

Color get subFontColor =>
      brightness == Brightness.light ? subTextColor : Colors.white60;

  Color get baseLightColor =>
      brightness == Brightness.light ? Colors.white60 : Colors.black54;

  Color get crossColor =>
      brightness == Brightness.light ? Colors.black : Colors.white;


 Color get cardBgColor =>
     brightness == Brightness.light ? cardColor:darkCardColor;

  Color get subCardBgColor =>
      brightness == Brightness.light ?'#ffffff'.toColor()
          :darkSubCardColor;

  Color get themeBorderColor =>
      brightness == Brightness.light ? borderColor
          :darkBorderColor;

Color get subPrimaryColor =>
      brightness == Brightness.light ? subPrimaryTextColor
          :darkBorderColor;

}



Color subPrimaryColor(BuildContext context) {
  return Theme.of(context).colorScheme.subPrimaryColor;
}

Color getReportColor(BuildContext context) {
  return Theme.of(context).colorScheme.reportCellColor;
}

Color getOpacityColor(BuildContext context) { 
  return Theme.of(context).primaryColor.withOpacity(0.15);
}


Color getFontColor(BuildContext context) {
  return Theme.of(context).colorScheme.fontColor;
}

Color getSubFontColor(BuildContext context) {
  return Theme.of(context).colorScheme.subFontColor;
}

getPrimaryColor(BuildContext context) {
  return Theme.of(context).primaryColor;
}

getBackgroundColor(BuildContext context) {
  return Theme.of(context).colorScheme.appBackgroundColor;
}

getCardColor(BuildContext context) {
  return Theme.of(context).colorScheme.cardBgColor;
}

getSubCardColor(BuildContext context) {
  return Theme.of(context).colorScheme.subCardBgColor;
}

getBaseColor(BuildContext context) {
  return Color(0x0c000000);
}
getBorderColor(BuildContext context) {
  return Theme.of(context).colorScheme.themeBorderColor;
}
