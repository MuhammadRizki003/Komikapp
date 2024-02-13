// ignore_for_file: non_constant_identifier_names

import 'package:get/get.dart';
import 'package:komikapp/api_link.dart' as globals;

class LoginPageController extends GetxController {
  RxBool loginPage = false.obs;
  RxBool isLogin = false.obs;
  RxBool refreshData = false.obs;
  Map<String, dynamic>? userData;
  LoginPageFunc() {
    loginPage(!loginPage.value);
  }

  refreshEdit() {
    refreshData(!refreshData.value);
    refreshData(!refreshData.value);
  }

  LoginFunc(id, nama, avatar, email, roleId) {
    isLogin(isLogin.value = true);
    userData = {
      'id_user': id,
      'nama': nama,
      'avatar': avatar,
      'email': email,
      'role_id': roleId
    } as Map<String, dynamic>?;
    globals.idUser = userData?['id_user'];
  }

  LogoutFunc() {
    isLogin(isLogin.value = false);
    userData = {};
    globals.idUser = null;
  }

  RxBool editProfile = false.obs;
  RxBool isRememberMe = false.obs;
}
