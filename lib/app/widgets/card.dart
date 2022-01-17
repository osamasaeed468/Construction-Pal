import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  CustomCard({this.children});

  final children;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      margin: const EdgeInsets.only(top: 4.0,bottom: 4,left: 20,right: 20),

      child: Padding(
        padding:const EdgeInsets.only(top: 4.0,bottom: 4,left: 15,right: 15),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}