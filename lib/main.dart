import 'dart:ui';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:ebookadminpanel/controller/genre_controller.dart';
import 'package:ebookadminpanel/util/constants.dart';
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
import 'controller/author_controller.dart';
import 'controller/category_controller.dart';
import 'controller/data/LoginData.dart';
import 'controller/story_controller.dart';

RxInt selectedAction = 0.obs;

bool isLogin = false;
ThemeController themeController = Get.put(ThemeController());
// CategoryController categoryController = Get.put(CategoryController());
// AuthorController authorController = Get.put(AuthorController());
GenreController genreController = Get.put(GenreController());
StoryController storyController = Get.put(StoryController());

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (provider) {
        print("them===${provider.themeMode}");
        themeController.setThemeStatusBar(context);
        return GetMaterialApp(
          title: 'Flutter Demo',
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
//
// class MyHomePag1e extends StatefulWidget {
//   const MyHomePag1e({
//     Key? key,
//     required this.title,
//   }) : super(key: key);
//
//   final String title;
//
//   @override
//   State<MyHomePag1e> createState() => _MyHomePageState();
// }
//
//
//
// class _MyHomePageState extends State<MyHomePag1e> {
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text(widget.title),
//
//         ),
//         body: ListView(
//            children: [
//              SingleChildScrollView(
//                  scrollDirection: Axis.horizontal,
//
//                  child: Column(
//                      children: List.generate(columns.length, (index) => Row(
//                        children: List.generate(columns1.length, (index) => Container(
//                          height: 100,
//                          width: 100,
//                          decoration: BoxDecoration(
//                              border: Border.all(color: Colors.grey.shade100,width: 1)
//                          ),
//                          alignment: Alignment.center,
//                          child:  Text(columns1[index].toString()),
//                        )),
//                      ))
//                  )
//              )
//            ],
//         ),
//
//
//
//         // body: TabBarView(
//         //   children: [
//         //     // simple
//         //     ScrollableTableView(
//         //       columns: columns.map((column) {
//         //         return TableViewColumn(
//         //           label: column.toString(),
//         //         );
//         //       }).toList(),
//         //       rows: columns.map((product) {
//         //         return TableViewRow(
//         //           height: 60,
//         //           cells: columns.map((column) {
//         //             return TableViewCell(
//         //               child: Text(product[column] ?? ""),
//         //             );
//         //           }).toList(),
//         //         );
//         //       }).toList(),
//         //     ),
//         //     // paginated
//         //     Column(
//         //       children: [
//         //         Padding(
//         //           padding: const EdgeInsets.symmetric(horizontal: 25),
//         //           child: ValueListenableBuilder(
//         //               valueListenable: _paginationController,
//         //               builder: (context, value, child) {
//         //                 return Row(
//         //                   children: [
//         //                     Text(
//         //                         "${_paginationController.currentPage}  of ${_paginationController.pageCount}"),
//         //                     Row(
//         //                       children: [
//         //                         IconButton(
//         //                           onPressed:
//         //                           _paginationController.currentPage <= 1
//         //                               ? null
//         //                               : () {
//         //                             _paginationController.previous();
//         //                           },
//         //                           iconSize: 20,
//         //                           splashRadius: 20,
//         //                           icon: Icon(
//         //                             Icons.arrow_back_ios_new_rounded,
//         //                             color:
//         //                             _paginationController.currentPage <= 1
//         //                                 ? Colors.black26
//         //                                 : Theme.of(context).primaryColor,
//         //                           ),
//         //                         ),
//         //                         IconButton(
//         //                           onPressed:
//         //                           _paginationController.currentPage >=
//         //                               _paginationController.pageCount
//         //                               ? null
//         //                               : () {
//         //                             _paginationController.next();
//         //                           },
//         //                           iconSize: 20,
//         //                           splashRadius: 20,
//         //                           icon: Icon(
//         //                             Icons.arrow_forward_ios_rounded,
//         //                             color: _paginationController.currentPage >=
//         //                                 _paginationController.pageCount
//         //                                 ? Colors.black26
//         //                                 : Theme.of(context).primaryColor,
//         //                           ),
//         //                         ),
//         //                       ],
//         //                     ),
//         //                   ],
//         //                 );
//         //               }),
//         //         ),
//         //         Expanded(
//         //           child: ScrollableTableView(
//         //             paginationController: _paginationController,
//         //             columns: columns.map((column) {
//         //               return TableViewColumn(
//         //                 label: column,
//         //               );
//         //             }).toList(),
//         //             rows: columns.map((product) {
//         //               return TableViewRow(
//         //                 height: 60,
//         //                 cells: columns.map((column) {
//         //                   return TableViewCell(
//         //                     child: Text(product[column] ?? ""),
//         //                   );
//         //                 }).toList(),
//         //               );
//         //             }).toList(),
//         //           ),
//         //         ),
//         //       ],
//         //     ),
//         //   ],
//         // )
//     );
//   }
// }
//
// class MultiplicationTableCell extends StatelessWidget {
//   final int? value;
//   final Color? color;
//   MultiplicationTableCell({
//     this.value,
//     this.color,
//   });
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 150,
//       height: 150,
//       decoration: BoxDecoration(
//         color: color,
//         border: Border.all(
//           color: Colors.black12,
//           width: 1.0,
//         ),
//       ),
//       alignment: Alignment.center,
//       child: Text(
//         '${value ?? ''}',
//         style: TextStyle(fontSize: 16.0),
//       ),
//     );
//   }
// }
//
// class TableHead extends StatelessWidget {
//   final ScrollController? scrollController;
//   TableHead({
//     @required this.scrollController,
//   });
//   @override
//   Widget build(BuildContext context) {
//     int maxNumber =50;
//     return SizedBox(
//       height: 150,
//       child: Row(
//         children: [
//           MultiplicationTableCell(
//             color: Colors.yellow.withOpacity(0.3),
//             value: 1,
//           ),
//           Expanded(
//             child: ListView(
//               controller: scrollController,
//               physics: ClampingScrollPhysics(),
//               scrollDirection: Axis.horizontal,
//               children: List.generate(maxNumber - 1, (index) {
//                 return MultiplicationTableCell(
//                   color: Colors.yellow.withOpacity(0.3),
//                   value: index + 2,
//                 );
//               }),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// class TableBody extends StatefulWidget {
//   final ScrollController? scrollController;
//   TableBody({
//     @required this.scrollController,
//   });
//   @override
//   _TableBodyState createState() => _TableBodyState();
// }
// class _TableBodyState extends State<TableBody> {
//   LinkedScrollControllerGroup _controllers=LinkedScrollControllerGroup();
//   ScrollController? _firstColumnController;
//   ScrollController? _restColumnsController;
//   @override
//   void initState() {
//     super.initState();
//     _firstColumnController = _controllers.addAndGet();
//     _restColumnsController = _controllers.addAndGet();
//   }
//   @override
//   void dispose() {
//     _firstColumnController!.dispose();
//     _restColumnsController!.dispose();
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     int maxNumber =50;
//     return Row(
//       children: [
//         SizedBox(
//           width: 150,
//           child: ListView(
//             controller: _firstColumnController,
//             physics: ClampingScrollPhysics(),
//             children: List.generate(maxNumber - 1, (index) {
//               return MultiplicationTableCell(
//                 color: Colors.yellow.withOpacity(0.3),
//                 value: index + 2,
//               );
//             }),
//           ),
//         ),
//         Expanded(
//           child: SingleChildScrollView(
//             controller: widget.scrollController,
//             scrollDirection: Axis.horizontal,
//             physics: const ClampingScrollPhysics(),
//             child: SizedBox(
//               width: (maxNumber - 1) * 150,
//               child: ListView(
//                 controller: _restColumnsController,
//                 physics: const ClampingScrollPhysics(),
//                 children: List.generate(maxNumber - 1, (y) {
//                   return Row(
//                     children: List.generate(maxNumber - 1, (x) {
//                       return MultiplicationTableCell(
//                         value: (x + 2) * (y + 2),
//                       );
//                     }),
//                   );
//                 }),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
// class MultiplicationTable extends StatefulWidget {
//   @override
//   _MultiplicationTableState createState() => _MultiplicationTableState();
// }
// class _MultiplicationTableState extends State<MultiplicationTable> {
//   LinkedScrollControllerGroup? _controllers;
//   ScrollController? _headController;
//   ScrollController? _bodyController;
//   @override
//   void initState() {
//     super.initState();
//     _controllers = LinkedScrollControllerGroup();
//     _headController = _controllers!.addAndGet();
//     _bodyController = _controllers!.addAndGet();
//   }
//   @override
//   void dispose() {
//     _headController!.dispose();
//     _bodyController!.dispose();
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         TableHead(
//           scrollController: _headController!,
//         ),
//         Expanded(
//           child: TableBody(
//             scrollController: _bodyController!,
//           ),
//         ),
//       ],
//     );
//   }
// }
//

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.mouse,
        PointerDeviceKind.touch,
      };
}
