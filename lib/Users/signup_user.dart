
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalconstruction/app/constants/app_constants.dart';
import 'package:digitalconstruction/app/routes/app_pages.dart';
import 'package:digitalconstruction/app/widgets/custom_button.dart';
import 'package:digitalconstruction/app/widgets/custom_text_field.dart';
import 'package:digitalconstruction/app/widgets/responsive_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';


class SignupUser extends StatelessWidget {
  TextEditingController fnameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController conPassController = TextEditingController();
  String name="", email="", password="", conPass="", lname="";

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return ResponsiveLayout(
      mobileBody: Scaffold(
        appBar: AppBar(
          backgroundColor: kPinkColor,
          title: Text('Signup As Customer'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: height * 0.1,
                ),
                FaIcon(
                  FontAwesomeIcons.userAlt,
                  size: width * 0.15,
                  color: kPinkColor,
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                AutoSizeText(
                  'Signup',
                  maxLines: 1,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                CustomTextField(
                  label: 'First Name',
                  keyboardType: TextInputType.name,
                  controller: fnameController,
                ),
                CustomTextField(
                  label: 'Last Name',
                  keyboardType: TextInputType.name,
                  controller: lNameController,
                ),
                CustomTextField(
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                ),
                CustomTextField(
                  label: 'Password',
                  isPassword: true,
                  keyboardType: TextInputType.visiblePassword,
                  controller: passController,
                ),
                CustomTextField(
                  label: 'Confirm Password',
                  isPassword: true,
                  keyboardType: TextInputType.visiblePassword,
                  controller: conPassController,
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                CustomButton(
                  width: width * 0.3,
                  height: height * 0.05,
                  text: 'Signup',
                  onPressed: () async {
                    Get.dialog(
                      Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                    if (passController.text != conPassController.text) {
                      Get.back();

                      Get.snackbar(
                        'Error',
                        'Please Fill the Form First',
                        colorText: kPinkColor,
                      );
                    } else {
                      signUp();
                    }
                  },
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                GestureDetector(
                  onTap: () {
                    Get.offNamed(Routes.userLogin);
                  },
                  child: AutoSizeText(
                    'Login Instead',
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future signUp() async {
    email = emailController.text;
    password = passController.text;

    name = fnameController.text;
    lname = lNameController.text;

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: "barry.allen@example.com",
          password: "SuperSecretPassword!"
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    // final User user = await _auth.createUserWithEmailAndPassword(email: email, password: password)
    //     .then((signedInUser) {
    //   FirebaseFirestore.instance
    //       .collection('users')
    //       .doc(signedInUser.user!.uid)
    //       .set({
    //     'email': email,
    //     'first_name': name,
    //     'last_name': lname,
    //     'uid': signedInUser.user!.uid,
    //   }).then((value) {
    //     if (signedInUser != null) {
    //       print("suceess");
    //
    //       Get.offNamed(Routes.userLogin);
    //     }
    //   }).catchError((e) {
    //     print(e);
    //   });
    // }).catchError((e) {
    //   print(e);
    // });


    // if (user != null) {
    //   setState(() {
    //     _success = true;
    //     _userEmail = user.email;
    //   });keytool -list -v \ > -alias androidebugkey -keystore ~/.android\debug.keystore
    // } else {
    //   setState(() {
    //     _success = true;
    //   });
    // }
  }
}
