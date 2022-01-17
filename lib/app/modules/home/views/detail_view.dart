import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class DetailView extends GetView<HomeController> {
  String id = Get.arguments;

  @override
  Widget build(BuildContext context) {
    final height = Get.height;
    Map<String, dynamic> item =
        controller.construct.where((element) => element['id'] == id).first;
    return Scaffold(
        appBar: AppBar(
          title: Text(item['name']),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            Image(
              image: NetworkImage(
                item['bookUrl'],
              ),
              fit: BoxFit.fill,
              width: double.infinity,
              height: height * .3,
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              title: Text('Author: ${item['author']}'),
              subtitle: Text('Categorys: ${item['category']}'),
            ),
            ListTile(
              title: Text('Sales Price: ${item['salesPrice']}'),
              subtitle: Text('Rent Price: ${item['rentPrice']}'),
            ),
            ListTile(
              title: Text('Language: ${item['language']}'),
              subtitle: Text('Publisher: ${item['publisher']}'),
              trailing: Text('Edition: ${item['edition']}'),
            ),
            ListTile(
              title: Text('Available for: ${item['available']}'),
            ),
            ListTile(
              title: Text('Owner Name: ${item['ownerName']}'),
              subtitle: Text('Owner Email: ${item['ownerEmail']}'),
            ),
          ],
        ));
  }
}
