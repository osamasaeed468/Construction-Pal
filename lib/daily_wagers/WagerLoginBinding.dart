import 'package:get/get.dart';

import 'WagerLoginController.dart';

class WagerLoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WagerLoginController>(
      () => WagerLoginController(),
    );
  }
}
