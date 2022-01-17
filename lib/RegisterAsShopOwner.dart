// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalconstruction/Shop/ShopModel.dart';
import 'package:digitalconstruction/app/routes/app_pages.dart';
import 'package:digitalconstruction/app/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterAsShopOwner extends StatefulWidget {
  RegisterAsShopOwner({Key? key}) : super(key: key);

  static const routeName = '/register-as-shop-owner';

  @override
  State<RegisterAsShopOwner> createState() => _RegisterAsShopOwnerState();
}

class _RegisterAsShopOwnerState extends State<RegisterAsShopOwner> {
  late final dID;
  final imageController = TextEditingController();
  final imageFocusNode = FocusNode();
  final ownerEmailController = TextEditingController();
  final ownerNameController = TextEditingController();
  final ownerPhoneNoController = TextEditingController();
  final passwordController = TextEditingController();
  final shopNameController = TextEditingController();

  @override
  void initState() {
    imageFocusNode.addListener(() {
      if (!imageFocusNode.hasFocus) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final shops = Provider.of<Shops>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register As A Shop Owner'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomTextField(
              controller: shopNameController,
              label: "Enter Shop Name",
              isPassword: false,
              keyboardType: TextInputType.name,
            ),
            CustomTextField(
              controller: ownerNameController,
              label: "Enter Owner Name",
              isPassword: false,
              keyboardType: TextInputType.name,
            ),
            CustomTextField(
              controller: ownerPhoneNoController,
              label: "Enter Phone Number",
              isPassword: false,
              keyboardType: TextInputType.name,
            ),
            CustomTextField(
              controller: ownerEmailController,
              label: "Enter Owner Businness Email",
              isPassword: false,
              keyboardType: TextInputType.name,
            ),
            CustomTextField(
              controller: passwordController,
              label: "Enter Password",
              isPassword: true,
              keyboardType: TextInputType.text,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 23.0, right: 3.0, top: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: Colors.black,
                      ),
                    ),
                    child: imageController.text.isNotEmpty
                        ? Image.network(
                            imageController.text,
                            fit: BoxFit.cover,
                          )
                        : const Center(
                            child: Text(
                              'No Image Selected',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    width: 200,
                    child: TextFormField(
                      controller: imageController,
                      focusNode: imageFocusNode,
                      keyboardType: TextInputType.url,
                      decoration: const InputDecoration(
                        hintText: 'Image url',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            FlatButton(
              padding: const EdgeInsets.only(
                  left: 144.5, right: 144.5, top: 15, bottom: 15),
              textColor: Colors.white,
              color: Colors.green,
              onPressed: () async {
                try {
                  dID = await shops.addShop(
                    shopNameController.text,
                    ownerNameController.text,
                    int.parse(ownerPhoneNoController.text),
                    ownerEmailController.text,
                    passwordController.text,
                    imageController.text,
                  );

                  await Future.delayed(const Duration(seconds: 1), () {
                    FirebaseFirestore.instance
                        .collection('Products')
                        .doc(dID)
                        .set({'dID': dID});

                    Navigator.of(context).pushReplacementNamed(
                      Routes.AfterSplash,
                    );
                  });
                } catch (err) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return const AlertDialog(
                        content: Text(
                            'Failed to add Shop either due to invalid data...'),
                      );
                    },
                  );
                }
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
