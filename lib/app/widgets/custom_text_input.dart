import 'package:flutter/material.dart';



class CustomTextField extends StatefulWidget {
  final String label;
  final bool isPassword;
  final TextInputType keyboardType;
  final TextEditingController? controller;

  CustomTextField({
    required this.label,
    this.isPassword = false,
    required this.keyboardType, this.controller,

  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(12.0),
        child:
      Container(
      width: double.infinity,
      height: 50,
      decoration: const ShapeDecoration(
        color: Colors.grey,
        shape: StadiumBorder(),
      ),
      child: TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          label: Text(widget.label),
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(left: 10),
          // fillColor: Colors.white,
          // filled: true,
          // border: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(25.0),
          //   borderSide: BorderSide(
          //   ),

          //),
          //fillColor: Colors.green

          //border: InputBorder.none,
          suffixIcon: (widget.isPassword)
              ? IconButton(
            icon: Icon(
              _passwordVisible ? Icons.visibility : Icons.visibility_off,

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
      )
    );
  }
}
