import 'package:flutter/material.dart';
import 'package:komikapp/api_link.dart' as globals;
import 'package:komikapp/pages/lihat_komik.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({
    super.key,
  });

  void clearSearch() {
    TextEditingController cariKomik = TextEditingController();
    cariKomik.clear();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController cariKomik = TextEditingController();
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 4),
      child: Container(
        height: 60,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF292B37),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.search,
              color: Colors.white54,
              size: 30,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 2),
                child: TextField(
                    controller: cariKomik,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (value) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => LihatKomik(
                            url: '${globals.cariUrl}${cariKomik.text}&page=',
                            page: 1,
                            cari: cariKomik.text,
                          ),
                        ),
                      );
                    },
                    style: const TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search",
                        hintStyle:
                            TextStyle(color: Colors.white, fontSize: 17))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
