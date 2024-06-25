import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebookadminpanel/controller/data/FirebaseData.dart';
import 'package:ebookadminpanel/controller/data/key_table.dart';
import 'package:ebookadminpanel/controller/home_controller.dart';
import 'package:ebookadminpanel/model/rate_us_model.dart';
import 'package:ebookadminpanel/model/user_model.dart';
import 'package:ebookadminpanel/theme/color_scheme.dart';
import 'package:ebookadminpanel/util/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../model/feedback_model.dart';
import '../ui/common/common.dart';

class RatingController extends GetxController {
  TextEditingController userIdController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController ratingController = TextEditingController();
  

  RxBool isLoading = false.obs;

  RxList selectedUser = [].obs;
  RxList selectedUserNameList = [].obs;

  RateUsModel? rateUsModel;
  HomeController? homeController;

  RatingController({this.rateUsModel, this.homeController});

 @override
  Future<void> onInit() async {
    super.onInit();
    if (rateUsModel != null) {
      setAllDataFromRatingModel(rateUsModel!);
    }
  }

  setAllDataFromRatingModel(RateUsModel? rateUs) {
    userIdController.text = rateUs!.userId;
    userNameController.text = rateUs.userName;
    ratingController.text = rateUs.rating.toString();
  }

  clearRatingData() {
    userIdController.clear();
    userNameController.clear();
    ratingController.clear();
    rateUsModel = null;
    isLoading.value = false;
  }

  bool checkValidation(BuildContext context) {
    if (isNotEmpty(userIdController.text)) {
      if (isNotEmpty(userNameController.text)) {
        if (isNotEmpty(ratingController.text)) {
          // Ensure ratingController.text can be parsed to double
          if (double.tryParse(ratingController.text) != null) {
            return true;
          } else {
            showCustomToast(
              message: 'Rating harus berupa angka.',
              title: 'Error',
              context: context,
            );
            return false;
          }
        } else {
          showCustomToast(
            message: 'Masukkan rating...',
            title: 'Error',
            context: context,
          );
          return false;
        }
      } else {
        showCustomToast(
          message: 'Masukkan nama pengguna...',
          title: 'Error',
          context: context,
        );
        return false;
      }
    } else {
      showCustomToast(
        message: 'Masukkan ID pengguna...',
        title: 'Error',
        context: context,
      );
      return false;
    }
  }

  addRating(HomeController homeController, BuildContext context, Function function) async {
    if (checkValidation(context)) {
      // Ensure ratingController.text is converted to double
      double rating = double.parse(ratingController.text);

      RateUsModel newRating = RateUsModel(
        id: '',
        userId: userIdController.text,
        userName: userNameController.text,
        rating: rating,
      );

      FirebaseData.insertData(
        context: context,
        map: newRating.toJson(),
        tableName: KeyTable.rating,
        function: () {
          isLoading(false);
          function();
          clearRatingData();
        },
      );
    }
  }

  editRating(HomeController homeController, BuildContext context, Function function) async {
    if (checkValidation(context)) {
      // Ensure ratingController.text is converted to double
      double rating = double.parse(ratingController.text);

      rateUsModel!.userId = userIdController.text;
      rateUsModel!.userName = userNameController.text;
      rateUsModel!.rating = rating.toString() as double; // Make sure rating is stored as String

      FirebaseData.updateData(
        context: context,
        map: rateUsModel!.toJson(),
        tableName: KeyTable.rating,
        doc: rateUsModel!.id,
        function: () {
          isLoading(false);
          function();
          clearRatingData();
        },
      );
    }
  }


  Future<void> showOwnerDialog(BuildContext context) async {
    List<UserModel> userList = [];
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Users').get();
      userList = querySnapshot.docs
          .map((doc) => UserModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error fetching user data: $e');
    }

    if (userList.isEmpty) {
      showCustomToast(context: context, message: "No Data");
      return;
    }

    RxString selectedOwnerId = ''.obs;
    RxString selectedOwnerName = ''.obs;

    if (selectedUser.isNotEmpty) {
      selectedOwnerId.value = selectedUser.first;
      selectedOwnerName.value = selectedUserNameList.first;
    }

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: getTextWidget(context, 'Pilih User', 60, getFontColor(context),
              fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          backgroundColor: getBackgroundColor(context),
          contentPadding: EdgeInsets.zero,
          content: Container(
            padding: EdgeInsets.symmetric(horizontal: 25.h, vertical: 15.h),
            width: Responsive.isDesktop(context) ? 450.h : 350.h,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: userList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: getCustomFont(
                      userList[index].fullName, 14, getFontColor(context), 1),
                  trailing: Obx(() => Radio<String>(
                        activeColor: getPrimaryColor(context),
                        value: userList[index].id,
                        groupValue: selectedOwnerId.value,
                        onChanged: (String? value) {
                          if (value != null) {
                            selectedOwnerId.value = value;
                            selectedOwnerName.value = userList[index].fullName;
                          }
                        },
                      )),
                );
              },
            ),
          ),
          actions: [
            getButtonWidget(
              context,
              'Submit',
              isProgress: false,
              () {
                if (selectedOwnerId.isNotEmpty) {
                  selectedUser.clear();
                  selectedUser.add(selectedOwnerId.value);
                  selectedUserNameList.clear();
                  selectedUserNameList.add(selectedOwnerName.value);
                  userNameController.text = selectedOwnerName.value;
                  Get.back();
                } else {
                  showCustomToast(
                      message: 'Pilih User...',
                      title: 'Error',
                      context: context);
                }
              },
              horPadding: 25.h,
              horizontalSpace: 0,
              verticalSpace: 0,
              btnHeight: 40.h,
            )
          ],
        );
      },
    );
  }
}
