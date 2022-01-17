import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WagerHomeController extends GetxController {
  bool isLoggedin = false;
  List<Map<String, dynamic>> construct = [];

  @override
  Future<void> onInit() async {
    if (await FirebaseAuth.instance.currentUser != null) {
      isLoggedin = true;
    } else {
      isLoggedin = false;
    }
    update();
    super.onInit();
  }

  Future<void> signout() async {
    Get.dialog(
      Center(
        child: CircularProgressIndicator(),
      ),
    );
    await FirebaseAuth.instance.signOut();
    isLoggedin = false;
    Get.back();
    update();
  }

  List<Map<String, dynamic>> get constructors {
    return construct
        .where((element) => element['category'] == 'Constructors')
        .toList();
  }

  List<Map<String, dynamic>> get dailyWagers {
    return construct
        .where((element) => element['category'] == 'Daily Wagers')
        .toList();
  }

  @override
  void onClose() {}
}
