import 'package:flutter/material.dart';

class ComicImage extends StatelessWidget {
  const ComicImage({
    super.key,
    required this.coverAnime,
    required this.itemHeight,
    required this.itemWidth,
  });

  final String coverAnime;
  final double itemHeight;
  final double itemWidth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                    color: const Color(0xFF292B37).withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 8)
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(
                coverAnime,
                height: itemHeight,
                width: itemWidth,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  'assets/thumbnail/no-image.jpg',
                  width: itemWidth,
                  height: itemHeight,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
