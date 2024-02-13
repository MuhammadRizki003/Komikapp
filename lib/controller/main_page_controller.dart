import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class MainPageController extends GetxController {
  RxInt indexNow = 1.obs;
  indexChangeFunc(i) {
    indexNow(indexNow.value = i);
  }

  RxBool iNet = true.obs;
  iNetFalseFunc() {
    iNet(iNet.value = false);
  }

  iNetTrueFunc() {
    iNet(iNet.value = true);
  }

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  ConnectivityResult get connectionStatus => _connectionStatus;
  @override
  void onInit() {
    super.onInit();
    initConnectivity();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await Connectivity().checkConnectivity();
    } catch (e) {
      // developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    _updateConnectionStatus(result);

    Connectivity().onConnectivityChanged.listen((result) {
      _updateConnectionStatus(result);
    });
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    _connectionStatus = result;
    if (_connectionStatus != ConnectivityResult.none) {
      iNetTrueFunc();
    } else {
      iNetFalseFunc();
    }
  }
}
