import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:komikapp/controller/main_page_controller.dart';
import 'package:komikapp/pages/genre_page.dart';
import 'package:komikapp/pages/home.dart';
import 'package:komikapp/pages/login.dart';
import 'package:komikapp/pages/no_internet_pages.dart';

class MainPage extends StatelessWidget {
  MainPage({
    super.key,
  });

  final List<Widget> pages = [GenrePage(), Home(), const Login()];
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MainPageController());
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Center(
            child: SizedBox(
              height: 60,
              child: Opacity(
                opacity: 0.7,
                child: Image.asset(
                  'assets/logoApp/logo-komikapp.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        backgroundColor: const Color(0xFF0F111D),
      ),
      body: Obx(
        () => controller.iNet.value
            ? pages[controller.indexNow.value]
            : const NoInternetPages(),
      ),
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.reactCircle,
        backgroundColor: const Color(0xFF292B37),
        items: const [
          TabItem(icon: Icons.list, title: 'Genre List'),
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.person, title: 'Profile'),
        ],
        initialActiveIndex: controller.indexNow.value,
        onTap: (int i) {
          controller.indexChangeFunc(i);
        },
      ),
    );
  }
}
