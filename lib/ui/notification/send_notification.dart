

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebookadminpanel/util/common_blank_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ebookadminpanel/controller/data/FirebaseData.dart';
import 'package:ebookadminpanel/controller/notification_controller.dart';
import '../../controller/data/LoginData.dart';
import '../../controller/home_controller.dart';
import '../../model/story_model.dart';
import '../../theme/color_scheme.dart';
import '../book/addBook/add_book_screen.dart';
import '../common/common.dart';
import 'notification_drop_down.dart';

class SendNotification extends StatefulWidget{

  final Function function;


  SendNotification({required this.function});

  @override
  State<SendNotification> createState() => _SendNotificationState();
}

class _SendNotificationState extends State<SendNotification> {
  @override
  void initState() {
    super.initState();

    LoginData.getDeviceId();
  }


  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.find();

    return SafeArea(
      child: CommonPage(widget: Container(
        margin: EdgeInsets.symmetric(
            horizontal: getDefaultHorSpace(context),
            vertical: getDefaultHorSpace(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getTextWidget(context, 'Send Notification', 75, getFontColor(context),
                fontWeight: FontWeight.w700),
            getVerticalSpace(context, 35),
            Expanded(
                child: getCommonContainer(
                  context: context,
                  verSpace: 0,

                  child: GetBuilder<NotificationController>(
                    init: NotificationController(),
                    builder: (controller) {
                      return ListView(
                        children: [
                          getVerticalSpace(context, (getCommonPadding(context)/2)),
                          itemSubTitle('Title', context),
                          getVerticalSpace(context, 10),
                          getTextFiledWidget(
                              context, "Enter title..", controller.nameController),
                          getVerticalSpace(context, 22),
                          itemSubTitle('Message', context),
                          getVerticalSpace(context, 10),
                          getMessageTextFiledWidget(
                              context, "Enter message..", controller.messageController),
                          getVerticalSpace(context, 22),
                          Row(
                            children: [
                              itemSubTitle('Image', context),
                              itemSubTitle('(optional)', context,color: getSubFontColor(context)),
                            ],
                          ),

                          getVerticalSpace(context, 10),
                          getTextFiledWidget(
                              context, "No file chosen", controller.imageController,
                              isEnabled: false,
                              child: getCommonChooseFileBtn(context, (){controller.imgFromGallery();})),
                          getVerticalSpace(context, 22),
                          Row(
                            children: [
                              itemSubTitle('External Link', context),
                              itemSubTitle('(optional)', context,color: getSubFontColor(context)),
                            ],
                          ),
                          getVerticalSpace(context, 10),  getTextFiledWidget(
                              context, "https://google.com", controller.linkController),

                          getVerticalSpace(context, 22),
                          Row(
                            children: [
                              itemSubTitle('Send Book', context),
                              itemSubTitle('(optional)', context,color: getSubFontColor(context)),
                            ],
                          ),
                          getVerticalSpace(context, 10),

                          // Obx(() {
                          //   return controller.storyList.length == 1
                          //       ? getDisableDropDownWidget(
                          //     context,
                          //     controller.storyList[0].name!,
                          //   )
                          //       : NotificationDropDown(
                          //     controller,
                          //     value: controller.selectedStory.value,
                          //     onChanged: (value) {
                          //       if (value != controller.selectedStory.value) {
                          //         controller.selectedStory(value);
                          //       }
                          //     },
                          //   );
                          // }),

                          // Obx(() {
                          //
                          //   controller.fetchStoryData();
                          //
                          //
                          //   return NotificationDropDown(
                          //     controller,
                          //     value: controller.selectedStory.value,
                          //     onChanged: (value) {
                          //
                          //       print("val---${value}");
                          //       if (value !=
                          //           controller.selectedStory.value) {
                          //         controller.selectedStory(value);
                          //       }
                          //     },
                          //   );
                          // }),

                          Obx(() {
                            return homeController.storyListNotification.length == 1
                                ? getDisableDropDownWidget(
                              context,
                              homeController.storyListNotification[0].name!,
                            )
                                : NotificationDropDown(
                              homeController,
                              value: homeController.storyNotification.value,
                              onChanged: (value) {
                                if (value != homeController.storyNotification.value) {
                                  homeController.storyNotification(value);
                                }
                              },
                            );
                          }),

                          getVerticalSpace(context, 22),
                          Row(
                            children: [
                              Obx(() => getButtonWidget(
                                context,
                                'Submit',
                                isProgress: controller.isLoading.value,
                                    () async {



                                      // if(homeController.storyNotification.isNotEmpty){
                                      //   StoryModel story = await FirebaseData.getStory(homeController.storyNotification.value);
                                      //
                                      //   print("story=====${story.name}");
                                      //
                                      //   sendNotificationWithStory(context,controller,story);
                                      //
                                      // }else{
                                      //
                                      //   print("object----true");
                                      //   sendNotification(context,controller);
                                      //
                                      // }

                                      if (homeController
                                          .storyNotification.isNotEmpty) {
                                        StoryModel story =
                                        await FirebaseData.getStory(
                                            homeController
                                                .storyNotification.value);

                                        bool b =
                                        await sendNotificationWithStory(
                                            context,
                                            controller,
                                            story,
                                            homeController);

                                        print("notification=====${b}");

                                        if (b) {
                                          homeController
                                              .storyNotification.value = "";

                                          controller.clearAllData();

                                          showCustomToast(
                                              context: context,
                                              message:
                                              "Notification send successfully");
                                        }
                                      } else {
                                        print("object----true");

                                        bool b = await sendNotification(
                                            context,
                                            controller,
                                            homeController);

                                        print("b--------------${b}");
                                        if (b) {
                                          showCustomToast(
                                              context: context,
                                              message:
                                              "Notification send successfully");

                                          homeController.storyNotification.value = "";

                                          controller.clearAllData();
                                        }
                                      }

                                },
                                horPadding: 22.h,
                                horizontalSpace: 0,
                                verticalSpace: 0,
                                btnHeight: 40.h,
                              )),Expanded(child: Container())
                            ],
                          ),
                          getVerticalSpace(context, 22),
                        ],
                      );
                    },
                  ),
                ))
          ],
        ),
      )),
    );
  }




  // sendNotification(BuildContext context,NotificationController controller) async {
  //
  //   QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //       .collection("tokens")
  //       .get();
  //
  //   if(querySnapshot.docs.isNotEmpty){
  //
  //     if(controller.checkValidation(context)){
  //
  //       querySnapshot.docs.forEach((e) {
  //
  //         Map data = e.data() as Map;
  //
  //         print("qu-===${data["token"] }");
  //
  //         if(data["token"] != null && data["token"].isNotEmpty) {
  //           controller.sendFcmMessage(context,
  //               controller.nameController.text, controller.messageController.text,
  //               data["token"],controller.imageController.text);
  //         }
  //
  //       });
  //
  //     }
  //   }
  // }
  //
  // sendNotificationWithStory(BuildContext context,NotificationController controller,
  //     StoryModel storyModel) async {
  //
  //   QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //       .collection("tokens")
  //       .get();
  //
  //   if(querySnapshot.docs.isNotEmpty){
  //
  //     querySnapshot.docs.forEach((e) {
  //
  //       Map data = e.data() as Map;
  //
  //       print("qu-===${data["token"] }");
  //
  //       if(data["token"] != null && data["token"].isNotEmpty) {
  //         controller.sendFcmMessageWihStory(context,
  //             data["token"], storyModel);
  //       }
  //
  //     });
  //
  //   }
  // }


  Future<bool> sendNotification(BuildContext context,
      NotificationController controller, HomeController homeController) async {
    bool b = false;
    controller.isLoading.value = true;
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection("tokens").get();
    print("qu-===${querySnapshot.docs.length}");

    if (querySnapshot.docs.isNotEmpty) {
      if (controller.checkValidation(context)) {
        b = await sendNotificationByAdmin(querySnapshot.docs, controller);

        print("i===${b}");
      }
    }

    controller.isLoading.value = false;

    return b;
  }

  Future<bool> sendNotificationByAdmin(List<DocumentSnapshot> someInput,
      NotificationController controller) async {
    bool b = false;
    String imageUrl = "";

    if(controller.pickImage != null){
      imageUrl =  await controller.getImage();
    }

    print("imageUrl------${imageUrl}");

    await Future.wait(someInput.map((input) async {
      Map data = input.data() as Map;
      if (data["token"] != null && data["token"].isNotEmpty) {
        b = await controller.sendFcmMessage(
            context,
            controller.nameController.text,
            controller.messageController.text,
            data["token"],
            imageUrl);
      }

      print("message-----------$b");
    }));

    print(" $b");

    return b;
  }

  Future<bool> sendNotificationWithStory(
      BuildContext context,
      NotificationController controller,
      StoryModel storyModel,
      HomeController homeController) async {
    controller.isLoading.value = true;
    bool b = false;

    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection("tokens").get();

    if (querySnapshot.docs.isNotEmpty) {
      b = await sendStoryNotificationByAdmin(querySnapshot.docs, controller,storyModel);
    }
    controller.isLoading.value = false;

    return b;
  }

  Future<bool> sendStoryNotificationByAdmin(List<DocumentSnapshot> someInput,
      NotificationController controller, StoryModel storyModel) async {
    bool b = false;

    await Future.wait(someInput.map((input) async {
      Map data = input.data() as Map;
      if (data["token"] != null && data["token"].isNotEmpty) {
        b = await controller.sendFcmMessageWihStory(context,
            data["token"], storyModel);
      }

      print("message-----------$b");
    }));

    return b;
  }
}