library globals;

import 'package:flutter/material.dart';

bool iNet = false;
int? idUser;

String ip = "http://192.168.1.101";
String baseUrlOffline = "$ip/komikapp";
String baseUrlOnline = 'https://komikapp-api.000webhostapp.com';
String baseUrl = baseUrlOnline;
String homeUrl = '$baseUrl/api/home';
String komikInfo = '$baseUrl/api/komik-info/?endpoint=';
String bacaKomik = '$baseUrl/api/baca?endpoint=';
String populerUrl = '$baseUrl/api/populer?page=';
String cariUrl = '$baseUrl/api/cari?search=';
String addFav = '$baseUrl/KomikFav/komikfav';
String delFav = '$baseUrl/KomikFav/komikfavdelete';
String regisLink = '$baseUrl/User/tambahuser';
String loginLink = '$baseUrl/User/login';
String gantiNamaLink = '$baseUrl/User/gantinama';
String gantiEmailLink = '$baseUrl/User/gantiemail';
String gantiPasswordLink = '$baseUrl/User/gantipassword';
String gantiAvatarLink = '$baseUrl/User/gantiavatar';
String komikFavHome = '$baseUrl/KomikFav/komikfavhome';
String komikFav = '$baseUrl/KomikFav/komikfav?idUser=$idUser&page=';
String cekFav = '$baseUrl/KomikFav/isFav?idUser=$idUser&judul=';
String byGenreUrl = '$baseUrl/api/genre?endpoint=';
String genreLink = '$baseUrl/api/list-genre';
Image noImage = Image.asset(
  'assets/thumbnail/no-image.jpg',
  height: 200,
  width: double.maxFinite,
  fit: BoxFit.cover,
);
Image loadingImage = Image.asset(
  'assets/thumbnail/loading.jpg',
  fit: BoxFit.cover,
);
