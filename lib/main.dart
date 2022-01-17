import 'package:digitalconstruction/RegisterAsShopOwner.dart';
import 'package:digitalconstruction/Shop/ShopModel.dart';
import 'package:digitalconstruction/Shop/ViewIndividualShopProductsPage.dart.dart';
import 'package:digitalconstruction/Shop/addShopProductPage.dart';
import 'package:digitalconstruction/Shop/shopHomePage.dart';
import 'package:digitalconstruction/Shop/shopOwnerLogin.dart';
import 'package:digitalconstruction/Shop/shopOwnerProductDetailPage.dart';
import 'package:digitalconstruction/Users/UserShopHomePage.dart';
import 'package:digitalconstruction/Users/UserShopOwnerProductDetailPage.dart';
import 'package:digitalconstruction/Users/UserViewIndividualShopProductsPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'app/constants/helpers.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Helper.fetchAllCons();
  Helper.fetchAllUsers();
  Helper.fetchAllWagers();
  runApp(
    DigitalConstruction(),
  );
}

class DigitalConstruction extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  DigitalConstruction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => Shops(),
              ),
            ],
            child: GetMaterialApp(
              routes: {
                RegisterAsShopOwner.routeName: (_) => RegisterAsShopOwner(),
                ShopHomePage.routeName: (_) => const ShopHomePage(),
                ShopOwnerLogin.routeName: (_) => ShopOwnerLogin(),
                //   AddProductToShopPage.routeName: (_) => AddProductToShopPage(),
                AddShopProductPage.routeName: (_) => const AddShopProductPage(),
                ViewIndividualShopProductsPage.routeName: (_) =>
                    const ViewIndividualShopProductsPage(),

                UserShopHomePage.routeName: (_) => const UserShopHomePage(),
                UserViewIndividualShopProductsPage.routeName: (_) =>
                    const UserViewIndividualShopProductsPage(),

                ShopOwnerProductDetailPage.routeName: (_) =>
                    const ShopOwnerProductDetailPage(),

                UserShopOwnerProductDetailPage.routeName: (_) =>
                    const UserShopOwnerProductDetailPage()
              },
              theme: ThemeData(
                primarySwatch: Colors.blue,
                primaryTextTheme: Theme.of(context).textTheme.apply(
                      displayColor: Colors.black,
                    ),
              ),
              title: "Digital Construction",
              initialRoute: AppPages.INITIAL,
              getPages: AppPages.routes,
              // themeMode: ThemeMode.light,
              debugShowCheckedModeBanner: false,
            ),
          );
        }

        return const CircularProgressIndicator();
      },
    );
  }
}
