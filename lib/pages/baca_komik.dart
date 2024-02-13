import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:komikapp/api_link.dart' as globals;
import 'package:animated_text_kit/animated_text_kit.dart';

// ignore: must_be_immutable
class BacaKomik extends StatelessWidget {
  BacaKomik(
      {super.key,
      required this.endpoint,
      required this.indexChapter,
      required this.lengthChapter,
      required this.endpointChapterList});
  final String endpoint;
  final int indexChapter;
  final int lengthChapter;
  final String endpointChapterList;
  bool tombolSebelumnya = false;
  bool tombolSelanjutnya = false;
  List chapterDetail = [];
  List chapterList = [];
  String title = '';
  List<String> chapters = [];
  String selectedChapter = '';
  Future comicInfoPage() async {
    try {
      var responseRec =
          await http.get(Uri.parse('${globals.bacaKomik}$endpoint'));
      chapterDetail = (json.decode(responseRec.body)
          as Map<String, dynamic>)["result"]['image'];
      var responseChap =
          await http.get(Uri.parse('${globals.komikInfo}$endpointChapterList'));
      chapterList = (json.decode(responseChap.body)
          as Map<String, dynamic>)["result"]['chapter-list'];
      title = (json.decode(responseChap.body) as Map<String, dynamic>)["result"]
          ['title'];

      if (indexChapter + 1 == chapterList.length) {
        tombolSebelumnya = false;
      } else {
        tombolSebelumnya = true;
      }
      if (indexChapter == 0) {
        tombolSelanjutnya = false;
      } else {
        tombolSelanjutnya = true;
      }
    } catch (e) {
      print("Terjadi Kesalahan");
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return Scaffold(
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          scrollController.animateTo(scrollController.position.minScrollExtent,
              duration: const Duration(milliseconds: 500),
              curve: Curves.fastEaseInToSlowEaseOut);
        },
        backgroundColor: const Color(0xFF1789DF).withOpacity(0.7),
        child: const Icon(Icons.arrow_upward_rounded),
      ),
      body: FutureBuilder(
        future: comicInfoPage(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Stack(
              children: [
                Center(
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
                Padding(
                  padding: const EdgeInsets.only(top: 48, left: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white70,
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
          } else {
            return Stack(
              children: [
                SingleChildScrollView(
                  controller: scrollController,
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
                                'KomikApp › $title ${chapterList[indexChapter]["Name"]} Bahasa Indonesia ',
                                style: const TextStyle(color: Colors.white54),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: <TextSpan>[
                                  const TextSpan(
                                    text: 'Baca manga ',
                                    style: TextStyle(
                                        color: Colors.white54, fontSize: 10),
                                  ),
                                  TextSpan(
                                    text: '$title Bahasa Indonesia ',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white70,
                                        fontSize: 10),
                                  ),
                                  const TextSpan(
                                    text: 'terbaru hanya di ',
                                    style: TextStyle(
                                        color: Colors.white54, fontSize: 10),
                                  ),
                                  const TextSpan(
                                    text: 'KomikApp',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white70,
                                        fontSize: 10),
                                  ),
                                  const TextSpan(
                                    text: '. Manga ',
                                    style: TextStyle(
                                        color: Colors.white54, fontSize: 10),
                                  ),
                                  TextSpan(
                                    text: '$title Bahasa Indonesia ',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white70,
                                        fontSize: 10),
                                  ),
                                  const TextSpan(
                                    text: 'selalu update di ',
                                    style: TextStyle(
                                        color: Colors.white54, fontSize: 10),
                                  ),
                                  const TextSpan(
                                    text: 'KomikApp',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white70,
                                        fontSize: 10),
                                  ),
                                  const TextSpan(
                                    text:
                                        '.  Jangan lupa membaca update komik lainnya ya. Cari Semua koleksi komik terlengkap hanya di ',
                                    style: TextStyle(
                                        color: Colors.white54, fontSize: 10),
                                  ),
                                  const TextSpan(
                                    text: 'KomikApp',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white70,
                                        fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Row(
                            children: [
                              tombolSebelumnya
                                  ? ChapterSebelumnya(
                                      chapterList: chapterList,
                                      indexChapter: indexChapter,
                                      endpointChapterList: endpointChapterList)
                                  : Expanded(child: Container()),
                              const SizedBox(width: 5),
                              ChapterListButton(
                                  chapterList: chapterList,
                                  endpointChapterList: endpointChapterList),
                              const SizedBox(width: 5),
                              tombolSelanjutnya
                                  ? ChapterSelanjutnya(
                                      chapterList: chapterList,
                                      indexChapter: indexChapter,
                                      endpointChapterList: endpointChapterList)
                                  : Expanded(child: Container())
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            for (var i = 0; i < chapterDetail.length; i++)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: Image.network(
                                  chapterDetail[i],
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    } else {
                                      return globals.loadingImage;
                                    }
                                  },
                                ),
                              )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 5),
                          child: Row(
                            children: [
                              tombolSebelumnya
                                  ? ChapterSebelumnya(
                                      chapterList: chapterList,
                                      indexChapter: indexChapter,
                                      endpointChapterList: endpointChapterList)
                                  : Expanded(child: Container()),
                              const SizedBox(width: 5),
                              ChapterListButton(
                                  chapterList: chapterList,
                                  endpointChapterList: endpointChapterList),
                              const SizedBox(width: 5),
                              tombolSelanjutnya
                                  ? ChapterSelanjutnya(
                                      chapterList: chapterList,
                                      indexChapter: indexChapter,
                                      endpointChapterList: endpointChapterList)
                                  : Expanded(child: Container())
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                          ),
                          child: Container(
                            color: Colors.transparent,
                            width: double.maxFinite,
                            child: Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  'Baca komik $title hanya di KomikApp',
                                  style: const TextStyle(
                                      color: Colors.white54,
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                          ),
                          child: Container(
                            color: Colors.transparent,
                            width: double.maxFinite,
                            child: const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  'All right reserved \u00a9 Copyright 2023, KomikApp',
                                  style: TextStyle(
                                      color: Colors.white54,
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15)
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 48, left: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white70,
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

class ChapterListButton extends StatelessWidget {
  const ChapterListButton({
    super.key,
    required this.chapterList,
    required this.endpointChapterList,
  });

  final List chapterList;
  final String endpointChapterList;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            const Color(0xFF1789DF).withOpacity(0.7),
          ),
        ),
        child: const Text(
          'Chapter ▼',
          style: TextStyle(
            color: Color(0xFF0F111D),
          ),
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                backgroundColor: const Color(0xFF292B37).withOpacity(0.8),
                child: Stack(
                  children: [
                    SizedBox(
                      height: 500,
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Text(
                              'Daftar Chapter',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: SingleChildScrollView(
                                child: Column(children: [
                                  for (var i = 0; i < chapterList.length; i++)
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) => BacaKomik(
                                              endpoint: chapterList[i]
                                                  ['Endpoint'],
                                              indexChapter: i,
                                              lengthChapter: chapterList.length,
                                              endpointChapterList:
                                                  endpointChapterList,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 10),
                                          child: Text(
                                            chapterList[i]['Name'],
                                            style: const TextStyle(
                                                color: Colors.white70,
                                                fontSize: 18),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  const SizedBox(height: 5)
                                ]),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Icon(Icons.close_rounded,
                                color: Colors.white70),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ChapterSelanjutnya extends StatelessWidget {
  const ChapterSelanjutnya({
    super.key,
    required this.chapterList,
    required this.indexChapter,
    required this.endpointChapterList,
  });

  final List chapterList;
  final int indexChapter;
  final String endpointChapterList;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => BacaKomik(
                endpoint: chapterList[indexChapter - 1]['Endpoint'],
                indexChapter: indexChapter - 1,
                lengthChapter: chapterList.length,
                endpointChapterList: endpointChapterList,
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border:
                  Border.all(color: const Color(0xFF1789DF).withOpacity(0.2))),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Text(
              'Next ▷',
              style:
                  TextStyle(color: Colors.white54, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class ChapterSebelumnya extends StatelessWidget {
  const ChapterSebelumnya({
    super.key,
    required this.chapterList,
    required this.indexChapter,
    required this.endpointChapterList,
  });

  final List chapterList;
  final int indexChapter;
  final String endpointChapterList;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => BacaKomik(
                endpoint: chapterList[indexChapter + 1]['Endpoint'],
                indexChapter: indexChapter + 1,
                lengthChapter: chapterList.length,
                endpointChapterList: endpointChapterList,
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
              '◁ Prev',
              style:
                  TextStyle(color: Colors.white54, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
