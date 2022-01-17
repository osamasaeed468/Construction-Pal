import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalconstruction/Shop/addShopProductPage.dart';
import 'package:digitalconstruction/Shop/shopOwnerProductDetailPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewIndividualShopProductsPage extends StatefulWidget {
  const ViewIndividualShopProductsPage({Key? key}) : super(key: key);

  static const routeName = '/view-individual-shop-products-page';

  @override
  State<ViewIndividualShopProductsPage> createState() =>
      _ViewIndividualShopProductsPageState();
}

class _ViewIndividualShopProductsPageState
    extends State<ViewIndividualShopProductsPage> {
  late dynamic allShopArgs;
  late String dID;
  late dynamic shopName;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    allShopArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    shopName = allShopArgs['shopName'] as String;
    dID = allShopArgs['dID'] as String;

    final shopProducts = FirebaseFirestore.instance
        .collection('Shops')
        .doc(dID)
        .collection('Products');

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(shopName),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(
                AddShopProductPage.routeName,
                arguments: {
                  'dID': dID,
                },
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: shopProducts.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final productData = snapshot.data!.docs;

          return ListView.builder(
              itemCount: productData.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      ShopOwnerProductDetailPage.routeName,
                      arguments: {
                        'prodImageUrl': productData[index]['items']
                            ['pImageUrl'],
                        'prodPrice': productData[index]['items']['price'],
                        'prodName': productData[index]['items']['pName'],
                        'prodDescription': productData[index]['items']
                            ['pDescription'],
                      },
                    );
                  },
                  child: Dismissible(
                    confirmDismiss: (_) {
                      return showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: const Text('Are you sure to delete it?'),
                              actions: [
                                FlatButton(
                                  color: Colors.red,
                                  textColor:
                                      const Color.fromRGBO(255, 255, 255, 1),
                                  onPressed: () {
                                    var pUid = productData[index]['pUid'];

                                    print(pUid);

                                    shopProducts.doc(pUid).delete();

                                    //  setState(() {});

////////////////////////////////////////////////
                                    Navigator.of(context).pop(true);
                                  },
                                  child: const Text('Yes'),
                                ),
                                FlatButton(
                                  color: Colors.green,
                                  textColor: Colors.white,
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: const Text('No'),
                                ),
                              ],
                            );
                          });
                    },
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                    background: ClipRRect(
                      //   borderRadius: BorderRadius.circular(120),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          alignment: Alignment.centerRight,
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 20,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(33),
                          ),
                        ),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(13),
                      width: double.infinity,
                      height: 250,
                      child: GridTile(
                        child: CachedNetworkImage(
                          imageUrl: productData[index]['items']['pImageUrl'],
                          fit: BoxFit.cover,
                          placeholder: (context, _) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                        footer: GridTileBar(
                          backgroundColor: Colors.black.withOpacity(0.75),
                          title: Text(
                            productData[index]['items']['pName'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
