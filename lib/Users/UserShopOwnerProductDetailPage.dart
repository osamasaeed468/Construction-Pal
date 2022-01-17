import 'package:flutter/material.dart';

class UserShopOwnerProductDetailPage extends StatelessWidget {
  const UserShopOwnerProductDetailPage({Key? key}) : super(key: key);

  static const routeName = '/user-shop-owner-product-detail-page';

  @override
  Widget build(BuildContext context) {
    final prodRouteArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final prodImageUrl = prodRouteArgs['prodImageUrl'] as String;
    final prodName = prodRouteArgs['prodName'] as String;
    final prodDescription = prodRouteArgs['prodDescription'] as String;
    final prodPrice = prodRouteArgs['prodPrice'] as double;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white70,
        body: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.62,
              child: Image.network(
                prodImageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.45,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 33.0, left: 27, right: 27, bottom: 27),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prodName,
                        style: const TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      RichText(
                        text: TextSpan(children: [
                          const TextSpan(
                              text: 'Price : ',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              )),
                          TextSpan(
                              text: '$prodPrice / item',
                              style: const TextStyle(
                                color: Colors.black,
                                //    fontWeight: FontWeight.bold,
                                fontSize: 17,
                              )),
                        ]),
                      ),
                      const SizedBox(height: 15),
                      RichText(
                        text: TextSpan(children: [
                          const TextSpan(
                              text: 'Description : ',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              )),
                          TextSpan(
                              text: prodDescription,
                              style: const TextStyle(
                                color: Colors.black,
                                //    fontWeight: FontWeight.bold,
                                fontSize: 17,
                              )),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
