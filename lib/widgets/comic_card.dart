import 'package:flutter/material.dart';
import 'package:komikapp/api_link.dart' as globals;
import 'package:komikapp/pages/comic_info.dart';

// ignore: must_be_immutable
class KomikCard extends StatelessWidget {
  KomikCard(
      {super.key,
      required this.image,
      required this.title,
      required this.desc,
      required this.endPoint,
      this.fromProfile});
  final String image;
  final String title;
  final String desc;
  final String endPoint;
  bool? fromProfile;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (fromProfile != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => ComicInfo(
                title: title,
                tglUpdate: desc,
                endPoint: endPoint,
                fromProfile: fromProfile,
              ),
            ),
          );
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ComicInfo(
                title: title,
                tglUpdate: desc,
                endPoint: endPoint,
              ),
            ),
          );
        }
      },
      child: Container(
        width: (MediaQuery.of(context).size.width / 2) - 17,
        // height: 300,
        margin: const EdgeInsets.only(left: 12),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
              ),
              child: Image.network(
                image,
                height: 200,
                width: (MediaQuery.of(context).size.width / 2) - 17,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => globals.noImage,
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
      ),
    );
  }
}
