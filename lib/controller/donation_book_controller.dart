import 'dart:math';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebookadminpanel/controller/home_controller.dart';
import 'package:ebookadminpanel/model/donation_book_model.dart';
import 'package:ebookadminpanel/model/genre_model.dart';
import 'package:ebookadminpanel/model/user_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:ebookadminpanel/model/story_model.dart';
import '../theme/color_scheme.dart';
import '../ui/common/common.dart';
import '../util/constants.dart';
import '../util/responsive.dart';
import 'data/FirebaseData.dart';
import 'data/key_table.dart';
import 'package:intl/intl.dart';

class DonationBookController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController pdfController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController genreController = TextEditingController();
  TextEditingController ownerController = TextEditingController();
  TextEditingController pageController = TextEditingController();
  TextEditingController publisherController = TextEditingController();
  TextEditingController releaseDateController = TextEditingController();
  TextEditingController bookTypeController = TextEditingController();
  RxString pdfUrl = ''.obs;
  RxString pdfSize = ''.obs;
  Uint8List webImage = Uint8List(10);

  Uint8List webFile = Uint8List(10);
  QuillController descController = QuillController.basic();

  RxBool isImageOffline = false.obs;

  DonationBookModel? storyModel;
  HomeController? homeController;
  RxBool isLoading = false.obs;

  String oldGenre = '';

  DonationBookController({this.storyModel, this.homeController});

  final DateFormat formatter = DateFormat('dd/MM/yyyy');

  RxList selectedGenre = [].obs;
  RxList selectedGenreNameList = [].obs;
  RxList selectedUser = [].obs;
  RxList selectedUserNameList = [].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    setAllDataFromStoryModel(storyModel!, homeController!);
  }

  getGenre(List selectedList) async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection(KeyTable.genreList).get();
    if (snapshot.docs.isNotEmpty && snapshot.size > 0) {
      List<DocumentSnapshot> list = snapshot.docs;
      for (int i = 0; i < list.length; i++) {
        if (selectedList.contains(list[i].id)) {
          selectedGenreNameList.add(Genre.fromFirestore(list[i]).genre!);
        }
      }
    }
    genreController.text = selectedGenreNameList
        .toString()
        .replaceAll('[', '')
        .replaceAll(']', '');
  }

  getUser(List selectedList) async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection(KeyTable.user).get();
    if (snapshot.docs.isNotEmpty && snapshot.size > 0) {
      List<DocumentSnapshot> list = snapshot.docs;
      for (int i = 0; i < list.length; i++) {
        if (selectedList.contains(list[i].id)) {
          selectedUser.add(list[i].id);
          selectedUserNameList.add(UserModel.fromFirestore(list[i]).fullName);
        }
      }
    }
    ownerController.text =
        selectedUserNameList.toString().replaceAll('[', '').replaceAll(']', '');
  }

  setAllDataFromStoryModel(DonationBookModel? s, HomeController controller) {
    print("called-----setData");
    homeController = controller;
    if (s != null) {
      storyModel = s;

      if (storyModel != null) {
        getGenre(storyModel!.genreId!);
        getUser(storyModel!.ownerId!);

        String fileName = storyModel!.image!.split('%2F').last;

        String file = fileName.split('?').first;

        String pdfFileName = storyModel!.pdf!.split('%2F').last;

        String pdfFile = pdfFileName.split('?').first;

        if (storyModel!.pdf!.contains("firebase")) {
          homeController!.pdf.value = Constants.file;
        }

        oldGenre = '';
        nameController.text = storyModel!.name!;
        authorController.text = storyModel!.author!;
        pageController.text = storyModel!.page!;
        publisherController.text = storyModel!.publisher!;
        releaseDateController.text = storyModel!.releaseDate!;
        imageController.text = file;
        selectedGenre.value = storyModel!.genreId!;

        homeController!.genre.value = storyModel!.refId!;
        homeController!.donationBookType.value = storyModel!.bookType!;

        pdfUrl.value = pdfFile;

        if (storyModel!.desc != null && storyModel!.desc!.isNotEmpty) {
          // Delta delta = new Delta()..insert(decode(storyModel!.desc!));
          // final doc = Document.fromDelta(delta);
          final doc = Document()..insert(0, decode(storyModel!.desc ?? ""));

          descController = QuillController(
              document: doc, selection: TextSelection.collapsed(offset: 0));
        }

        oldGenre = nameController.text;

        print("desc------_${storyModel!.desc}");
      }
    }
  }

  clearStoryData() {
    nameController = TextEditingController();
    authorController = TextEditingController();
    pageController = TextEditingController();
    publisherController = TextEditingController();
    releaseDateController = TextEditingController();
    bookTypeController = TextEditingController();
    imageController = TextEditingController();
    pdfController = TextEditingController();
    pdfUrl.value = '';
    pdfSize.value = '';
    webImage = Uint8List(10);
    genreController = TextEditingController();
    ownerController = TextEditingController();
    selectedGenre.value = [];
    selectedGenreNameList.value = [];
    selectedUser.value = [];
    selectedUserNameList.value = [];

    webFile = Uint8List(10);
    descController = QuillController.basic();

    isImageOffline.value = false;

    storyModel = null;
    homeController = null;
    isLoading.value = false;

    oldGenre = '';
  }

  addStory(BuildContext context, HomeController controller,
      Function function) async {
    if (checkValidation(context)) {
      String url = await uploadFile(pickImage!);
      String pdfUrl = await uploadPdfFile();

      DonationBookModel firebaseHistory = new DonationBookModel();
      firebaseHistory.name = nameController.text;
      firebaseHistory.author = authorController.text;
      firebaseHistory.publisher = publisherController.text;
      firebaseHistory.releaseDate = releaseDateController.text;
      firebaseHistory.page = pageController.text;
      firebaseHistory.image = url;
      firebaseHistory.pdf = (controller.pdf.value == Constants.physichBook)
          ? pdfController.text
          : pdfUrl;
      firebaseHistory.refId = controller.genre.value;
      firebaseHistory.genreId = selectedGenre;
      firebaseHistory.index = await FirebaseData.getLastIndexFromGenreTable();
      firebaseHistory.ownerId = selectedUser;
      firebaseHistory.desc =
          deltaToHtml(descController.document.toDelta().toJson());
      firebaseHistory.isActive = true;
      firebaseHistory.bookType = controller.donationBookType.value;

      FirebaseData.insertData(
          context: context,
          map: firebaseHistory.toJson(),
          tableName: KeyTable.donationBook,
          function: () {
            isLoading(false);
            function();
            clearStoryData();
          });
    }
  }

  bool checkValidation(BuildContext context) {
    if (isNotEmpty(nameController.text)) {
      if (isNotEmpty(genreController.text)) {
        if (isNotEmpty(authorController.text)) {
          if (isNotEmpty(publisherController.text)) {
            if (isNotEmpty(releaseDateController.text)) {
              if (isNotEmpty(pageController.text)) {
                if (isNotEmpty(imageController.text)) {
                  if (!imageController.text.split(".").last.startsWith("svg")) {
                    if (isNotEmpty(descController.plainTextEditingValue.text
                        .toString()
                        .trim())) {
                      isLoading(true);
                      return true;
                    } else {
                      showCustomToast(
                          message: 'Masukkan sinopsis...',
                          title: 'Error',
                          context: context);
                      return false;
                    }
                  } else {
                    showCustomToast(
                        message: 'svg image not supported',
                        title: 'Error',
                        context: context);
                    return false;
                  }
                } else {
                  showCustomToast(
                      message: 'Pilih Gambar',
                      title: 'Error',
                      context: context);
                  return false;
                }
              } else {
                showCustomToast(
                    message: 'Masukkan halaman...',
                    title: 'Error',
                    context: context);
                return false;
              }
            } else {
              showCustomToast(
                  message: 'Masukkan tanggal rilis...',
                  title: 'Error',
                  context: context);
              return false;
            }
          } else {
            showCustomToast(
                message: 'Masukkan penerbit...',
                title: 'Error',
                context: context);
            return false;
          }
        } else {
          showCustomToast(
              message: 'Masukkan penulis...', title: 'Error', context: context);
          return false;
        }
      } else {
        showCustomToast(
            message: 'Masukkan genre...', title: 'Error', context: context);
        return false;
      }
    } else {
      showCustomToast(
          message: 'Masukkan judul...', title: 'Error', context: context);
      return false;
    }
  }

  editStory(HomeController homeController, BuildContext context,
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

      storyModel!.releaseDate = releaseDateController.text;

      storyModel!.refId = homeController.genre.value;

      storyModel!.desc =
          deltaToHtml(descController.document.toDelta().toJson());
      storyModel!.genreId = selectedGenre;
      storyModel!.ownerId = selectedUser;

      FirebaseData.updateData(
          context: context,
          map: storyModel!.toJson(),
          tableName: KeyTable.donationBook,
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

      print("data===${fileBytes.toString()}");

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

  Future<void> showGenreDialog(
      BuildContext context, HomeController home) async {
    return showDialog(
        context: context,
        builder: (context) {
          print("genreList------_${home.genreList.length}");
          return AlertDialog(
            title: getTextWidget(
                context, 'Pilih Genre', 60, getFontColor(context),
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
                itemCount: home.genreList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    // title: getCustomFont("text", 18, getFontColor(context), 1),
                    title: getCustomFont(home.genreList[index].genre!, 14,
                        getFontColor(context), 1),
                    trailing: Obx(() => Checkbox(
                        activeColor: getPrimaryColor(context),
                        checkColor: Colors.white,
                        onChanged: (checked) {
                          print(
                              "checked--------${selectedGenre.contains(home.genreList[index].id!)}--------${checked}");

                          if (selectedGenre
                              .contains(home.genreList[index].id!)) {
                            selectedGenre.remove(home.genreList[index].id!);
                            selectedGenreNameList
                                .remove(home.genreList[index].genre!);
                          } else {
                            selectedGenre.add(home.genreList[index].id!);
                            selectedGenreNameList
                                .add(home.genreList[index].genre!);
                          }

                          print("selecteLen--------${selectedGenre.length}");

                          // isChecked[index] = checked;
                          // _title = _getTitle();
                        },
                        value:
                            selectedGenre.contains(home.genreList[index].id!))),
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
                  genreController.text = selectedGenreNameList
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
          title: getTextWidget(
              context, 'Pilih Pemilik', 60, getFontColor(context),
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
                  ownerController.text = selectedOwnerName.value;
                  Get.back();
                } else {
                  showCustomToast(
                      message: 'Pilih pemilik...',
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
