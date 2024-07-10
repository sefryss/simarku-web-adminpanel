import 'dart:ui';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:ebookadminpanel/controller/donation_book_controller.dart';
import 'package:ebookadminpanel/controller/feedback_controller.dart';
import 'package:ebookadminpanel/controller/genre_controller.dart';
import 'package:ebookadminpanel/controller/kegiatan_literasi_controller.dart';
import 'package:ebookadminpanel/controller/rating_controller.dart';
import 'package:ebookadminpanel/controller/sekilas_ilmu_controller.dart';
import 'package:ebookadminpanel/controller/tukar_milik_controller.dart';
import 'package:ebookadminpanel/controller/tukar_pinjam_controller.dart';
import 'package:ebookadminpanel/controller/user_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ebookadminpanel/theme/app_theme.dart';
import 'package:ebookadminpanel/theme/theme_controller.dart';
import 'package:ebookadminpanel/util/app_routes.dart';
import 'package:ebookadminpanel/util/pref_data.dart';
import 'controller/data/LoginData.dart';
import 'controller/story_controller.dart';
import 'controller/chat_controller.dart'; // Import your ChatController

RxInt selectedAction = 0.obs;

bool isLogin = false;
ThemeController themeController = Get.put(ThemeController());
// CategoryController categoryController = Get.put(CategoryController());
// AuthorController authorController = Get.put(AuthorController());
GenreController genreController = Get.put(GenreController());
StoryController storyController = Get.put(StoryController());
DonationBookController donationBookController =
    Get.put(DonationBookController());
SekilasInfoController sekilasInfoController = Get.put(SekilasInfoController());
KegiatanLiterasiController kegiatanLiterasiController =
    Get.put(KegiatanLiterasiController());
FeedbackController feedbackController = Get.put(FeedbackController());
RatingController ratingController = Get.put(RatingController());
TukarPinjamController tukarPinjamController = Get.put(TukarPinjamController());
TukarMilikController tukarMilikController = Get.put(TukarMilikController());
UserController userController = Get.put(UserController());

RxString deviceID = ''.obs;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  isLogin = await PrefData.getLogin();
  await initFirebase();

  deviceID.value = await LoginData.getDeviceIdentifier();

  print("deviceid------------${deviceID.value}");

  selectedAction.value = await PrefData.getAction();
  // setPathUrlStrategy();

  // configureApp();
    await ChatController.initializeUserModel();

  runApp(MyApp());
}

// void configureApp() {
//   setUrlStrategy(PathUrlStrategy());
// }

initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
      apiKey: "AIzaSyAysW8hFXTY0exHPrZy2lg97_AyXh0BtZg",
      authDomain: "simarku-a8d45.firebaseapp.com",
      projectId: "simarku-a8d45",
      storageBucket: "simarku-a8d45.appspot.com",
      messagingSenderId: "716875505153",
      appId: "1:716875505153:web:d8420ac2f09d1e6a892a00",
    ));
  } else {
    await Firebase.initializeApp();
  }

  FirebaseMessaging.instance.getInitialMessage();

  FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);

  FirebaseMessaging.instance.setAutoInitEnabled(true);
}

setScreenSize(
  BuildContext context,
) {
  ScreenUtil.init(context, designSize: Size(1440, 900));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (provider) {
        print("them===${provider.themeMode}");
        themeController.setThemeStatusBar(context);
        return GetMaterialApp(
          title: 'SiMarKu',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.theme,
          //
          scrollBehavior: AppScrollBehavior(),
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            // S.delegate
          ],
          // locale: Locale("ar"," "),
          supportedLocales: [
            Locale("en", " "),
            Locale("ar", " "),
          ],
          routes: appRoutes,
          themeMode: provider.themeMode,
          darkTheme: AppTheme.darkTheme,
          initialRoute: isLogin ? KeyUtil.homePage : KeyUtil.loginPage,
          // home: MyHomePag1e(title: ''),
        );
      },
      init: ThemeController(),
    );
  }
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.mouse,
        PointerDeviceKind.touch,
      };
}
