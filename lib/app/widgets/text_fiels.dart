import 'package:flutter/material.dart';

Widget myTextFieldWidget(
    BuildContext context,
    String myHintText,
    double myTextFieldWidth,
    double myTextFieldHeight,
    bool isPassword,
    TextInputType keyboardType,
    TextEditingController textFieldController,
    ) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Container(
      width: MediaQuery.of(context).size.width * myTextFieldWidth,
      height: MediaQuery.of(context).size.height * myTextFieldHeight,
      decoration: const ShapeDecoration(
        color: Colors.grey,
        shape: StadiumBorder(),
      ),
      child: TextField(
        controller: textFieldController,
        decoration: InputDecoration(

          labelText: myHintText,
          hintStyle: const TextStyle(color: Colors.black),
          // labelText: 'First Name',
          // labelStyle: TextStyle(color: Colors.black12),
          fillColor: const Color(0xffF7F9F9),
          filled: true,
          // iska effect screen pr tab show hoga jb hum text field ko click nahi karey gy
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 2),
            borderRadius: BorderRadius.circular(30),
          ),
          // jb hum text field ko click karey gy tab focusedBorder effect hoga
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 2),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        keyboardType: keyboardType,
      ),
    ),
  );
}

Widget myTextFieldForDateAndTime(
    BuildContext context,
    double myTextFieldWidthForDateAndTime,
    double myTextFieldHeightForDateAndTime) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5),
    child: Container(
      width: MediaQuery.of(context).size.width * myTextFieldWidthForDateAndTime,
      height:
      MediaQuery.of(context).size.height * myTextFieldHeightForDateAndTime,
      // width: MediaQuery.of(context).size.width * 0.12,
      // height: MediaQuery.of(context).size.height * 0.04,
      child: TextField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          fillColor: Color(0xffF7F9F9),
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 0),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 0),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    ),
  );
}