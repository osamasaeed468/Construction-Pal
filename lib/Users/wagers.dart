import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalconstruction/app/constants/helpers.dart';
import 'package:digitalconstruction/app/routes/app_pages.dart';
import 'package:digitalconstruction/app/widgets/card.dart';
import 'package:digitalconstruction/app/widgets/color_theme.dart';
import 'package:digitalconstruction/app/widgets/custom_text_field.dart';
import 'package:digitalconstruction/app/widgets/product_item.dart';
import 'package:digitalconstruction/app/widgets/profile_row.dart';
import 'package:digitalconstruction/models/dailywager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

import 'chat.dart';

class AllWagers extends StatefulWidget {
  final double latitude;
  final double longitude;
  const AllWagers({
    Key? key,required this.latitude,required this.longitude
  }) : super(key: key);

  @override
  _AllWagersState createState() => _AllWagersState();
}

class _AllWagersState extends State<AllWagers> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool searchState = false;
  String _typeSelected = '';
  var cat;
  List<DailyWagers> allWagersList = [];
  double? conLati;
  double? conLong;
  double myDistance=4;
  updateConstructor(){
    allWagersList=Helper.allWagerList;
    for(int i=0;i<allWagersList.length;i++){
      DailyWagers constructor=allWagersList[i];
      conLati=constructor.latitude.toDouble();
      print("wager latitude"+conLati.toString());
      conLong=constructor.longitude.toDouble();
      print("wager lotitude"+conLong.toString());
      print("My latitude"+widget.latitude.toString());
      print("My longitude"+widget.longitude.toString());
      calculateDistance(widget.latitude, widget.longitude, conLati, conLong);
      String uid=constructor.uid;
      FirebaseFirestore.instance.collection('Wagers').doc(uid).update(
          {
            'myDistance':myDistance
          });

    }
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    print("lat1:"+lat1.toString());
    print("lon1:"+lon1.toString());
    print("lat2:"+lat2.toString());
    print("lon2:"+lon2.toString());
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    myDistance=12742 * asin(sqrt(a));
    return myDistance;
  }

  @override
  void initState() {
    super.initState();
    updateConstructor();
  }
  String _typeSelect="";
  Widget _buildMType(String title) {
    return InkWell(
      child: Container(
        height: 40,
        width: 110,
        decoration: BoxDecoration(
          color: _typeSelect == title ? Colors.blue : const Color(0xFFCD3424),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
        ),
      ),
      onTap: () {
        setState(() {
          cat = title;
          _typeSelect = title;
        });
      },
    );
  }
  Widget _buildWagerType(String title) {
    return InkWell(
      child: Container(
        height: 40,
        width: 90,
        decoration: BoxDecoration(
          color: _typeSelected == title ? Colors.blue : Color(0xFFCD3424),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
        ),
      ),
      onTap: () {
        setState(() {
          cat = title;
          _typeSelected = title;
        });
      },
    );
  }
  String dropdownValue="All";
  double distance=20000;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
          title: Row(
            children: <Widget>[
              IconButton(
                //padding: const EdgeInsets.only(left: 200),
                icon: const Icon(Icons.arrow_back),
                color: Colors.white,

                onPressed: () {
                  Get.offNamed(Routes.UserMainScreen);
                },
              ),
              const SizedBox(
                width: 15,
              ),


              const Text('Daily Wagers',),
            ],
          )

      ),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.only(
                top: 12.0, left: 12.0, right: 12.0, bottom: 5.0),
            height: 40,

            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildWagerType('All'),
                const SizedBox(width: 10),
                _buildWagerType('Electrician'),
                const SizedBox(width: 10),
                _buildWagerType('Plumber'),
                const SizedBox(width: 10),
                _buildWagerType('Carpenter'),
                const SizedBox(width: 10),
                _buildWagerType('Welder'),
                SizedBox(width: 10),
                _buildWagerType('AC Repair'),
                SizedBox(width: 10),
                _buildWagerType('Others'),
              ],
            ),
          ),
          CustomCard(
            children: [
              const Text(
                'Near by',
                style: TextStyle(fontSize: 20,color: Colors.black),
              ),
              DropdownButton(
                value: dropdownValue,
                onChanged: (String? value) {
                  setState(() {
                    dropdownValue = value!;
                    if(dropdownValue=="3KM"){
                      distance=3;
                      print(distance);
                    }else if(dropdownValue=="5KM"){
                      distance=5;
                      print(distance);
                    }else if(dropdownValue=="10KM"){
                      distance=10;
                      print(distance);
                    }else if(dropdownValue=="20KM"){
                      distance=20;
                      print(distance);
                    }else if(dropdownValue=="All"){
                      distance=500000000;
                      print(distance);
                    }

                  });
                },
                style: const TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold),
                isExpanded: true,
                items:
                ['All', '3KM', '5KM', '10KM','20KM']
                    .map((e) => DropdownMenuItem(
                  child: Text(e),
                  value: e,
                ))
                    .toList(),
                underline: Container(
                  height: 3,
                  color: Colors.teal,
                ),
              ),

            ],
          ),
          _typeSelected == null
              ? StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("Wagers")
                  .where("myDistance",isLessThanOrEqualTo: distance)
                      .snapshots(),
                  builder: (context, snapshot) {
                    return !snapshot.hasData
                        ? Center(child: CircularProgressIndicator())
                        : SizedBox(
                            height: MediaQuery.of(context).size.height*0.7,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data?.docs.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot data =
                                    snapshot.data!.docs[index];
                                return GestureDetector(
                                  onTap: () {
                                    getDetailsDialog(
                                        context,
                                        snapshot.data!.docs[index],
                                        data['image'],
                                        data['Name'],
                                        data['experience'],
                                        data['type'],
                                        data['price'],
                                        data['expertise'],

                                        data['description'],
                                        data['uid']);

                                    //    updateDialog(context, snapshot.data.docs[index].id);
                                    // addOrder(
                                    //   context,
                                    //   snapshot.data.docs[index],
                                    //   data.id
                                    // );
                                  },
                                  onLongPress: () {
                                    // deleteData( snapshot.data.docs[index].id);
                                    //Fluttertoast.showToast(msg: "Deleted");
                                  },
                                  child: ProductItem(
                                    documentSnapshot: data,
                                    id: data.id,
                                    title: data['type'],
                                    description: data['description'],
                                    experience: data['experience'],
                                    name: data['Name'],
                                    city: data['city'],
                                    image: data['image'],
                                      myRating:data['myRating'], expertise: 'fgdg',
                                    orders: data['orders'],

                                  ),
                                );
                              },
                            ),
                          );
                  },
                )
              : cat == "All"
                  ? StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("Wagers")
                          .where("myDistance",isLessThanOrEqualTo: distance)
                          .snapshots(),
                      builder: (context, snapshot) {
                        return !snapshot.hasData
                            ? Center(child: CircularProgressIndicator())
                            : SizedBox(
                                height: MediaQuery.of(context).size.height*0.7,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data?.docs.length,
                                  itemBuilder: (context, index) {
                                    DocumentSnapshot data =
                                        snapshot.data!.docs[index];
                                    return GestureDetector(
                                      onTap: () {
                                        getDetailsDialog(
                                            context,
                                            snapshot.data!.docs[index],
                                            data['image'],
                                            data['Name'],
                                            data['experience'],
                                            data['type'],
                                            data['price'],
                                            data['expertise'],

                                            data['description'],
                                            data['uid']);

                                        //    updateDialog(context, snapshot.data.docs[index].id);
                                        // addOrder(
                                        //   context,
                                        //   snapshot.data.docs[index],
                                        //   data.id
                                        // );
                                      },
                                      onLongPress: () {
                                        // deleteData( snapshot.data.docs[index].id);
                                        //Fluttertoast.showToast(msg: "Deleted");
                                      },
                                      child: ProductItem(
                                        documentSnapshot: data,
                                        id: data.id,
                                        title: data['type'],
                                        description: data['description'],
                                        experience: data['experience'],
                                        name: data['Name'],
                                        myRating:data['myRating'],
                                        city: data['city'],

                                        image: data['image'], expertise: 'gcgd',
                                        orders: data['orders'],

                                      ),
                                    );
                                  },
                                ),
                              );
                      },
                    )
                  : StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("Wagers")
                          .where('type', isEqualTo: cat)
                          .where("myDistance",isLessThanOrEqualTo: distance)
                          .snapshots(),
                      builder: (context, snapshot) {
                        return !snapshot.hasData
                            ? Center(child: CircularProgressIndicator())
                            : SizedBox(
                                height: MediaQuery.of(context).size.height*0.7,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data?.docs.length,
                                  itemBuilder: (context, index) {
                                    DocumentSnapshot data =
                                        snapshot.data!.docs[index];
                                    return GestureDetector(
                                      onTap: () {
                                        // getCarouselWidget(data['uid']);
                                        getDetailsDialog(
                                            context,
                                            snapshot.data!.docs[index],
                                            data['image'],
                                            data['Name'],
                                            data['experience'],
                                            data['type'],
                                            data['price'],
                                            data['expertise'],

                                            data['description'],
                                            data['uid']);

                                        //    updateDialog(context, snapshot.data.docs[index].id);
                                        // addOrder(
                                        //   context,
                                        //   snapshot.data.docs[index],
                                        //   data.id
                                        // );
                                      },
                                      onLongPress: () {
                                        // deleteData( snapshot.data.docs[index].id);
                                        //Fluttertoast.showToast(msg: "Deleted");
                                      },
                                      child: ProductItem(
                                        documentSnapshot: data,
                                        id: data.id,
                                        title: data['type'],
                                        description: data['description'],
                                        experience: data['experience'],
                                        name: data['Name'],
                                        city: data['city'],
                                        image: data['image'],
                                        myRating:data['myRating'], expertise: 'gfcgdgd',
                                        orders: data['orders'],
                                      ),
                                    );
                                  },
                                ),
                              );
                      },
                    )
        ],
      ),
    );
  }
  Future<void> addOrder(BuildContext context, selectedDoc, String cUid) async {
    var variable = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();
    return showDialog(
        context: context,
        // barrierDismissible: false,
        builder: (BuildContext context) {
          return Scaffold(
              appBar: AppBar(
                title: Text("Place Order"),
              ),
              body: SingleChildScrollView(
                  child: Container(
                      margin: const EdgeInsets.all(25.0),
                      height: MediaQuery.of(context).size.height,
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(children: <Widget>[


                            profileRow(
                              title: 'Name',
                              subtitle: variable.data()!['first_name'],
                              icon: CupertinoIcons.person_alt_circle,

                            ),
                            SizedBox(
                              height: 15,
                            ),
                            profileRow(
                              title: 'Address',
                              subtitle: variable.data()!['address'],
                              icon: Icons.location_city_outlined,

                            ),
                            SizedBox(
                              height: 15,
                            ),
                            profileRow(
                              title: 'Contact',
                              subtitle: variable.data()!['phone'],
                              icon: Icons.phone,

                            ),
                            SizedBox(height: 15,),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:[
                                  Text('Work Type',style:TextStyle(color: textColor,fontWeight: FontWeight.bold,fontSize: 20),),

                                  Container(
                                    margin: EdgeInsets.only(
                                        top: 12.0, left: 12.0, right: 12.0, bottom: 5.0),
                                    height: 40,
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: [
                                        _buildMType('Basic'),
                                        SizedBox(width: 10),
                                        _buildMType('Standard'),
                                        SizedBox(width: 10),
                                        _buildMType('Premium'),

                                      ],
                                    ),
                                  ),
                                ] ),

                            SizedBox(height: 15,),
                            CustomTextField(
                              label: "Description",
                              controller: descriptionController, keyboardType: TextInputType.text,

                            ),
                            InkWell(
                              onTap: () async {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CircularProgressIndicator();
                                    });
                                var r = "pending";
//addOrder(context, selectedDoc, name, price, time, cUid, sUid)
                                final FirebaseAuth _auth = FirebaseAuth.instance;
                                final User? user = await _auth.currentUser;
                                String proj = FirebaseFirestore.instance
                                    .collection("Requests")
                                    .doc()
                                    .id;
                                // Firebase.Auth.FirebaseUser user1 = await FirebaseAuth.instance.currentUser;
                                FirebaseFirestore.instance
                                    .collection("Requests")
                                    .add({
                                  'user': user!.uid,
                                  'description': descriptionController.text,
                                  'name': _auth.currentUser?.displayName,
                                  'phone': variable.data()!['phone'].toString(),
                                  'address': variable.data()!['address'].toString(),
                                  'wagerID': cUid,
                                  'countReviews':"0",
                                  'workType':_typeSelect,
                                  'contractor':"null",
                                  'userReview':"No reviews available yet",
                                  'myWork':null,
                                  'image':"",

                                  'projID':proj,
                                  'status': "pending",
                                }).then((value) => print("Success"));

                                Navigator.of(context).pop();
                                Get.snackbar(
                                    'Order Placed',
                                    'Successfully',
                                    colorText: Colors.black,
                                    backgroundColor: Colors.white
                                );

                                Fluttertoast.showToast(msg: "Success");
                                //  addOrder(context, selectedDoc, name, price, time, user.uid, sUid,imageUrl,uName,uLocation,uPrice);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 18.0, right: 18.0, top: 20.0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFCD3424),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Send Request",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                    fontFamily: 'MetroPolis'
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ])))));
        });
  }



  Future<void> getDetailsDialog(
      BuildContext context,
      selectedDoc,
      String imag,
      String name,
      String experience,
      String type,
      String price,
      String expertise,
      String description,
      String sUid,
      ) {
    return showDialog(
        context: context,
        // barrierDismissible: false,
        builder: (BuildContext context) {

          final double _w = MediaQuery.of(context).size.width;
          final double _h = MediaQuery.of(context).size.height;


          return Scaffold(
            appBar: AppBar(
              title: Text('Profile'),
            ),
            body: SingleChildScrollView(

              child: Container(
                child: Stack(
                  children: [
                    ImageFiltered(
                      imageFilter: ImageFilter.blur(
                        sigmaX: 1.8,
                        sigmaY: 1.8,
                      ),
                      child: Container(
                        color:Colors.white,
                        height: _h,
                        width: _w,
                      ),
                    ),
                    Positioned(
                      top: _h*.2,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                        child: Container(
                          color: Colors.blue.withOpacity(0.3),
                          width: _w,
                          height: _h * 0.7,
                          padding: const EdgeInsets.all(15),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      top: _h * 0.06,
                                    ),
                                    child: Text(
                                      name,
                                      style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.blueGrey,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(
                                  height: 20,
                                ),
                                profileRow(
                                  title: 'Experience',
                                  subtitle: experience,
                                  icon: LineIcons.bRomBelExperteGmbhCoKg,

                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                profileRow(
                                  title: 'Type',
                                  subtitle: type,
                                  icon: CupertinoIcons.flag_circle_fill,

                                ),
                                SizedBox(
                                  height: 20,
                                ),


                                Row(
                                  children: [
                                    Container(
                                      height: 55,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.note,
                                          size: 17,
                                          color: Colors.yellow,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(child:  Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Description",
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black54,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'MetroPolis'
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          description,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                          ),
                                          maxLines: 3,
                                        ),
                                      ],
                                    ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height:10),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 8,
                                      right: 8,
                                      top: 2,
                                      bottom: 10,
                                    ),
                                    child: FlatButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      minWidth: _w * 0.9,
                                      height: 50,
                                      color: buttonBgColor,
                                      onPressed: () async {
                                        // save current user changes
                                        FirebaseAuth _auth = FirebaseAuth.instance;
                                        final User? user = await _auth.currentUser;
                                        Navigator.push(
                                            context,MaterialPageRoute(builder: (context)=>
                                            ChatPage(
                                              user_id: sUid, timestamp: 0,
                                              type:"Wagers"
                                            ),
                                        ));
                                      },
                                      child: const Text(
                                        'Contact Me',
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

                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 8,
                                      right: 8,
                                      top: 2,
                                      bottom: 10,
                                    ),
                                    child: FlatButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      minWidth: _w * 0.9,
                                      height: 50,
                                      color: buttonBgColor,
                                      onPressed: () async {
                                        // save current user changes
                                        FirebaseAuth _auth = FirebaseAuth.instance;
                                        final User? user = await _auth.currentUser;

                                        myServices(context, selectedDoc, sUid);
                                      },
                                      child: Text(
                                        'My Services',
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'MetroPolis'
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 8,
                                      right: 8,
                                      top: 2,
                                      bottom: 10,
                                    ),
                                    child: FlatButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      minWidth: _w * 0.9,
                                      height: 50,
                                      color: buttonBgColor,
                                      onPressed: () async {
                                        // save current user changes
                                        FirebaseAuth _auth = FirebaseAuth.instance;
                                        final User? user = await _auth.currentUser;

                                        pastProjects(context, selectedDoc, sUid);
                                      },
                                      child: Text(
                                        'Previous Projects',
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'MetroPolis'
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 8,
                                      right: 8,
                                      top: 2,
                                      bottom: 10,
                                    ),
                                    child: FlatButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      minWidth: _w * 0.9,
                                      height: 50,
                                      color: buttonBgColor,
                                      onPressed: () async {
                                        // save current user changes
                                        FirebaseAuth _auth = FirebaseAuth.instance;
                                        final User? user = await _auth.currentUser;

                                        addOrder(context, selectedDoc, sUid);

                                      },
                                      child: Text(
                                        'Send Request',
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'MetroPolis'
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
                    ),
                    Positioned(
                      top: _h * 0.1,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: _w * 0.35),
                        child: GestureDetector(
                          onTap: () {},
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: textColor,
                            backgroundImage: NetworkImage(imag),
                          ),
                        ),
                      ),
                    ),


                  ],
                ),
              ),

            ),
          );
        }
    );
  }

  Future<void> myServices(BuildContext context, selectedDoc, String cUid) {
    return showDialog(
        context: context,
        // barrierDismissible: false,
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text("My Services"),
              centerTitle: true,
            ),
            body: Container(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                FirebaseFirestore.instance.collection("Services").where(
                    'contractor', isEqualTo: cUid).snapshots(),
                builder: (context, snapshot) {
                  return !snapshot.hasData
                      ? Center(child: CircularProgressIndicator())
                      : SizedBox(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot data = snapshot.data!.docs[index];
                        return  InkWell(

                          onTap: () {
                          },

                          onLongPress: () {
                            // deleteData( snapshot.data.docs[index].id);
                            //Fluttertoast.showToast(msg: "Deleted");
                          },
                          child: OrderBoxService(
                              documentSnapshot: data,
                              id: data.id,
                              premium: data['premium'],
                              serviceName: data['serviceName'],
                              material: data['material'],
                              standard: data['standard'],
                              basic: data['basic']
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          );
        });
  }
  Future<void> pastProjects(BuildContext context, selectedDoc, String cUid) {
    return showDialog(
        context: context,
        // barrierDismissible: false,
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Previous Projects"),
              centerTitle: true,
            ),
            body: Container(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                FirebaseFirestore.instance.collection("Requests").where(
                    'wagerID', isEqualTo: cUid).where(
                    'status', isEqualTo: 'complete').snapshots(),
                builder: (context, snapshot) {
                  return !snapshot.hasData
                      ? Center(child: CircularProgressIndicator())
                      : SizedBox(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot data = snapshot.data!.docs[index];
                        return  InkWell(

                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => PastWork(documentSnapshot: data,
                                  id: data.id,
                                  description: data['description'],

                                  address: data['address'],
                                  projectID :data['projID'],
                                  wagerWork: data['myWork'],
                                  userReview: data['userReview'],
                                image: data['image']
                              )),
                            );
                          },

                          onLongPress: () {
                            // deleteData( snapshot.data.docs[index].id);
                            //Fluttertoast.showToast(msg: "Deleted");
                          },
                          child: OrderBox(
                            documentSnapshot: data,
                            id: data.id,
                            description: data['description'],
                            name: data['name'],
                            phone: data['phone'],
                            address: data['address'],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          );
        });
  }

}

class OrderBox extends StatefulWidget {
  final String name;
  final String phone;
  final String id;
  final String description;
  final String address;

  // String weight;
  final DocumentSnapshot documentSnapshot;

  const OrderBox(
      {Key? key,
        required this.name,
        required this.phone,
        required this.id,
        required this.description,
        required this.address,
        required this.documentSnapshot})
      : super(key: key);

  @override
  _OrderBoxState createState() => _OrderBoxState();
}

class _OrderBoxState extends State<OrderBox> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 15.0),
      child: Container(
        padding: EdgeInsets.all(0),
        decoration: BoxDecoration(
          border: Border.all(
              color: Colors.blue.withOpacity(0.2), // set border color
              width: 2.0),
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue.withOpacity(0.1), // set border color
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.name,
                    style:
                    TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
                  Text(widget.address,
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Phone No: ${widget.phone}",
                          style: TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 8.0, bottom: 5),
              child: Text("Description: ${widget.description}"),
            )
          ],
        ),
      ),
    );
  }
}


class PastWork extends StatefulWidget {

  final String id;
  final String description;
  final String address;
  final String projectID;
  final String wagerWork;
  final String userReview;
  final String image;
  // String weight;
  final DocumentSnapshot documentSnapshot;

  const PastWork(
      {Key? key,
        required this.image,
        required this.id,
        required this.description,
        required this.address,
        required this.documentSnapshot,required this.projectID,required  this.wagerWork,required  this.userReview})
      : super(key: key);

  @override
  _PWState createState() => _PWState();
}

class _PWState extends State<PastWork> {
  @override
  Widget build(BuildContext context) {
    final double _w = MediaQuery.of(context).size.width;
    final double _h = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: Text("Project Description"),
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
                            height: _h ,
                            padding: const EdgeInsets.all(15),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Row(
                                    children: [
                                      Container(
                                        height: 55,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.note,
                                            size: 17,
                                            color: Colors.yellow,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      Expanded(child:  Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Required Work",
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Color(0xFFA0A9A5),
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            widget.description,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                            ),

                                            maxLines: 3,
                                          ),


                                        ],
                                      ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        height: 55,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.location_city_sharp,
                                            size: 17,
                                            color: Colors.yellow,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Address",
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Color(0xFFA0A9A5),
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            widget.address,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                            ),

                                            maxLines: 3,
                                          ),


                                        ],
                                      ),

                                    ],
                                  ),

                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        height: 55,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.description_rounded,
                                            size: 17,
                                            color: Colors.yellow,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      Expanded(child:  Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "My Work",
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Color(0xFFA0A9A5),
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            widget.wagerWork,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                            ),

                                            maxLines: 3,
                                          ),


                                        ],
                                      ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Text("Project Photos",style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),),
                                        ),
                                        SizedBox(height: 20,),
                                        Container(
                                          height: 200.0,
                                          width: 330.0,
                                          child: Image.network(widget.image)
                                          // FutureBuilder(
                                          //     future: getCarouselWidget(widget.projectID),
                                          //     builder: (context, snapshot) {
                                          //       return CarouselSlider.builder(
                                          //           slideBuilder: (index) {
                                          //             // DocumentSnapshot sliderImage =
                                          //             // snapshot.data[index];
                                          //
                                          //             return Container(
                                          //                 child:
                                          //                 //snapshot.data == null
                                          //                      Text("No photos to show",style: TextStyle(
                                          //                   backgroundColor: Colors.greenAccent,
                                          //
                                          //                 ),));
                                          //                    // : Image.network(sliderImage['url']));
                                          //           },
                                          //           slideTransform: CubeTransform(),
                                          //           itemCount: 3);
                                          //     }),
                                        ),


                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        height: 55,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.comment,
                                            size: 17,
                                            color: Colors.yellow,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      Expanded(  child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Feedback",
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Color(0xFFA0A9A5),
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            widget.userReview,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                            ),

                                            maxLines: 3,
                                          ),


                                        ],
                                      ),

                                      ),

                                    ],
                                  ),


                                ],
                              ),
                            ),

                          ),
                        ),

                      ],
                    ),

                  ),

                ]
            )
        )
    );
  }

  Future getCarouselWidget(String idC) async {
    User? user = FirebaseAuth.instance.currentUser;

    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore
        .collection("PastProject")
        .where('projID', isEqualTo: idC)
        .get();
    return qn.docs;
    setState(() {});
  }
}

class OrderBoxService extends StatefulWidget {
  final String serviceName;
  final String basic;
  final String id;
  final String premium;
  final String standard;
  final String material;

  // String weight;
  final DocumentSnapshot documentSnapshot;

  const OrderBoxService(
      {Key? key,

        required this.id,
        required this.documentSnapshot,
        required this.premium,
        required this.serviceName,
        required this.material,required  this.standard,
        required this.basic})
      : super(key: key);

  @override
  _OrderBoxServiceState createState() => _OrderBoxServiceState();
}

class _OrderBoxServiceState extends State<OrderBoxService> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 15.0),
      child: Container(
        padding: EdgeInsets.all(0),
        decoration: BoxDecoration(
          border: Border.all(
              color: Colors.blue.withOpacity(0.1), // set border color
              width: 2.0),
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue.withOpacity(0.2), // set border color
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.serviceName,
                    style:
                    TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
                  Text(widget.material,
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Basic: ",
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold)),
                  Text('${widget.basic} Square meter',
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold))
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Standard: ",
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold)),
                  Text('${widget.standard} Square meter',
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Premium: ",
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold)),
                  Text('${widget.premium} Square meter',
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold))
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}