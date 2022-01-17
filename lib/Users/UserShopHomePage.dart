import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalconstruction/Users/UserViewIndividualShopProductsPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserShopHomePage extends StatefulWidget {
  const UserShopHomePage({Key? key}) : super(key: key);
  static const routeName = '/user-shop-home-page';

  @override
  State<UserShopHomePage> createState() => _UserShopHomePageState();
}

class _UserShopHomePageState extends State<UserShopHomePage> {
  CollectionReference allNoteCollection =
      FirebaseFirestore.instance.collection('Shops');

  List<DocumentSnapshot> documents = [];
  // late String dID;
  late dynamic shops;

  final searchController = TextEditingController();
  late String searchText = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    searchController.addListener(() {
      searchText = searchController.text;
      setState(() {});
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    shops = FirebaseFirestore.instance.collection('Shops');

    return Scaffold(
        backgroundColor: const Color.fromARGB(239, 255, 255, 255),
        appBar: AppBar(
          elevation: 0.0,
          title: const Text('All Shops'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(13.0),
              child: Container(
                height: 61,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    width: 3,
                    color: Colors.blue.withOpacity(0.7),
                  ),
                  borderRadius: BorderRadius.circular(23),
                ),
                child: Center(
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Search by shop name',
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                  stream: shops.snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    documents = snapshot.data!.docs;

                    if (searchText.isNotEmpty) {
                      documents = documents.where((element) {
                        return element
                            .get('shopName')
                            .toString()
                            .toLowerCase()
                            .contains(searchText.toLowerCase());
                      }).toList();
                    }

                    return GridView.builder(
                        padding: const EdgeInsets.all(17),
                        itemCount: documents.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          childAspectRatio: 1.45,
                        ),
                        itemBuilder: (context, index) {
                          return documents[index]['isShopApproved']
                              ? InkWell(
                                  onTap: () {
                                    Get.toNamed(
                                      UserViewIndividualShopProductsPage
                                          .routeName,
                                      arguments: {
                                        'shopName': documents[index]
                                            ['shopName'],
                                        'dID': documents[index]['shopOwnerUid'],
                                      },
                                    );
                                  },
                                  child: Card(
                                    margin: const EdgeInsets.only(bottom: 22),
                                    color: const Color.fromARGB(
                                        255, 255, 254, 254),
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
                                            // bottomLeft: Radius.circular(30),
                                            // bottomRight: Radius.circular(30),
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                          ),
                                          child: Container(
                                            width: double.infinity,
                                            height: 160,
                                            child: Image.network(
                                              documents[index]['shopImage'],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 13),
                                        Container(
                                          child: Text(
                                            documents[index]['shopName'],
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
                  }),
            ),
          ],
        ));
  }
}
