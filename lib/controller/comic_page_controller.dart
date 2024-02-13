import 'package:get/get.dart';

class ComicController extends GetxController {
  RxBool isFav = false.obs;
  isFavYes() {
    isFav(isFav.value = true);
  }

  isFavNo() {
    isFav(isFav.value = false);
  }
}
