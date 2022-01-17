// ignore_for_file: prefer_const_constructors

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalconstruction/RegisterAsShopOwner.dart';
import 'package:digitalconstruction/Shop/shopHomePage.dart';
import 'package:digitalconstruction/app/constants/app_constants.dart';
import 'package:digitalconstruction/app/modules/login/views/ForgetPassword.dart';
import 'package:digitalconstruction/app/routes/app_pages.dart';
import 'package:digitalconstruction/app/widgets/custom_button.dart';
import 'package:digitalconstruction/app/widgets/custom_text_field.dart';
import 'package:digitalconstruction/app/widgets/responsive_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShopOwnerLogin extends StatefulWidget {
  static const routeName = '/shop-owner-login';

  @override
  State<ShopOwnerLogin> createState() => _ShopOwnerLoginState();
}

class _ShopOwnerLoginState extends State<ShopOwnerLogin> {
  final shopOnwerPasswordController = TextEditingController();
  final shopOwnerEmailController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  queryData() async {
    Get.closeAllSnackbars();
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection("Shops").get();

    snapshot.docs.forEach((document) {
      var email = document['shopOwnerEmailName'];
      var password = document['shopOwnerPassword'];

      if (shopOwnerEmailController.text == email &&
          shopOnwerPasswordController.text == password) {
        Get.closeAllSnackbars();

        Get.toNamed(ShopHomePage.routeName, arguments: {
          'shopOwnerEmail': shopOwnerEmailController.text,
          'shopOwnerPassword': shopOnwerPasswordController.text,
        });
        Get.closeAllSnackbars();
      } else {
        Get.snackbar(
          "Error",
          "Either Email or Password is incorrect",
          colorText: Colors.blue,
        );
        Get.closeAllSnackbars();
        return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return ResponsiveLayout(
      mobileBody: Scaffold(
         body: Container(
          decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/loginback.png"),
            fit: BoxFit.cover,
          ),
        ),
          child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: height * 0.1,
                ),
                Image(
                  image: AssetImage(klogo),
                  width: width * 0.25,
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                const AutoSizeText(
                  'Login as a Shop Owner',
                  maxLines: 1,
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'MetroPolis',
                    fontSize: 24,
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                CustomTextField(
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  controller: shopOwnerEmailController,
                ),
                CustomTextField(
                  label: 'Password',
                  isPassword: true,
                  keyboardType: TextInputType.visiblePassword,
                  controller: shopOnwerPasswordController,
                ),
                Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Container(
                      width: double.infinity,
                      child: InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ForgotScreen()));
                        },
                        child: Text(
                          "Forgot password ?",
                          style: TextStyle(color: Colors.blue),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    )),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                CustomButton(
                  width: width * 0.3,
                  height: height * 0.05,
                  text: 'Login',
                  onPressed: () async {
                    //
                    if (shopOwnerEmailController.text.isEmpty ||
                        shopOnwerPasswordController.text.isEmpty) {
                      Get.closeAllSnackbars();

                      Get.snackbar(
                        "Error",
                        "Provide valid the credentals",
                        colorText: Colors.blue,
                      );

                      return;
                    }
                    Get.closeAllSnackbars();

                    queryData();

                    Get.closeAllSnackbars();
                  },
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => RegisterAsShopOwner()));
                  },
                  child: AutoSizeText(
                    'Register as a Shop Owner',
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                GestureDetector(
                  onTap: () {
                    Get.offNamed(Routes.userLogin);
                  },
                  child: AutoSizeText(
                    'Login as a Customer',
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                GestureDetector(
                  onTap: () {
                    Get.offNamed(Routes.LOGIN);
                  },
                  child: AutoSizeText(
                    'Login as a constructor',
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
      ),
    );
  }
}
