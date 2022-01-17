import 'package:digitalconstruction/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ForgotScreen();
  }
}

class _ForgotScreen extends State<ForgotScreen> {
  String email = "";
  var _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
          title: Row(
        children: <Widget>[
          IconButton(
            //padding: const EdgeInsets.only(left: 200),
            icon: Icon(Icons.arrow_back),
            color: Colors.white,

            onPressed: () {
              Get.offNamed(Routes.LOGIN);
            },
          ),
          SizedBox(
            width: 10,
          ),
          Text('Forget Password'),
        ],
      )),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(top: 50, left: 20, right: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text(
                  'Recovery Account',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  textAlign: TextAlign.right,
                ),
                Theme(
                  data: ThemeData(),
                  child: Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter your email";
                        } else {
                          email = value;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Please enter your email",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                BorderSide(color: Colors.white, width: 1)),
                        disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                BorderSide(color: Colors.white, width: 1)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                BorderSide(color: Colors.white, width: 1)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                BorderSide(color: Colors.white, width: 1)),
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: RaisedButton(
                      color: Colors.blue,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          FirebaseAuth.instance
                              .sendPasswordResetEmail(email: email);
                          Get.offNamed(Routes.LOGIN);
                          Get.snackbar(
                            'Check your email',
                            'Reset Password link sent successfully',
                            //fontWeight: FontWeight.bold,
                            colorText: Colors.white,
                            backgroundColor: Colors.black,
                          );
                        }
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        "Send",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            backgroundColor: Colors.blue,
                            fontSize: 20),
                      ),
                      padding: EdgeInsets.all(10),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
