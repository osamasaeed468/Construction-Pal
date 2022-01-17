import 'dart:math';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalconstruction/app/constants/helpers.dart';
import 'package:digitalconstruction/app/widgets/card.dart';
import 'package:digitalconstruction/app/widgets/color_theme.dart';
import 'package:digitalconstruction/app/widgets/dropdown.dart';
import 'package:digitalconstruction/app/widgets/product_item.dart';
import 'package:digitalconstruction/app/widgets/profile_row.dart';
import 'package:digitalconstruction/models/constructor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoder/model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:line_icons/line_icons.dart';

import 'package:cupertino_icons/cupertino_icons.dart';

import 'chat.dart';

class AllContractors extends StatefulWidget {
  final double latitude;
  final double longitude;
  AllContractors({
    Key? key,
    required this.latitude,
    required this.longitude,
  }) : super(key: key);

  @override
  _AllContractorsState createState() => _AllContractorsState();
}

class _AllContractorsState extends State<AllContractors> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController expertiseController = TextEditingController();

  String _typeSelected = '';
String pick=DateTime.now().toString();
String dueDate=DateTime.now().toString();
  String month="";
  String mon="";
DateTime time=DateTime.now();
  String _typeSel = '';
  String d="";
  String da="";
  var cat='All';
  late DateTime date2;
  late DateTime  date1;
  Future<void> selectDueDate(BuildContext context) async {
    DateTime? _dueDate=await showDatePicker(
        context: context,
        initialDate:time,
        firstDate: DateTime(2000),
        lastDate: DateTime(2050)
    );
    {
      if (_dueDate?.month == 1 || _dueDate?.month == 2 || _dueDate?.month == 3 ||
          _dueDate?.month == 4 || _dueDate?.month == 5 || _dueDate?.month == 6 ||
          _dueDate?.month == 7 || _dueDate?.month == 8 || _dueDate?.month == 9) {
        mon = "0" + _dueDate!.month.toString();
      }else{
        mon=_dueDate!.month.toString();
      }
    }
    {
      if (_dueDate.day == 1 || _dueDate.day == 2 || _dueDate.day == 3 ||
          _dueDate.day == 4 || _dueDate.day == 5 || _dueDate.day == 6 ||
          _dueDate.day == 7 || _dueDate.day == 8 || _dueDate.day == 9) {
        d = "0" + _dueDate.day.toString();
      }else{
        d=_dueDate.day.toString();
      }
    }
    if(_dueDate!=null&&_dueDate!=time){
      dueDate=_dueDate.year.toString()+"-"+mon+"-"+d;
      date2=_dueDate;

    }
  }

  Future<void> selectDate(BuildContext context) async {
  DateTime? _date=await showDatePicker(
      context: context,
      initialDate:time,
      firstDate: DateTime(2000),
      lastDate: DateTime(2050)
  );
  {
    if (_date?.day == 1 || _date?.day == 2 || _date?.day == 3 || _date?.day == 4 ||
        _date?.day == 5 || _date?.day == 6 || _date?.day == 7 || _date?.day == 8 ||
        _date?.day == 9) {
      da = "0" + _date!.day.toString();
    }else{
      da=_date!.day.toString();
    }
  }
  {
    if (_date.month == 1 || _date.month == 2 || _date.month == 3 ||
        _date.month == 4 || _date.month == 5 || _date.month == 6 ||
        _date.month == 7 || _date.month == 8 || _date.month == 9) {
      month = "0" + _date.month.toString();
    }
    else{
      month=_date.month.toString();
    }
  }
  if(_date!=null&&_date!=time){
    pick=_date.year.toString()+"-"+month+"-"+da;
date1=_date;
  }
}
  Widget _buildConstructorType(String title) {
    return InkWell(
      child: Container(
        height: 40,
        width: 110,
        decoration: BoxDecoration(
          color: _typeSelected == title ? Colors.blue : const Color(0xFFCD3424),
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
          _typeSelected = title;
        });
      },
    );
  }

  Widget _buildProjectType(String title) {
    return InkWell(
      child: Container(
        height: 40,
        width: 110,
        decoration: BoxDecoration(
          color: _typeSel == title ? Colors.blue : Color(0xFFCD3424),
          borderRadius: BorderRadius.circular(5),
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
          _typeSel = title;
        });
      },
    );
  }
String _typeSelect="";
  Widget _buildMType(String title) {
    return InkWell(
      child: Container(
        height: 40,
        width: 110,
        decoration: BoxDecoration(
          color: _typeSelect == title ? Colors.blue : Color(0xFFCD3424),
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

bool searchState=false;
  List<Constructors> allConsList = [];
double? conLati;
double? conLong;
  double myDistance=4;
  updateConstructor(){
    allConsList=Helper.allConsList;
    for(int i=0;i<allConsList.length;i++){
      Constructors constructor=allConsList[i];
      conLati=constructor.latitude.toDouble();
      print("constructor latitude"+conLati.toString());

      conLong=constructor.longitude.toDouble();
      print("constructor lotitude"+conLong.toString());
      print("My latitude"+widget.latitude.toString());
      print("My longitude"+widget.longitude.toString());
      calculateDistance(widget.latitude, widget.longitude, conLati, conLong);
      String uid=constructor.uid;
      FirebaseFirestore.instance.collection('Constructors').doc(uid).update(
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

  String dropdownValue="All";
  double distance=20000;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    updateConstructor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

       title: const Text("Constructors",style: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: 'MetroPolis',
        ),),
        centerTitle: true,
      ),
      body: Stack(
      children: [
        Positioned(
      child: SingleChildScrollView(
        child: Column(
        children:[
          Container(
            margin: const EdgeInsets.only(
                top: 12.0, left: 12.0, right: 12.0, bottom: 5.0),
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildConstructorType('All'),
                const SizedBox(width: 10),
                _buildConstructorType('Residential'),
                const SizedBox(width: 10),
                _buildConstructorType('Commercial'),
                const SizedBox(width: 10),
                _buildConstructorType('Infrastructural'),
                const SizedBox(width: 10),
                _buildConstructorType('Painter'),
                const SizedBox(width: 10),
                _buildConstructorType('Others'),
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
                      distance=50000000;
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
                .collection("Constructors")
            .where('myDistance', isLessThanOrEqualTo: distance)
                .snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? Center(child: CircularProgressIndicator())
                  : SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height*0.7,
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
                          data['description'],
                          data['uid'],
                          data['expertise'],
                        );
                      },
                      onLongPress: () {
                        // deleteData( snapshot.data.docs[index].id);
                        //Fluttertoast.showToast(msg: "Deleted");
                      },
                      child: ProductItem(
                        documentSnapshot: data,
                        id: data.id,
                        title: data['type'],
                        description: data['expertise'],
                        experience: data['experience'],
                        name: data['Name'],
                        myRating:data['myRating'],
                        city: data['city'],
                        image: data['image'], expertise: 'dfgf', orders: data['orders'],
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
                .collection("Constructors")
                .where('myDistance', isLessThanOrEqualTo: distance)
                .snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? Center(child: CircularProgressIndicator())
                  : SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height*0.7,
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
                          data['description'],
                          data['uid'],
                          data['expertise'],
                        );
                      },
                      onLongPress: () {
                        // deleteData( snapshot.data.docs[index].id);
                        //Fluttertoast.showToast(msg: "Deleted");
                      },
                      child: ProductItem(
                        documentSnapshot: data,
                        id: data.id,
                        title: data['type'],
                        description: data['expertise'],
                        experience: data['experience'],
                        name: data['Name'],
                        city: data['city'],
                        image: data['image'],
                          myRating:data['myRating'], expertise: 'hvhhch',
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
                .collection("Constructors")
                .where('type',isEqualTo: cat)
                .where('myDistance', isLessThanOrEqualTo: distance)
                .snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? Center(child: const CircularProgressIndicator())
                  : SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height*0.7,
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
                          data['description'],
                          data['uid'],
                          data['expertise'],
                        );

                      },
                      onLongPress: () {
                        // deleteData( snapshot.data.docs[index].id);
                        //Fluttertoast.showToast(msg: "Deleted");
                      },
                      child: ProductItem(
                        documentSnapshot: data,
                        id: data.id,
                        title: data['type'],
                        description: data['expertise'],
                        experience: data['experience'],
                        name: data['Name'],
                        city: data['city'],
                        image: data['image'],
                          myRating:data['myRating'], expertise: 'hjgjgjhv',
                        orders: data['orders'],

                      ),
                    );
                  },
                ),
              );
            },
          )
    ]),
      ))
      ],
        ),
    );
  }

  Future<void> addOrder(BuildContext context, selectedDoc, String cUid) async {
    final double _w = MediaQuery.of(context).size.width;
    final double _h = MediaQuery.of(context).size.height;

    FirebaseAuth _auth = FirebaseAuth.instance;

    final User? user = _auth.currentUser;
    var variable = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();
    String name="";
    String address="";
    String phone="";
    if(variable.get('first_name')!=null){
      name=variable.data()!['first_name'];
    }
    if(variable.get('phone')!=null){
      phone=variable.data()!['phone'];
    }
    if(variable.get('address')!=null){
      address=variable.data()!['address'];
    }

    return showDialog(
        context: context,
        // barrierDismissible: false,
        builder: (BuildContext context) {
          return Scaffold(
              appBar: AppBar(
                title: const Text("Place Order"),
              ),
              body: SingleChildScrollView(
                  child:  Stack(

                      children:[
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(children: <Widget>[
                              profileRow(
                                title: 'Name',
                                subtitle:name,
                               // variable.data()!['first_name'] !=null ? variable.data()!['first_name']:'Tabish',
                                icon: CupertinoIcons.person_alt_circle,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              profileRow(
                                title: 'Address',
                                subtitle: address,
                                //variable.data()!['address']!=null?variable.data()!['address']:'Multan',
                                icon: Icons.location_city_outlined,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              profileRow(
                                title: 'Contact',
                                subtitle: phone,
                                //variable.data()!['phone']!=null?variable.data()!['phone']:'032112345666',
                                icon: Icons.phone,
                              ),
                              SizedBox(height: 15,),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:[
                                    Text('Project Type',style:TextStyle(color: textColor,fontWeight: FontWeight.bold,fontSize: 20),),

                                    Container(

                                      margin: const EdgeInsets.only(
                                          top: 12.0, left: 12.0, right: 12.0, bottom: 5.0),
                                      height: 40,
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: [

                                          _buildProjectType('Residential'),
                                          SizedBox(width: 10,),
                                          _buildProjectType('Commercial'),
                                          SizedBox(width: 10),
                                          _buildProjectType('Infrastructural'),
                                          SizedBox(width: 10),
                                          _buildProjectType('Painter'),
                                          SizedBox(width: 10),
                                          _buildProjectType('Carpenter'),
                                        ],
                                      ),
                                    ),
                                  ]
                              ),
                              SizedBox(
                                height: 15,
                              ),

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
                              SizedBox(
                                height: 15,
                              ),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:[
                                    Text('Start Date',style:TextStyle(color:textColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold
                                    )),
                                    TextField(
                                        onTap: (){
                                          setState(() {
                                            selectDate(context);
                                          });
                                        },
                                        readOnly: true,

                                        decoration:InputDecoration(
                                            hintText: pick,
                                            border: OutlineInputBorder(

                                            )
                                        )
                                    ),
                                  ]
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:[
                                    Text('Due Date',style:TextStyle(color:textColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold
                                    )),
                                    TextField(
                                        onTap: (){
                                          setState(() {
                                            selectDueDate(context);
                                          });
                                        },
                                        readOnly: true,
                                        decoration:InputDecoration(
                                            hintText: dueDate,
                                            border: OutlineInputBorder(
                                            )
                                        )
                                    ),
                                  ]
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              TextField(

                                  controller: descriptionController,
                                  decoration:const InputDecoration(
                                      labelText: "Description",
                                      border: OutlineInputBorder(

                                      )
                                  )
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Container(
                                height: 50,
                                child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  minWidth : _w * 0.9,

                                  color: const Color(0xFFCD3424),
                                  child: const Text("Send Request", style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontFamily: 'MetroPolis',
                                  ),),
                                  onPressed: () async {
                                    final difference = date2.difference(date1).inDays;
                                    FirebaseAuth _auth = FirebaseAuth.instance;
                                    String proj = FirebaseFirestore.instance
                                        .collection("Requests")
                                        .doc()
                                        .id;
                                    final User? user = await _auth.currentUser;
                                    FirebaseFirestore.instance
                                        .collection("Requests")
                                        .add({
                                      'user': user!.uid,
                                      'serviceType':_typeSel,
                                      'description': descriptionController.text,
                                      'name': user.displayName,
                                      'dueTime': dueDate,
                                      'start':pick,
                                      'phone': variable.data()!['phone'].toString(),
                                      'workType':_typeSelect,
                                      'address': variable.data()!['address'].toString(),
                                      'contractor': cUid,
                                      'image':"",
                                      'projID': proj,
                                      'countReviews':"0",
                                      'dueDays':difference.toString(),
                                      'userReview':"Customer has not reviewed yet",
                                      'myWork':null,

                                      'status': "pending",
                                    }).then((value) => print("Success"));
                                    Get.back();

                                    Get.snackbar(
                                        'Order Placed',
                                        'Successfully',
                                        colorText: Colors.black,
                                        backgroundColor: Colors.white
                                    );
                                    // Navigator.of(context).pop();
                                    Fluttertoast.showToast(msg: "Success");
                                    //  addOrder(context, selectedDoc, name, price, time, user.uid, sUid,imageUrl,uName,uLocation,uPrice);
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                            ]))
                      ]
                  )));
        });
  }



  Future<void> getDetailsDialog(BuildContext context,
      selectedDoc,
      String imag,
      String name,
      String experience,
      String type,
      String price,
      String description,
      String sUid,
      String expertise
      ) {
    return showDialog(
        context: context,
        // barrierDismissible: false,
        builder: (BuildContext context) {
          final double _w = MediaQuery.of(context).size.width;
          final double _h = MediaQuery.of(context).size.height;
          return Scaffold(
            appBar: AppBar(
              title: const Text('Profile',style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'MetroPolis',
              ),),
            ),
            body:


            Stack(
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
                    borderRadius: const BorderRadius.only(
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
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.blueGrey,
                                      fontFamily: 'MetroPolis',
                                      fontWeight:FontWeight.bold
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 20,
                            ),
                            profileRow(
                              title: 'Experience',
                              subtitle: experience,
                              icon: LineIcons.bRomBelExperteGmbhCoKg,

                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            profileRow(
                              title: 'Type',
                              subtitle: type,
                              icon: CupertinoIcons.flag_circle_fill,
                              

                            ),
                            const SizedBox(
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
                                  child: const Center(
                                    child: Icon(
                                      Icons.note,
                                      size: 17,
                                      color: Colors.yellow,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(child:  Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Description",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black54,
                                        fontFamily: 'MetroPolis',
                                        fontWeight: FontWeight.bold
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
                                  color: Colors.blueAccent[200],
                                  onPressed: () async {
                                    // save current user changes
                                    FirebaseAuth _auth = FirebaseAuth.instance;
                                    final User? user = await _auth.currentUser;
                                    Navigator.push(
                                        context,MaterialPageRoute(builder: (context)=>
                                        ChatPage(
                                          user_id: sUid, timestamp: 0,type:"Constructors",
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
                                  color: Colors.blueAccent[200],
                                  onPressed: () async {
                                     myServices(context, selectedDoc, sUid);
                                  },
                                  child: const Text(
                                    'My Services',
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
                                  color: Colors.blueAccent[200],
                                  onPressed: () async {
                                    myTeam(context, selectedDoc, sUid);
                                  },
                                  child: const Text(
                                    'My Team',
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
                                  color: Colors.blueAccent[200],
                                  onPressed: () async {
                                     pastProjects(context, selectedDoc, sUid);
                                  },
                                  child: const Text(
                                    'Previous Projects',
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
                                  color: Colors.blueAccent[200],
                                  onPressed: () async {
                                    // save current user changes
                                    FirebaseAuth _auth = FirebaseAuth.instance;
                                    final User? user = await _auth.currentUser;
                                    addOrder(context, selectedDoc, sUid);
                                  },
                                  child: const Text(
                                    'Send Request',
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
              title: const Text("Previous Projects"),
              centerTitle: true,
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream:
              FirebaseFirestore.instance.collection("Requests").where(
                  'contractor', isEqualTo: cUid).where(
                  'status', isEqualTo: 'complete').snapshots(),
              builder: (context, snapshot) {
                return !snapshot.hasData
                    ? const Center(child: CircularProgressIndicator())
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
                                constructorWork: data['myWork'],
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
          );
        });
  }
}

Future<void> myTeam(BuildContext context, selectedDoc, String cUid) {
  return showDialog(
      context: context,
      // barrierDismissible: false,
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("My Team"),
            centerTitle: true,
          ),
          body: Container(
            child: StreamBuilder<QuerySnapshot>(
              stream:
              FirebaseFirestore.instance.collection("Teams").where(
                  'contractor', isEqualTo: cUid).snapshots(),
              builder: (context, snapshot) {
                return !snapshot.hasData
                    ? const Center(child: CircularProgressIndicator())
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
                        child: OrderBoxTeam(
                          documentSnapshot: data,
                          id: data.id,
                          expertise: data['expertise'],
                          name: data['name'],
                          type: data['type'],
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

Future<void> myServices(BuildContext context, selectedDoc, String cUid) {
  return showDialog(
      context: context,
      // barrierDismissible: false,
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("My Services"),
            centerTitle: true,
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream:
            FirebaseFirestore.instance.collection("Services").where(
                'contractor', isEqualTo: cUid).snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? const Center(child: CircularProgressIndicator())
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
        );
      });
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
              color: Colors.blue.withOpacity(0.1),
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
                    const TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
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
        required this.documentSnapshot,required  this.premium, required this.serviceName,
        required this.material,required  this.standard,required  this.basic})
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
              color: Colors.black.withOpacity(0.1), // set border color
              width: 2.0),
          borderRadius: BorderRadius.circular(10),
          color: Colors.lightBlue.withOpacity(0.1), // set border color
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 3), // changes position of shadow
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
              padding: const EdgeInsets.only(left: 10.0, right: 10),
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


class OrderBoxTeam extends StatefulWidget {
  final String name;
  final String id;
  final String type;
  final String expertise;

  // String weight;
  final DocumentSnapshot documentSnapshot;

  const OrderBoxTeam(
      {Key? key,
        required this.name,

        required this.id,
        required this.documentSnapshot,required  this.expertise,required this.type})
      : super(key: key);

  @override
  _OrderBoxTeamState createState() => _OrderBoxTeamState();
}

class _OrderBoxTeamState extends State<OrderBoxTeam> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 15.0),
      child: Container(
        padding: EdgeInsets.all(0),
        decoration: BoxDecoration(
          border: Border.all(
              color: Colors.black.withOpacity(0.3), // set border color
              width: 2.0),
          borderRadius: BorderRadius.circular(10),
          color: Colors.lightBlue.withOpacity(0.1), // set border color
          boxShadow: [
            BoxShadow(
              color: Colors.lightBlue.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 1,
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
                  Text(widget.type,
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8.0, bottom: 7.0,right: 8.0),
              child: Text("Expertise: ${widget.expertise}"),
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
  final String constructorWork;
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
        required this.documentSnapshot,required  this.projectID,required  this.constructorWork, required  this.userReview})
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
                            height: _h * 0.8,
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
                                          const Text(
                                            "Required Work",
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Color(0xFFA0A9A5),
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            widget.description,
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
                                            widget.constructorWork,
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
                                          //                 //    ?
                                          //                 Text("No photos to show",style: TextStyle(
                                          //                   backgroundColor: Colors.greenAccent,
                                          //
                                          //                 ),));
                                          //                  //   : Image.network(sliderImage['url']));
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
                                      Expanded(child:Column(
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