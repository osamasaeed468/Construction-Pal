import 'package:digitalconstruction/app/constants/app_constants.dart';
import 'package:digitalconstruction/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';




class UserLoginController extends GetxController {
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();

  @override
  void onInit() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.onInit();
  }

  bool validateForm() {
    if (!GetUtils.isEmail(emailController.text)) {
      return false;
    }
    if (passwordController.text.isEmpty) {
      return false;
    }
    return true;
  }

  Future<void> login() async {
    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Get.back();
      Get.offNamed(Routes.UserMainScreen);
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      }
      Get.back();
      Get.snackbar(
        'Error',
        'Something Went Wrong',
        colorText: kPinkColor,
      );
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
  }
}
