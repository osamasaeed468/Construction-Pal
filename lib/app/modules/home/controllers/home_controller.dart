import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
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

  @override
  void onReady() {
    FirebaseFirestore.instance
        .collection('Books')
        .where('isApproved', isEqualTo: true)
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                construct.add({
                  'id': doc.id,
                  'bookUrl': doc['bookUrl'],
                  'category': doc['category'],
                  'language': doc['language'],
                  'name': doc['name'],
                  'author': doc['author'],
                  'edition': doc['edition'],
                  'publisher': doc['publisher'],
                  'available': doc['available'],
                  'rentPrice': doc['rentPrice'],
                  'salesPrice': doc['salesPrice'],
                  'isApproved': doc['isApproved'],
                  'ownerName': doc['ownerName'],
                  'ownerUid': doc['ownerUid'],
                  'ownerEmail': doc['ownerEmail'],
                });
              }),
            })
        .then((value) => {
              update(),
            });
    super.onReady();
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
