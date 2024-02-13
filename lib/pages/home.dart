import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:komikapp/pages/comic_info.dart';
import 'package:komikapp/widgets/bagan_homepage.dart';
import 'package:komikapp/widgets/comic_card.dart';
import 'package:komikapp/widgets/empty_card.dart';
import 'package:komikapp/widgets/komik_terbaru_card.dart';
import 'package:komikapp/widgets/komik_terbaru_card_empty.dart';
import 'package:komikapp/widgets/search_bar.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:komikapp/api_link.dart' as globals;

// ignore: must_be_immutable
class Home extends StatelessWidget {
  Home({super.key});
  List empty = ['', '', ''];
  List recommendedComic = [];
  List populerComic = [];
  List newComic = [];
  Future homePage() async {
    try {
      if (recommendedComic.isEmpty ||
          populerComic.isEmpty ||
          newComic.isEmpty) {
        var response = await http.get(Uri.parse(globals.homeUrl));
        List dataRec =
            (json.decode(response.body) as Map<String, dynamic>)["recomended"];
        List dataPop =
            (json.decode(response.body) as Map<String, dynamic>)["populer"];
        List dataNew =
            (json.decode(response.body) as Map<String, dynamic>)["terbaru"];
        for (var element in dataRec) {
          recommendedComic.add(element);
        }
        for (var element in dataPop) {
          populerComic.add(element);
        }
        for (var element in dataNew) {
          newComic.add(element);
        }
      }
    } catch (e) {
      print("Terjadi Kesalahan");
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SearchBarWidget(),
        const SizedBox(height: 10),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: FutureBuilder(
              future: homePage(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                    children: [
                      const SizedBox(height: 10),
                      CarouselSlider(
                        options: CarouselOptions(
                          height: 180,
                          enlargeCenterPage: true,
                          enlargeStrategy: CenterPageEnlargeStrategy.height,
                        ),
                        items: empty.map(
                          (i) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 180,
                                  margin: const EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF292B37),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          color: const Color(0xFF292B37)
                                              .withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 6),
                                    ],
                                  ),
                                  child: const Stack(
                                    alignment: Alignment.bottomRight,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                        child: SizedBox(),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ).toList(),
                      ),
                      BaganHomePage(
                        namaBagan: 'Komik Terpopuler',
                        url: globals.populerUrl,
                        page: 1,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (int i = 0; i < 3; i++) const EmptyCard()
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Komik',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(width: 10),
                          Container(
                            decoration: BoxDecoration(
                                color: const Color(0xFF1789DF).withOpacity(0.7),
                                borderRadius: BorderRadius.circular(5)),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              child: Text(
                                'Update',
                                style: TextStyle(
                                    color: Color(0xFF0F111D),
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: 10,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 15,
                                  crossAxisSpacing: 10,
                                  childAspectRatio:
                                      ((MediaQuery.of(context).size.width / 2) /
                                          320),
                                ),
                                itemBuilder: (context, index) {
                                  return const KomikTerbaruCardEmpty();
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      const SizedBox(height: 10),
                      CarouselSlider(
                        options: CarouselOptions(
                          height: 180,
                          enlargeCenterPage: true,
                          enlargeStrategy: CenterPageEnlargeStrategy.height,
                        ),
                        items: recommendedComic.map((i) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ComicInfo(
                                    title: i['title'],
                                    tglUpdate: i['tgl_update'],
                                    endPoint: i['endpoint'],
                                  ),
                                ),
                              );
                            },
                            child: Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 180,
                                  margin: const EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF292B37),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          color: const Color(0xFF292B37)
                                              .withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 6),
                                    ],
                                  ),
                                  child: Stack(
                                    alignment: Alignment.bottomRight,
                                    children: [
                                      ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          ),
                                          child: (i['image'] != null)
                                              ? Image.network(
                                                  i['image'],
                                                  height: 180,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  fit: BoxFit.cover,
                                                )
                                              : globals.noImage),
                                      Container(
                                        decoration: const BoxDecoration(
                                            color: Colors.black26),
                                        child: Center(
                                          child: Text(
                                            i['title'],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        }).toList(),
                      ),
                      BaganHomePage(
                          namaBagan: 'Komik Terpopuler',
                          url: globals.populerUrl,
                          page: 1,
                          genre: 'Terpopuler'),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (int i = 0; i < populerComic.length; i++)
                              KomikCard(
                                image: populerComic[i]['image'],
                                title: populerComic[i]['title'],
                                desc: populerComic[i]['tgl_update'],
                                endPoint: populerComic[i]['endpoint'],
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Komik',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(width: 10),
                          Container(
                            decoration: BoxDecoration(
                                color: const Color(0xFF1789DF).withOpacity(0.7),
                                borderRadius: BorderRadius.circular(5)),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              child: Text(
                                'Update',
                                style: TextStyle(
                                    color: Color(0xFF0F111D),
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: newComic.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 15,
                                  crossAxisSpacing: 10,
                                  childAspectRatio:
                                      ((MediaQuery.of(context).size.width / 2) /
                                          320),
                                ),
                                itemBuilder: (context, index) {
                                  return KomikTerbaruCard(
                                      image: newComic[index]['image'],
                                      title: newComic[index]['title'],
                                      desc: newComic[index]['tgl_update'],
                                      endPoint: newComic[index]['endpoint']);
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                }
              },
            ),
          ),
        )
      ],
    );
  }
}
