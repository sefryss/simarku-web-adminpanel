
import 'package:ebookadminpanel/main.dart';
import 'package:ebookadminpanel/ui/home/home_page.dart';
import 'package:ebookadminpanel/util/common_blank_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ebookadminpanel/model/category_model.dart';
import 'package:ebookadminpanel/theme/color_scheme.dart';
import 'package:ebookadminpanel/ui/common/common.dart';

import '../../../controller/data/LoginData.dart';
import '../../../util/constants.dart';

class AddCategoryScreen extends StatefulWidget {
  final Function function;
  final CategoryModel? categoryModel;

  AddCategoryScreen({required this.function,this.categoryModel});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {

  @override
  void initState() {
    super.initState();

    LoginData.getDeviceId();
  }
  @override
  Widget build(BuildContext context) {

    // double radius = getResizeRadius(context, 20);

    bool isEdit = widget.categoryModel != null;

    return SafeArea(
      child: CommonPage(widget: Container(
        margin: EdgeInsets.symmetric(
            horizontal: getDefaultHorSpace(context),
            vertical: getDefaultHorSpace(context) ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getTextWidget(
                context,isEdit?'Edit Category': 'Add Category', 75, getFontColor(context),
                fontWeight: FontWeight.w700),
            getVerticalSpace(context, 35),
            Expanded(
              child: getCommonContainer(
                context: context,
                verSpace: 0,
                horSpace: isWeb(context) ? null : 15.h,
                // width: double.infinity,
                // height: double.infinity,
                // decoration: getDefaultDecoration(
                //     bgColor: getCardColor(context), radius: radius),
                // padding: EdgeInsets.all(padding),
                child: ListView(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getVerticalSpace(context, 30),
                    getCommonBackIcon(context,onTap: (){changeAction(actionCategories);}),

                    getVerticalSpace(context, 30),
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: getTextWidget(
                    //           context,isEdit?'Edit Category': 'Add Category', 75, getFontColor(context),
                    //           fontWeight: FontWeight.w700),
                    //       flex: 1,
                    //     ),
                    //   ],
                    // ),

                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          itemSubTitle('Category Name', context),
                          getVerticalSpace(context, 10),
                          getTextFiledWidget(
                              context, "Enter here..", categoryController.nameController),
                          getVerticalSpace(context, 30),
                          itemSubTitle('Category Image', context),
                          getVerticalSpace(context, 10),
                          getTextFiledWidget(
                              context, "No file chosen", categoryController.imageController,
                              isEnabled: false,
                              child: getCommonChooseFileBtn(context, (){categoryController.imgFromGallery();})),
                        ],
                      ),
                    ),
                    getVerticalSpace(context, 35),

                    Align(
                      alignment: Alignment.topLeft,
                      child: Obx(() {

                        return (categoryController.isImageOffline.value)
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(
                              (getResizeRadius(
                                  context, 35))), //add border radius
                          child: (categoryController.isSvg)?Image.asset(Constants.placeImage,height: 200.h,width: 300.h,fit: BoxFit.contain,):Image.memory(
                            categoryController.webImage,
                            height: 200.h,
                            width: 300.h,
                            fit: BoxFit.contain,
                          ),
                        )
                            :isEdit?
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                              (getResizeRadius(
                                  context, 35))), //add border radius
                          child: (widget.categoryModel!.image!.split(".").last.startsWith("svg"))?Image.asset(Constants.placeImage,height: 200.h,width: 300.h,fit: BoxFit.contain,):Image.network(
                            widget.categoryModel!.image!,
                            height: 200.h,
                            width: 300.h,
                            fit: BoxFit.contain,
                          ),
                        )
                            : Container();
                      }),
                    ),

                    Obx(() => (categoryController.isImageOffline.value || isEdit)?getVerticalSpace(context, 20):getVerticalSpace(context, 0)),
                    Row(
                      children: [
                        Obx(() => getButtonWidget(
                          context,
                          isEdit?'Update':'Save',
                          isProgress: categoryController.isLoading.value,
                              () {
                            if(isEdit){
                              categoryController.editCategory(context,(){
                                widget.function();
                              });
                            }else{categoryController.addCategory(context,(){
                              widget.function();
                            });
                            }
                          },
                          horPadding: 25.h,
                          horizontalSpace: 0,
                          verticalSpace: 0,
                          btnHeight: 40.h,
                        )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  itemSubTitle(String s, BuildContext context) {
    return getTextWidget(
      context,
      s,
      45  ,
      getFontColor(context),
      fontWeight: FontWeight.w500,
    );
  }
}
