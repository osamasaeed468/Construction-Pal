import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalconstruction/app/modules/constructors/profile_screen.dart';
import 'package:digitalconstruction/app/modules/login/views/AuthService.dart';
import 'package:digitalconstruction/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'constructor_main_screen.dart';


var uiD;

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final User? user = FirebaseAuth.instance.currentUser;
  final AuthService _auths = AuthService();

  Widget text(BuildContext context, String calQ) {
    final User? user = FirebaseAuth.instance.currentUser;
    final String uid = user!.uid.toString();

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Constructors')
            .doc(uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Text("Loading");
          }
          return Container();

        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              const Text("Dashboard"),
              IconButton(
                icon: const Icon(
                  Icons.logout,
                  color: Colors.white,
                  size: 22,
                ),
                padding: const EdgeInsets.only(left: 200),
                onPressed: () async {
                  await _auths.signOut();
                  Get.offNamed(Routes.LOGIN);
                },
              )
            ],
          )),
      body: ListView(
        children: [
          //priceBox(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(top: 158.0, left: 10.0, right: 14.0),
                child: ButtonTheme(
                  buttonColor: Colors.blueAccent[100],
                  minWidth: 120.0,
                  height: 150.0,
                  child: RaisedButton(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(22.0),
                          bottomLeft: Radius.circular(22.0)),
                    ),
                    child: Column(
                      children: const [
                        Icon(
                          Icons.reorder,
                          
                          size: 50.0,
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          'Track Orders',
                          style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    onPressed: () async {
                      print("Hello");
                      User? user = FirebaseAuth.instance.currentUser;
                      u = user!.uid;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ContractorsMain()));
                      // dark="dark";
                      //  dark=dar;
                      // SharedPreferences prefs = await SharedPreferences.getInstance();
                      //
                      //Get.toNamed(Routes.AllUserContractors);
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 158.0, left: 10.0),
                child: ButtonTheme(
                  buttonColor: Colors.blueAccent[100],
                  minWidth: 120.0,
                  height: 150.0,
                  child: RaisedButton(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(22.0),
                          bottomLeft: Radius.circular(22.0)),
                    ),
                    child: Column(
                      children: const [
                        Icon(
                          Icons.account_circle,
                          size: 50.0,
                          
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Text(
                          'Profile',
                          style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    onPressed: () async {
                      User? user = FirebaseAuth.instance.currentUser;
                      u = user!.uid;
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Profile()));

                      // Get.changeTheme(ThemeData.light());
                      // dark="light";
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  priceBox() {
    // var document =await  FirebaseFirestore.instance.collection("Users").doc(user.uid).get();

    return Column(
      children: [
        Container(
            margin: EdgeInsets.only(top: 18.0),
            width: MediaQuery.of(context).size.width * 0.3,
            height: MediaQuery.of(context).size.height * 0.2,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.2,
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.white, // set border color
                    width: 2.0),
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                      child: text(
                    context,
                    'orders',
                  )),
                  Text(
                    "Total Orders",
                    style: TextStyle(color: Colors.black.withOpacity(0.8)),
                  )
                ],
              ),
            )),
      ],
    );
  }
}
