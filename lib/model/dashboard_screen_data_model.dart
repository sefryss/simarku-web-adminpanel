import 'dart:ui';

class DashBoardData {
  final String? title;
  final String? tableName;
  final String? icon;
  final Color? backgroundColor;
  final Color? buttonColor;
  final int? navigateId;
  final int? navigateIndex;
  final int? navigateAddClassId;
  final int? action;
  final bool? isPopular;
  final bool? isFeatured;

  final int? addAction;

  DashBoardData(
      {this.title,
      this.tableName,
      this.isFeatured,
      this.isPopular,
      this.icon,
      this.backgroundColor,
      this.buttonColor,
      this.navigateId,
      this.navigateIndex,
      this.action,
      this.addAction,
      this.navigateAddClassId});
}
