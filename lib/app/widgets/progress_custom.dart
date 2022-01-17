import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  String message;

  ProgressBar({required this.message});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.blue,
      child: Container(
          margin: EdgeInsets.all(15.0),
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0), color: Colors.white),
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Row(
              children: [
                Text(
                  message,
                  style: TextStyle(color: Colors.black),
                )
              ],
            ),
          )),
    );
  }
}
