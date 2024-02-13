// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:komikapp/controller/login_page_controller.dart';
import 'package:komikapp/widgets/bagan_homepage.dart';
import 'package:komikapp/widgets/comic_card.dart';
import 'package:komikapp/widgets/empty_card.dart';
import 'package:komikapp/api_link.dart' as globals;
import 'package:komikapp/widgets/loading_animation.dart';

// ignore: must_be_immutable
class InfoAkun extends StatelessWidget {
  InfoAkun({super.key});

  List? komikFav;
  Future infoAkun() async {
    try {
      var komikFavHttp = await http
          .get(Uri.parse('${globals.komikFavHome}?idUser=${globals.idUser}'));
      var data = (json.decode(komikFavHttp.body) as Map<String, dynamic>);
      if (data['status'] == true) {
        komikFav = data['result'];
      }
    } catch (e) {
      print("Terjadi Kesalahan");
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginPageController());
    TextEditingController namaController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController passwordBaruController1 = TextEditingController();
    TextEditingController passwordBaruController2 = TextEditingController();

    RxString pesan = ''.obs;
    var isVisible = true.obs;
    RxList optionValue = ['1.png', '2.png', '3.png', '4.png', '5.png'].obs;
    RxString currentOption = '${controller.userData?['avatar']}'.obs;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        child: Stack(
          children: [
            SizedBox(
              height: 200,
              width: double.maxFinite,
              child: Opacity(
                opacity: 0.18,
                child: Image.asset(
                  'assets/logoApp/background_user.jpg',
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 100),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Color(0xFF292B37),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF292B37),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    backgroundColor: const Color(0xFF292B37),
                                    child: SingleChildScrollView(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 10),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text(
                                              'Pilih Avatar',
                                              style: TextStyle(
                                                  color: Colors.white54),
                                              textAlign: TextAlign.center,
                                            ),
                                            SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                children: [
                                                  for (int i = 0;
                                                      i < optionValue.length;
                                                      i++)
                                                    Obx(
                                                      () => Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 3),
                                                        child: Stack(
                                                          alignment:
                                                              Alignment.center,
                                                          children: [
                                                            Align(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                child:
                                                                    ColorFiltered(
                                                                  colorFilter:
                                                                      ColorFilter
                                                                          .mode(
                                                                    currentOption.value ==
                                                                            optionValue[
                                                                                i]
                                                                        ? Colors
                                                                            .white30 // Warna saat radio button aktif
                                                                        : Colors
                                                                            .black87, // Warna saat radio button belum dipilih (transparan)
                                                                    BlendMode
                                                                        .multiply,
                                                                  ),
                                                                  child: Image
                                                                      .asset(
                                                                    'assets/avatar/${i + 1}.png',
                                                                    height: MediaQuery.of(context)
                                                                            .size
                                                                            .width /
                                                                        4,
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width /
                                                                        4,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Transform.scale(
                                                              scale: 3,
                                                              child: Radio(
                                                                value:
                                                                    optionValue[
                                                                        i],
                                                                groupValue:
                                                                    currentOption
                                                                        .value,
                                                                fillColor:
                                                                    MaterialStatePropertyAll(
                                                                        Colors
                                                                            .transparent),
                                                                onChanged:
                                                                    (value) {
                                                                  currentOption
                                                                          .value =
                                                                      value;
                                                                  print(
                                                                      currentOption);
                                                                  print(
                                                                      optionValue[
                                                                          i]);
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: double.maxFinite,
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  loadingAnimation(context);
                                                  var editInfo =
                                                      await http.post(
                                                    Uri.parse(globals
                                                        .gantiAvatarLink),
                                                    body: {
                                                      'id': (globals.idUser)
                                                          .toString(),
                                                      'avatar':
                                                          currentOption.value,
                                                    },
                                                  );
                                                  var isEdit = (json
                                                          .decode(editInfo.body)
                                                      as Map<String, dynamic>);
                                                  if (isEdit['status'] ==
                                                      true) {
                                                    Navigator.of(context).pop();
                                                    Navigator.of(context).pop();
                                                    controller.userData?[
                                                            'avatar'] =
                                                        currentOption.value;
                                                    controller.refreshEdit();
                                                  } else {
                                                    // Navigator.of(context).pop();
                                                    Navigator.pop(context);
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return Dialog(
                                                          backgroundColor:
                                                              const Color(
                                                                  0xFF292B37),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                const Text(
                                                                  'EDIT AKUN GAGAL!',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red,
                                                                      fontSize:
                                                                          23),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                                Text(
                                                                  isEdit[
                                                                      'message'],
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                                SizedBox(
                                                                  width: double
                                                                      .maxFinite,
                                                                  child:
                                                                      ElevatedButton(
                                                                    onPressed: () =>
                                                                        Navigator.pop(
                                                                            context),
                                                                    child:
                                                                        const Text(
                                                                      'Close',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  }
                                                },
                                                child: const Text(
                                                  'Ubah Avatar',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Text(
                              'Ganti Avatar',
                              style: TextStyle(color: Colors.blueAccent),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    width: double.maxFinite,
                    decoration: const BoxDecoration(
                      color: Color(0xFF292B37),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10, left: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Obx(
                              () => controller.refreshData.value
                                  ? Text(
                                      controller.userData?['nama'],
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  : Text(
                                      controller.userData?['nama'],
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                            ),
                          ),
                          const SizedBox(width: 2),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    backgroundColor: const Color(0xFF292B37),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text(
                                              'Form pengubahan  Nama',
                                              style: TextStyle(
                                                  color: Colors.white54),
                                              textAlign: TextAlign.center,
                                            ),
                                            TextField(
                                              controller: namaController,
                                              decoration: const InputDecoration(
                                                  prefixIcon: Icon(
                                                    Icons.person,
                                                    color: Colors.white38,
                                                  ),
                                                  focusedBorder:
                                                      InputBorder.none,
                                                  hintText: 'Nama pengganti',
                                                  hintMaxLines: 1,
                                                  hintStyle: TextStyle(
                                                      color: Colors.white54)),
                                              cursorColor: Colors.white,
                                              style: const TextStyle(
                                                  color: Colors.white54,
                                                  fontSize: 20),
                                            ),
                                            Obx(
                                              () => TextField(
                                                controller: passwordController,
                                                obscureText: isVisible.value,
                                                decoration: InputDecoration(
                                                    prefixIcon: const Icon(
                                                      Icons.lock_outline,
                                                      color: Colors.white38,
                                                    ),
                                                    suffixIcon: GestureDetector(
                                                      onTap: () {
                                                        isVisible.value =
                                                            !isVisible.value;
                                                      },
                                                      child: Icon(
                                                        isVisible.value
                                                            ? Icons.visibility
                                                            : Icons
                                                                .visibility_off,
                                                        color: Colors.white30,
                                                      ),
                                                    ),
                                                    focusedBorder:
                                                        InputBorder.none,
                                                    hintText: 'Password anda',
                                                    hintMaxLines: 1,
                                                    hintStyle: const TextStyle(
                                                        color: Colors.white54)),
                                                cursorColor: Colors.white,
                                                style: const TextStyle(
                                                    color: Colors.white54,
                                                    fontSize: 20),
                                              ),
                                            ),
                                            SizedBox(
                                              width: double.maxFinite,
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  loadingAnimation(context);
                                                  var editInfo =
                                                      await http.post(
                                                    Uri.parse(
                                                        globals.gantiNamaLink),
                                                    body: {
                                                      'id': (globals.idUser)
                                                          .toString(),
                                                      'nama': namaController
                                                          .value.text,
                                                      'password':
                                                          passwordController
                                                              .value.text,
                                                    },
                                                  );
                                                  var isEdit = (json
                                                          .decode(editInfo.body)
                                                      as Map<String, dynamic>);
                                                  if (isEdit['status'] ==
                                                      true) {
                                                    Navigator.pop(context);
                                                    controller
                                                            .userData?['nama'] =
                                                        namaController
                                                            .value.text;
                                                    controller.refreshEdit();
                                                    namaController.clear();
                                                    passwordController.clear();
                                                    Navigator.pop(context);
                                                  } else {
                                                    namaController.clear();
                                                    passwordController.clear();
                                                    Navigator.pop(context);
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return Dialog(
                                                          backgroundColor:
                                                              const Color(
                                                                  0xFF292B37),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                const Text(
                                                                  'EDIT AKUN GAGAL!',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red,
                                                                      fontSize:
                                                                          23),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                                Text(
                                                                  isEdit[
                                                                      'message'],
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                                SizedBox(
                                                                  width: double
                                                                      .maxFinite,
                                                                  child:
                                                                      ElevatedButton(
                                                                    onPressed: () =>
                                                                        Navigator.pop(
                                                                            context),
                                                                    child:
                                                                        const Text(
                                                                      'Close',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  }
                                                },
                                                child: const Text(
                                                  'Ubah Nama',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: const Icon(
                              Icons.edit,
                              color: Colors.blueAccent,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 10)
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    width: double.maxFinite,
                    constraints:
                        const BoxConstraints(maxWidth: double.maxFinite),
                    decoration: const BoxDecoration(
                      color: Color(0xFF292B37),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Email',
                          style: TextStyle(color: Colors.white54),
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Obx(
                                  () => controller.refreshData.value
                                      ? Text(
                                          '${controller.userData?["email"]}',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500),
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      : Text(
                                          '${controller.userData?["email"]}',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500),
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                ),
                              ),
                              const SizedBox(width: 2),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        backgroundColor:
                                            const Color(0xFF292B37),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Text(
                                                  'Form pengubahan  Email',
                                                  style: TextStyle(
                                                      color: Colors.white54),
                                                  textAlign: TextAlign.center,
                                                ),
                                                Obx(
                                                  () => Text(
                                                    pesan.value,
                                                    style: const TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 10),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                TextField(
                                                  controller: emailController,
                                                  decoration:
                                                      const InputDecoration(
                                                          prefixIcon: Icon(
                                                            Icons.email,
                                                            color:
                                                                Colors.white38,
                                                          ),
                                                          focusedBorder:
                                                              InputBorder.none,
                                                          hintText:
                                                              'Email pengganti',
                                                          hintMaxLines: 1,
                                                          hintStyle: TextStyle(
                                                              color: Colors
                                                                  .white54)),
                                                  cursorColor: Colors.white,
                                                  style: const TextStyle(
                                                      color: Colors.white54,
                                                      fontSize: 20),
                                                ),
                                                Obx(
                                                  () => TextField(
                                                    controller:
                                                        passwordController,
                                                    obscureText:
                                                        isVisible.value,
                                                    decoration: InputDecoration(
                                                        prefixIcon: const Icon(
                                                          Icons.lock_outline,
                                                          color: Colors.white38,
                                                        ),
                                                        suffixIcon:
                                                            GestureDetector(
                                                          onTap: () {
                                                            isVisible.value =
                                                                !isVisible
                                                                    .value;
                                                          },
                                                          child: Icon(
                                                            isVisible.value
                                                                ? Icons
                                                                    .visibility
                                                                : Icons
                                                                    .visibility_off,
                                                            color:
                                                                Colors.white30,
                                                          ),
                                                        ),
                                                        focusedBorder:
                                                            InputBorder.none,
                                                        hintText:
                                                            'Password anda',
                                                        hintMaxLines: 1,
                                                        hintStyle:
                                                            const TextStyle(
                                                                color: Colors
                                                                    .white54)),
                                                    cursorColor: Colors.white,
                                                    style: const TextStyle(
                                                        color: Colors.white54,
                                                        fontSize: 20),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: double.maxFinite,
                                                  child: ElevatedButton(
                                                    onPressed: () async {
                                                      loadingAnimation(context);
                                                      var editInfo =
                                                          await http.post(
                                                        Uri.parse(globals
                                                            .gantiEmailLink),
                                                        body: {
                                                          'id': (globals.idUser)
                                                              .toString(),
                                                          'email':
                                                              emailController
                                                                  .value.text,
                                                          'password':
                                                              passwordController
                                                                  .value.text,
                                                        },
                                                      );
                                                      var isEdit = (json.decode(
                                                              editInfo.body)
                                                          as Map<String,
                                                              dynamic>);
                                                      if (isEdit['status'] ==
                                                          true) {
                                                        Navigator.pop(context);
                                                        controller.userData?[
                                                                'email'] =
                                                            emailController
                                                                .value.text;
                                                        controller
                                                            .refreshEdit();
                                                        Navigator.pop(context);
                                                        emailController.clear();
                                                        passwordController
                                                            .clear();
                                                      } else {
                                                        emailController.clear();
                                                        passwordController
                                                            .clear();
                                                        Navigator.pop(context);
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return Dialog(
                                                              backgroundColor:
                                                                  const Color(
                                                                      0xFF292B37),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    const Text(
                                                                      'EDIT AKUN GAGAL!',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .red,
                                                                          fontSize:
                                                                              23),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                    Text(
                                                                      isEdit[
                                                                          'message'],
                                                                      style:
                                                                          const TextStyle(
                                                                        color: Colors
                                                                            .red,
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                    SizedBox(
                                                                      width: double
                                                                          .maxFinite,
                                                                      child:
                                                                          ElevatedButton(
                                                                        onPressed:
                                                                            () =>
                                                                                Navigator.pop(context),
                                                                        child:
                                                                            const Text(
                                                                          'Close',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      }
                                                    },
                                                    child: const Text(
                                                      'Ubah Email',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.blueAccent,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 10)
                            ],
                          ),
                        ),
                        const SizedBox(height: 10)
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF292B37),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    backgroundColor: const Color(0xFF292B37),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text(
                                              'Form pengubahan  Password',
                                              style: TextStyle(
                                                  color: Colors.white54),
                                              textAlign: TextAlign.center,
                                            ),
                                            Obx(
                                              () => TextField(
                                                obscureText: isVisible.value,
                                                controller: passwordController,
                                                decoration: InputDecoration(
                                                    prefixIcon: const Icon(
                                                      Icons.lock_outline,
                                                      color: Colors.white38,
                                                    ),
                                                    suffixIcon: GestureDetector(
                                                      onTap: () {
                                                        isVisible.value =
                                                            !isVisible.value;
                                                      },
                                                      child: Icon(
                                                        isVisible.value
                                                            ? Icons.visibility
                                                            : Icons
                                                                .visibility_off,
                                                        color: Colors.white30,
                                                      ),
                                                    ),
                                                    focusedBorder:
                                                        InputBorder.none,
                                                    hintText: 'Password Lama',
                                                    hintMaxLines: 1,
                                                    hintStyle: const TextStyle(
                                                        color: Colors.white54)),
                                                cursorColor: Colors.white,
                                                style: const TextStyle(
                                                    color: Colors.white54,
                                                    fontSize: 20),
                                              ),
                                            ),
                                            Obx(
                                              () => TextField(
                                                controller:
                                                    passwordBaruController1,
                                                obscureText: isVisible.value,
                                                decoration: InputDecoration(
                                                    prefixIcon: const Icon(
                                                      Icons.lock_outline,
                                                      color: Colors.white38,
                                                    ),
                                                    suffixIcon: GestureDetector(
                                                      onTap: () {
                                                        isVisible.value =
                                                            !isVisible.value;
                                                      },
                                                      child: Icon(
                                                        isVisible.value
                                                            ? Icons.visibility
                                                            : Icons
                                                                .visibility_off,
                                                        color: Colors.white30,
                                                      ),
                                                    ),
                                                    focusedBorder:
                                                        InputBorder.none,
                                                    hintText: 'Password Baru',
                                                    hintMaxLines: 1,
                                                    hintStyle: const TextStyle(
                                                        color: Colors.white54)),
                                                cursorColor: Colors.white,
                                                style: const TextStyle(
                                                    color: Colors.white54,
                                                    fontSize: 20),
                                              ),
                                            ),
                                            Obx(
                                              () => TextField(
                                                controller:
                                                    passwordBaruController2,
                                                obscureText: isVisible.value,
                                                decoration: InputDecoration(
                                                    prefixIcon: const Icon(
                                                      Icons.lock_outline,
                                                      color: Colors.white38,
                                                    ),
                                                    suffixIcon: GestureDetector(
                                                      onTap: () {
                                                        isVisible.value =
                                                            !isVisible.value;
                                                      },
                                                      child: Icon(
                                                        isVisible.value
                                                            ? Icons.visibility
                                                            : Icons
                                                                .visibility_off,
                                                        color: Colors.white30,
                                                      ),
                                                    ),
                                                    focusedBorder:
                                                        InputBorder.none,
                                                    hintText: 'Konfirmasi',
                                                    hintMaxLines: 1,
                                                    hintStyle: const TextStyle(
                                                        color: Colors.white54)),
                                                cursorColor: Colors.white,
                                                style: const TextStyle(
                                                    color: Colors.white54,
                                                    fontSize: 20),
                                              ),
                                            ),
                                            SizedBox(
                                              width: double.maxFinite,
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  loadingAnimation(context);
                                                  var editInfo =
                                                      await http.post(
                                                    Uri.parse(globals
                                                        .gantiPasswordLink),
                                                    body: {
                                                      'id': (globals.idUser)
                                                          .toString(),
                                                      'password':
                                                          passwordController
                                                              .value.text,
                                                      'password_baru':
                                                          passwordBaruController1
                                                              .value.text,
                                                      'password_baru2':
                                                          passwordBaruController2
                                                              .value.text,
                                                    },
                                                  );
                                                  var isEdit = (json
                                                          .decode(editInfo.body)
                                                      as Map<String, dynamic>);
                                                  print(isEdit['status']);
                                                  if (isEdit['status'] ==
                                                      true) {
                                                    Navigator.of(context).pop();
                                                    Navigator.of(context).pop();
                                                    passwordController.clear();
                                                    passwordBaruController1
                                                        .clear();
                                                    passwordBaruController2
                                                        .clear();
                                                  } else {
                                                    Navigator.of(context).pop();
                                                    Navigator.of(context).pop();
                                                    passwordController.clear();
                                                    passwordBaruController1
                                                        .clear();
                                                    passwordBaruController2
                                                        .clear();

                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return Dialog(
                                                          backgroundColor:
                                                              const Color(
                                                                  0xFF292B37),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                const Text(
                                                                  'EDIT AKUN GAGAL!',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red,
                                                                      fontSize:
                                                                          23),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                                Text(
                                                                  isEdit[
                                                                      'message'],
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                                SizedBox(
                                                                  width: double
                                                                      .maxFinite,
                                                                  child:
                                                                      ElevatedButton(
                                                                    onPressed: () =>
                                                                        Navigator.pop(
                                                                            context),
                                                                    child:
                                                                        const Text(
                                                                      'Close',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  }
                                                },
                                                child: const Text(
                                                  'Ubah Password',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: const Text(
                              'Ganti Password',
                              style: TextStyle(color: Colors.blueAccent),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Column(
                  children: [
                    BaganHomePage(
                        namaBagan: 'Komik Favorit',
                        url: globals.komikFav,
                        page: 1),
                    FutureBuilder(
                      future: infoAkun(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                for (int i = 0; i < 3; i++) const EmptyCard()
                              ],
                            ),
                          );
                        } else {
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                if (komikFav == null)
                                  const SizedBox(
                                    height: 200,
                                    child: Center(
                                      child: Text(
                                        'Anda belum memiliki komik Favorit',
                                        style: TextStyle(color: Colors.white54),
                                      ),
                                    ),
                                  )
                                else
                                  for (int i = 0; i < komikFav!.length; i++)
                                    KomikCard(
                                      image: komikFav?[i]['image'],
                                      title: komikFav?[i]['title'],
                                      desc: komikFav?[i]['tgl_update'],
                                      endPoint: komikFav?[i]['endpoint'],
                                      fromProfile: true,
                                    ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        controller.LogoutFunc();
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Logout'),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
            Center(
              child: Stack(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 50),
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: const Color(0xFF292B37),
                          border: Border.all(
                            color: const Color.fromARGB(255, 55, 58, 83),
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Obx(
                              () => controller.refreshData.value
                                  ? Image.asset(
                                      'assets/avatar/${controller.userData?["avatar"]}',
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      'assets/avatar/${controller.userData?["avatar"]}',
                                      fit: BoxFit.cover,
                                    ),
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
