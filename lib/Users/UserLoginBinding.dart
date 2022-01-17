import 'package:get/get.dart';

import 'UserLoginController.dart';

class UserLoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserLoginController>(
          () => UserLoginController(),
    );
  }
}
