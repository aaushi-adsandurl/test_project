import 'package:get/get.dart';
import 'package:test_for_soft_prodigy/api/api_provider.dart';

class HomeController extends GetxController with StateMixin<dynamic> {
  @override
  void onInit() {
    super.onInit();
    Provider().getUser().then((value) {
      change(value, status: RxStatus.success());
    }, onError: (error) {
      change(null, status: RxStatus.error(error.toString()));
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
