// import 'package:ebookadminpanel/main.dart';
// import 'package:ebookadminpanel/model/authors_model.dart';
// import 'package:ebookadminpanel/util/common_blank_page.dart';
// import 'package:ebookadminpanel/util/constants.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_quill/flutter_quill.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:ebookadminpanel/controller/home_controller.dart';
// import 'package:ebookadminpanel/theme/color_scheme.dart';
// import 'package:ebookadminpanel/ui/common/common.dart';
// import '../../../controller/data/LoginData.dart';
// import '../../../util/responsive.dart';

// import '../../home/home_page.dart';

// class AddAuthorScreen extends StatefulWidget {
//   final Function function;
//   final TopAuthors? authorModel;

//   AddAuthorScreen({required this.function, this.authorModel});

//   @override
//   State<AddAuthorScreen> createState() => _AddAuthorScreenState();
// }

// class _AddAuthorScreenState extends State<AddAuthorScreen> {


//   @override
//   Widget build(BuildContext context) {

//     HomeController homeController = Get.find();

//     bool isEdit = widget.authorModel != null;
//     return SafeArea(
//       child: CommonPage(widget: Container(
//         margin: EdgeInsets.symmetric(
//             horizontal: getDefaultHorSpace(context),
//             vertical: getDefaultHorSpace(context)),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             getTextWidget(
//                 context,
//                 isEdit ? 'Edit Author' : 'Add Author',
//                 75,
//                 getFontColor(context),
//                 fontWeight: FontWeight.w700),
//             getVerticalSpace(context, 35),
//             Expanded(
//               child: getCommonContainer(
//                 context: context,
//                 verSpace: 0,
//                 horSpace: isWeb(context) ? null : 15.h,
//                 // width: double.infinity,
//                 // height: double.infinity,
//                 // decoration: getDefaultDecoration(
//                 //     bgColor: getCardColor(context), radius: radius),
//                 // padding: EdgeInsets.all(padding),
//                 child: Column(
//                   children: [
//                     Expanded(
//                       child: ListView(
//                         // crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           getVerticalSpace(context, 30),
//                           getCommonBackIcon(context,onTap: (){changeAction(actionAuthor);}),

//                           getVerticalSpace(context, 30),


//                           // Row(
//                           //   children: [
//                           //     Expanded(
//                           //       child: getTextWidget(
//                           //           context,
//                           //           isEdit ? 'Edit Author' : 'Add Author',
//                           //           75,
//                           //           getFontColor(context),
//                           //           fontWeight: FontWeight.w700),
//                           //       flex: 1,
//                           //     ),
//                           //   ],
//                           // ),
//                           // getVerticalSpace(context, 40),
//                           Responsive.isMobile(context)


//                               ? Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               itemSubTitle('Name', context),
//                               getVerticalSpace(context, 10),
//                               getTextFiledWidget(
//                                   context, "Enter name", authorController.nameController),
//                               getVerticalSpace(context, 30),
//                               itemSubTitle('Designation', context),
//                               getVerticalSpace(context, 10),
//                               getTextFiledWidget(context, "Enter designation",
//                                   authorController.designationController),

//                               getVerticalSpace(context, 30),
//                               itemSubTitle('Facebook URL (optional)', context),
//                               getVerticalSpace(context, 10),
//                               getTextFiledWidget(context, "Enter facebook url",
//                                   authorController.facebookController),
//                               getVerticalSpace(context, 30),
//                               itemSubTitle('Instagram URL (optional)', context),
//                               getVerticalSpace(context, 10),
//                               getTextFiledWidget(context, "Enter instagram url",
//                                   authorController.instagramController),
//                               getVerticalSpace(context, 30),
//                               itemSubTitle('Twitter URL (optional)', context),
//                               getVerticalSpace(context, 10),
//                               getTextFiledWidget(context, "Enter twitter url",
//                                   authorController.twitterController),
//                               getVerticalSpace(context, 30),itemSubTitle('Youtube URL (optional)', context),
//                               getVerticalSpace(context, 10),
//                               getTextFiledWidget(context, "Enter youtube url",
//                                   authorController.youTubeController),

//                               getVerticalSpace(context, 30),
//                               itemSubTitle('Website URL (optional)', context),
//                               getVerticalSpace(context, 10),
//                               getTextFiledWidget(context, "Enter website url",
//                                   authorController.twitterController),
//                               getVerticalSpace(context, 30),
//                               itemSubTitle('Status', context),
//                               getVerticalSpace(context, 10),
//                               Container(
//                                 height: 30.h,
//                                 child: FittedBox(
//                                   fit: BoxFit.fitHeight,
//                                   child: Obx(() => CupertinoSwitch(
//                                       activeColor: getPrimaryColor(context),
//                                       value: authorController.activeStatus.value,
//                                       onChanged: (value) {
//                                         authorController.activeStatus.value = value;
//                                       })),
//                                 ),
//                               ),
//                               getVerticalSpace(context, 30),
//                               itemSubTitle('Description', context),
//                               getVerticalSpace(context, 10),
//                               Container(
//                                 decoration: getDefaultDecoration(
//                                     radius: getDefaultRadius(context),
//                                     bgColor: getCardColor(context),
//                                     // bgColor: getReportColor(context),
//                                     borderColor: getBorderColor(context),
//                                     borderWidth: 1),
//                                 child: Column(
//                                   children: [
//                                     getVerticalSpace(context, 10),
//                                     Container(
//                                       margin: EdgeInsets.all(8.h),
//                                       decoration: getDefaultDecoration(
//                                           radius: getDefaultRadius(context),
//                                           bgColor: getCardColor(context),
//                                           borderColor: getBorderColor(context),
//                                           borderWidth: 1),
//                                       child: QuillToolbar.simple(
//                                         configurations: QuillSimpleToolbarConfigurations(
//                                             controller: authorController.descController
//                                         ),

//                                         // iconTheme: QuillIconTheme(
//                                         //     iconUnselectedFillColor: Colors.transparent
//                                         // ),
//                                         // controller: authorController.descController
//                                       ),
//                                     ),

//                                     Container(
//                                       child: QuillEditor(
//                                         scrollController: ScrollController(),

//                                         focusNode: FocusNode(),
//                                         configurations: QuillEditorConfigurations(
//                                           controller: authorController.descController,

//                                           scrollable: true,
//                                           autoFocus: true,
//                                           expands: false,
//                                           readOnly: false,
//                                           padding: EdgeInsets.zero,
//                                           placeholder: "Enter Description..",
//                                           customStyles: DefaultStyles(
//                                             // placeHolder: quillView.DefaultTextBlockStyle(
//                                             //     TextStyle(
//                                             //       color: getSubFontColor(context),
//                                             //     ),
//                                             //     const Tuple2(16, 0),
//                                             //     const Tuple2(0, 0),
//                                             //     null),
//                                             //
//                                             // paragraph: quillView.DefaultTextBlockStyle(
//                                             //     TextStyle(
//                                             //       color: textColor,
//                                             //     ),
//                                             //     const Tuple2(16, 0),
//                                             //     const Tuple2(0, 0),
//                                             //     null),
//                                           ),



//                                         ),

//                                       ).paddingSymmetric(
//                                           vertical: 15.h, horizontal: 15),
//                                     ).marginSymmetric(vertical: 15.h),
//                                     // Container(
//                                     //   child: QuillEditor.basic(
//                                     //     controller: controller.descController,
//                                     //
//                                     //     readOnly: false, // true for view only mode
//                                     //   ).paddingSymmetric(
//                                     //       vertical: 15.h, horizontal: 15),
//                                     // ).marginSymmetric(vertical: 15.h),
//                                   ],
//                                 ),
//                               ),
//                               getVerticalSpace(context, 30),
//                               itemSubTitle('Image', context),
//                               getVerticalSpace(context, 10),
//                               getTextFiledWidget(
//                                   context, "Chosen file", authorController.imageController,
//                                   isEnabled: false,
//                                   child: getCommonChooseFileBtn(context, (){authorController.imgFromGallery();})),
//                               getVerticalSpace(context, 30),
//                               Align(
//                                 alignment: Alignment.topLeft,
//                                 child: Obx(() {
//                                   return (authorController.isImageOffline.value)
//                                       ? ClipRRect(
//                                     borderRadius: BorderRadius.circular(
//                                         (getResizeRadius(
//                                             context, 35))), //add border radius
//                                     child: (authorController.isSvg)?Image.asset(Constants.placeImage,height: 100.h,width: 100.h,fit: BoxFit.contain,):Image.memory(
//                                       authorController.webImage,
//                                       height: 100.h,
//                                       width: 100.h,
//                                       fit: BoxFit.contain,
//                                     ),
//                                   )
//                                       : isEdit
//                                       ? ClipRRect(
//                                     borderRadius: BorderRadius.circular(
//                                         (getResizeRadius(
//                                             context, 35))), //add border radius
//                                     child: (widget.authorModel!.image!.split(".").last.startsWith("svg"))?Image.asset(Constants.placeImage,height: 150.h,width: 200.h,fit: BoxFit.contain,):Image.network(
//                                       widget.authorModel!.image!,
//                                       height: 150.h,
//                                       width: 200.h,
//                                       fit: BoxFit.contain,
//                                     ),
//                                   )
//                                       : Container();
//                                 }),
//                               ),
//                               getVerticalSpace(context, 30),


//                               // getHorizontalSpace(context, 10),

//                             ],
//                           )


//                               : Column(
//                             children: [
//                               Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Expanded(
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           itemSubTitle('Name', context),
//                                           getVerticalSpace(context, 10),
//                                           getTextFiledWidget(
//                                               context, "Enter name", authorController.nameController),
//                                         ],
//                                       )),

//                                   getHorizontalSpace(context, 10),

//                                   Expanded(
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           itemSubTitle('Designation', context),
//                                           getVerticalSpace(context, 10),
//                                           getTextFiledWidget(context, "Enter designation",
//                                               authorController.designationController),
//                                         ],
//                                       )),

//                                 ],
//                               ),
//                               getVerticalSpace(context, 30),
//                               Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Expanded(
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           itemSubTitle('Facebook URL (optional)', context),
//                                           getVerticalSpace(context, 10),
//                                           getTextFiledWidget(context, "Enter facebook url",
//                                               authorController.facebookController),
//                                         ],
//                                       )),
//                                   getHorizontalSpace(context, 10),
//                                   Expanded(
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           itemSubTitle('Instagram URL (optional)', context),
//                                           getVerticalSpace(context, 10),
//                                           getTextFiledWidget(context, "Enter instagram url",
//                                               authorController.instagramController),
//                                         ],
//                                       )),
//                                   getHorizontalSpace(context, 10),
//                                   Expanded(
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           itemSubTitle('Twitter URL (optional)', context),
//                                           getVerticalSpace(context, 10),
//                                           getTextFiledWidget(context, "Enter twitter url",
//                                               authorController.twitterController),
//                                         ],
//                                       )),
//                                 ],
//                               ),
//                               getVerticalSpace(context, 30),
//                               Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Expanded(
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           itemSubTitle('Youtube URL (optional)', context),
//                                           getVerticalSpace(context, 10),
//                                           getTextFiledWidget(context, "Enter youtube url",
//                                               authorController.youTubeController),
//                                         ],
//                                       )),
//                                   getHorizontalSpace(context, 10),
//                                   Expanded(
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           itemSubTitle('Website URL (optional)', context),
//                                           getVerticalSpace(context, 10),
//                                           getTextFiledWidget(context, "Enter website url",
//                                               authorController.websiteController),
//                                         ],
//                                       )),
//                                   getHorizontalSpace(context, 10),
//                                   Expanded(
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           itemSubTitle('Status', context),
//                                           getVerticalSpace(context, 10),
//                                           Container(
//                                             height: 30.h,
//                                             child: FittedBox(
//                                               fit: BoxFit.fitHeight,
//                                               child: Obx(() => CupertinoSwitch(
//                                                   activeColor: getPrimaryColor(context),
//                                                   value: authorController.activeStatus.value,
//                                                   onChanged: (value) {
//                                                     authorController.activeStatus.value = value;
//                                                   })),
//                                             ),
//                                           ),
//                                         ],
//                                       )),
//                                 ],
//                               ),
//                               getVerticalSpace(context, 30),

//                               Row(
//                                 children: [
//                                   Expanded(
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           itemSubTitle('Description', context),
//                                           getVerticalSpace(context, 10),
//                                           Container(
//                                             decoration: getDefaultDecoration(
//                                                 radius: getDefaultRadius(context),
//                                                 bgColor: getCardColor(context),
//                                                 // bgColor: getReportColor(context),
//                                                 borderColor: getBorderColor(context),
//                                                 borderWidth: 1
//                                             ),
//                                             child: Column(
//                                               children: [
//                                                 getVerticalSpace(context, 10),
//                                                 Container(
//                                                   decoration: getDefaultDecoration(
//                                                       radius: getDefaultRadius(context),
//                                                       bgColor: getCardColor(context),
//                                                       borderColor: getBorderColor(context),
//                                                       borderWidth: 1
//                                                   ),
//                                                   child: QuillToolbar.simple(
//                                                     configurations: QuillSimpleToolbarConfigurations(
//                                                         controller: authorController.descController
//                                                     ),
//                                                     // iconTheme: QuillIconTheme(
//                                                     //     iconUnselectedFillColor: Colors.transparent
//                                                     // ),
//                                                     //
//                                                     // controller: authorController.descController
//                                                   ),
//                                                 ),
//                                                 Container(
//                                                   child: QuillEditor(
//                                                     scrollController: ScrollController(),
//                                                     focusNode: FocusNode(),
//                                                     configurations: QuillEditorConfigurations(
//                                                       controller: authorController.descController,
//                                                       scrollable: true,
//                                                       autoFocus: true,
//                                                       expands: false,

//                                                       padding: EdgeInsets.zero,
//                                                       placeholder: "Enter Description..",
//                                                       customStyles: DefaultStyles(
//                                                         // placeHolder: quillView.DefaultTextBlockStyle(
//                                                         //     TextStyle(
//                                                         //       color: getSubFontColor(context),
//                                                         //     ),
//                                                         //     const Tuple2(16, 0),
//                                                         //     const Tuple2(0, 0),
//                                                         //     null),
//                                                         //
//                                                         // paragraph: quillView.DefaultTextBlockStyle(
//                                                         //     TextStyle(
//                                                         //       color: textColor,
//                                                         //     ),
//                                                         //     const Tuple2(16, 0),
//                                                         //     const Tuple2(0, 0),
//                                                         //     null),
//                                                       ),
//                                                       readOnly: false,
//                                                     ),
//                                                     // true for view only mode
//                                                   ).paddingSymmetric(
//                                                       vertical: 15.h, horizontal: 15),
//                                                 ).marginSymmetric(vertical: 15.h),
//                                               ],
//                                             ),
//                                           ),
//                                         ],
//                                       )),
//                                   Expanded(child: Container()),
//                                 ],
//                               ),
//                               getVerticalSpace(context, 30),
//                               Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Expanded(
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           itemSubTitle('Image', context),
//                                           getVerticalSpace(context, 10),
//                                           getTextFiledWidget(
//                                               context, "Chosen file", authorController.imageController,
//                                               isEnabled: false,
//                                               child: getCommonChooseFileBtn(context, (){authorController.imgFromGallery();})),
//                                           getVerticalSpace(context, 35),
//                                         ],
//                                       )),
//                                   getHorizontalSpace(context, 10),
//                                   Expanded(
//                                     child: Align(
//                                       alignment: Alignment.topLeft,
//                                       child: Obx(() {
//                                         return (authorController.isImageOffline.value)
//                                             ? ClipRRect(
//                                           borderRadius: BorderRadius.circular(
//                                               (getResizeRadius(
//                                                   context, 35))), //add border radius
//                                           child: (authorController.isSvg)?Image.asset(Constants.placeImage,height: 100.h,width: 100.h,fit: BoxFit.contain,):Image.memory(
//                                             authorController.webImage,
//                                             height: 100.h,
//                                             width: 100.h,
//                                             fit: BoxFit.contain,
//                                           ),
//                                         )
//                                             : isEdit
//                                             ? ClipRRect(
//                                           borderRadius: BorderRadius.circular(
//                                               (getResizeRadius(
//                                                   context, 35))), //add border radius
//                                           child: (widget.authorModel!.image!.split(".").last.startsWith("svg"))?Image.asset(Constants.placeImage,height: 100.h,width: 100.h,fit: BoxFit.contain,):Image.network(
//                                             widget.authorModel!.image!,
//                                             height: 100.h,
//                                             width: 100.h,
//                                             fit: BoxFit.contain,
//                                           ),
//                                         )
//                                             : Container();
//                                       }),
//                                     ),),
//                                   getHorizontalSpace(context, 10),
//                                   Expanded(
//                                       child: Container()),
//                                 ],
//                               ),
//                             ],

//                           ),




//                           // Obx(() => controller.isLoading.value
//                           //     ? getProgressWidget(context)
//                           //     : Container())
//                         ],
//                       ),
//                     ),
//                     getVerticalSpace(context, 20),
//                     Row(
//                       children: [
//                         Obx(() => getButtonWidget(
//                           context,
//                           isEdit ? 'Update' : 'Save',
//                           isProgress: authorController.isLoading.value,
//                               () {
//                             if (isEdit) {
//                               authorController.editAuthor(homeController, context,
//                                       () {
//                                     print(
//                                         "edit------${authorController.authorModel!.authorName}");
//                                     widget.function();
//                                   });
//                             } else {
//                               authorController.addAuthor(context, homeController,
//                                       () {
//                                     widget.function();
//                                   });
//                             }
//                           },
//                           horPadding: 25.h,
//                           horizontalSpace: 0,
//                           verticalSpace: 0,
//                           btnHeight: 40.h,
//                         )),
//                       ],
//                     ),
//                     getVerticalSpace(context, 20),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       )),
//     );
//   }

//   @override
//   void initState() {
//     super.initState();

//     LoginData.getDeviceId();
//   }
// }

// itemSubTitle(String s, BuildContext context, {Color? color}) {
//   return getTextWidget(
//     context,
//     s,
//     45,
//     color == null ? getFontColor(context) : color,
//     fontWeight: FontWeight.w500,
//   );
// }
