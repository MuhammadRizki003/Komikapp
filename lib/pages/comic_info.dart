// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:komikapp/controller/comic_page_controller.dart';
import 'package:komikapp/pages/baca_komik.dart';
import 'package:komikapp/pages/main_page.dart';
import 'package:komikapp/widgets/comic_image.dart';
import 'package:komikapp/api_link.dart' as globals;
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:komikapp/widgets/loading_animation.dart';

// ignore: must_be_immutable
class ComicInfo extends StatelessWidget {
  ComicInfo(
      {super.key,
      required this.title,
      required this.tglUpdate,
      required this.endPoint,
      this.fromProfile});
  final String title;
  final String tglUpdate;
  final String endPoint;
  bool? fromProfile;

  String judulKomik = "";
  String author = "";
  String status = "";
  String type = "";
  List genre = [];
  String cover = "";
  String sinopsis = "";
  List chapterList = [];
  String genrelist = '';
  bool hasilCek = false;
  bool isLogin = false;
  Future comicInfoPage() async {
    try {
      var responseRec =
          await http.get(Uri.parse('${globals.komikInfo}$endPoint'));
      judulKomik = (json.decode(responseRec.body)
          as Map<String, dynamic>)["result"]['title'];
      author = (json.decode(responseRec.body) as Map<String, dynamic>)["result"]
          ['author'];
      status = (json.decode(responseRec.body) as Map<String, dynamic>)["result"]
          ['status'];
      type = (json.decode(responseRec.body) as Map<String, dynamic>)["result"]
          ['type'];
      cover = (json.decode(responseRec.body) as Map<String, dynamic>)["result"]
          ['thumbnail'];
      sinopsis = (json.decode(responseRec.body)
          as Map<String, dynamic>)["result"]['sinopsis'];
      genre = (json.decode(responseRec.body) as Map<String, dynamic>)["result"]
          ['genres'];
      for (var i = 0; i < genre.length; i++) {
        genrelist = '$genrelist ${genre[i]},';
      }
      if (globals.idUser != null) {
        isLogin = true;
        var cekFav = await http.get(Uri.parse('${globals.cekFav}$title'));
        hasilCek =
            ((json.decode(cekFav.body) as Map<String, dynamic>)["status"]);
        final controller = Get.put(ComicController());
        if (hasilCek == true) {
          controller.isFavYes();
        } else {
          controller.isFavNo();
        }
      }
      chapterList = (json.decode(responseRec.body)
          as Map<String, dynamic>)["result"]['chapter-list'];
    } catch (e) {
      print("Terjadi Kesalahan");
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemWidth = (size.width / 3);
    final double itemHeight = (itemWidth * 3 / 2);
    final controller = Get.put(ComicController());
    return Scaffold(
      body: FutureBuilder(
        future: comicInfoPage(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText(
                          'Loading',
                          textStyle: const TextStyle(color: Colors.white54),
                          speed: const Duration(milliseconds: 65),
                        )
                      ],
                      totalRepeatCount: 15,
                    ),
                  ),
                  SizedBox(
                    height: 27,
                    width: 18,
                    child: Image.asset(
                      'assets/gif/loading-anime.gif',
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Stack(
              children: [
                SingleChildScrollView(
                  child: SafeArea(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 65,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: const Color(0xFF292B37).withOpacity(0.3),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: Text(
                                'KomikApp › $judulKomik',
                                style: const TextStyle(color: Colors.white54),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: const Color(0xFF292B37).withOpacity(0.3),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: Column(
                                children: [
                                  ComicImage(
                                      coverAnime: cover,
                                      itemHeight: itemHeight,
                                      itemWidth: itemWidth),
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30),
                                      child: Obx(
                                        () => ElevatedButton(
                                          onPressed: () async {
                                            if (isLogin == false) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  backgroundColor:
                                                      Colors.red[300],
                                                  content: const Center(
                                                    child: Text(
                                                      'Anda Belum Login',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                  margin:
                                                      const EdgeInsetsDirectional
                                                          .symmetric(
                                                          horizontal: 25,
                                                          vertical: 20),
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  duration: const Duration(
                                                      milliseconds: 1500),
                                                ),
                                              );
                                            } else {
                                              if (controller.isFav.value ==
                                                  true) {
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
                                                                .symmetric(
                                                                horizontal: 10,
                                                                vertical: 10),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            const Text(
                                                              'Apakah anda yakin ingin menghapus komik ini dari daftar Favorit?',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white54,
                                                                  fontSize: 20),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                            const SizedBox(
                                                                height: 20),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Expanded(
                                                                  child:
                                                                      ElevatedButton(
                                                                    onPressed:
                                                                        () async {
                                                                      loadingAnimation(
                                                                          context);
                                                                      Map<String,
                                                                              dynamic>
                                                                          dataFav =
                                                                          {
                                                                        'idUser':
                                                                            (globals.idUser).toString(),
                                                                        'title':
                                                                            title,
                                                                      };
                                                                      await http.post(
                                                                          Uri.parse(globals
                                                                              .delFav),
                                                                          body:
                                                                              dataFav);
                                                                      Navigator.pop(
                                                                          context);
                                                                      Navigator.pop(
                                                                          context);
                                                                      controller
                                                                          .isFavNo();
                                                                    },
                                                                    child:
                                                                        const Text(
                                                                      'Ya',
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
                                                                ),
                                                                const SizedBox(
                                                                    width: 20),
                                                                Expanded(
                                                                  child:
                                                                      ElevatedButton(
                                                                    style: ButtonStyle(
                                                                        backgroundColor:
                                                                            MaterialStateProperty.all(Colors.red)),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child:
                                                                        const Text(
                                                                      'Tidak',
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
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              } else {
                                                loadingAnimation(context);
                                                Map<String, dynamic> dataFav = {
                                                  'idUser': (globals.idUser)
                                                      .toString(),
                                                  'title': title,
                                                  'image': cover,
                                                  'tipe': 'Manga',
                                                  'endpoint': endPoint
                                                };
                                                await http.post(
                                                  Uri.parse(globals.addFav),
                                                  body: dataFav,
                                                );
                                                Navigator.pop(context);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    backgroundColor:
                                                        Colors.green[300],
                                                    content: const Center(
                                                      child: Text(
                                                        'Menambahkan Komik Favorit',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                    margin:
                                                        const EdgeInsetsDirectional
                                                            .symmetric(
                                                            horizontal: 25,
                                                            vertical: 20),
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    duration: const Duration(
                                                        milliseconds: 1500),
                                                  ),
                                                );
                                                controller.isFavYes();
                                              }
                                            }
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                controller.isFav.value
                                                    ? MaterialStateProperty.all(
                                                        Colors.red)
                                                    : MaterialStateProperty.all(
                                                        Colors.blue),
                                          ),
                                          child: Obx(
                                            () => Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(Icons
                                                    .favorite_border_rounded),
                                                Text(controller.isFav.value
                                                    ? 'Hapus Favorit'
                                                    : "Tambah ke Favorit"),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'Authored by ',
                                          maxLines: 1,
                                          style:
                                              TextStyle(color: Colors.white54),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          author,
                                          maxLines: 1,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.italic),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    child: Row(children: [
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF292B37),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  'Status',
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                      color: Colors.white54),
                                                  textAlign: TextAlign.center,
                                                ),
                                                Text(
                                                  status,
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF292B37),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  'Manga',
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                      color: Colors.white54),
                                                  textAlign: TextAlign.center,
                                                ),
                                                Text(
                                                  type,
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    ]),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    child: Text(
                                      judulKomik,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
                                          fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const Text(
                                    'Sinopsis',
                                    style: TextStyle(
                                      color: Colors.white54,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    child: Text(
                                      sinopsis,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.italic),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'Genre',
                                    style: TextStyle(
                                      color: Colors.white54,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    child: Text(
                                      genrelist,
                                      maxLines: 2,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.italic),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: const Color(0xFF292B37).withOpacity(0.3),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    'Chapter List ',
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: Colors.white54,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Container(
                                  constraints:
                                      const BoxConstraints(maxHeight: 500),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: GridView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: chapterList.length,
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              mainAxisSpacing: 15,
                                              crossAxisSpacing: 10,
                                              childAspectRatio: 3 / 1,
                                            ),
                                            itemBuilder: (context, index) {
                                              return InkWell(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          BacaKomik(
                                                        endpoint:
                                                            chapterList[index]
                                                                ['Endpoint'],
                                                        indexChapter: index,
                                                        lengthChapter:
                                                            chapterList.length,
                                                        endpointChapterList:
                                                            endPoint,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color:
                                                        const Color(0xFF292B37),
                                                  ),
                                                  child: Center(
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 5),
                                                      child: Text(
                                                        chapterList[index]
                                                            ['Name'],
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20)
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20)
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 48, left: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (fromProfile != null) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => MainPage()),
                            );
                          } else {
                            Get.offAll(MainPage());
                          }
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 31),
                      child: SizedBox(
                        height: 60,
                        child: Opacity(
                          opacity: 0.7,
                          child: Image.asset(
                            'assets/logoApp/logo-komikapp.png',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
