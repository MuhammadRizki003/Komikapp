// ignore_for_file: file_names
import 'dart:convert';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:komikapp/api_link.dart' as globals;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:komikapp/pages/lihat_komik.dart';

// ignore: must_be_immutable
class GenrePage extends StatelessWidget {
  GenrePage({super.key});
  List data = [];
  Future getAllKategori() async {
    try {
      if (data.isEmpty) {
        var response = await http.get(
          Uri.parse(globals.genreLink),
        );
        List x = (json.decode(response.body) as Map<String, dynamic>)["result"];
        for (var element in x) {
          data.add(element);
        }
      }
      // print(allKategori);
    } catch (e) {
      print("Terjadi Kesalahan");
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 10;
    final double itemWidth = size.width / 2;
    return FutureBuilder(
        future: getAllKategori(),
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
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 15,
                    ),
                    child: Center(
                      child: Text(
                        'Genre List',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: data.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 10,
                          childAspectRatio: (itemWidth / itemHeight),
                        ),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => LihatKomik(
                                      url:
                                          '${globals.byGenreUrl}${data[index]}',
                                      page: 1,
                                      genre: '${data[index]}'
                                          .replaceAll('-', ' ')),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color(0xFF292B37),
                              ),
                              child: Center(
                                child: Text(
                                  '${data[index]}'.replaceAll('-', ' '),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        });
  }
}
