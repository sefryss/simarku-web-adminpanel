
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ebookadminpanel/theme/app_theme.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

import '../../main.dart';
import '../../theme/color_scheme.dart';
import '../../util/constants.dart';
import '../../util/responsive.dart';

Widget getVerticalSpace(BuildContext context, double value) {
  if (Responsive.isTablet(context)) {
    return (value.h * 1.7).verticalSpace;
  }
  return value.h.verticalSpace;
}

Widget getTextWidget(
    BuildContext context, String text, double fontSize, Color fontColor,
    {TextOverflow overflow = TextOverflow.ellipsis,
    TextDecoration decoration = TextDecoration.none,
    FontWeight fontWeight = FontWeight.normal,
    TextAlign textAlign = TextAlign.start,
    String? customFont,
    txtHeight}) {
  return Text(
    text,
    style: TextStyle(
        decoration: decoration,
        fontSize: getResizeFont(context, fontSize),
        color: fontColor,
        fontFamily: customFont == null ? Constants.fontsFamily : customFont,
        fontWeight: fontWeight),
    softWrap: true,
    textAlign: textAlign,
  );
}

Widget getMaxLineFont(BuildContext context, String text, double fontSize,
    Color fontColor, int maxLine,
    {TextOverflow overflow = TextOverflow.ellipsis,
    TextDecoration decoration = TextDecoration.none,
    FontWeight fontWeight = FontWeight.normal,
    TextAlign textAlign = TextAlign.start,
    String? customFont,
    String? font,
    txtHeight}) {
  return Text(
    text,
    overflow: overflow,
    style: TextStyle(
        decoration: decoration,
        fontSize: getResizeFont(context, fontSize),
        fontStyle: FontStyle.normal,
        color: fontColor,
        fontFamily: customFont == null ? Constants.fontsFamily : customFont,
        fontWeight: fontWeight,height: txtHeight),
    maxLines: maxLine,
    softWrap: true,
    textAlign: textAlign,
  );
}

separatorBuilder(BuildContext context,{RxString? queryText, String? value}) {
  bool cell = true;

  if (queryText != null &&value !=null) {
    if (queryText.value.isNotEmpty && !value.contains(queryText.value)) {
      cell = false;
    }
  }

  return Container(
    height: 0.5,
    width: double.infinity,
    color: cell ? getBorderColor(context) : Colors.transparent,
    margin: EdgeInsets.symmetric(vertical: 4.h),
  );
}

Widget imageAsset(String icon,
    {required double height,
    required double width,
    Color? color,
    BoxFit? boxFit}) {
  return Image.asset(
    Constants.assetPath + icon,
    height: height,
    width: width,
    color: color == null ? null : color,
    fit: boxFit == null ? null : boxFit,
  );
}

getDefaultHorSpace(BuildContext context) {
  if (Responsive.isDesktop(context)) {
    return 55.w;
  } else if (Responsive.isTablet(context)) {
    return 12.w;
  } else if (Responsive.isMobile(context)) {
    return 55.w;
  } else {
    return 15.w;
  }
}

getBrightnessLight() {
  return themeController.checkDarkTheme()
      ? SystemUiOverlayStyle.light
      : SystemUiOverlayStyle.dark;
}

Widget imageSvg(String icon,
    {required double height,
    required double width,
    Color? color,
    String? folder,
    Function? onTap,
    BoxFit? boxFit}) {
  print("folft===$folder");
  return GestureDetector(
    child: SvgPicture.asset(
      folder == null ? Constants.assetSvgPath + icon : folder + icon,
      height: height,
      width: width,
      // ignore: deprecated_member_use
      color: color == null ? null : color,
    ),
    onTap: () {
      if (onTap != null) {
        onTap();
      }
    },
  );
}

getCommonDialog(
    {required BuildContext context,
    required String title,
    required String subTitle,
    required Function function}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(subTitle),
        content: Text(title),
        actions: <Widget>[
          new TextButton(
            child: new Text('No',
                style: TextStyle(color: getPrimaryColor(context))),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          new TextButton(
            child: new Text('Yes',
                style: TextStyle(color: getPrimaryColor(context))),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          )
        ],
      );
    },
  ).then((value) {
    if (value) {
      function();
    }
  });
}


Widget getSvgImage(String image,
    {double? width,
      double? height,
      Color? color,
      BoxFit boxFit = BoxFit.contain}) {
  return SvgPicture.asset(
    Constants.assetPath + image,
    // ignore: deprecated_member_use
    color: color,
    width: width,
    height: height,
    fit: boxFit,
  );
}


Widget getSvgImage1(String image,
    {double? width,
      double? height,
      Color? color,
      BoxFit boxFit = BoxFit.contain}) {
  return SvgPicture.asset(
    Constants.assetSvgPath + image,
    // ignore: deprecated_member_use
    color: color,
    width: width,
    height: height,
    fit: boxFit,
  );
}

Widget getCustomFont(String text, double fontSize, Color fontColor, int maxLine,
    {String? fontFamily ,
      TextOverflow overflow = TextOverflow.ellipsis,
      TextDecoration decoration = TextDecoration.none,
      FontWeight fontWeight = FontWeight.normal,
      TextAlign textAlign = TextAlign.start,
      txtHeight}) {
  return Text(
    text,
    overflow: overflow,
    style: TextStyle(
      decoration: decoration,
      fontSize: fontSize,
      color: fontColor,
      fontFamily: fontFamily ?? Constants.fontsFamily,
      height: txtHeight ?? 1.5.h,
      fontWeight: fontWeight,
    ),
    maxLines: maxLine,
    softWrap: true,
    textAlign: textAlign,
  );
}

Widget getVerSpace(double verSpace) {
  return SizedBox(
    height: verSpace,
  );
}

Widget getHorSpace(double horSpace) {
  return SizedBox(
    width: horSpace,
  );
}



Widget getMultilineCustomFont(String text, double fontSize, Color fontColor,
    {TextOverflow overflow = TextOverflow.ellipsis,
      TextDecoration decoration = TextDecoration.none,
      FontWeight fontWeight = FontWeight.normal,
      TextAlign textAlign = TextAlign.start,
      txtHeight = 1.0,
      String? fontFamily}) {
  return Text(
    text,
    style: TextStyle(
        decoration: decoration,
        fontSize: fontSize,
        fontStyle: FontStyle.normal,
        color: fontColor,
        fontFamily: fontFamily ?? Constants.fontsFamily,
        height: txtHeight,
        fontWeight: fontWeight),
    textAlign: textAlign,
  );
}


Widget getTextFiledWidget(
    BuildContext context, String s, TextEditingController textEditingController,
    {bool? isEnabled,
    var inputType,
    var inputFormatters,
    var onChanged,
      Function? function,
    Widget? child}) {
  double height = 45.h;

  if (Responsive.isTablet(context)) {
    height = 55.h;
  }

  // double radius = (Responsive.isMobile(context))?30.r:12.r;
  double radius = getDefaultRadius(context);
  double fontSize = getResizeFont(context, 40);

  Widget textFiled = TextFormField(
    maxLines: 1,
    onTap: () {},
    enabled: (isEnabled != null) ? isEnabled : true,
    controller: textEditingController,
    textAlign: TextAlign.start,
    textAlignVertical: TextAlignVertical.center,
    keyboardType: (inputType != null) ? inputType : null,
    inputFormatters: (inputFormatters != null) ? inputFormatters : null,
    onChanged: (onChanged != null) ? onChanged : null,
    style: TextStyle(
        fontFamily: Constants.fontsFamily,
        color: getFontColor(context),
        fontWeight: FontWeight.w400,
        fontSize: fontSize),
    decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 10.h,),
        border: InputBorder.none,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          borderSide: BorderSide(
            color: getPrimaryColor(context),
          )
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
            borderSide: BorderSide(
              color: borderColor,
            )
        ),
        errorBorder: InputBorder.none,
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
            borderSide: BorderSide(
              color: borderColor,
            )
        ),
        // suffixIcon: (child != null)?InkWell(
        //   onTap: (){
        //     if(function != null){
        //       function();
        //     }
        //   },
        //   child: Container(
        //     height: height,
        //     width: 112.h,
        //     child: child,
        //   ),
        // ):null,
        // suffixIcon: Container(height: height,child: child),
        filled: true,
        fillColor: getCardColor(context),
        // fillColor: getReportColor(context),
        focusColor: Colors.green,
        hintText: s,
        isDense: false,
        hintStyle: TextStyle(
            fontFamily: Constants.fontsFamily,
            color: getSubFontColor(context),
            fontWeight: FontWeight.w400,
            fontSize: fontSize)),
  );

  // return Container(
  //   height: height,
  //   alignment: Alignment.center,
  //   decoration: getDefaultDecoration(
  //       radius: radius,
  //       bgColor: getReportColor(context),
  //       borderColor: getBorderColor(context),
  //       borderWidth: 1),
  //   child: child == null
  //       ? textFiled
  //       : Row(
  //           children: [Expanded(child: textFiled), child],
  //         ),
  // );

  return child == null
        ? textFiled
        : Row(
            children: [Expanded(child: textFiled), Container(height: height,child: child)],
          );

}

Widget getMessageTextFiledWidget(
    BuildContext context, String s, TextEditingController textEditingController,
    {bool? isEnabled,
      var inputType,
      var inputFormatters,
      var onChanged,
      Widget? child}) {



  double radius = 12.r;
  // double radius = getDefaultRadius(context);
  double fontSize = getResizeFont(context, 40);
  Widget textFiled = TextFormField(
    maxLines: 6,
    onTap: () {},
    enabled: (isEnabled != null) ? isEnabled : true,
    controller: textEditingController,
    textAlign: TextAlign.start,
    textAlignVertical: TextAlignVertical.center,
    keyboardType: (inputType != null) ? inputType : null,
    inputFormatters: (inputFormatters != null) ? inputFormatters : null,
    onChanged: (onChanged != null) ? onChanged : null,
    style: TextStyle(
        fontFamily: Constants.fontsFamily,
        color: getFontColor(context),
        fontWeight: FontWeight.w400,
        fontSize: fontSize),

    decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 10.h,top: 25.h),
        border: InputBorder.none,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
            borderSide: BorderSide(
              color: getPrimaryColor(context),
            )
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
            borderSide: BorderSide(
              color: borderColor,
            )
        ),
        errorBorder: InputBorder.none,
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
            borderSide: BorderSide(
              color: borderColor,
            )
        ),
        // suffixIcon: (child != null)?InkWell(
        //   onTap: (){
        //     if(function != null){
        //       function();
        //     }
        //   },
        //   child: Container(
        //     height: height,
        //     width: 112.h,
        //     child: child,
        //   ),
        // ):null,
        // suffixIcon: Container(height: height,child: child),
        filled: true,
        fillColor: getCardColor(context),
        // fillColor: getReportColor(context),
        focusColor: Colors.green,
        hintText: s,
        isDense: false,
        hintStyle: TextStyle(
            fontFamily: Constants.fontsFamily,
            color: getSubFontColor(context),
            fontWeight: FontWeight.w400,
            fontSize: fontSize)),
  );

  return child == null
      ? textFiled
      : Row(
    children: [Expanded(child: textFiled), child],
  );
}

String removeAllHtmlTags(String htmlText) {
  RegExp exp = RegExp(
      r"<[^>]*>",
      multiLine: true,
      caseSensitive: true
  );

  return htmlText.replaceAll(exp, '');
}



Widget getDisableDropDownWidget(BuildContext context, String s,
    {bool? isEnabled,
    var inputType,
    var inputFormatters,
    var onChanged,
    Widget? child}) {
  double height = 45.h;

  if (Responsive.isTablet(context)) {
    height = 55.h;
  }

  double radius = (Responsive.isMobile(context))?30.r:12.r;
  // double radius = getDefaultRadius(context);
  double fontSize = getResizeFont(context, 40);
  Widget textFiled = TextFormField(
    maxLines: 1,
    onTap: () {},
    enabled: false,
    textAlign: TextAlign.start,
    textAlignVertical: TextAlignVertical.center,
    keyboardType: (inputType != null) ? inputType : null,
    inputFormatters: (inputFormatters != null) ? inputFormatters : null,
    onChanged: (onChanged != null) ? onChanged : null,
    style: TextStyle(
        fontFamily: Constants.fontsFamily,
        color: getFontColor(context),
        fontWeight: FontWeight.w400,
        fontSize: fontSize),
    decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 5.h, top: 2.h, right: 5.h),
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        hintText: s,

        // suffixIcon: Container(alignment: Alignment.centerRight,child: imageAsset('down.png',
        //     height: 10.h, width: 10.h,color: getFontColor(context))),

        isDense: true,
        hintStyle: TextStyle(
            fontFamily: Constants.fontsFamily,
            color: getSubFontColor(context),
            fontWeight: FontWeight.w400,
            fontSize: fontSize)),
  );

  return Container(
    height: height,
    alignment: Alignment.center,
    decoration: getDefaultDecoration(
        radius: radius,
        bgColor: getCardColor(context),
        borderColor: getBorderColor(context),
        borderWidth: 1),
    child: Row(
      children: [
        Expanded(child: textFiled),
        imageAsset('down.png',
            height: 10.h, width: 10.h, color: getFontColor(context)).paddingSymmetric(horizontal: 10.h),
        // getHorizontalSpace(context, 5)
      ],
    ),
  );
}

Widget getDisableTextFiledWidget(BuildContext context, String s,
    {bool? isEnabled,
    var inputType,
    var inputFormatters,
    var onChanged,
    Widget? child}) {
  double height = 45.h;

  if (Responsive.isTablet(context)) {
    height = 55.h;
  }

  // double radius = (Responsive.isMobile(context))?30.r:12.r;
  double radius = getDefaultRadius(context);
  double fontSize = getResizeFont(context, 40);
  Widget textFiled = TextFormField(
    maxLines: 1,
    onTap: () {},
    enabled: false,
    textAlign: TextAlign.start,
    textAlignVertical: TextAlignVertical.center,
    keyboardType: (inputType != null) ? inputType : null,
    inputFormatters: (inputFormatters != null) ? inputFormatters : null,
    onChanged: (onChanged != null) ? onChanged : null,
    style: TextStyle(
        fontFamily: Constants.fontsFamily,
        color: getFontColor(context),
        fontWeight: FontWeight.w400,
        fontSize: fontSize),
    decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 5.h, top: 2.h),
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        hintText: s,
        isDense: true,
        hintStyle: TextStyle(
            fontFamily: Constants.fontsFamily,
            color: getSubFontColor(context),
            fontWeight: FontWeight.w400,
            fontSize: fontSize)),
  );

  return Container(
    height: height,
    alignment: Alignment.center,
    decoration: getDefaultDecoration(
        radius: radius,
        bgColor: getCardColor(context),
        borderColor: getBorderColor(context),
        borderWidth: 1),
    child: child == null
        ? textFiled
        : Row(
            children: [Expanded(child: textFiled), child],
          ),
  );
}

bool isNotEmpty(String s) {
  return (s.isNotEmpty);
}


bool isEmpty(String s) {
  return (s.isEmpty);
}




String decode(String codeUnits) {
  var unescape = HtmlUnescape();

  codeUnits = codeUnits.replaceAll("<pre>", '');
  codeUnits = codeUnits.replaceAll("</pre>", '');
  codeUnits = codeUnits.replaceAll("<p>", '');
  codeUnits = codeUnits.replaceAll("</p>", '');
  codeUnits = codeUnits.replaceAll("<strong>", '');
  codeUnits = codeUnits.replaceAll("</strong>", '');
  String singleConvert = unescape
      .convert(codeUnits.replaceAll("\\n\\n", "<br>"))
      .replaceAll("\\n", "<br>");
  return unescape.convert(singleConvert);
}

bool isValidEmail(String email) {
  return RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(email);
}



Widget getSearchTextFiledWidget(
  BuildContext context,
  String s,
  TextEditingController textEditingController, {
  bool? isEnabled,
  var inputType,
  var inputFormatters,
  var onChanged,
}) {
  double height = 45.h;
  double radius = getResizeRadius(context, 45);
  double fontSize = getResizeFont(context, 45);

  return Container(
    height: height,
    alignment: Alignment.center,
    decoration: getDefaultDecoration(
      radius: radius,
      bgColor: getReportColor(context),
    ),
    child: Row(

      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 20.h,
          alignment: Alignment.centerLeft,
          child: imageSvg('search.svg', height: 18.h, width: 18.h),
        ).marginSymmetric(horizontal: 15.h),
        Expanded(
          child: TextFormField(
            onTap: () {
              // if (onTapFunction != null) {
              //   onTapFunction();
              // }
            },
            enabled: (isEnabled != null) ? isEnabled : true,
            controller: textEditingController,
            textAlign: TextAlign.start,
            textAlignVertical: TextAlignVertical.center,
            keyboardType: (inputType != null) ? inputType : null,
            inputFormatters: (inputFormatters != null) ? inputFormatters : null,
            onChanged: (onChanged != null) ? onChanged : null,
            style: TextStyle(
                // height: 1.5,
                color: getFontColor(context),
                fontWeight: FontWeight.w400,
                fontFamily: Constants.fontsFamily,
                fontSize: fontSize),
            decoration: InputDecoration(
                // contentPadding: EdgeInsets.zero,

                // contentPadding: EdgeInsets.only(top: isWeb(context)?7.h:0.h,bottom:  isWeb(context)?0.h:10.h),
                border: InputBorder.none,
                // isCollapsed: true,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintText: s,
                // prefixIcon: Container(
                //   width: 20.h,
                //   alignment: Alignment.centerLeft,
                //   child: imageSvg('search.svg', height: 20.h, width: 20.h),
                // ).marginSymmetric(horizontal: 15.h),
                isDense: true,
                hintStyle: TextStyle(
                    color: getSubFontColor(context),
                    fontFamily: Constants.fontsFamily,
                    fontWeight: FontWeight.w400,
                    fontSize: fontSize)),
          ),
        ),
      ],
    ),
  );
}

getResizeFont(BuildContext context, double font) {
  if (Responsive.isDesktop(context)) {
    return (font / 4).sp;
  } else if (Responsive.isTablet(context)) {
    return (font / 2).sp;
  } else {
    return (font).sp;
  }
}

getResizeRadius(BuildContext context, double font) {
  if (Responsive.isDesktop(context)) {
    // return (font).r;
    return (font / 2).r;
  } else if (Responsive.isTablet(context)) {
    // return (font).r;
    return (font / 2).r;
  } else {
    return font.r;
  }
}

getResizeSize(BuildContext context, double size) {
  if (Responsive.isDesktop(context)) {
    return (size / 3.5);
  } else if (Responsive.isTablet(context)) {
    return (size / 2);
  } else {
    return size;
  }
}

getDefaultButtonSize(BuildContext context) {
  if (Responsive.isTablet(context)) {
    return 65.h;
  }

  return 55.h;
}

getDefaultRadius(BuildContext context) {


  if(Responsive.isMobile(context)){return 30.r;}else{return 12.r;}
  // if (Responsive.isDesktop(context)) {
  //   return 5.r;
  // } else if (Responsive.isTablet(context)) {
  //   return 10.r;
  // } else {
  //   return 20.r;
  // }
}

hideKeyboard() {
  FocusManager.instance.primaryFocus?.unfocus();
}

getDefaultBtnRadius() {
  return 20.r;
}

getDefaultFontSize() {
  return 45.toDouble();
}

getDefaultPageSpace(BuildContext context) {
  if (Responsive.isDesktop(context)) {
    return 60.w;
  } else if (Responsive.isTablet(context)) {
    return 25.w;
  } else {
    return 15.w;
  }
}

getProgressDialog(BuildContext context,
    {Color? color, Color? backgroundColor, double? height, double? width}) {
  return new Container(
      height: height == null ? double.infinity : height,
      width: width == null ? double.infinity : width,
      child: new Center(
          child: CupertinoActivityIndicator(
        color: color == null ? Colors.grey : color,
      )));
}

getProgressWidget(BuildContext context) {
  return Center(
    child: Container(
      height: 70.h,
      width: 70.h,
      child: getProgressDialog(context, color: getPrimaryColor(context)),
    ),
  );
}

getHorizontalSpace(BuildContext context, double width) {
  if (Responsive.isDesktop(context)) {
    return width.w.horizontalSpace;
  } else if (Responsive.isTablet(context)) {
    return width.w.horizontalSpace;
  } else {
    return (width * 2).h.horizontalSpace;
  }
}

Widget getButtonWidget(BuildContext context, String s, Function function,
    {double? horizontalSpace,
    IconData? icon,
    var color,
    double? verticalSpace,
    Color? bgColor,
    bool? isProgress,
    Color? textColor,
    double? btnHeight,
    double? horPadding,
    double? verPadding,
    Widget? child,
    Color? iconColor}) {
  double height = btnHeight == null ? getDefaultButtonSize(context) : btnHeight;
  double radius = 12.r;
  // double radius = getDefaultRadius(context);
  double fontSize = btnHeight == null
      ? getDefaultFontSize()
      : getResizeFont(
          context, isWeb(context) ? (btnHeight * 3) : (btnHeight * 5.5));
  double progressDialogSize = isWeb(context) ? (15.h) : (5.h);

  return InkWell(
    splashColor: Colors.black12,
    onTap: () {
      hideKeyboard();
      function();
    },
    child: Container(
      height: height,
      margin: EdgeInsets.symmetric(
          vertical:
              verticalSpace == null ? getDefaultHorSpace(context) : verticalSpace,
          horizontal: horizontalSpace == null
              ? getDefaultHorSpace(context)
              : horizontalSpace),
      child: Material(
        // <----------------------------- Outer Material
        shadowColor: Colors.transparent,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
        elevation: 0,
        child: Container(
          decoration: getDefaultDecoration(
            radius: radius,
            bgColor: bgColor == null ? primaryColor : bgColor,
          ),
          padding: EdgeInsets.symmetric(
              horizontal: horPadding == null
                  ? 0
                  : isWeb(context)
                      ? horPadding
                      : (horPadding / 2),
              vertical: verPadding == null ? 0 : verPadding),
          child: Material(
            // <------------------------- Inner Material
            type: MaterialType.transparency,
            elevation: 1.0,
            color: Colors.transparent,
            shadowColor: Colors.black12,
            child: InkWell(
              //<------------------------- InkWell

              child: Container(
                alignment: Alignment.center,
                child: (isProgress != null && isProgress)
                    ? getProgressDialog(context,
                        color: Colors.white,
                        backgroundColor: Colors.transparent,
                        width: progressDialogSize,
                        height: progressDialogSize)
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          s.isEmpty
                              ? Container()
                              : getTextWidget(context, s, fontSize,
                                  textColor == null ? Colors.white : textColor,
                                  fontWeight: FontWeight.w600,customFont: ""),
                          getHorizontalSpace(context, icon == null ? 0 : 15),
                          icon == null
                              ? Container()
                              : Container(
                                  child: Icon(
                                    icon,
                                    color: iconColor == null
                                        ? Colors.white
                                        : iconColor,
                                    size: 60.h,
                                  ),
                                ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget getPasswordTextFiledWidget(
  BuildContext context,
  String s,
  TextEditingController textEditingController, {
  bool? isEnabled,
  var inputType,
  var inputFormatters,
  var onChanged,
  var onSubmit,
}) {
  double height = getDefaultButtonSize(context);
  double radius = 12.r;
  // double radius = getDefaultRadius(context);
  double fontSize = getResizeFont(context, 45);


  RxBool isSecure = true.obs;

  return Container(
    height: height,
    alignment: Alignment.center,
    decoration: getDefaultDecoration(
        radius: radius,
        bgColor: getSubCardColor(context),
        borderColor: getBorderColor(context),
        borderWidth: 1),
    child: Obx(() => TextFormField(
      maxLines: 1,
      onTap: () {
        // if (onTapFunction != null) {
        //   onTapFunction();
        // }
      },
      enabled: (isEnabled != null) ? isEnabled : true,
      onFieldSubmitted: (onSubmit != null) ? onSubmit : null,

      controller: textEditingController,
      obscureText: isSecure.value,
      textAlign: TextAlign.start,
      textAlignVertical: TextAlignVertical.center,
      keyboardType: (inputType != null) ? inputType : null,
      inputFormatters: (inputFormatters != null) ? inputFormatters : null,
      onChanged: (onChanged != null) ? onChanged : null,
      style: TextStyle(
          color: getFontColor(context),
          fontFamily: Constants.fontsFamily,
          fontWeight: FontWeight.w400,
          fontSize: fontSize),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 22.w),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintText: s,
          isDense: true,
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                  onTap: (){

                    (isSecure.value)?isSecure.value = false:isSecure.value = true;

                  },
                  child: Center(child: Obx(() => imageAsset((isSecure.value)?"hide.png":"view.png", height: 18.h, width: 18.h,color: Colors.grey.shade500)))),
            ],
          ),
          hintStyle: TextStyle(
              fontFamily: Constants.fontsFamily,
              color: getSubFontColor(context),
              fontWeight: FontWeight.w400,
              fontSize: fontSize)),
    )),
  );
}



Widget getDefaultTextFiledWidget(
    BuildContext context,
    String s,
    TextEditingController textEditingController, {
      bool? isEnabled,
      var inputType,
      var inputFormatters,
      var onChanged,
    }) {
  double height = getDefaultButtonSize(context);
  double radius = 12.r;
  // double radius = getDefaultRadius(context);
  double fontSize = getResizeFont(context, 45);

  return Container(
    height: height,
    alignment: Alignment.center,
    decoration: getDefaultDecoration(
        radius: radius,
        bgColor: getSubCardColor(context),
        borderColor: getBorderColor(context),
        borderWidth: 1),
    child: TextFormField(
      maxLines: 1,
      onTap: () {},
      enabled: (isEnabled != null) ? isEnabled : true,
      controller: textEditingController,
      textAlign: TextAlign.start,
      textAlignVertical: TextAlignVertical.center,
      keyboardType: (inputType != null) ? inputType : null,
      inputFormatters: (inputFormatters != null) ? inputFormatters : null,
      onChanged: (onChanged != null) ? onChanged : null,
      style: TextStyle(
          fontFamily: Constants.fontsFamily,
          color: getFontColor(context),
          fontWeight: FontWeight.w400,
          fontSize: fontSize),
      decoration: InputDecoration(
        prefixIconConstraints: BoxConstraints(
          maxHeight: height,
          minHeight: height
        ),
          prefixIcon: SizedBox(
            height: height,
            width: 22.w,
          ),
          contentPadding: EdgeInsets.only(left: 22.w),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintText: s,
          isDense: true,
          hintStyle: TextStyle(
              fontFamily: Constants.fontsFamily,
              color: getSubFontColor(context),
              fontWeight: FontWeight.w400,
              fontSize: fontSize)),
    ),
  );
}

showCustomToast(
    {required BuildContext context, required String message, String? title}) {
  print("calledToast----true");
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      fontSize: getResizeFont(context, 50));
}


bool hasValidUrl(String value) {
  String pattern = r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?';
  RegExp regExp = new RegExp(pattern);
  // if (value.length == 0) {
  //   return 'Please enter url';
  // }


  print("hasMatch============${regExp.hasMatch(value)}");
  if (!regExp.hasMatch(value)) {
    return false;
  }
  return true;
}

getDefaultDecoration(
    {double? radius,
    Color? bgColor,
    Color? borderColor,
    bool? isShadow,
    Color? shadowColor,
    double? borderWidth,
    var shape}) {
  return ShapeDecoration(
    color: (bgColor == null) ? Colors.transparent : bgColor,
    shadows: isShadow == null
        ? []
        : [
            BoxShadow(
                color: shadowColor == null ? Colors.grey.shade200 : shadowColor,
                spreadRadius: 0,
                blurRadius: 10,
                offset: Offset(0, 3))
          ],
    shape: SmoothRectangleBorder(
      side: BorderSide(
          color: (borderColor == null) ? Colors.transparent : borderColor,
          width: (borderWidth == null) ? 1 : borderWidth),
      borderRadius: SmoothBorderRadius(
        cornerRadius: (radius == null) ? 0 : radius,
        cornerSmoothing: 0.8,
      ),
    ),
  );
}

getCommonRadius(BuildContext context) {
  return getResizeRadius(context, 35);
}

getCommonPadding(BuildContext context) {
  if (Responsive.isDesktop(context)) {
    return 35.h;
  } else if (Responsive.isTablet(context)) {
    return 35.h;
  } else {
    return 15.h;
  }
}

isWeb(BuildContext context) {
  return Responsive.isDesktop(context);
}

getCommonContainer(
    {required BuildContext context,
    required Widget child,
    double? horSpace,
    double? verSpace,
    EdgeInsets? margin}) {
  double padding = horSpace == null ? getCommonPadding(context) : horSpace;
  double radius = getCommonRadius(context);

  return Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(
        horizontal: padding,
        vertical: verSpace == null ? getCommonPadding(context) : verSpace),
    margin: margin == null ? EdgeInsets.zero : margin,
    decoration: getDefaultDecoration(
        bgColor: getCardColor(context),
        isShadow: themeController.checkDarkTheme() ? null : true,
        radius: radius),
    child: child,
  );
}

getSideDecoration(
    {required double radius,
    bool? topRight,
    bool? topLeft,
    bool? bottomRight,
    bool? bottomLeft,
    Color? bgColor,
    Color? borderColor,
    bool? isShadow,
    Color? shadowColor,
    double? borderWidth,
    var shape}) {
  return ShapeDecoration(
    color: (bgColor == null) ? Colors.transparent : bgColor,
    shadows: isShadow == null
        ? []
        : [
            BoxShadow(
                color: shadowColor == null ? Colors.grey.shade200 : shadowColor,
                spreadRadius: 0,
                blurRadius: 10,
                offset: Offset(0, 3))
          ],
    shape: SmoothRectangleBorder(
      side: BorderSide(
          color: (borderColor == null) ? Colors.transparent : borderColor,
          width: (borderWidth == null) ? 1 : borderWidth),

      borderRadius: SmoothBorderRadius.only(
        topLeft: SmoothRadius(
          cornerRadius: topLeft == null ? 0 : radius,
          cornerSmoothing: 1,
        ),
        topRight: SmoothRadius(
          cornerRadius: topRight == null ? 0 : radius,
          cornerSmoothing: 1,
        ),
        bottomLeft: SmoothRadius(
          cornerRadius: bottomLeft == null ? 0 : radius,
          cornerSmoothing: 0.8,
        ),
        bottomRight: SmoothRadius(
          cornerRadius: bottomRight == null ? 0 : radius,
          cornerSmoothing: 0.8,
        ),
      ),


    ),
  );
}



String deltaToHtml(List<dynamic> desc){

  try {
    final deltaJson = desc;

    final converter = QuillDeltaToHtmlConverter(
        List.castFrom(deltaJson),
        ConverterOptions.forEmail()
    );

    print("delta--------------${converter.convert()}");


    return converter.convert();

  } catch (e, s) {


    print("eroor-----------${e}-----------_${s}");

    return "";
  }


}




getNoData(BuildContext context) {
  return getTextWidget(context, 'No data', 50, getFontColor(context),
      fontWeight: FontWeight.w500);
}


getCommonBackIcon(BuildContext context, {Function? onTap}) {
  return Align(
    alignment: Alignment.centerLeft,
    child: InkWell(
      onTap: (){
        if(onTap != null){
          onTap();
        }
      },
        child: getSvgImage("arrow_left.svg",
            height: 24.h, width: 24.h, color: getFontColor(context))),
  );
}


getCommonChooseFileBtn(BuildContext context,Function function){
  return InkWell(
    onTap: () {
      function();
    },
    child: Container(
      height: double.infinity,
      alignment: Alignment.center,
      margin: EdgeInsets.only(left: 7.h),
      // margin: EdgeInsets.all(7.h),
      padding: EdgeInsets.symmetric(
          horizontal: 5.h, vertical: 5.h),
      decoration: getDefaultDecoration(
          bgColor: getReportColor(context),
          // bgColor: borderColor,
          radius: getResizeRadius(context, 10)),
      child: getTextWidget(
        context,
        'Choose file',
        35,
        getSubFontColor(context),
        // primaryFontColor,
        customFont: "",
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}