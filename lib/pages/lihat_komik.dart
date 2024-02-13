// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:komikapp/pages/main_page.dart';
import 'package:komikapp/widgets/lihat_komik_card.dart';
import 'package:komikapp/widgets/search_bar.dart';

// ignore: must_be_immutable
class LihatKomik extends StatelessWidget {
  LihatKomik(
      {super.key,
      required this.url,
      required this.page,
      this.cari,
      this.genre,
      this.fromProfile});
  final String url;
  final int page;
  final String? cari;
  final String? genre;
  bool? fromProfile;
  List dataKomik = [];
  bool tombolSelanjutnya = false;
  bool tombolSebelumnya = false;

  bool cekData(String? x) {
    if ([null].contains(x)) {
      return false;
    } else {
      return true;
    }
  }

  Future komikList(BuildContext context) async {
    try {
      var linkKomik = await http.get(Uri.parse('$url&page=$page'));
      dataKomik =
          (json.decode(linkKomik.body) as Map<String, dynamic>)["result"];
      var linkNext = await http.get(Uri.parse('$url&page=${page + 1}'));
      tombolSelanjutnya =
          (json.decode(linkNext.body) as Map<String, dynamic>)['success'];
      if (page > 1) {
        tombolSebelumnya = true;
      }
    } catch (e) {
      // showDialog(
      //   context: context,
      //   builder: (context) {
      //     return AlertDialog(
      //       backgroundColor: const Color(0xFF292B37).withOpacity(0.5),
      //       title: const Center(
      //           child: Text(
      //         'Loading Error',
      //         style: TextStyle(color: Colors.white),
      //       )),
      //       content: const Text(
      //         'Data tidak dapat di muat / Internet Error',
      //         style: TextStyle(color: Colors.white54),
      //       ),
      //       actions: <Widget>[
      //         Center(
      //           child: TextButton(
      //             onPressed: () {
      //               Navigator.of(context).push(
      //                 MaterialPageRoute(
      //                   builder: (context) => LihatKomik(
      //                     url: url,
      //                     page: page,
      //                   ),
      //                 ),
      //               );
      //             },
      //             child: const Row(
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               children: [
      //                 Icon(Icons.refresh_outlined),
      //                 Text('Refresh'),
      //               ],
      //             ),
      //           ),
      //         ),
      //       ],
      //     );
      //   },
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: komikList(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
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
                      totalRepeatCount: 10,
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
            ),
          );
        } else {}
        return Scaffold(
          appBar: AppBar(
            leading: GestureDetector(
              onTap: () {
                if (fromProfile != null) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => MainPage()),
                  );
                } else {
                  Get.back();
                }
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 30,
              ),
            ),
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
          body: Column(
            children: [
              const SearchBarWidget(),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    cekData(cari)
                        ? Expanded(
                            child: Row(
                              children: [
                                const Text(
                                  'Cari Komik :',
                                  style: TextStyle(color: Colors.white54),
                                ),
                                Expanded(
                                  child: Text(
                                    ' ${cari!}',
                                    maxLines: 1,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(),
                    cekData(genre)
                        ? Expanded(
                            child: Row(
                              children: [
                                const Text(
                                  'Pencarian Komik :',
                                  style: TextStyle(color: Colors.white54),
                                ),
                                Expanded(
                                  child: Text(
                                    ' ${genre!}',
                                    maxLines: 1,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(),
                    Expanded(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          'Halaman :',
                          style: TextStyle(color: Colors.white54),
                        ),
                        Text(
                          ' ${page.toString()}',
                          maxLines: 1,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    right: 10, left: 10, bottom: 5, top: 3),
                child: Row(children: [
                  tombolSebelumnya
                      ? TombolSebelumnya(
                          url: url,
                          page: page,
                          cari: cari,
                          genre: genre,
                        )
                      : const Expanded(child: Center()),
                  const SizedBox(width: 12),
                  tombolSelanjutnya
                      ? TombolSelanjutnya(
                          url: url,
                          page: page,
                          cari: cari,
                          genre: genre,
                        )
                      : const Expanded(child: Center())
                ]),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: dataKomik.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 10,
                            childAspectRatio:
                                ((MediaQuery.of(context).size.width / 2) / 320),
                          ),
                          itemBuilder: (context, index) {
                            return LihatKomikCard(
                                image: dataKomik[index]['image'],
                                title: dataKomik[index]['title'],
                                desc: dataKomik[index]['tgl_update'],
                                endPoint: dataKomik[index]['endpoint']);
                          },
                        ),
                      ),
                      const SizedBox(height: 20)
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class TombolSelanjutnya extends StatelessWidget {
  const TombolSelanjutnya(
      {super.key,
      required this.url,
      required this.page,
      this.cari,
      this.genre});

  final String url;
  final int page;
  final String? cari;
  final String? genre;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => LihatKomik(
                url: url,
                page: page + 1,
                cari: cari,
                genre: genre,
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: const Color(0xFF1789DF).withOpacity(0.2),
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Text(
              'Selanjutnya',
              style: TextStyle(color: Colors.white54),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class TombolSebelumnya extends StatelessWidget {
  const TombolSebelumnya(
      {super.key,
      required this.url,
      required this.page,
      this.cari,
      this.genre});

  final String url;
  final int page;
  final String? cari;
  final String? genre;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => LihatKomik(
                url: url,
                page: page - 1,
                cari: cari,
                genre: genre,
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: const Color(0xFF1789DF).withOpacity(0.2),
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Text(
              'Sebelumnya',
              style: TextStyle(color: Colors.white54),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
