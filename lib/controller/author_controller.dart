// import 'dart:typed_data';
// import 'package:ebookadminpanel/model/authors_model.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_quill/flutter_quill.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:ebookadminpanel/controller/home_controller.dart';
// import '../ui/common/common.dart';
// import 'data/FirebaseData.dart';
// import 'data/key_table.dart';

// class AuthorController extends GetxController {
//   TopAuthors? authorModel;
//   HomeController? controller;

//   AuthorController({this.authorModel, this.controller});

//   TextEditingController nameController = TextEditingController();
//   TextEditingController imageController = TextEditingController();
//   TextEditingController designationController = TextEditingController();

//   TextEditingController facebookController = TextEditingController();
//   TextEditingController instagramController = TextEditingController();
//   TextEditingController twitterController = TextEditingController();
//   TextEditingController youTubeController = TextEditingController();
//   TextEditingController websiteController = TextEditingController();

//   final document = "text";

//   QuillController descController = QuillController.basic();

//   RxBool isLoading = false.obs;
//   RxBool activeStatus = true.obs;

//   @override
//   void onInit() {
//     super.onInit();

//     setAllDataFromAuthorModel(authorModel, true);
//   }

//   bool isStatus = true;

//   setAllDataFromAuthorModel(TopAuthors? a, bool status) {
//     isStatus = status;

//     if (a != null) {
//       authorModel = a;

//       if (authorModel != null) {
//         String fileName = authorModel!.image!.split('%2F').last;

//         String file = fileName.split('?').first;

//         print("status----${activeStatus.value}");

//         nameController.text = authorModel!.authorName ?? "";
//         imageController.text = file;
//         designationController.text = authorModel!.designation ?? "";

//         activeStatus.value = authorModel!.isActive ?? true;
//         facebookController.text = authorModel!.faceUrl ?? "";
//         instagramController.text = authorModel!.instUrl ?? "";
//         twitterController.text = authorModel!.twitUrl ?? "";
//         youTubeController.text = authorModel!.youUrl ?? "";
//         websiteController.text = authorModel!.webUrl ?? "";

//         if (authorModel!.desc != null && authorModel!.desc!.isNotEmpty) {
//           final doc = Document()..insert(0, decode(authorModel!.desc ?? ""));

//           // Delta delta = new Delta()..insert(decode(authorModel!.desc!));
//           // final doc = Document.fromDelta(delta);
//           descController = QuillController(
//               document: doc, selection: TextSelection.collapsed(offset: 0));
//         }
//         print("status----${activeStatus.value}");
//       }
//     }
//   }

//   clearAuthData() {
//     authorModel = null;
//     controller = null;

//     nameController = TextEditingController();
//     imageController = TextEditingController();
//     designationController = TextEditingController();

//     facebookController = TextEditingController();
//     instagramController = TextEditingController();
//     twitterController = TextEditingController();
//     youTubeController = TextEditingController();
//     websiteController = TextEditingController();

//     // document = "text";

//     descController = QuillController.basic();

//     isLoading.value = false;
//     activeStatus.value = true;
//   }

//   addAuthor(BuildContext context, HomeController controller,
//       Function function) async {
//     if (checkValidation(context)) {
//       String url = await uploadFile(pickImage!);
//       // String audioUrl = await uploadAudio();

//       TopAuthors firebaseHistory = new TopAuthors();
//       firebaseHistory.authorName = nameController.text;
//       firebaseHistory.image = url;
//       // firebaseHistory.audio = audioUrl;
//       firebaseHistory.refId = controller.category.value;
//       firebaseHistory.index = await FirebaseData.getLastIndexFromAuthTable();
//       firebaseHistory.desc =
//           deltaToHtml(descController.document.toDelta().toJson());
//       // firebaseHistory.desc = quillDeltaToHtml(descController.document.toDelta());
//       // firebaseHistory.date = date.value;
//       firebaseHistory.isActive = activeStatus.value;
//       firebaseHistory.designation = designationController.text;
//       firebaseHistory.faceUrl = facebookController.text;
//       firebaseHistory.instUrl = instagramController.text;
//       firebaseHistory.twitUrl = twitterController.text;
//       firebaseHistory.youUrl = youTubeController.text;
//       firebaseHistory.webUrl = websiteController.text;

//       // firebaseHistory.views = 0;
//       // firebaseHistory.isBookmark = false;
//       // firebaseHistory.isFav = false;

//       FirebaseData.insertData(
//           context: context,
//           map: firebaseHistory.toJson(),
//           tableName: KeyTable.authorList,
//           function: () {
//             // removeAllField(context);
//             isLoading(false);
//             function();
//             clearAuthData();
//           });
//     }
//   }

//   Future<String> uploadFile(XFile _image) async {
//     try {
//       final fileBytes = await _image.readAsBytes();
//       var reference =
//           FirebaseStorage.instance.ref().child("files/${_image.name}");

//       UploadTask uploadTask = reference.putData(
//           fileBytes,
//           SettableMetadata(
//               contentType:
//                   "image/${getFileExtension(_image.name).replaceAll('.', '')}"));

//       return await getUrlFromTask(uploadTask);
//     } catch (e) {
//       print('error in uploading image for : ${e.toString()}');
//       return '';
//     }
//   }

//   getUrlFromTask(UploadTask uploadTask) async {
//     TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {
//       print("complete=====true");
//       // ignore: body_might_complete_normally_catch_error
//     }).catchError((error) {
//       print("error=====$error");
//     });
//     String url = await taskSnapshot.ref.getDownloadURL();

//     return url;
//   }

//   String getFileExtension(String fileName) {
//     try {
//       return "." + fileName.split('.').last;
//     } catch (e) {
//       return '';
//     }
//   }

//   bool checkValidation(BuildContext context) {
//     if (isNotEmpty(nameController.text)) {
//       if (isNotEmpty(designationController.text)) {
//         if (isNotEmpty(
//             descController.plainTextEditingValue.text.toString().trim())) {
//           // if (isNotEmpty(audioUrl.value)) {

//           if (isNotEmpty(imageController.text)) {
//             if (!imageController.text.split(".").last.startsWith("svg")) {
//               if (isEmpty(facebookController.text) ||
//                   hasValidUrl(facebookController.text)) {
//                 if (isEmpty(instagramController.text) ||
//                     hasValidUrl(instagramController.text)) {
//                   if (isEmpty(twitterController.text) ||
//                       hasValidUrl(twitterController.text)) {
//                     if (isEmpty(youTubeController.text) ||
//                         hasValidUrl(youTubeController.text)) {
//                       if (isEmpty(websiteController.text) ||
//                           hasValidUrl(websiteController.text)) {
//                         if (!imageController.text
//                             .split(".")
//                             .last
//                             .startsWith("svg")) {
//                           isLoading(true);
//                           return true;
//                         } else {
//                           showCustomToast(
//                               message: 'svg image not supported',
//                               title: 'Error',
//                               context: context);
//                           return false;
//                         }
//                       } else {
//                         showCustomToast(
//                             message: 'Website url not valid',
//                             title: 'Error',
//                             context: context);
//                         return false;
//                       }
//                     } else {
//                       showCustomToast(
//                           message: 'YouTube url not valid',
//                           title: 'Error',
//                           context: context);
//                       return false;
//                     }
//                   } else {
//                     showCustomToast(
//                         message: 'Twitter url not valid',
//                         title: 'Error',
//                         context: context);
//                     return false;
//                   }
//                 } else {
//                   showCustomToast(
//                       message: 'Instagram url not valid',
//                       title: 'Error',
//                       context: context);
//                   return false;
//                 }
//               } else {
//                 showCustomToast(
//                     message: 'Facebook url not valid',
//                     title: 'Error',
//                     context: context);
//                 return false;
//               }
//             } else {
//               showCustomToast(
//                   message: 'svg image not supported',
//                   title: 'Error',
//                   context: context);
//               return false;
//             }
//           } else {
//             showCustomToast(
//                 message: 'Choose Image', title: 'Error', context: context);
//             return false;
//           }

//           // } else {
//           //   showCustomToast(
//           //       message: 'Choose Audio', title: 'Error', context: context);
//           //   return false;
//           // }
//         } else {
//           showCustomToast(
//               message: 'Enter Description...',
//               title: 'Error',
//               context: context);

//           return false;
//         }
//       } else {
//         showCustomToast(
//             message: 'Enter designation...', title: 'Error', context: context);
//         return false;
//       }
//     } else {
//       showCustomToast(
//           message: 'Enter name...', title: 'Error', context: context);
//       return false;
//     }
//   }

//   // String quillDeltaToHtml(Delta delta) {
//   //   final convertedValue = jsonEncode(delta.toJson());
//   //   final markdown = deltaToMarkdown(convertedValue);
//   //   final html = mark.markdownToHtml(markdown);
//   //   return html;
//   // }

//   removeAllField(BuildContext context) {
//     nameController.text = "";
//     designationController.text = "";
//     // descController.plainTextEditingValue.text = "";
//     imageController.text = "";
//   }

//   Uint8List webImage = Uint8List(10);

//   RxBool isImageOffline = false.obs;

//   editAuthor(HomeController homeController, BuildContext context,
//       Function function) async {
//     if (checkValidation(context)) {
//       String url = imageController.text;

//       if (imageController.text != authorModel!.image!) {
//         if (pickImage != null) {
//           url = await uploadFile(pickImage!);
//         }
//       }

//       authorModel!.authorName = nameController.text;

//       if (pickImage != null) {
//         print("called----if");
//         authorModel!.image = url;
//       } else {
//         print("called----else");
//         authorModel!.image = authorModel!.image;
//       }

//       // authorModel!.image = url;

//       authorModel!.refId = homeController.category.value;
//       authorModel!.desc =
//           deltaToHtml(descController.document.toDelta().toJson());
//       // authorModel!.desc = quillDeltaToHtml(descController.document.toDelta());
//       authorModel!.designation = designationController.text;
//       authorModel!.isActive = activeStatus.value;

//       FirebaseData.updateData(
//           context: context,
//           map: authorModel!.toJson(),
//           tableName: KeyTable.authorList,
//           doc: authorModel!.id!,
//           function: () {
//             isLoading(false);
//             function();
//             clearAuthData();
//           });
//     }
//   }

//   Future<String> uploadAudio() async {
//     try {
//       Uint8List fileBytes = result!.files.first.bytes!;
//       String fileName = result!.files.first.name;

//       var reference = FirebaseStorage.instance.ref().child(
//             'uploads/$fileName',
//           );

//       UploadTask uploadTask = reference.putData(
//           fileBytes, SettableMetadata(contentType: "audio/mpeg"));

//       return await getUrlFromTask(uploadTask);
//     } catch (e) {
//       return '';
//     }
//   }

//   XFile? pickImage;
//   final picker = ImagePicker();
//   FilePickerResult? result;
//   bool isSvg = false;

//   imgFromGallery() async {
//     XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

//     pickImage = image;

//     if (image != null) {
//       String file = image.name.split(".").last;

//       if (file == "svg") {
//         isSvg = true;
//       }
//       imageController.text = pickImage!.name;
//       var f = await pickImage!.readAsBytes();
//       isImageOffline(false);
//       webImage = f;
//       isImageOffline(true);
//     }
//   }
// }
