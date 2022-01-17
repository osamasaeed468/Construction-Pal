// ignore_for_file: prefer_final_fields, invalid_return_type_for_catch_error

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ShopDetails {
  ShopDetails({
    required this.shopName,
    required this.shopOwnerName,
    required this.shopOwnerPhoneNo,
    required this.shopImage,
    required this.shopOwnerEmailName,
    required this.shopOwnerPassword,
    this.isShopApproved = false,
  });

  late bool isShopApproved;
  late String shopImage;
  late String shopName;
  late String shopOwnerEmailName;
  late String shopOwnerName;
  late String shopOwnerPassword;
  late int shopOwnerPhoneNo;
}

class Shops with ChangeNotifier {
  List<ShopDetails> _shops = [];

  List<ShopDetails> get shops {
    return [..._shops];
  }

  Future<String> addShop(
    String shopName,
    String shopOwnerName,
    int shopOwnerPhoneNo,
    String shopOwnerEmailName,
    String shopOwnerPassword,
    String shopImage,
  ) async {
    CollectionReference shops = FirebaseFirestore.instance.collection('Shops');
    late final String dID;
    await shops.add({
      'shopOwnerEmailName': shopOwnerEmailName,
      'shopOwnerPassword': shopOwnerPassword,
      'shopName': shopName,
      'shopOwnerName': shopOwnerName,
      'shopOwnerPhoneNo': shopOwnerPhoneNo,
      'shopImage': shopImage,
      'isShopApproved': false,
    }).then((value) {
      dID = value.id;
      shops.doc(dID).update({
        'shopOwnerUid': value.id,
      });

      print("Shop Added");
    }).catchError((error) => print("Failed to add Shop: $error"));

    return dID;
  }
}
