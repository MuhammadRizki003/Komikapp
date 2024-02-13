// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:komikapp/controller/login_page_controller.dart';
import 'package:http/http.dart' as http;
import 'package:komikapp/api_link.dart' as globals;
import 'package:komikapp/widgets/loading_animation.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController namaRegisterController = TextEditingController();
    TextEditingController emailRegisterController = TextEditingController();
    TextEditingController passwordRegisterController1 = TextEditingController();
    TextEditingController passwordRegisterController2 = TextEditingController();
    final controller = Get.put(LoginPageController());
    var isVisible1 = true.obs;
    var isVisible2 = true.obs;
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
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.name,
              controller: namaRegisterController,
              decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.white38,
                  ),
                  focusedBorder: InputBorder.none,
                  hintText: 'Masukan Nama',
                  hintMaxLines: 1,
                  hintStyle: TextStyle(color: Colors.white54)),
              cursorColor: Colors.white,
              style: const TextStyle(color: Colors.white54, fontSize: 20),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10, left: 10, bottom: 15),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF292B37),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              controller: emailRegisterController,
              decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: Colors.white38,
                  ),
                  focusedBorder: InputBorder.none,
                  hintText: 'Masukan Email',
                  hintMaxLines: 1,
                  hintStyle: TextStyle(color: Colors.white54)),
              cursorColor: Colors.white,
              style: const TextStyle(color: Colors.white54, fontSize: 20),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10, left: 10, bottom: 15),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF292B37),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Obx(
              () => TextField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                obscureText: isVisible1.value,
                controller: passwordRegisterController1,
                decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: Colors.white38,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        isVisible1.value = !isVisible1.value;
                      },
                      child: Icon(
                        isVisible1.value
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
                obscureText: isVisible2.value,
                controller: passwordRegisterController2,
                decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: Colors.white38,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        isVisible2.value = !isVisible2.value;
                      },
                      child: Icon(
                        isVisible2.value
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: ElevatedButton(
            onPressed: () async {
              loadingAnimation(context);
              var registerResponse = await http.post(
                Uri.parse(globals.regisLink),
                body: {
                  'nama': namaRegisterController.value.text,
                  'email': emailRegisterController.value.text,
                  'password1': passwordRegisterController1.value.text,
                  'password2': passwordRegisterController2.value.text
                },
              );
              var isRegister =
                  (json.decode(registerResponse.body) as Map<String, dynamic>);
              if (isRegister['status'] == true) {
                Navigator.pop(context);
                controller.LoginPageFunc();
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
                Navigator.pop(context);
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
                    'Register',
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
                text: 'Sudah punya akun? ',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                ),
              ),
              TextSpan(
                text: 'Login disini',
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.blue,
                    fontSize: 12),
                recognizer: TapGestureRecognizer()
                  ..onTap = () =>
                      // Navigator.of(context).pushReplacement(
                      //       MaterialPageRoute(
                      //         builder: (context) => Register(),
                      //       ),
                      //     ),
                      controller.LoginPageFunc(),
              )
            ],
          ),
        )
      ],
    );
  }
}
