import 'dart:math';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebookadminpanel/controller/home_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:ebookadminpanel/model/story_model.dart';
import '../model/authors_model.dart';
import '../theme/color_scheme.dart';
import '../ui/common/common.dart';
import '../util/constants.dart';
import '../util/responsive.dart';
import 'data/FirebaseData.dart';
import 'data/key_table.dart';
import 'package:intl/intl.dart';

class StoryController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController pdfController = TextEditingController();
  TextEditingController authController = TextEditingController();
  // RxString audioUrl = ''.obs;
  RxString pdfUrl = ''.obs;
  RxString pdfSize = ''.obs;
  Uint8List webImage = Uint8List(10);

  Uint8List webFile = Uint8List(10);
  QuillController descController = QuillController.basic();

  RxBool isImageOffline = false.obs;

  StoryModel? storyModel;
  HomeController? homeController;
  RxBool isLoading = false.obs;
  RxBool isPopular = true.obs;
  RxBool isFeatured = true.obs;

  String oldCategory = '';

  StoryController({this.storyModel, this.homeController});

  final DateFormat formatter = DateFormat('dd/MM/yyyy');

  // RxString date = ''.obs;
  // DateTime customDate = DateTime.now();

  RxList selectedAuthors = [].obs;
  RxList selectedAuthorsNameList = [].obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    // date(formatter.format(DateTime.now()));
    setAllDataFromStoryModel(storyModel!, homeController!);
  }

  getAuthors(List selectedList) async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection(KeyTable.authorList).get();

    if (snapshot.docs.isNotEmpty && snapshot.size > 0) {
      List<DocumentSnapshot> list = snapshot.docs;

      for (int i = 0; i < list.length; i++) {
        if (selectedList.contains(list[i].id)) {
          selectedAuthorsNameList
              .add(TopAuthors.fromFirestore(list[i]).authorName!);
        }
      }
    }

    authController.text = selectedAuthorsNameList
        .toString()
        .replaceAll('[', '')
        .replaceAll(']', '');

    // publisher.value = jsonDecode(storyModel!.publisher ?? "");
    //
    //
    // publisherController1.text = publisher.toString().replaceAll('[', '').replaceAll(']', '');
    //
    // print("selected---------publisher--${publisher.toString()}");

    print("selected-----------${selectedAuthorsNameList.toString()}");
    print("selected-----------${selectedAuthors.toString()}");
  }

  setAllDataFromStoryModel(StoryModel? s, HomeController controller) {
    print("called-----setData");
    homeController = controller;
    if (s != null) {
      storyModel = s;

      if (storyModel != null) {
        getAuthors(storyModel!.authId!);

        // String authName = await FirebaseData.getAuthName(refId: storyModel!.authId ?? "");

        String fileName = storyModel!.image!.split('%2F').last;

        String file = fileName.split('?').first;

        String pdfFileName = storyModel!.pdf!.split('%2F').last;

        String pdfFile = pdfFileName.split('?').first;

        if (storyModel!.pdf!.contains("firebase")) {
          homeController!.pdf.value = Constants.file;
        }

        oldCategory = '';
        nameController.text = storyModel!.name!;
        imageController.text = file;

        homeController!.category.value = storyModel!.refId!;
        // homeController!.author.value = storyModel!.authId!;

        selectedAuthors.value = storyModel!.authId!;

        pdfUrl.value = pdfFile;

        if (storyModel!.desc != null && storyModel!.desc!.isNotEmpty) {
          // Delta delta = new Delta()..insert(decode(storyModel!.desc!));
          // final doc = Document.fromDelta(delta);
          final doc = Document()..insert(0, decode(storyModel!.desc ?? ""));

          descController = QuillController(
              document: doc, selection: TextSelection.collapsed(offset: 0));
        }

        // var myJSON = jsonDecode(r'{"insert":"hello\n"}');
        // Delta delta = new Delta()..insert(decode(storyModel!.desc!));
        //
        // descController = QuillController(
        //
        //   document: Document.fromDelta(delta),
        //   selection: TextSelection.collapsed(offset: 0),
        // );

        // pdfUrl.value = storyModel!.pdf!;

        oldCategory = nameController.text;

        isPopular.value = storyModel!.isPopular!;
        isFeatured.value = storyModel!.isFeatured!;

        print("desc------_${storyModel!.desc}");

        // date(storyModel!.date);
        // customDate = formatter.parse(storyModel!.date!);
      }
    }
  }

  clearStoryData() {
    nameController = TextEditingController();
    imageController = TextEditingController();
    pdfController = TextEditingController();
    pdfUrl.value = '';
    pdfSize.value = '';
    webImage = Uint8List(10);

    authController = TextEditingController();

    selectedAuthors.value = [];
    selectedAuthorsNameList.value = [];

    webFile = Uint8List(10);
    descController = QuillController.basic();

    isImageOffline.value = false;

    storyModel = null;
    homeController = null;
    isLoading.value = false;
    isPopular.value = true;
    isFeatured.value = true;

    oldCategory = '';
  }

  addStory(BuildContext context, HomeController controller,
      Function function) async {
    if (checkValidation(context)) {
      String url = await uploadFile(pickImage!);
      String pdfUrl = await uploadPdfFile();

      StoryModel firebaseHistory = new StoryModel();
      firebaseHistory.name = nameController.text;
      firebaseHistory.image = url;
      firebaseHistory.pdf =
          (controller.pdf.value == Constants.url) ? pdfController.text : pdfUrl;
      firebaseHistory.refId = controller.category.value;
      firebaseHistory.authId = selectedAuthors;
      // firebaseHistory.authId = controller.author.value;
      firebaseHistory.index = await FirebaseData.getLastIndexFromAuthTable();
      firebaseHistory.desc =
          deltaToHtml(descController.document.toDelta().toJson());
      // firebaseHistory.desc = quillDeltaToHtml(descController.document.toDelta());
      // firebaseHistory.date = date.value;
      firebaseHistory.isActive = true;
      firebaseHistory.views = 0;
      firebaseHistory.isBookmark = false;
      firebaseHistory.isFav = false;
      firebaseHistory.isPopular = isPopular.value;
      firebaseHistory.isFeatured = isFeatured.value;

      FirebaseData.insertData(
          context: context,
          map: firebaseHistory.toJson(),
          tableName: KeyTable.storyList,
          function: () {
            isLoading(false);
            function();
            clearStoryData();
          });
    }
  }

  bool checkValidation(BuildContext context) {
    if (isNotEmpty(nameController.text)) {
      if (isNotEmpty(
          descController.plainTextEditingValue.text.toString().trim())) {
        if (isNotEmpty(pdfUrl.value)) {
          if (isNotEmpty(imageController.text)) {
            if (!imageController.text.split(".").last.startsWith("svg")) {
              isLoading(true);
              return true;
            } else {
              showCustomToast(
                  message: 'svg image not supported',
                  title: 'Error',
                  context: context);
              return false;
            }
          } else {
            showCustomToast(
                message: 'Choose Image', title: 'Error', context: context);
            return false;
          }
        } else {
          showCustomToast(
              message: 'Choose File', title: 'Error', context: context);
          return false;
        }
      } else {
        showCustomToast(
            message: 'Enter Story...', title: 'Error', context: context);

        return false;
      }
    } else {
      showCustomToast(
          message: 'Enter name...', title: 'Error', context: context);
      return false;
    }
  }

  // String quillDeltaToHtml(Delta delta) {
  //   final convertedValue = jsonEncode(delta.toJson());
  //   final markdown = deltaToMarkdown(convertedValue);
  //   final html = mark.markdownToHtml(markdown);
  //   return html;
  // }

  editCategory(HomeController homeController, BuildContext context,
      Function function) async {
    if (checkValidation(context)) {
      String url = imageController.text;

      if (imageController.text != storyModel!.image!) {
        if (pickImage != null) {
          url = await uploadFile(pickImage!);
        }
      }

      if (pdfUrl.value != storyModel!.pdf!) {
        if (result != null) {
          pdfUrl.value = await uploadPdfFile();
        }
      }

      storyModel!.name = nameController.text;

      if (pickImage != null) {
        print("called----if");
        storyModel!.image = url;
      } else {
        print("called----else");
        storyModel!.image = storyModel!.image;
      }

      // storyModel!.image = url;

      if (result != null) {
        storyModel!.pdf = pdfUrl.value;
      } else {
        storyModel!.pdf = storyModel!.pdf;
      }

      // storyModel!.pdf = pdfUrl.value;

      storyModel!.isPopular = isPopular.value;
      storyModel!.isFeatured = isFeatured.value;

      storyModel!.refId = homeController.category.value;

      storyModel!.desc =
          deltaToHtml(descController.document.toDelta().toJson());
      // storyModel!.desc = quillDeltaToHtml(descController.document.toDelta());
      storyModel!.authId = selectedAuthors;
      // storyModel!.authId = homeController.author.value;

      // storyModel!.date = date.value;

      FirebaseData.updateData(
          context: context,
          map: storyModel!.toJson(),
          tableName: KeyTable.storyList,
          doc: storyModel!.id!,
          function: () {
            isLoading(false);
            function();
            clearStoryData();
          });
    }
  }

  Future<String> uploadFile(XFile _image) async {
    try {
      final fileBytes = await _image.readAsBytes();
      var reference =
          FirebaseStorage.instance.ref().child("files/${_image.name}");

      UploadTask uploadTask = reference.putData(
          fileBytes,
          SettableMetadata(
              contentType:
                  "image/${getFileExtension(_image.name).replaceAll('.', '')}"));

      return await getUrlFromTask(uploadTask);
    } catch (e) {
      print('error in uploading image for : ${e.toString()}');
      return '';
    }
  }

  Future<String> uploadPdfFile() async {
    try {
      Uint8List fileBytes = result!.files.first.bytes!;

      String fileName = result!.files.first.name;

      var reference = FirebaseStorage.instance.ref().child(
            'uploads/$fileName',
          );

      UploadTask uploadTask = reference.putData(
          fileBytes,
          SettableMetadata(
            contentType: "application/pdf",
          ));
      // TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {
      //   print("complete=====true");
      // }).catchError((error) {
      //   print("error=====$error");
      // });

      // // String url = await taskSnapshot.ref.fullPath;
      //
      //
      print("data===${fileBytes.toString()}");
      //
      // return utf8.decode(fileBytes);
      //
      //
      // // return fileBytes.toString();
      return await getUrlFromTask(uploadTask);
    } catch (e) {
      return '';
    }
  }

  getUrlFromTask(UploadTask uploadTask) async {
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {
      print("complete=====true");
      // ignore: body_might_complete_normally_catch_error
    }).catchError((error) {
      print("error=====$error");
    });

    // String url = await taskSnapshot.ref.fullPath;
    String url = await taskSnapshot.ref.getDownloadURL();

    print("url---------${url}");

    return url;
  }

  String getFileExtension(String fileName) {
    try {
      return "." + fileName.split('.').last;
    } catch (e) {
      return '';
    }
  }

  XFile? pickImage;
  final picker = ImagePicker();
  FilePickerResult? result;

  openFile() async {
    result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: false,
    );

    if (result != null) {
      String fileName = result!.files.first.name;

      print("sfdfsdf==$fileName");

      String size =
          getFileSizeString(bytes: result!.files.first.size, decimals: 1);

      pdfUrl.value = fileName;

      pdfSize.value = size;

      print("Size-------_${size}");
    } else {
      pdfUrl.value = '';
    }
  }

  static String getFileSizeString({required int bytes, int decimals = 0}) {
    if (bytes <= 0) return "0 Bytes";
    const suffixes = [" Bytes", "KB", "MB", "GB", "TB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
  }

  bool isSvg = false;

  imgFromGallery() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

    pickImage = image;

    if (image != null) {
      String file = image.name.split(".").last;

      if (file == "svg") {
        isSvg = true;
      }
      imageController.text = pickImage!.name;
      var f = await pickImage!.readAsBytes();
      isImageOffline(false);
      webImage = f;
      isImageOffline(true);
    }
  }

  Future<void> showAuthorDialog(
      BuildContext context, HomeController home) async {
    return showDialog(
        context: context,
        builder: (context) {
          print("auythLrn------_${home.authorList.length}");
          return AlertDialog(
            title: getTextWidget(
                context, 'Select Author', 60, getFontColor(context),
                fontWeight: FontWeight.w700),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            backgroundColor: getBackgroundColor(context),
            contentPadding: EdgeInsets.zero,
            content: Container(
              padding: EdgeInsets.symmetric(horizontal: 25.h, vertical: 15.h),
              width:
                  Responsive.isDesktop(context) || Responsive.isDesktop(context)
                      ? 450.h
                      : 350.h,
              child: ListView.builder(
                shrinkWrap: true,
                // itemCount: 10,
                itemCount: home.authorList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    // title: getCustomFont("text", 18, getFontColor(context), 1),
                    title: getCustomFont(home.authorList[index].authorName!, 14,
                        getFontColor(context), 1),
                    trailing: Obx(() => Checkbox(
                        activeColor: getPrimaryColor(context),
                        checkColor: Colors.white,
                        onChanged: (checked) {
                          print(
                              "checked--------${selectedAuthors.contains(home.authorList[index].id!)}--------${checked}");

                          if (selectedAuthors
                              .contains(home.authorList[index].id!)) {
                            selectedAuthors.remove(home.authorList[index].id!);
                            selectedAuthorsNameList
                                .remove(home.authorList[index].authorName!);
                          } else {
                            selectedAuthors.add(home.authorList[index].id!);
                            selectedAuthorsNameList
                                .add(home.authorList[index].authorName!);
                          }

                          print("selecteLen--------${selectedAuthors.length}");

                          // isChecked[index] = checked;
                          // _title = _getTitle();
                        },
                        value: selectedAuthors
                            .contains(home.authorList[index].id!))),
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
                  Get.back();
                  authController.text = selectedAuthorsNameList
                      .toString()
                      .replaceAll('[', '')
                      .replaceAll(']', '');
                },
                horPadding: 25.h,
                horizontalSpace: 0,
                verticalSpace: 0,
                btnHeight: 40.h,
              )
            ],
          );
        });
  }
}
