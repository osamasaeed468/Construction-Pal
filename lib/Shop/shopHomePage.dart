import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalconstruction/Shop/ViewIndividualShopProductsPage.dart.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';

class ShopHomePage extends StatefulWidget {
  const ShopHomePage({Key? key}) : super(key: key);

  static const routeName = '/shop-home-page';

  @override
  State<ShopHomePage> createState() => _ShopHomePageState();
}

class _ShopHomePageState extends State<ShopHomePage> {
  late String dID;
  late String ownerEmail;
  late String ownerPassword;
  late String pImageUrl;
  late dynamic shops;

  @override
  void didChangeDependencies() {
    setState(() {});
    dynamic dIDArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    // dID = dIDArgs['dID'] as String;

    dynamic ownerCredentialsArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    ownerEmail = ownerCredentialsArgs['shopOwnerEmail'];
    ownerPassword = ownerCredentialsArgs['shopOwnerPassword'];

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    shops = FirebaseFirestore.instance.collection('Shops');
    return Scaffold(
        backgroundColor: const Color.fromARGB(239, 255, 255, 255),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0.0,
          title: const Text('Shop'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.logout))
          ],
        ),
        body: StreamBuilder(
            stream: shops.snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }

              final shopsData = snapshot.data!.docs
                  .where(
                      (element) => element['shopOwnerEmailName'] == ownerEmail)
                  .toList();

              return GridView.builder(
                  padding: const EdgeInsets.all(17),
                  itemCount: shopsData.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 1.45,
                  ),
                  itemBuilder: (context, index) {
                    return shopsData[index]['isShopApproved']
                        ? InkWell(
                            onTap: () {
                              ///////////////////////////////////////////////////////////////////////////////////
                              // final dIDArgs = ModalRoute.of(context)!
                              //     .settings
                              //     .arguments as Map<String, dynamic>;

                              //   dID = dIDArgs['dID'] as String;

                              dID = shopsData[index]['shopOwnerUid'];

                              Get.toNamed(
                                ViewIndividualShopProductsPage.routeName,
                                arguments: {
                                  'shopName': shopsData[index]['shopName'],
                                  'dID': dID,
                                },
                              );
                            },
                            child: Card(
                              margin: const EdgeInsets.only(bottom: 22),
                              color: const Color.fromARGB(255, 255, 254, 254),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(30),
                                  bottomRight: Radius.circular(30),
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              elevation: 2.2,
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                    child: Container(
                                      width: double.infinity,
                                      height: 160,
                                      child: Image.network(
                                        shopsData[index]['shopImage'],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 13),
                                  Container(
                                    child: Text(
                                      shopsData[index]['shopName'],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 17),
                                ],
                              ),
                            ),
                          )
                        : Container();
                  });
            }));
  }
}
