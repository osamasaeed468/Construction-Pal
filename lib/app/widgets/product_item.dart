import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ProductItem extends StatefulWidget {
  final String title;
  final String name;
  final String image;
  final String experience;
  final String description;
  final String expertise;
  final String id;
  final String city;
  final String orders;

  final num myRating;

  // String weight;
  final DocumentSnapshot documentSnapshot;

  const ProductItem(

      {
        Key? key,
        required this.title,
      required this.documentSnapshot,
      required this.id,
      required this.experience,
      required this.image,

        required  this.description,
        required this.expertise,
        required this.city,
        required this.name,required this.myRating,
        required this.orders,
      // this.weight
      });

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    num price=widget.myRating;
    String price1 = price.toStringAsFixed(2);
    double p=double.parse(price1);
    return Container(
      margin: const EdgeInsets.only(top: 4.0,bottom: 4,left: 15,right: 15),
      height: height * 0.18,

      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        // height: height * 0.162,
        // width: MediaQuery.of(context).size.width,
        // decoration: BoxDecoration(
        //     gradient: const LinearGradient(
        //         begin: Alignment.topRight,
        //         end: Alignment.bottomLeft,
        //         colors: [
        //           Color(0xFF1a1c20),
        //           Color(0xFF222222),
        //         ]),
        //     borderRadius: BorderRadius.circular(20)),
      child: Row(
      children: <Widget>[


      SizedBox(

        height: height * 0.22,
        width: height * 0.18,
        child:ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(15.0),bottomLeft: Radius.circular(15.0)),


          child: Image.network(widget.image,fit: BoxFit.fill),
        )
          ),
      Expanded(
      child: Padding(
      padding: const EdgeInsets.symmetric(
      vertical: 8.0, horizontal: 16),


        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: <Widget>[

            Text(

              widget.name,

              overflow: TextOverflow.ellipsis,

              style: TextStyle(
                  color: Colors.black,
                  fontFamily: "MetroPolis",
                  fontWeight: FontWeight.bold,
                  fontSize:
                  MediaQuery.of(context).size.width *
                      0.05),
            ),
            Text(

              widget.city,

              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.black87,
                  fontFamily: "Poppins-Medium",
                  fontWeight: FontWeight.bold,
                  fontSize:MediaQuery.of(context).size.width *
                      0.04
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.width *
                0.012,),
            Text(
              widget.title,
              style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Poppins-Light",
                  fontSize:
                  MediaQuery.of(context).size.width *
                      0.035),
            ),
            SizedBox(height: MediaQuery.of(context).size.width *
                0.02,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "⭐ $p",
                  style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Poppins-Semibold",
                      fontSize: MediaQuery.of(context).size.width *
                          0.04),
                ),
                SizedBox(

                  child: Row(
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.width*0.04,
                          width: MediaQuery.of(context).size.width*0.04,
                          child: Image.asset('assets/reg.png')
                      ),
                      Text(
                        " ${widget.orders} ",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Poppins-Light",
                            fontSize: MediaQuery.of(context).size.width *
                                0.04),
                      ),
                      Text(
                        "orders",
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Poppins-Light",
                            fontSize: MediaQuery.of(context).size.width *
                                0.04),
                      ),
                    ],
                  ),
                ),

              ],
            )
          ],
        ),

      ),
      ),
      ],
      ),
      ),

    );
  }
}
//
// class CategoreisBox extends StatefulWidget {
//   final String title;
//
//   // final String price;
//   final String imageUrl;
//   final String id;
//
//   // String weight;
//   final DocumentSnapshot documentSnapshot;
//
//   CategoreisBox({
//     @required this.imageUrl,
//     @required this.documentSnapshot,
//     @required this.id,
//     this.title,
//     //@required this.price,
//     // this.weight
//   });
//
//   @override
//   _CategoreisBoxState createState() => _CategoreisBoxState();
// }
//
// class _CategoreisBoxState extends State<CategoreisBox> {
//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//         scrollDirection: Axis.vertical,
//         shrinkWrap: true,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(top: 20.0, right: 10.0, left: 10.0),
//             child: Container(
//               height: 200.0,
//               width: MediaQuery.of(context).size.width * 0.5,
//               child: Column(
//                 children: <Widget>[
//                   Container(
//                     height: MediaQuery.of(context).size.height * 0.2,
//                     width: MediaQuery.of(context).size.width * 0.4,
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(10),
//                       child: Image.network(
//                         widget.imageUrl,
//                         //  fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 0.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Column(
//                           children: <Widget>[
//                             Padding(
//                               padding: const EdgeInsets.only(left: 8.0),
//                               child: Expanded(
//                                 child: Text(
//                                   widget.title,
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.black,
//                                       fontSize: 18),
//                                 ),
//                               ),
//                             ),
//                             // SizedBox(height: ,)
//                           ],
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                         ),
//                         Row(
//                           children: <Widget>[],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               padding: EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 border: Border.all(
//                     color: Colors.white, // set border color
//                     width: 2.0),
//                 borderRadius: BorderRadius.circular(10),
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.5),
//                     spreadRadius: 3,
//                     blurRadius: 7,
//                     offset: Offset(0, 3), // changes position of shadow
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 20.0, right: 10.0, left: 10.0),
//             child: Container(
//               width: MediaQuery.of(context).size.width * 0.3,
//               child: Column(
//                 children: <Widget>[
//                   Container(
//                     height: MediaQuery.of(context).size.height * 0.2,
//                     width: MediaQuery.of(context).size.width * 0.4,
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(10),
//                       child: Image.asset(
//                         "assets/images/kamdan.png",
//                         //  fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 0.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Column(
//                           children: <Widget>[
//                             Padding(
//                               padding: const EdgeInsets.only(left: 8.0),
//                               child: Expanded(
//                                 child: Text(
//                                   "Help",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.black,
//                                       fontSize: 18),
//                                 ),
//                               ),
//                             ),
//                             // SizedBox(height: ,)
//                           ],
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                         ),
//                         Row(
//                           children: <Widget>[],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               padding: EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 border: Border.all(
//                     color: Colors.white, // set border color
//                     width: 2.0),
//                 borderRadius: BorderRadius.circular(10),
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.5),
//                     spreadRadius: 3,
//                     blurRadius: 7,
//                     offset: Offset(0, 3), // changes position of shadow
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ]);
//   }
// }
//
// class DetailsView extends StatefulWidget {
//   // final String title;
//   // final String price;
//   final String time;
//   final String imageUrl;
//   final String id;
//
//   // String weight;
//   final DocumentSnapshot documentSnapshot;
//
//   DetailsView({
//     @required this.imageUrl,
//     @required this.documentSnapshot,
//     @required this.id,
//     this.time,
//     // this.title,
//     //@required this.price,
//     // this.weight
//   });
//
//   @override
//   _DetailsViewState createState() => _DetailsViewState();
// }
//
// class _DetailsViewState extends State<DetailsView> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Container(
//             height: MediaQuery.of(context).size.height * 0.2,
//             width: MediaQuery.of(context).size.width,
//             child: Image.asset(
//               widget.imageUrl,
//               fit: BoxFit.cover,
//             ),
//           ),
//           Container(
//             width: MediaQuery.of(context).size.width,
//             //height: ,
//             padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//             decoration: BoxDecoration(
//                 color: Colors.white,
//                 border: Border.all(
//                   color: Colors.black.withOpacity(0.2),
//                 ),
//                 borderRadius: BorderRadius.circular(10)),
//             child: Column(
//               children: [
//                 Text(
//                   "Delivery Time",
//                   style: TextStyle(
//                       fontSize: 18.0,
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold),
//                 ),
//                 Row(
//                   children: [
//                     Icon(Icons.access_time, color: Colors.black),
//                     Text(
//                       widget.time,
//                       style: TextStyle(fontSize: 18.0, color: Colors.grey),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
