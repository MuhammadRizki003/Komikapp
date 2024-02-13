// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:komikapp/controller/login_page_controller.dart';
import 'package:http/http.dart' as http;
import 'package:komikapp/api_link.dart' as globals;
import 'package:get_storage/get_storage.dart';
import 'package:komikapp/widgets/loading_animation.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginPageController());
    var isVisible = true.obs;
    TextEditingController emailLoginController = TextEditingController();
    TextEditingController passwordLoginController = TextEditingController();
    final box = GetStorage();
    if (box.read('rememberMe') != null) {
      controller.isRememberMe = true.obs;
      emailLoginController.text = box.read('rememberMe')['email'];
      passwordLoginController.text = box.read('rememberMe')['password'];
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF292B37),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              controller: emailLoginController,
              decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.white38,
                  ),
                  focusedBorder: InputBorder.none,
                  hintText: 'Email',
                  hintMaxLines: 1,
                  hintStyle: TextStyle(color: Colors.white54)),
              cursorColor: Colors.white,
              style: const TextStyle(color: Colors.white54, fontSize: 20),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10, left: 10),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF292B37),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Obx(
              () => TextField(
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                obscureText: isVisible.value,
                controller: passwordLoginController,
                decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: Colors.white38,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        isVisible.value = !isVisible.value;
                      },
                      child: Icon(
                        isVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.white30,
                      ),
                    ),
                    focusedBorder: InputBorder.none,
                    hintText: 'Password',
                    hintMaxLines: 1,
                    hintStyle: const TextStyle(color: Colors.white54)),
                cursorColor: Colors.white,
                style: const TextStyle(color: Colors.white54, fontSize: 20),
              ),
            ),
          ),
        ),
        Obx(
          () => CheckboxListTile(
            value: controller.isRememberMe.value,
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (value) {
              controller.isRememberMe.toggle();
            },
            title: const Text(
              'Simpan info login',
              style: TextStyle(color: Colors.white54),
            ),
            side: const BorderSide(
              color: Colors.white54,
              width: 1.5,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: ElevatedButton(
            onPressed: () async {
              loadingAnimation(context);
              var loginResponse = await http.post(
                Uri.parse(globals.loginLink),
                body: {
                  'email': emailLoginController.value.text,
                  'password': passwordLoginController.value.text,
                },
              );
              var isRegister =
                  (json.decode(loginResponse.body) as Map<String, dynamic>);
              if (isRegister['status'] == true) {
                Navigator.of(context).pop();
                controller.LoginFunc(
                  int.parse(isRegister['data']['id_user']),
                  isRegister['data']['nama'],
                  isRegister['data']['avatar'],
                  isRegister['data']['email'],
                  isRegister['data']['user_id'],
                );
                if (box.read('rememberMe') != null) {
                  box.remove('rememberMe');
                }
                if (controller.isRememberMe.isTrue) {
                  box.write(
                    'rememberMe',
                    {
                      'email': emailLoginController.value.text,
                      'password': passwordLoginController.value.text,
                    },
                  );
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.green[300],
                    content: Center(
                      child: Text(
                        isRegister['message'],
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    margin: const EdgeInsetsDirectional.symmetric(
                        horizontal: 25, vertical: 20),
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 3),
                  ),
                );
              } else {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.red[800],
                    content: Center(
                      child: Text(
                        isRegister['message'],
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    margin: const EdgeInsetsDirectional.symmetric(
                        horizontal: 25, vertical: 20),
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(milliseconds: 2500),
                  ),
                );
              }
            },
            style: ButtonStyle(
              fixedSize: const MaterialStatePropertyAll(
                  Size(double.maxFinite, double.nan)),
              shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.login_rounded),
                  SizedBox(width: 5),
                  Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        RichText(
          text: TextSpan(
            children: [
              const TextSpan(
                text: 'Belum punya akun? ',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                ),
              ),
              TextSpan(
                  text: 'Daftar disini',
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.blue,
                      fontSize: 12),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => controller.LoginPageFunc())
            ],
          ),
        )
      ],
    );
  }
}
