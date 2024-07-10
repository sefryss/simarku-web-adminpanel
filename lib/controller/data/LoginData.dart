import 'package:client_information/client_information.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebookadminpanel/controller/data/FirebaseData.dart';
import 'package:ebookadminpanel/util/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../main.dart';
import '../../model/admin_model.dart';
import '../../ui/common/common.dart';
import '../../ui/home/sidemenu/side_menu.dart';
import '../../util/constants.dart';
import '../../util/pref_data.dart';
import 'key_table.dart';

class LoginData {
  static Future<bool> loginUsingEmailPassword(context,
      {email, password}) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    print("email-----${email}");
    print("password-----${password}");

    try {
      await auth
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) {
        auth.currentUser != null;
      });

      return auth.currentUser != null;
    } on FirebaseAuthException catch (e) {
      print(e.code);
      print("ecode----------${e.code}");
      if (e.code == 'email-already-in-use') {
        if (auth.currentUser != null) {
          auth.currentUser != null;
        }
        showCustomToast(
            message: "The account already exists for that email.",
            context: context);
        return false;
      } else if (e.code == "invalid-email") {
        showCustomToast(context: context, message: "Email tidak valid");
        return false;
      } else if (e.code == "wrong-password") {
        showCustomToast(context: context, message: "Password tidak valid");
        return false;
      } else if (e.code == "invalid-credential") {
        showCustomToast(
            context: context, message: "Eamil atau Password tidak valid");
        return false;
      } else {
        showCustomToast(message: e.code, context: context);
        return false;
      }
    } catch (e) {
      print("e------------$e");
      return false;
    }
  }

  static Future<bool> login(BuildContext context, {username, password}) async {
    bool isLogin = await loginUsingEmailPassword(context,
        email: username, password: password);

    FirebaseAuth auth = FirebaseAuth.instance;

    print("isLogin--------${isLogin}");

    if (isLogin) {
      print("username1212121212===$username === $password=");
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(KeyTable.adminData)
          .where(KeyTable.keyUserName, isEqualTo: username)
          .where(KeyTable.keyUid, isEqualTo: auth.currentUser!.uid)
          .get();
      print("username===${querySnapshot.size}");

      if (querySnapshot.size > 0) {
        for (var element in querySnapshot.docs) {
          String pushToken = await fetchFirebaseMessagingToken();
          print("Fetched push token: $pushToken");

          await FirebaseData.updateData(
              map: {
                KeyTable.keyDeviceId: deviceID.value,
                'PushToken': pushToken,
              },
              tableName: KeyTable.adminData,
              doc: element.id,
              function: () {},
              context: context,
              isToast: false);

          print(
              "Updated Firestore with new token for document ID: ${element.id}");

          selectedAction.value = actionDashBoard;
          selectedIndex.value = 0;

          PrefData.setLogin(true, element.id, true);
        }
        return true;
      } else {
        print("No documents found for username: $username");
        return false;
      }
    } else {
      print("Login failed for username: $username");
      return false;
    }
  }

  static Future<String> fetchFirebaseMessagingToken() async {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      await messaging.requestPermission();
      String? token = await messaging.getToken();
      if (token == null) {
        print("Failed to get push token");
        throw Exception('Failed to get push token');
      }
      print("Push token retrieved: $token");
      return token;
    } catch (e) {
      print("Error getting push token: $e");
      throw 'Terjadi kesalahan mendapatkan push token';
    }
  }

  static Future<void> updateUserField(
      Map<String, dynamic> json, String uid) async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .update(json);
      print("User field updated for UID: $uid with data: $json");
    } catch (e) {
      print(
          "Error updating user field for UID: $uid with data: $json. Error: $e");
      throw 'Terjadi kesalahan. Mohon coba lagi';
    }
  }

  static Future<bool> registerUsingEmailPassword(BuildContext context,
      {email, password}) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      await auth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) {
        auth.currentUser != null;
      });

      // user = userCredential.user;
      //
      //
      // user = auth.currentUser;
      // print('The=====${user!.email}');

      return auth.currentUser != null;
    } on FirebaseAuthException catch (e) {
      print("code------------${e.code}");

      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        if (auth.currentUser != null) {
          auth.currentUser != null;
        }

        showCustomToast(
            message: "The account already exists for that email.",
            context: context);
        return false;
      }
    } catch (e) {
      print("e------------$e");
      return false;
    }

    return false;
  }

  static Future<bool?> createAdmin(
      {username, password, context, function}) async {
    print("isRegister===fgfgfg");

    bool isRegister = await registerUsingEmailPassword(context,
        email: username, password: password);

    print("isRegister===$isRegister");

    if (isRegister) {
      FirebaseData.createUser(
          isAdmin: true,
          isAccess: true,
          password: password,
          username: username,
          function: () async {
            FirebaseAuth.instance.signOut();
            bool isLoginComplete = await LoginData.login(context,
                password: password, username: username);

            print("isLoginCompe===$isLoginComplete");
            if (isLoginComplete) {
              function();
            } else {
              showCustomToast(message: "Something wrong", context: context);
            }
          });
    } else {
      showCustomToast(message: "Something wrong", context: context);
    }

    // print("username===$username === $password");
    //
    // try {
    //   UserCredential userCredential = await FirebaseAuth.instance
    //       .createUserWithEmailAndPassword(email: username, password: password);
    //
    //   if (userCredential.user != null) {
    //     await FirebaseFirestore.instance.collection(KeyTable.adminData).add({
    //       KeyTable.keyPassword: password,
    //       KeyTable.keyUserName: username,
    //
    //     });
    //
    //
    //     return await login(
    //         context, password: password, username: username);
    //   }
    //
    //   showCustomToast(context: context, message: 'Config Data');
    //
    //   return null;
    // } on FirebaseAuthException catch (e) {
    //   print("3===${e.code}");
    //   if (e.code == 'invalid-email') {
    //     print('Invalid email');
    //
    //     showCustomToast(context: context, message: 'Invalid email');
    //   }
    //   if (e.code == 'weak-password') {
    //     showCustomToast(
    //         context: context, message: 'The password provided is too weak.');
    //
    //     // print('The password provided is too weak.');
    //   } else if (e.code == 'email-already-in-use') {
    //     showCustomToast(
    //         context: context,
    //         message: 'The account already exists for that email.');
    //
    //     // print('The account already exists for that email.');
    //   }
    //   return null;
    // } catch (e) {
    //   print(e);
    // }

    return false;
  }

  static logout({bool? isUpdate}) async {
    String loginId = await PrefData.getLoginId();

    if (loginId.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection(KeyTable.adminData)
          .doc(loginId)
          .update({
        "IsAccess": false

        // LoginData.keyActive: false,
      });
    }

    PrefData.setLogin(false, loginId, false);

    PrefData.setAction(actionDashBoard);

    // if(isUpdate ==null) {
    //   update();
    // }
  }

  static Future<bool> getDeviceId() async {
    String id = await PrefData.getLoginId();

    print("id----11-----${id}");

    if (id.isEmpty) {
      LoginData.sendLoginPage(isUpdate: true);
      return false;
    }

    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection(KeyTable.adminData)
        .doc(id)
        .get();

    bool isData = true;

    // ignore: unnecessary_null_comparison
    if (snapshot != null) {
      print("sn--------${snapshot.data()}");
      AdminModel adminModel = AdminModel.fromFirestore(snapshot);

      print("admin-------${adminModel.toString()}");

      deviceID.value = await getDeviceIdentifier();

      isData = (adminModel.deviceId == deviceID.value) ? true : false;

      print(
          "device----11-----${adminModel.deviceId}---${adminModel.email}-----${deviceID.value}");

      print("isData---${isData}");

      if (!isData) {
        await FirebaseFirestore.instance
            .collection(KeyTable.adminData)
            .doc(id)
            .update({
          "IsAccess": false

          // LoginData.keyActive: false,
        });

        // function();
        if (FirebaseAuth.instance.currentUser != null) {
          LoginData.sendLoginPage(isUpdate: true);

          return false;
        }
      }
    } else {
      isData = true;
    }

    return true;
  }

  static sendLoginPage({bool? isUpdate}) {
    logout(isUpdate: (isUpdate));
    Future.delayed(Duration(seconds: 1), () {
      Get.toNamed(KeyUtil.loginPage);
    });
  }

  static Future<String> getDeviceIdentifier() async {
    ClientInformation info = await ClientInformation.fetch();
    print("info===${info.deviceId}");
    return info.deviceId;

    // String? deviceId = await PlatformDeviceId.deviceInfoPlugin.in;
    //
    // print("devi-----${deviceId}");
    //
    //
    // return deviceId ?? "";
  }
}
