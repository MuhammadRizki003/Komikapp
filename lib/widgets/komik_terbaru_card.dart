import 'package:flutter/material.dart';
import 'package:komikapp/api_link.dart' as globals;
import 'package:komikapp/pages/comic_info.dart';

class KomikTerbaruCard extends StatelessWidget {
  const KomikTerbaruCard(
      {super.key,
      required this.image,
      required this.title,
      required this.desc,
      required this.endPoint});
  final String image;
  final String title;
  final String desc;
  final String endPoint;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ComicInfo(
              title: title,
              tglUpdate: desc,
              endPoint: endPoint,
            ),
          ),
        );
      },
      child: Container(
        width: (MediaQuery.of(context).size.width / 2) - 7,
        // height: 300,
        decoration: BoxDecoration(
          color: const Color(0xFF292B37),
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
                color: const Color(0xFF292B37).withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 6),
          ],
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: SizedBox(
                        height: 60,
                        width: 60,
                        child: Opacity(
                          opacity: 0.5,
                          child: Image.asset(
                            'assets/logoApp/new.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                  child: Stack(
                    children: [
                      Image.network(
                        image,
                        height: 200,
                        width: (MediaQuery.of(context).size.width / 2) - 7,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            globals.noImage,
                      ),
                      Image.asset(
                        'assets/logoApp/update.png',
                        height: 65,
                        width: 65,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Text(
                          '$title\n',
                          maxLines: 2,
                          style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Text(
                          desc,
                          style: const TextStyle(color: Colors.white54),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
