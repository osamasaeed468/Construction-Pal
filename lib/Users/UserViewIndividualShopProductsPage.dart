import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalconstruction/Users/UserShopOwnerProductDetailPage.dart';
import 'package:flutter/material.dart';

class UserViewIndividualShopProductsPage extends StatefulWidget {
  const UserViewIndividualShopProductsPage({Key? key}) : super(key: key);

  static const routeName = '/user-view-individual-shop-products-page';

  @override
  State<UserViewIndividualShopProductsPage> createState() =>
      _UserViewIndividualShopProductsPageState();
}

class _UserViewIndividualShopProductsPageState
    extends State<UserViewIndividualShopProductsPage> {
  late dynamic allShopArgs;
  late String dID;
  late String shopName;

  @override
  void didChangeDependencies() {
    allShopArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    shopName = allShopArgs['shopName'] as String;
    dID = allShopArgs['dID'] as String;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final shopProducts = FirebaseFirestore.instance
        .collection('Shops')
        .doc(dID)
        .collection('Products');

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(shopName),
        centerTitle: true,
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
                      UserShopOwnerProductDetailPage.routeName,
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
                              child: CircularProgressIndicator());
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
                );
              });
        },
      ),
    );
  }
}
