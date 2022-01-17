import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalconstruction/Shop/Product.dart';
import 'package:digitalconstruction/Shop/shopHomePage.dart';
import 'package:digitalconstruction/app/widgets/custom_text_field.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddShopProductPage extends StatefulWidget {
  const AddShopProductPage({Key? key}) : super(key: key);

  static const routeName = '/add-shop-page';

  @override
  State<AddShopProductPage> createState() => _AddShopPageState();
}

class _AddShopPageState extends State<AddShopProductPage> {
  late String dID;
  final productDescriptionController = TextEditingController();
  final productImageController = TextEditingController();
  final productImageFocusNode = FocusNode();
  final productNameController = TextEditingController();
  final productPriceNoController = TextEditingController();
  final productQuantityController = TextEditingController();
  late dynamic routeArgsDID;
  CollectionReference shopProducts =
      FirebaseFirestore.instance.collection('Shops');

  @override
  void didChangeDependencies() {
    productImageController.addListener(() {
      SystemChannels.textInput.invokeMethod('TextInput.hide');

      if (FocusScope.of(context).hasFocus) {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        setState(() {});
      }

      if (productImageController.text.isNotEmpty) {
        SystemChannels.textInput.invokeMethod('TextInput.hide');

        setState(() {});
      }

      if (productImageController.text.isEmpty) {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        setState(() {});
      }
    });
    super.didChangeDependencies();
  }

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    routeArgsDID =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    dID = routeArgsDID['dID'] as String;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text('Add Product'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomTextField(
              controller: productNameController,
              label: "Enter Product Name",
              isPassword: false,
              keyboardType: TextInputType.text,
            ),
            CustomTextField(
              controller: productImageController,
              label: "Enter Product Image",
              isPassword: false,
              keyboardType: TextInputType.text,
            ),
            CustomTextField(
              controller: productDescriptionController,
              label: "Enter Product Description",
              isPassword: false,
              keyboardType: TextInputType.text,
            ),
            CustomTextField(
              controller: productPriceNoController,
              label: "Enter Product Price",
              isPassword: false,
              keyboardType: TextInputType.number,
            ),
            CustomTextField(
              controller: productQuantityController,
              label: "Enter Product Quantity",
              isPassword: false,
              keyboardType: TextInputType.number,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 22.5, right: 22.5, top: 10),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: Colors.black,
                  ),
                ),
                child: productImageController.text.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: productImageController.text,
                        fit: BoxFit.cover,
                        placeholder: (context, _) {
                          return const Center(
                              child: CircularProgressIndicator());
                        },
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
            ),
            const SizedBox(height: 20),
            FlatButton(
              padding: const EdgeInsets.only(
                left: 100,
                right: 100,
                top: 15,
                bottom: 15,
              ),
              textColor: Colors.white,
              color: Colors.green,
              onPressed: () {
                final databaseReference = FirebaseFirestore.instance;

                databaseReference
                    .collection('Shops')
                    .doc(dID)
                    .collection('Products')
                    .add({
                  'items': {
                    'pName': productNameController.text,
                    'pDescription': productDescriptionController.text,
                    'pImageUrl': productImageController.text,
                    'price': double.parse(productPriceNoController.text),
                    'quantity': int.parse(productQuantityController.text),
                  }
                }).then((value) {
                  //  dID = value.id;
                  databaseReference
                      .collection('Shops')
                      .doc(dID)
                      .collection('Products')
                      .doc(value.id)
                      .update({
                    'pUid': value.id,
                  });

                  print("Shop Added");
                });

                Navigator.of(context).pop();
              },
              child: const Text('Add Product'),
            ),
            const SizedBox(height: 13),
          ],
        ),
      ),
    );
  }
}
