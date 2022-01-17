import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalconstruction/app/constants/app_constants.dart';
import 'package:digitalconstruction/app/routes/app_pages.dart';
import 'package:digitalconstruction/app/widgets/custom_text_field.dart';
import 'package:digitalconstruction/app/widgets/progress_custom.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddConstructor extends StatefulWidget {
  @override
  _AddConstructorState createState() => _AddConstructorState();
}

class _AddConstructorState extends State<AddConstructor> {
  File? _image;
  TextEditingController _nameController=TextEditingController(),
      _emailController=TextEditingController(),
      _passController=TextEditingController(),
      _numberController=TextEditingController(),
      _cnicController=TextEditingController(),
      _proDesController=TextEditingController(),
      _expController=TextEditingController(),
      _cityController=TextEditingController(),
      _priceController=TextEditingController(),
      _expertiseController=TextEditingController();
  String _typeSelected = '';

  DatabaseReference? _ref;

  get bold => null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController = TextEditingController();
    _numberController = TextEditingController();
    _priceController = TextEditingController();

    _cnicController = TextEditingController();
    _cityController = TextEditingController();
    _emailController = TextEditingController();
    _passController = TextEditingController();

    _proDesController = TextEditingController();
    _expController = TextEditingController();
    _expertiseController = TextEditingController();
    getCurrentLocation();

    _ref = FirebaseDatabase.instance.reference().child('Constructors');
  }
  double? latitude;
  double? longitude;
  Future getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission != PermissionStatus.granted) {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission != PermissionStatus.granted)
        getLocation();
      return;
    }
    getLocation();
  }
  GoogleMapController? _controllers ;

  List<Address> results = [];
  LatLng latlong=LatLng(0,0);
  getLocation() async
  {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position.latitude);



    setState(() {

      longitude=position.longitude;
      latitude=position.latitude;
    });
  }

  final ImagePicker _picker=ImagePicker();
  _imgFromCamera() async {
    final image = await _picker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = image as File;
    });
  }

  _imgFromGallery() async {
    final image = await _picker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image as File;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
  bool isSelected=false;
  List<String> types=[];
  Widget _buildConstructorType(String title ,int index) {
    return InkWell(
      child: Container(
        height: 40,
        width: 110,
        decoration: BoxDecoration(
          // ignore: unrelated_type_equality_checks
          color: isSelected && (types.contains(title)) ? Colors.blue : Colors.pinkAccent,
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
          if(types.contains(title)){
            _typeSelected ="";

            types.remove(title);
          }
          else{
            isSelected=true;
            types.add(title);}
        });
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    var focusnode = new FocusNode();
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.pinkAccent,
        title: const Text('Register Constructor',),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(focusnode);
        },
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Center(
                //   child: GestureDetector(
                //     onTap: () {
                //       _showPicker(context);
                //     },
                //     child: Container(
                //       decoration: BoxDecoration(
                //         color: Colors.green,
                //
                //         borderRadius: BorderRadius.all(Radius.circular(10)),
                //         boxShadow: [
                //           BoxShadow(
                //               color: Colors.white.withOpacity(0.1),
                //               blurRadius: 10,
                //               offset: Offset(0, 5)),
                //         ],
                //         border:
                //             Border.all(color: Colors.white.withOpacity(0.05)),
                //         //  gradient: gradient,
                //       ),
                //       child: _image != null
                //           ? Container(
                //               width: MediaQuery.of(context).size.width * 0.5,
                //               height: MediaQuery.of(context).size.height * 0.2,
                //               decoration: BoxDecoration(
                //                 color: Colors.green,
                //
                //                 borderRadius:
                //                     BorderRadius.all(Radius.circular(10)),
                //                 boxShadow: [
                //                   BoxShadow(
                //                       color: Colors.white.withOpacity(0.1),
                //                       blurRadius: 10,
                //                       offset: Offset(0, 5)),
                //                 ],
                //                 border: Border.all(
                //                     color: Colors.white.withOpacity(0.05)),
                //                 //  gradient: gradient,
                //               ),
                //               child: ClipRRect(
                //                 borderRadius:
                //                     BorderRadius.all(Radius.circular(10)),
                //                 child: Image.file(
                //                   _image,
                //                   width: 100,
                //                   height: 100,
                //                   fit: BoxFit.cover,
                //                 ),
                //               ),
                //             )
                //           : Container(
                //               width: MediaQuery.of(context).size.width * 0.35,
                //               height: MediaQuery.of(context).size.height * 0.1,
                //               decoration: BoxDecoration(
                //                 color: Colors.green,
                //                 borderRadius:
                //                     BorderRadius.all(Radius.circular(10)),
                //                 boxShadow: [
                //                   BoxShadow(
                //                       color: Colors.white.withOpacity(0.1),
                //                       blurRadius: 10,
                //                       offset: Offset(0, 5)),
                //                 ],
                //                 border: Border.all(
                //                     color: Colors.white.withOpacity(0.05)),
                //                 //  gradient: gradient,
                //               ),
                //               child: ClipRRect(
                //                 borderRadius:
                //                     BorderRadius.all(Radius.circular(10)),
                //                 child: Icon(
                //                   Icons.camera_alt,
                //                   color: Colors.grey[800],
                //                 ),
                //               ),
                //             ),
                //     ),
                //   ),
                // ),

                CustomTextField(
                  controller: _nameController,
                  label: "Enter Name",
                  isPassword: false,
                  keyboardType: TextInputType.name,
                ),
                CustomTextField(
                  controller: _emailController,
                  label: "Enter Email",
                  isPassword: false,
                  keyboardType: TextInputType.emailAddress,
                ),
                CustomTextField(
                  controller: _passController,
                  label: "Enter Password",
                  isPassword: true,
                  keyboardType: TextInputType.visiblePassword,
                ),
                CustomTextField(
                  controller: _numberController,
                  label: "Enter Phone",
                  isPassword: false,
                  keyboardType: TextInputType.phone,
                ),
                CustomTextField(
                  controller: _cnicController,
                  label: "Enter CNIC",
                  isPassword: false,
                  keyboardType: TextInputType.number,
                ),
                CustomTextField(
                  controller: _cityController,
                  label: "Enter City",
                  isPassword: false,
                  keyboardType: TextInputType.text,
                ),

                CustomTextField(
                  controller: _expController,
                  label: "Enter Experience",
                  isPassword: false,
                  keyboardType: TextInputType.text,
                ),

                CustomTextField(
                  controller: _proDesController,
                  label: "Enter Description",
                  isPassword: false,
                  keyboardType: TextInputType.text,
                ),
                SizedBox(
                  height: 10.0,
                ),

                Container(
                  height: 40,


                  child:
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("AllConstType")
                        .snapshots(),
                    builder: (context, snapshot) {
                      return !snapshot.hasData
                          ? Center(child: CircularProgressIndicator())
                          : SizedBox(
                        height: MediaQuery.of(context).size.height,

                        child: ListView.builder(


                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot data =
                            snapshot.data!.docs[index];
                            return GestureDetector(
                              onTap: () {


                              },
                              onLongPress: () {
                                // deleteData( snapshot.data.docs[index].id);
                                //Fluttertoast.showToast(msg: "Deleted");
                              },
                              child: Row(
                                  children:[
                                    _buildConstructorType(data['typeName'],index),
                                    SizedBox(width: 10,)
                                  ]
                              ),
                            );
                          },

                        ),

                      );

                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                // Padding(
                //     padding: EdgeInsets.only(right: 20),
                //     child: Container(
                //       width: double.infinity,
                //       child: InkWell(
                //         onTap: () {
                //           addRequest(context);
                //         },
                //         child: Text(
                //           "Add other Type ?",
                //           style: TextStyle(color: Colors.blue),
                //           textAlign: TextAlign.right,
                //         ),
                //       ),
                //     )),
                // SizedBox(height: 20,)
                // ,
                InkWell(
                  onTap: () async {
                    // Reference ref = FirebaseStorage.instance.ref().child(
                    //     "image" +
                    //         DateTime.now().toString()); //generate a unique name
                    // await ref
                    //     .putFile(File(_image!.path)); //you need to add path here
                    // String imageUrl = await ref.getDownloadURL();

                    upload();
                    Get.snackbar('Please wait for Conformation', '',
                        //fontWeight: FontWeight.bold,
                        colorText: Colors.white,
                        backgroundColor: Colors.blue);
                    // Get.offNamed(Routes.LOGIN);
                  },
                  child: Container(
                    height: 50.0,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Center(child: Text("Register",
                    style: TextStyle(fontSize: 25, fontWeight: bold, color: Colors.white),
                    ),
                    
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.offNamed(Routes.LOGIN);
                  },
                  child: Center(
                    child: AutoSizeText(
                      'Login Instead',
                      maxLines: 1,
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Future<String> uploadingData(
  //     File _img,
  //     String _productName,
  //     String _productPrice,
  //     String category,String det,String time) async {
  //
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return ProgressBar(
  //           message: "Please Wait...",
  //         );
  //       });
  //
  //   title=titleController.text;
  //   price=priceController.text;
  //   final User user = await FirebaseAuth.instance.currentUser;
  //   print(user.uid);
  //   Reference ref = FirebaseStorage.instance
  //       .ref()
  //       .child("image" + DateTime.now().toString()); //generate a unique name
  //   await ref.putFile(File(_image.path)); //you need to add path here
  //   String imageUrl = await ref.getDownloadURL();
  //
  //   FirebaseFirestore.instance.collection("Foods").add({
  //     'title': _productName,
  //     'price':_productPrice,
  //
  //     'category': category,
  //     "image": imageUrl,
  //     "details":det,
  //     "time":time,
  //     'uid':user.uid,
  //   }).catchError((e) {
  //     print(e);
  //   });
  //   setState(() {
  //     timeController.clear();
  //     titleController.clear();
  //     desciptionController.clear();
  //     priceController.clear();
  //   });
  //   Navigator.pop(context);
  //   Fluttertoast.showToast(msg: "Success");
  //   //  await  databaseReference.collection("recipee").add(
  //   //     {
  //   //
  //   //       'name': _productName,
  //   //       'quantity': _productPrice,
  //   //       'description': _isFavourite,
  //   //       'calories': _isCal,
  //   //       'category':category,
  //   //      "image":imageUrl
  //   //       }
  //   // ).then((value){
  //   //   print(value.id);
  //   // });
  //   // Navigator.pop(context);
  //   imageUrl = null;
  // }
  //
  Future<void> addRequest(BuildContext context) {
    TextEditingController serviceNameController = TextEditingController();
    TextEditingController basicController = TextEditingController();
    TextEditingController standardController = TextEditingController();
    TextEditingController premiumController = TextEditingController();
    return showDialog(
        context: context,
        // barrierDismissible: false,
        builder: (BuildContext context) {
          return Scaffold(
              appBar: AppBar(
                title: Text("Request"),
              ),
              body: SingleChildScrollView(
                  child: Container(
                      margin: EdgeInsets.only(top: 20.0),
                      height: MediaQuery
                          .of(context)
                          .size
                          .height,
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: new Column(children: <Widget>[

                            TextField(
                              decoration: InputDecoration(
                                  labelText: "Type Name",
                                  border: OutlineInputBorder(

                                  )
                              ),

                              controller: serviceNameController,
                            ),
                            InkWell(
                              onTap: () async {

                                num b=0;
                                FirebaseFirestore.instance
                                    .collection("ServiceRequests")
                                    .add({


                                  'name': serviceNameController.text,
                                  'cat':"AllConstType",
                                  'add':b,




                                }).then((value) => print("Success"));
                                Get.back();


                                // Navigator.of(context).pop();
                                Fluttertoast.showToast(msg: "Success");
                                //  addOrder(context, selectedDoc, name, price, time, user.uid, sUid,imageUrl,uName,uLocation,uPrice);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 18.0, right: 18.0, top: 20.0),
                                child: Container(
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFCD3424),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Request To add",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ])))));
        });
  }


  Future<void> upload() async {

    String name,
        email,
        pass,
        phone,
        cnic,
        city,
        description,
        experience,
        expertise,
        price;
    email = _emailController.text;
    pass = _passController.text;
    phone = _numberController.text;
    city = _cityController.text;
    description = _proDesController.text;
    experience = _expController.text;


    cnic = _cnicController.text;
    price = _priceController.text;
    // Reference ref = FirebaseStorage.instance
    //     .ref()
    //     .child("image" + DateTime.now().toString()); //generate a unique name
    // await ref.putFile(File(_image!.path)); //you need to add path here
    // String imageUrl = await ref.getDownloadURL();

    name = _nameController.text;
    try {
      String ty="";
      if(types.isNotEmpty){
        int leng=types.length;
        int i=0;
        // ignore: unnecessary_statements
        for(i;i<leng;i++){
          ty=types[i];
        }
      }
      final num b=3;
      double myDistance=0;


      FirebaseAuth _auth = FirebaseAuth.instance;
      final User? user = await _auth.currentUser;
      _auth
          .createUserWithEmailAndPassword(email: email, password: pass)
          .then((signedInUser) {
        FirebaseFirestore.instance
            .collection('Constructors')
            .doc(signedInUser.user!.uid)
            .set({
          'email': email,
          'Name': name,
          'cnic': cnic,
          "image": 'https://firebasestorage.googleapis.com/v0/b/digital-construction-969cd.appspot.com/o/commercia.jpg?alt=media&token=dc5b5838-6216-4fc2-8112-7273c8992a31',
          'experience': experience,
          'expertise': 'expertise',
          'description': description,
          'phone': phone,
          'city': city,
          'uid': signedInUser.user!.uid,
          'type': ty,
          'orders': "0",
          'totalRating': "0",
          'totalReviews': "0",
          'longitude':longitude,
          'latitude':latitude,
          'myDistance':myDistance,
          'myRating': b,
          'price':'5000',
          'isApproved': false,


        }).then((value) {
          if (signedInUser != null) {
            print("suceess");

            Get.offNamed(Routes.LOGIN);
          }
        }).catchError((e) {
          print(e);
        });
      }).catchError((e) {
        print(e);
      });

      await FirebaseAuth.instance.currentUser?.updateProfile(
        displayName: name,
      );

    } on FirebaseAuthException catch (e) {
      String message="";
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      }
      Get.back();
      Get.snackbar(
        'Error',
        message,
        colorText: kPinkColor,
      );
    } catch (e) {
      Get.back();
      Get.snackbar(
        'Error Occurred',
        'Something went wrong. Try again',
        colorText: kPinkColor,
      );
    }
  }
}
