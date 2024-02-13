import 'package:flutter/material.dart';
import 'package:komikapp/controller/login_page_controller.dart';
import 'package:get/get.dart';
import 'package:komikapp/widgets/info_akun.dart';
import 'package:komikapp/widgets/login_form.dart';
import 'package:komikapp/widgets/register_form.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginPageController());

    return Obx(() => SizedBox(
          child: controller.isLogin.value
              ? InfoAkun()
              : Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                      color: Colors.blueAccent.withOpacity(0.2),
                                      width: 3)),
                              height: 90,
                              width: 90,
                              child: Image.asset(
                                'assets/logoApp/userLogin.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                        Obx(
                          () => Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Center(
                              child: Text(
                                controller.loginPage.value ? 'Daftar' : 'Login',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        Obx(
                          () => SizedBox(
                            child: controller.loginPage.value
                                ? const RegisterForm()
                                : const LoginForm(),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
        ));
  }
}
