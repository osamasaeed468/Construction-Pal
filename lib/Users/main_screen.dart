import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalconstruction/Shop/shopHomePage.dart';
import 'package:digitalconstruction/Users/UserShopHomePage.dart';
import 'package:digitalconstruction/Users/user_location.dart';
import 'package:digitalconstruction/Users/user_orders.dart';
import 'package:digitalconstruction/Users/wagers.dart';
import 'package:digitalconstruction/app/constants/helpers.dart';
import 'package:digitalconstruction/app/modules/login/views/AuthService.dart';
import 'package:digitalconstruction/app/routes/app_pages.dart';
import 'package:digitalconstruction/app/widgets/color_theme.dart';
import 'package:digitalconstruction/app/widgets/custom_text_field.dart';
import 'package:digitalconstruction/app/widgets/profile_row.dart';
import 'package:digitalconstruction/models/reg_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:line_icons/line_icons.dart';
import 'package:permission_handler/permission_handler.dart';

import 'admin_chat.dart';
import 'all_chat.dart';
import 'all_contractors.dart';
import 'chat.dart';
import 'history.dart';
import 'login_page.dart';

var uu;

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final AuthService _auth = new AuthService();

  FirebaseAuth auth = FirebaseAuth.instance;

  double latitude = 0;

  double longitude = 0;

  Future getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission != PermissionStatus.granted) {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission != PermissionStatus.granted) getLocation();
      return;
    }
    getLocation();
  }

  GoogleMapController? _controllers;

  List<Address> results = [];

  getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      longitude = position.longitude;
      print("my longitude" + longitude.toString());
      latitude = position.latitude;
      print("my lotitude" + latitude.toString());
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      
      
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              onTap: () async {

                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const MyAccount()));
              },
              leading: const Icon(Icons.supervised_user_circle_outlined),
              title: const Text("My Account"),
            ),
            const Divider(
              height: 0.1,
            ),
            ListTile(
              onTap: () async {
                FirebaseAuth auth = FirebaseAuth.instance;
                final User? user = auth.currentUser;
                uu = user!.uid;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ChatWithBarberLayout()));
              },
              leading: const Icon(Icons.all_inbox_sharp),
              title: const Text("Inbox"),
            ),
            const Divider(
              height: 0.1,
            ),
            ListTile(
              leading: const Icon(Icons.add_alert),
              title: const Text("Orders Management"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TabBarDemo()),
                );
              },
            ),
            const Divider(
              height: 0.1,
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text("History"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => History()),
                );
              },
            ),
            const Divider(
              height: 0.1,
            ),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text("Complain"),
              onTap: () {
                Navigator.push(
                    context,MaterialPageRoute(builder: (context)=>
                    const ChatPage1(
                      user_id: "sUid", timestamp: 0,type:"Admin",
                    ),
                ));
              },
            ),
            const Divider(
              height: 0.1,
            ),
            ListTile(
              title: const Text("Logout"),
              leading: const Icon(Icons.logout),
              onTap: () async {
                await _auth.signOut();
                Get.offNamed(Routes.userLogin);
              },
            ),
          ],
        ),
      ),
      
      appBar: AppBar(
          title: const Text(
        'Construction Pal',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: 'MetroPolis',
        ),
      )),

      body: Container(
          decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/userback.png"),
            fit: BoxFit.cover,
          ),
        ),
      
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 34.0, bottom: 30),
              child: Text(
                "WELCOME",
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Metropolis',
                    color: Colors.blue,
                    letterSpacing: 3.0,
                    fontSize: 38.0),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 40.0),
              child: Text(
                "What You Want ?",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Metropolis',
                    color: Colors.blue,
                    letterSpacing: 2.0,
                    fontSize: 20.0),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.width * 0.4,
                    

                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                              begin: Alignment.bottomRight,
                              colors: [
                                
                                Colors.blueAccent.withOpacity(0.3),
                                Colors.blueAccent.withOpacity(0.3),
                                
                                
                              ])),
                      
                    
                    
                    child: Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.width * 0.4,
                    
                    decoration: const BoxDecoration(
                      
                        image: DecorationImage(
                      
                      image: AssetImage("assets/constructors.png"),
                    )),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                              begin: Alignment.bottomRight,
                              colors: [
                                
                                Colors.blueGrey.withOpacity(0.0),
                                Colors.blueGrey.withOpacity(0.0),
                                
                              ])),
                      child: const Padding(
                        padding:
                            EdgeInsets.only(top: 128, bottom: 4.0, left: 26),
                        child: Text(
                          'Constructors',
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    ),
                  ),
                  ),
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AllContractors(
                                  longitude: longitude,
                                  latitude: latitude,
                                )));
                  },
                  
                ),
                const SizedBox(
                  width: 15,
                ),
                InkWell(
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.width * 0.4,
                    

                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                              begin: Alignment.bottomRight,
                              colors: [
                                
                                Colors.blueAccent.withOpacity(0.3),
                                Colors.blueAccent.withOpacity(0.3),
                                
                              ])),


                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.width * 0.4,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                      fit: BoxFit.contain,
                      image: AssetImage("assets/wagers.png"),
                    )),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                              begin: Alignment.bottomRight,
                              colors: [
                                Colors.blueGrey.withOpacity(0.1),
                                Colors.blueGrey.withOpacity(0.1),
                              ])),
                      child: const Padding(
                        padding:
                            EdgeInsets.only(top: 128, bottom: 4.0, left: 45),
                        child: Text(
                          'Wagers',
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                      ),
                    ),
                  ),
                  onTap: () async {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => AllWagers(
                              latitude: latitude,
                              longitude: longitude,
                            )));
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),

////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////
            ///

            InkWell(

             child: Container(
                    width: MediaQuery.of(context).size.width * 0.83,
                    height: MediaQuery.of(context).size.width * 0.4,
                    

                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                              begin: Alignment.bottomRight,
                              colors: [
                                
                                Colors.blueAccent.withOpacity(0.3),
                                Colors.blueAccent.withOpacity(0.3),
                                
                              ])),


              child: Container(
                width: MediaQuery.of(context).size.width * 0.83,
                height: MediaQuery.of(context).size.width * 0.4,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  
                  image: AssetImage(
                    "assets/store.png",
                  ),
                )),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient:
                          LinearGradient(begin: Alignment.bottomRight, colors: [
                        Colors.black.withOpacity(0.0),
                        Colors.black.withOpacity(0.0),
                      ])),

                  // shape: const RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.only(
                  //       topRight: Radius.circular(22.0),
                  //       bottomLeft: Radius.circular(22.0)),
                  // ),

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

                  child: const Padding(
                    padding: EdgeInsets.only(top: 125, bottom: 1.0, left: 120),
                    child: Text(
                      'Products',
                      style: TextStyle(
                          fontSize: 22.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                ),
              ),
                    ),
             ),
              onTap: () {
                Get.toNamed(UserShopHomePage.routeName);
              },
            ),
          ],
        ),
      ),
    ),
    
    );
  }
}

class MyAccount extends StatefulWidget {
  const MyAccount({Key? key}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<MyAccount> {
  RegUser user = RegUser(
    uid: "uid",
    first_name: "Name",
    address: "city",
    email: "email",
    cnic: "cnic",
    phone: "phone",
    last_name: "last_name",
  );
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = Helper.fetchUserValue(FirebaseAuth.instance.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    final double _w = MediaQuery.of(context).size.width;
    final double _h = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                child: Stack(
                  children: [
                    Positioned(
                      child: Container(

                        width: _w,
                        height: _h * 0.8,
                        padding: const EdgeInsets.all(15),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              profileRow(
                                title: 'Name',
                                subtitle:
                                    user.first_name + " ${user.last_name}",
                                icon: CupertinoIcons.person_alt_circle,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              profileRow(
                                title: 'E-mail',
                                subtitle: user.email,
                                icon: Icons.email_rounded,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              profileRow(
                                title: 'Address',
                                subtitle:
                                user.address,
                                icon: Icons.location_on_sharp,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              profileRow(
                                title: 'CNIC',
                                subtitle:
                                user.cnic,
                                icon: Icons.perm_identity_sharp,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              profileRow(
                                title: 'Number',
                                subtitle:
                                user.phone,
                                icon: CupertinoIcons.phone,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 8,
                                    right: 8,
                                    top: 120,
                                    bottom: 0,
                                  ),
                                  child: FlatButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    minWidth: _w * 0.9,
                                    height: 50,
                                    color: buttonBgColor,
                                    onPressed: () async {
                                      _profileUpdateWidget(context);
                                    },
                                    child: const Text(
                                      'Edit Profile',
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.white,
                                          fontFamily: 'MetroPolis',
                                          fontWeight:FontWeight.bold
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
  Future<void> _profileUpdateWidget(BuildContext context) {
    TextEditingController firstNameController =
    TextEditingController(text: user.first_name);
    TextEditingController secondNameController =
    TextEditingController(text: user.last_name);
    TextEditingController phoneNumberController =
    TextEditingController(text: user.phone);
    TextEditingController addressController =
    TextEditingController(text: user.address);

    return showDialog(
        builder: (BuildContext context) {
          return Scaffold(
              appBar: AppBar(
              title: const Text("Edit Profile"),
          centerTitle: true,
          ),
          body:SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomTextField(
                  label: user.first_name,
                  keyboardType: TextInputType.text,
                  controller: firstNameController,
                ),
              ),
              // second name
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomTextField(
                  label: user.last_name,
                  keyboardType: TextInputType.text,
                  controller: secondNameController,
                ),
              ),

              // phone number
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomTextField(
                  label: user.phone,
                  keyboardType: TextInputType.number,
                  controller: phoneNumberController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomTextField(
                  label: user.address,
                  keyboardType: TextInputType.text,
                  controller: addressController,
                ),
              ),

              // button
              Container(
                margin: const EdgeInsets.all(8.0),
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.06,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    //for button background color
                    primary: Colors.redAccent,
                    //for button text color
                    onPrimary: Colors.white,
                    //minimumSize: Size(40, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .update({
                      'email':user.email,
                      'first_name': firstNameController.text,
                      'last_name': secondNameController.text,
                      'address':addressController.text,
                      'cnic':user.cnic,
                      'phone':phoneNumberController.text,
                      'uid':user.uid
                    });
                  },
                  child: const Center(
                    child: Text(
                      "Update",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
          );
        },
      context: context,
    );
  }

}
