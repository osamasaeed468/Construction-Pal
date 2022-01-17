import 'package:flutter/material.dart';

class DropDown extends StatefulWidget {
  @override
  _DropDownState createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  String dropdownValue = 'All';
  final kDropdownItemsStyle = const TextStyle(fontSize: 18, color: Colors.black);
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: dropdownValue,
      onChanged: (String? value) {
        setState(() {
          dropdownValue = value!;
        });
      },
      style: kDropdownItemsStyle,
      isExpanded: true,
      items:
      ['All', '3KM', '5KM', '10KM']
          .map((e) => DropdownMenuItem(
        child: Text(e),
        value: e,
      ))
          .toList(),
      underline: Container(
        height: 3,
        color: Colors.teal,
      ),
    );
  }
}