import 'package:flutter/material.dart';

import '../controller/data/LoginData.dart';

class CommonPage extends StatelessWidget{

  final Widget widget;
  CommonPage({required this.widget});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: LoginData.getDeviceId(),
      builder: (context, snapshot) {

        print("snap----_${snapshot.data}");

        if(snapshot.data == null) {
          return Container();
        }
        if(snapshot.data != null && !snapshot.data!){
          return Container();
        }

        return widget;

      },);
  }

}