import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalconstruction/app/constants/app_constants.dart';
import 'package:digitalconstruction/app/routes/app_pages.dart';
import 'package:digitalconstruction/app/widgets/custom_text_field.dart';
import 'package:digitalconstruction/app/widgets/progress_custom.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddWager extends StatefulWidget {
  @override
  _AddWagerState createState() => _AddWagerState();
}

class _AddWagerState extends State<AddWager> {
  File? _image;
  TextEditingController _nameController = TextEditingController(),
      _emailController = TextEditingController(),
      _passController = TextEditingController(),
      _numberController = TextEditingController(),
      _cnicController = TextEditingController(),
      _proDesController = TextEditingController(),
      _expController = TextEditingController(),
      _cityController = TextEditingController(),
      _priceController = TextEditingController(),
      _expertiseController = TextEditingController();
  String _typeSelected = '';

  DatabaseReference? _ref;
  List<XFile>? _imageFileList;

  get bold => null;

  set _imageFile(XFile? value) {
    _imageFileList = value == null ? null : [value];
  }

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
    _expertiseController = TextEditingController();
    _proDesController = TextEditingController();
    _expController = TextEditingController();
    getCurrentLocation();

    _ref = FirebaseDatabase.instance.reference().child('Wagers');
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


  XFile? _ximage;
  XFile? image = null;

  final ImagePicker _picker = ImagePicker();
  _imgFromCamera() async {
    image =
    await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    if (image != null) {
      setState(() {
        _ximage = image;
      });
    }
  }

  _imgFromGallery() async {
    image =
    await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    if (image != null) {
      //print('image:   is not null    ');
      setState(() {
        _ximage = image;
        //_image = File( _ximage!.path );
      });
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text('Gallery'),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text('Camera'),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  bool isSelected = false;
  List<String> types = [];
  Widget _buildConstructorType(String title, int index) {
    return InkWell(
      child: Container(
        height: 40,
        width: 110,
        decoration: BoxDecoration(
          // ignore: unrelated_type_equality_checks
          color: isSelected && (types.contains(title))
              ? Colors.blue
              : Colors.pinkAccent,
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
          if (types.contains(title)) {
            _typeSelected = "";

            types.remove(title);
          } else {
            isSelected = true;
            types.add(title);
          }
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
        title: Text('Register as a Wager'),
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
                //   Center(
                //     child: GestureDetector(
                //       onTap: () {
                //         _showPicker(context);
                //       },
                //       child: Container(
                //         decoration: BoxDecoration(
                //           color: Colors.green,
                //
                //           borderRadius: BorderRadius.all(Radius.circular(10)),
                //           boxShadow: [
                //             BoxShadow(
                //                 color: Colors.white.withOpacity(0.1),
                //                 blurRadius: 10,
                //                 offset: Offset(0, 5)),
                //           ],
                //           border:
                //               Border.all(color: Colors.white.withOpacity(0.05)),
                //           //  gradient: gradient,
                //         ),
                //         child: _ximage != null
                //             ? Container(
                //                 width: MediaQuery.of(context).size.width * 0.5,
                //                 height: MediaQuery.of(context).size.height * 0.2,
                //                 decoration: BoxDecoration(
                //                   color: Colors.green,
                //
                //                   borderRadius:
                //                       BorderRadius.all(Radius.circular(10)),
                //                   boxShadow: [
                //                     BoxShadow(
                //                         color: Colors.white.withOpacity(0.1),
                //                         blurRadius: 10,
                //                         offset: Offset(0, 5)),
                //                   ],
                //                   border: Border.all(
                //                       color: Colors.white.withOpacity(0.05)),
                //                   //  gradient: gradient,
                //                 ),
                //               child: CircleAvatar(
                //                 radius: 25,
                //                 backgroundImage: FileImage(File(_ximage!.path )),),
                //
                //               )
                //             : Container(
                //                 width: MediaQuery.of(context).size.width * 0.35,
                //                 height: MediaQuery.of(context).size.height * 0.1,
                //                 decoration: BoxDecoration(
                //                   color: Colors.green,
                //                   borderRadius:
                //                       BorderRadius.all(Radius.circular(10)),
                //                   boxShadow: [
                //                     BoxShadow(
                //                         color: Colors.white.withOpacity(0.1),
                //                         blurRadius: 10,
                //                         offset: Offset(0, 5)),
                //                   ],
                //                   border: Border.all(
                //                       color: Colors.white.withOpacity(0.05)),
                //                   //  gradient: gradient,
                //                 ),
                //                 child: ClipRRect(
                //                   borderRadius:
                //                       BorderRadius.all(Radius.circular(10)),
                //                   child: Icon(
                //                     Icons.camera_alt,
                //                     color: Colors.grey[800],
                //                   ),
                //                 ),
                //               ),
                //       ),
                //     ),
                //   ),
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
                const SizedBox(
                  height: 10.0,
                ),
                Container(
                  height: 40,

                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("AllWagerTypes")
                        .snapshots(),
                    builder: (context, snapshot) {
                      return !snapshot.hasData
                          ? Center(child: CircularProgressIndicator())
                          : SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot data =
                            snapshot.data!.docs[index];
                            return GestureDetector(
                              onTap: () {},
                              onLongPress: () {
                                // deleteData( snapshot.data.docs[index].id);
                                //Fluttertoast.showToast(msg: "Deleted");
                              },
                              child: Row(children: [
                                _buildConstructorType(
                                    data['typeName'], index),
                                SizedBox(
                                  width: 10,
                                )
                              ]),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  //
                  // child: ListView(
                  //   scrollDirection: Axis.horizontal,
                  //   children: [
                  //     _buildConstructorType('Electrician'),
                  //     SizedBox(width: 10),
                  //     _buildConstructorType('Plumber'),
                  //     SizedBox(width: 10),
                  //     _buildConstructorType('Carpenter'),
                  //     SizedBox(width: 10),
                  //     _buildConstructorType('Welder'),
                  //     SizedBox(width: 10),
                  //     _buildConstructorType('AC Repair'),
                  //     SizedBox(width: 10),
                  //     _buildConstructorType('Others'),
                  //   ],
                  // ),
                ),
                SizedBox(
                  height: 10,
                ),
//                 Padding(
//                     padding: EdgeInsets.only(right: 20),
//                     child: Container(
//                       width: double.infinity,
//                       child: InkWell(
//                         onTap: () {
// addRequest(context);
//                         },
//                         child: Text(
//                           "Add other Type ?",
//                           style: TextStyle(color: Colors.blue),
//                           textAlign: TextAlign.right,
//                         ),
//                       ),
//                     )),
//                 SizedBox(height: 20,)
                InkWell(
                  onTap: () async {
                    // Reference ref = FirebaseStorage.instance.ref().child(
                    //     "image" +
                    //         DateTime.now().toString()); //generate a unique name
                    // await ref
                    //     .putFile(File(_image!.path)); //you need to add path here
                    // String imageUrl = await ref.getDownloadURL();

                    upload();
                    Get.snackbar('Please wait for confirmation', '',
                        //fontWeight: FontWeight.bold,
                        colorText: Colors.white,
                        backgroundColor: Colors.blue);

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
                    )),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.offNamed(Routes.LoginWager);
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
                      height: MediaQuery.of(context).size.height,
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: new Column(children: <Widget>[
                            TextField(
                              decoration: InputDecoration(
                                  labelText: "Type Name",
                                  border: OutlineInputBorder()),
                              controller: serviceNameController,
                            ),
                            InkWell(
                              onTap: () async {
                                num b = 0;
                                FirebaseFirestore.instance
                                    .collection("ServiceRequests")
                                    .add({
                                  'name': serviceNameController.text,
                                  'cat': "AllWagerTypes",
                                  'add': b,
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
        expertise;
    bool isApproved = false;
    email = _emailController.text;
    pass = _passController.text;
    phone = _numberController.text;

    city = _cityController.text;
    description = _proDesController.text;
    experience = _expController.text;
    cnic = _cnicController.text;

    // Reference ref = FirebaseStorage.instance
    //     .ref()
    //     .child("image" + DateTime.now().toString()); //generate a unique name
    // await ref.putFile(File(_image!.path)); //you need to add path here
    // String imageUrl = await ref.getDownloadURL();

    name = _nameController.text;
    try {
      FirebaseAuth _auth = FirebaseAuth.instance;
      String ty = "";
      if (types.isNotEmpty) {
        int leng = types.length;
        int i = 0;
        // ignore: unnecessary_statements
        for (i; i < leng; i++) {
          ty = types[i];
        }
      }

      double myDistance=0;

      final num b = 3;
      final User? user = await _auth.currentUser;
      _auth
          .createUserWithEmailAndPassword(email: email, password: pass)
          .then((signedInUser) {
        FirebaseFirestore.instance
            .collection('Wagers')
            .doc(signedInUser.user!.uid)
            .set({
          'email': email,
          'Name': name,
          'cnic': cnic,
          "image":
          "https://firebasestorage.googleapis.com/v0/b/digital-construction-969cd.appspot.com/o/electrition.jpg?alt=media&token=be5ee1ab-1dde-428d-a7c2-d54d8976cec7",
          'experience': experience,
          'description': description,
          'expertise': "expertise",
          'phone': phone,
          'city': city,
          'uid': signedInUser.user!.uid,
          'type': ty,
          'orders': "0",
          'totalRating': "0",
          'price': '5000',
          'totalReviews': "0",
          'myRating': b,
          'longitude':longitude,
          'latitude':latitude,
          'myDistance':myDistance,
          'isApproved': false,
        }).then((value) {
          if (signedInUser != null) {
            print("suceess");

            Get.offNamed(Routes.LoginWager);
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
      String message = "";
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

class Types extends StatefulWidget {
  final String title;
  final String typeName;

  final String id;

  // String weight;
  final DocumentSnapshot documentSnapshot;

  Types({
    required this.title,
    required this.documentSnapshot,
    required this.id,
    required this.typeName,
    // this.weight
  });

  @override
  _TypesState createState() => _TypesState();
}

class _TypesState extends State<Types> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: 40,
        width: 110,
        decoration: BoxDecoration(
          color: Colors.pinkAccent,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            widget.typeName,
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
