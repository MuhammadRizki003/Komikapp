// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:komikapp/pages/lihat_komik.dart';

class BaganHomePage extends StatelessWidget {
  BaganHomePage(
      {super.key,
      required this.namaBagan,
      required this.url,
      required this.page,
      this.genre,
      this.fromProfile});
  final String namaBagan;
  final String url;
  final int page;
  final String? genre;
  bool? fromProfile;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            namaBagan,
            style: const TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
          ),
          InkWell(
            onTap: () {
              if (fromProfile != null) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => LihatKomik(
                      url: url,
                      page: page,
                      genre: genre,
                      fromProfile: fromProfile,
                    ),
                  ),
                );
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => LihatKomik(
                      url: url,
                      page: page,
                      genre: genre,
                    ),
                  ),
                );
              }
            },
            child: const Text(
              "Lihat semua",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
