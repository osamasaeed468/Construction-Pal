import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalconstruction/app/modules/signup/controllers/signup_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../constants/app_constants.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/responsive_widget.dart';


class SignupView extends GetView<SignupController> {
  final SignupController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return ResponsiveLayout(
      mobileBody: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: kPinkColor,
        //   title: Text('Login'),
        // ),
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
                  controller: controller.firstNameController,
                ),
                CustomTextField(
                  label: 'Last Name',
                  keyboardType: TextInputType.name,
                  controller: controller.lastNameController,
                ),
                CustomTextField(
                  label: 'CNIC',
                  keyboardType: TextInputType.emailAddress,
                  controller: controller.cnicController,
                ),
                CustomTextField(
                  label: 'Address',
                  keyboardType: TextInputType.emailAddress,
                  controller: controller.addressController,
                ),
                CustomTextField(
                  label: 'Contact Number',
                  keyboardType: TextInputType.emailAddress,
                  controller: controller.phoneController,
                ),
                CustomTextField(
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  controller: controller.emailController,
                ),
                CustomTextField(
                  label: 'Password',
                  isPassword: true,
                  keyboardType: TextInputType.visiblePassword,
                  controller: controller.passwordController,
                ),
                CustomTextField(
                  label: 'Confirm Password',
                  isPassword: true,
                  keyboardType: TextInputType.visiblePassword,
                  controller: controller.confirmPasswordController,
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
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                    if (controller.validateForm()!="True") {
                      Get.back();

                      Get.snackbar(
                        'Error',
                        controller.validateForm(),
                        colorText: kPinkColor,
                      );
                    } else {
                      await controller.signup();
                      Get.offNamed(Routes.userLogin);
                    }
                  },
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                GestureDetector(
                  onTap: () {
                    Get.offNamed(Routes.LOGIN);
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


}
