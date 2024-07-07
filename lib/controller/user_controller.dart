import 'package:ebookadminpanel/controller/home_controller.dart';
import 'package:ebookadminpanel/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  TextEditingController fullName = TextEditingController();
  TextEditingController nikNumber = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController role =
      TextEditingController(); // New TextEditingController for role

  UserModel? userModel;
  HomeController? homeController;
  RxBool isLoading = false.obs;

  UserController({this.userModel, this.homeController});

  @override
  Future<void> onInit() async {
    super.onInit();
    setAllDataFromUserModel(userModel!, homeController!);
  }

  setAllDataFromUserModel(UserModel? s, HomeController controller) async {
    print("called-----setData");
    homeController = controller;
    if (s != null) {
      userModel = s;

      if (userModel != null) {
        fullName.text = userModel!.fullName;
        email.text = userModel!.email;
        address.text = userModel!.address;
        phoneNumber.text = userModel!.phoneNumber;
        nikNumber.text = userModel!.nikNumber;
        role.text = userModel!.isAdmin ? 'Admin' : 'User';
      }
    }
  }

  void clearStoryData() {
    fullName = TextEditingController();
    email = TextEditingController();
    phoneNumber = TextEditingController();
    address = TextEditingController();
    nikNumber = TextEditingController();
    role = TextEditingController(); // Clear role text
    homeController = null;
    isLoading.value = false;
  }

  // void detailUser(HomeController homeController, BuildContext context,
  //     Function function) async {
  //   userModel!.fullName = fullName.text;
  //   userModel!.email = email.text;
  //   userModel!.phoneNumber = phoneNumber.text;
  //   userModel!.address = address.text;
  //   userModel!.nikNumber = nikNumber.text;
  //   // userModel!.isAdmin = role.text as bool;
  // }
}
