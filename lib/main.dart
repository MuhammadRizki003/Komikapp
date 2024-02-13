import 'package:komikapp/pages/home.dart';
import 'package:get/get.dart';
import 'package:komikapp/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // void onInit() {
  //   SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  // }
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(
          0xFF0F111D,
        ),
      ),
      home: MainPage(),
      routes: {
        '/home': (context) => Home(),
      },
    );
  }
}
