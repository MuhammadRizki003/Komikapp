import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

Future<dynamic> loadingAnimation(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: const Color(0xFF292B37),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                            'Loading_',
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
              ),
            ),
          ],
        ),
      );
    },
    barrierDismissible: false,
  );
}
