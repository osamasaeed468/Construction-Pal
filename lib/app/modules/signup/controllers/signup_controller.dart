import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/app_constants.dart';
import '../../../routes/app_pages.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignupController extends GetxController {
  TextEditingController firstNameController= TextEditingController();
  TextEditingController lastNameController= TextEditingController();
  TextEditingController emailController= TextEditingController();
  TextEditingController passwordController= TextEditingController();
  TextEditingController confirmPasswordController= TextEditingController();
  TextEditingController cnicController= TextEditingController();
  TextEditingController addressController= TextEditingController();
  TextEditingController phoneController= TextEditingController();

  @override
  void onInit() {
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    cnicController = TextEditingController();
    addressController = TextEditingController();
    phoneController = TextEditingController();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  String validateForm() {
    String msg="";
    if (firstNameController.text.isEmpty || lastNameController.text.isEmpty) {
      msg="Please Enter full Name";
      return msg;
    }
    if (!GetUtils.isEmail(emailController.text)) {
      msg="Please Enter email";
      return msg;
    }
    if (confirmPasswordController.text != passwordController.text) {
      msg="Please Enter full same password";
      return msg;
    }
    if(phoneController.text.length!=11){
      msg="Please Enter valid number";
      return msg;

    }
    if(phoneController.text.startsWith('1') || phoneController.text.startsWith('2') || phoneController.text.startsWith('3')
    || phoneController.text.startsWith('4') || phoneController.text.startsWith('5') || phoneController.text.startsWith('6')
    || phoneController.text.startsWith('7') || phoneController.text.startsWith('8') || phoneController.text.startsWith('9')
    ){
      msg="Please Enter valid number";
      return msg;
    }
    return "True";
  }

  Future<void> signup() async {

    try {
      UserCredential? userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      ) .then((signedInUser) {
            FirebaseFirestore.instance
                .collection('users')
                .doc(signedInUser.user!.uid)
                .set({
              'email': emailController.text,
              'first_name': firstNameController.text,
              'last_name': lastNameController.text,
              'address':addressController.text,
              'cnic':cnicController.text,
              'phone':phoneController.text,
              'uid': signedInUser.user!.uid,
            }).then((value) {
              if (signedInUser != null) {
                print("suceess");
                Get.snackbar(
                  'Added',
                  'Successfully',
                  colorText: kPinkColor,
                );
              }
            }).catchError((e) {
              print(e);
            });
          }).catchError((e) {
            print(e);
          });
      await FirebaseAuth.instance.currentUser?.updateProfile(
        displayName: firstNameController.text + ' ' + lastNameController.text,
      );
      Get.back();
    } on FirebaseAuthException catch (e) {
      String message="";
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      }
      Get.back();
      Get.snackbar(
        'Error',
        message,
        colorText: kPinkColor,
      );
    } catch (e) {
      Get.back();
      Get.snackbar(
        'Error Occurred',
        'Something went wrong. Try again',
        colorText: kPinkColor,
      );
    }
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    cnicController.dispose();
    addressController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }
}
