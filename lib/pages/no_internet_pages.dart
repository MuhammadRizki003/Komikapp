import 'package:flutter/material.dart';

class NoInternetPages extends StatelessWidget {
  const NoInternetPages({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.wifi_off,
            size: 70,
            color: Colors.blueAccent.withOpacity(0.5),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'No Internet',
            style: TextStyle(
                color: Colors.blueAccent.withOpacity(0.5), fontSize: 25),
          ),
          const Text(
            'Perangkat tidak terhubung dengan internet!',
            style: TextStyle(color: Colors.white38, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
