import 'package:get/get.dart';

import 'WagerHomeController.dart';

class WagerHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WagerHomeController>(
      () => WagerHomeController(),
      fenix: true,
    );
  }
}
