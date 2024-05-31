import 'dart:typed_data';
import 'package:ebookadminpanel/model/kegiatan_literasi_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ebookadminpanel/controller/home_controller.dart';
import '../ui/common/common.dart';
import 'data/FirebaseData.dart';
import 'data/key_table.dart';

class KegiatanLiterasiController extends GetxController {
  TextEditingController titleController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController urlController = TextEditingController();
  Uint8List webImage = Uint8List(10);
  QuillController descController = QuillController.basic();

  RxBool isImageOffline = false.obs;

  KegiatanLiterasiModel? kegiatanLiterasiModel;
  HomeController? controller;
  RxBool isLoading = false.obs;
  // RxBool isFav = false.obs;
  RxBool activeStatus = true.obs;

  KegiatanLiterasiController({this.kegiatanLiterasiModel, this.controller});

  @override
  void onInit() {
    super.onInit();

    setAllSekilasInfo(kegiatanLiterasiModel);
  }

  setAllSekilasInfo(
    KegiatanLiterasiModel? kegiatanLiterasi,
  ) {
    if (kegiatanLiterasi != null) {
      kegiatanLiterasiModel = kegiatanLiterasi;

      if (kegiatanLiterasiModel != null) {
        // File file = new File((kegiatanLiterasiModel!.image ?? "") as List<Object>);
        // String basename = basename(file.path);

        String fileName = kegiatanLiterasiModel!.image!.split('%2F').last;

        String file = fileName.split('?').first;

        titleController.text = kegiatanLiterasiModel!.title!;
        imageController.text = file;
        authorController.text = kegiatanLiterasiModel!.author!;
        dateController.text = kegiatanLiterasiModel!.date!;
        urlController.text = kegiatanLiterasiModel!.url!;
        activeStatus.value = kegiatanLiterasiModel!.isActive ?? true;
        if (kegiatanLiterasiModel!.desc != null &&
            kegiatanLiterasiModel!.desc!.isNotEmpty) {
          // Delta delta = new Delta()..insert(decode(kegiatanLiterasiModel!.desc!));
          // final doc = Document.fromDelta(delta);
          final doc = Document()
            ..insert(0, decode(kegiatanLiterasiModel!.desc ?? ""));

          descController = QuillController(
              document: doc, selection: TextSelection.collapsed(offset: 0));
        }
        // imageController.text = kegiatanLiterasiModel!.image!;
        // oldkegiatanLiterasi = nameController.text;
      }

      // if (categoryModel != null) {
      //
      //   // File file = new File((categoryModel!.image ?? "") as List<Object>);
      //   // String basename = basename(file.path);
      //
      //   String fileName = categoryModel!.image!.split('%2F').last;
      //
      //   String file = fileName.split('?').first;
      //
      //   oldCategory = '';
      //   nameController.text = categoryModel!.name!;
      //   // colorController.text = categoryModel!.color!;
      //   imageController.text = file;
      //
      //   // imageController.text = categoryModel!.image!;
      //   oldCategory = nameController.text;
      //
      // }
    }
  }

  clearKegiatanLiterasiData() {
    titleController = TextEditingController();
    imageController = TextEditingController();
    webImage = Uint8List(10);
    authorController = TextEditingController();
    dateController = TextEditingController();
    urlController = TextEditingController();
    descController = QuillController.basic();
    isImageOffline.value = false;

    kegiatanLiterasiModel = null;
    isLoading = false.obs;
    activeStatus.value = true;

    // oldCategory = '';
  }

  bool isCheckAlreadyExistsOrNot(BuildContext context) {
    HomeController homeController = Get.find();
    if (homeController.allKegiatanLiterasiList.length > 0 &&
        homeController.allKegiatanLiterasiList.contains(titleController.text)) {
      isLoading(false);

      showCustomToast(context: context, message: 'Already Exists..');
      return false;
    } else {
      return true;
    }
  }

  addKegiatanLiterasi(BuildContext context, HomeController controller,
      Function function) async {
    if (checkValidation(context)) {
      String url = await uploadFile(pickImage!);

      if (isCheckAlreadyExistsOrNot(context)) {
        KegiatanLiterasiModel firebaseHistory = new KegiatanLiterasiModel();
        firebaseHistory.title = titleController.text;
        firebaseHistory.image = url;
        firebaseHistory.author = authorController.text;
        firebaseHistory.date = dateController.text;
        firebaseHistory.desc =
            deltaToHtml(descController.document.toDelta().toJson());
        firebaseHistory.url = urlController.text;
        // firebaseHistory.isFav = false;
        firebaseHistory.isActive = activeStatus.value;

        FirebaseData.insertData(
            context: context,
            map: firebaseHistory.toJson(),
            tableName: KeyTable.kegiatanLiterasi,
            function: () {
              isLoading(false);
              function();
              clearKegiatanLiterasiData();
            });
      }
    }
  }

  bool checkValidation(BuildContext context) {
    if (isNotEmpty(titleController.text)) {
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
          message: 'Enter name...', title: 'Error', context: context);
      return false;
    }
  }

  editKegiatanLiterasi(HomeController controller, BuildContext context,
      Function function) async {
    if (checkValidation(context)) {
      String url = imageController.text;

      if (imageController.text != kegiatanLiterasiModel!.image!) {
        if (pickImage != null) {
          url = await uploadFile(pickImage!);
        }
      }

      if (isCheckAlreadyExistsOrNot(context)) {
        kegiatanLiterasiModel!.title = titleController.text;
        kegiatanLiterasiModel!.author = authorController.text;
        kegiatanLiterasiModel!.date = dateController.text;
        kegiatanLiterasiModel!.desc =
            deltaToHtml(descController.document.toDelta().toJson());
        kegiatanLiterasiModel!.url = urlController.text;
        kegiatanLiterasiModel!.isActive = activeStatus.value;

        if (pickImage != null) {
          print("called----if");
          kegiatanLiterasiModel!.image = url;
        } else {
          print("called----else");
          kegiatanLiterasiModel!.image = kegiatanLiterasiModel!.image;
        }

        FirebaseData.updateData(
            context: context,
            map: kegiatanLiterasiModel!.toJson(),
            tableName: KeyTable.kegiatanLiterasi,
            doc: kegiatanLiterasiModel!.id!,
            function: () {
              isLoading(false);
              function();
              clearKegiatanLiterasiData();
            });
      }
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
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {
        print("complete=====true");
        // ignore: body_might_complete_normally_catch_error
      }).catchError((error) {
        print("error=====$error");
      });
      String url = await taskSnapshot.ref.getDownloadURL();
      print("complete=====$url");

      return url;
    } catch (e) {
      print('error in uploading image for : ${e.toString()}');
      return '';
    }
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
}
