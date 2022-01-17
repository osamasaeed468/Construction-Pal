import 'package:flutter/material.dart';

import '../constants/app_constants.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final bool isPassword;
  final TextInputType keyboardType;
  final TextEditingController controller;

  CustomTextField({
    required this.label,
    this.isPassword = false,
    required this.keyboardType,
    required this.controller,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 25.0,
      ),
      child: TextField(

        controller: widget.controller,
        decoration: InputDecoration(
          labelText: widget.label,
          filled: true,
          border: OutlineInputBorder(
          ),
          suffixIcon: (widget.isPassword)
              ? IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: kPinkColor,
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                )
              : null,
        ),
        keyboardType: widget.keyboardType,
        obscureText: (widget.isPassword) ? !_passwordVisible : false,
      ),
    );
  }
}
