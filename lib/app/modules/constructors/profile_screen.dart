import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalconstruction/app/constants/helpers.dart';
import 'package:digitalconstruction/app/widgets/color_theme.dart';
import 'package:digitalconstruction/app/widgets/custom_text_field.dart';
import 'package:digitalconstruction/app/widgets/profile_row.dart';
import 'package:digitalconstruction/models/constructor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:path/path.dart' as Path;

import 'all_chat.dart';
import 'constructor_main_screen.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  dynamic data;
  TextEditingController nameController = TextEditingController();
  TextEditingController serviceNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController basicController = TextEditingController();
  TextEditingController standardController = TextEditingController();
  TextEditingController premiumController = TextEditingController();
  String type = "";

  Widget _buildType(String title) {
    return InkWell(
      child: Container(
        height: 40,
        width:110,
        decoration: BoxDecoration(
          color: type == title ? Colors.blue : Color(0xFFCD3424),
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
          type = title;
        });
      },
    );
  }

  Future<dynamic> getData() async {
    final DocumentReference document =
    FirebaseFirestore.instance.collection("Constructors").doc(u);

    await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        data = snapshot.data;
      });
    });
  }
  Constructors user=Constructors(
    uid: "uid",
    Name: "Name",
    city: "city",
    email: "email",
    cnic: "cnic",
    phone: "phone",
    orders: "orders",
    image: "image",
    type: "type",
    price: "price",
    latitude: 0,
    longitude: 0,
    myRating: 0,
    description: "description",
    experience: "experience",
    totalReviews: "totalReviews",
    totalRating: "totalRating",
    expertise: "expertise",
    myDistance: 0,
  );
  @override
  void initState() {
    super.initState();
    getData();
    user=Helper.fetchConstructorValue(FirebaseAuth.instance.currentUser!.uid);
  }

  File? _pickedImage;
  final picker = ImagePicker();

  dynamic _pickImageError;

  void _pickImageCamera() async {
    try {
      final pickedImage = await picker.pickImage(source: ImageSource.camera);
      final pickedImageFile = File(pickedImage!.path);
      setState(() {
        _pickedImage = pickedImageFile;
        _profileUpdate(context);
      });
    }catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  void _pickImageGallery() async {
    try {
      final pickedImage = await picker.pickImage(source: ImageSource.gallery);
      final pickedImageFile = File(pickedImage!.path);
      setState(() {
        _pickedImage = pickedImageFile;
        _profileUpdate(context);
      });
    }
    catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }
  String? _retrieveDataError;
  Future<void> retrieveLostData() async {
    final LostDataResponse response = await picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _pickedImage = response.file as File?;

      });

    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: const Text('Gallery'),
                      onTap: () {
                        _pickImageGallery();
                        Navigator.of(context).pop();

                      }),
                  ListTile(
                    leading: const Icon(Icons.photo_camera),
                    title: const Text('Camera'),
                    onTap: () {
                      _pickImageCamera();
                      Navigator.of(context).pop();

                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
  Future<void> _profileUpdate(BuildContext context) {
    return showDialog(
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Edit Profile Image"),
            centerTitle: true,
          ),
          body:Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                    width: MediaQuery.of(context).size.width*0.8,
                    height: MediaQuery.of(context).size.height*0.4,
                    child: _pickedImage != null ? Image.file(File(_pickedImage!.path))
                    /*as ImageProvider*/ : Container()
                  //FileImage(_pickedImage!),
                ),

                SizedBox(
                  height: 20,
                ),
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
                    onPressed: () async {
                      final User? user = FirebaseAuth.instance.currentUser;
                      final String uid = user!.uid.toString();

                      String _uploadedFileURL="";
                      int now = DateTime.now().millisecondsSinceEpoch;
                      Reference storageReference = FirebaseStorage.instance
                          .ref()
                          .child('posts/$uid.png');
                      UploadTask uploadTask = storageReference.putFile(File(_pickedImage!.path));
                      final TaskSnapshot url=(await uploadTask.whenComplete(() => print('Uploaded')));
                      final String postImage=await url.ref.getDownloadURL();
                      FirebaseFirestore.instance
                          .collection('Constructors')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .update({
                        'image':postImage
                      });
                      Navigator.of(context).pop();
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
        );
      },
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double _w = MediaQuery
        .of(context)
        .size
        .width;
    final double _h = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile Screen",
          style: TextStyle(color: Colors.white,
              fontFamily: 'MetroPolis',
              fontWeight: FontWeight.bold),
        ),

        centerTitle: true,
        //backgroundColor: Colors.pink,
        automaticallyImplyLeading: true,
        elevation: 0,
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
                  color: Colors.white,
                  height: _h,
                  width: _w,
                ),
              ),
              Positioned(
                top: _h * .2,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),

                  child: Container(
                    color: Colors.blue.withOpacity(0.2),

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
                              data()['Name'],
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.blueGrey,
                                  fontFamily: 'MetroPolis',
                                  fontWeight:FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        profileRow(
                          title: 'Email',
                          subtitle: data()['email'],
                          icon: Icons.email,

                        ),
                        SizedBox(
                          height: 20,
                        ),
                        profileRow(
                          title: 'Contact',
                          subtitle: data()['phone'],
                          icon: Icons.phone,

                        ),

                        const SizedBox(
                          height: 20,
                        ),
                        profileRow(
                          title: 'Experience',
                          subtitle: data()['experience'],
                          icon: LineIcons.bRomBelExperteGmbhCoKg,

                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        profileRow(
                          title: 'Type',
                          subtitle: data()['type'],
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
                            Expanded(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Description",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black54,
                                      fontFamily: 'MetroPolis',
                                      fontWeight:FontWeight.bold
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  data()['description'],
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
                        const SizedBox(height: 10,),
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
                        // // save current user changes
                        FirebaseAuth _auth = FirebaseAuth.instance;
                        final User? user =  _auth.currentUser;
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const ChatWithBarberLayout()));                      },
                      child: const Text(
                        'Inbox',
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
                                // // save current user changes
                                FirebaseAuth _auth = FirebaseAuth.instance;
                                final User? user =  _auth.currentUser;

                                myServices(context, user!.uid);
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
                              color: buttonBgColor,
                              onPressed: () async {
                                // // save current user changes
                                FirebaseAuth _auth = FirebaseAuth.instance;
                                final User? user = _auth.currentUser;
                                myTeam(context, user!.uid);
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
                              color: buttonBgColor,
                              onPressed: () async {
                                // save current user changes
                                FirebaseAuth _auth = FirebaseAuth.instance;
                                final User? user = await _auth.currentUser;
                                pastProjects(context, user!.uid);
                              },
                              child: const Text(
                                'My Previous Work',
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
                    onTap: () {
                      _showPicker(context);
                    },
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: textColor,
                      backgroundImage: NetworkImage(data()['image']),
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
  Future<void> _profileUpdateWidget(BuildContext context) {
    TextEditingController firstNameController =
    TextEditingController(text: user.Name);
    TextEditingController desController =
    TextEditingController(text: user.description);
    TextEditingController phoneNumberController =
    TextEditingController(text: user.phone);
    TextEditingController addressController =
    TextEditingController(text: user.city);

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
                      label: user.Name,
                      keyboardType: TextInputType.text,
                      controller: firstNameController,
                    ),
                  ),
                  // second name
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomTextField(
                      label: user.city,
                      keyboardType: TextInputType.text,
                      controller: addressController,
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
                      label: user.description,
                      keyboardType: TextInputType.text,
                      controller: desController,
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
                            .collection('Constructors')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .update({
                          'Name': firstNameController.text,
                          'city':addressController.text,
                          'phone':phoneNumberController.text,
                          'description':desController.text,
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

  Future<void> myTeam(BuildContext context, String cUid) {
    return showDialog(
        context: context,
        // barrierDismissible: false,
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text("My Team"),
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
                        return InkWell(

                          onTap: () {

                          },

                          onLongPress: () {
                            // deleteData( snapshot.data.docs[index].id);
                            //Fluttertoast.showToast(msg: "Deleted");
                          },
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
            floatingActionButton: FloatingActionButton.extended(
              backgroundColor: const Color(0xff03dac6),
              icon: const Icon(Icons.add),
              label: const Text('Add Team Member'),
              onPressed: () {
               addTeam(context);
              },
            ),
          );
        });
  }


  Future<void> myServices(BuildContext context, String cUid) {
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
                        return InkWell(

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
            floatingActionButton: FloatingActionButton.extended(
              backgroundColor: const Color(0xff03dac6),
              icon: Icon(Icons.add),
              label: Text('Add Service'),
              onPressed: () {
                addService(context, cUid);
              },
            ),
          );
        });
  }


  Future<void> pastProjects(BuildContext context, String cUid) {
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
                    'contractor', isEqualTo: cUid).where(
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
                                  constructorWork: data['myWork'],
                                  userReview: data['userReview'],
                                image:data['image'],
                              )),
                            );
                          },

                          onLongPress: () {
                            // deleteData( snapshot.data.docs[index].id);
                            //Fluttertoast.showToast(msg: "Deleted");
                          },
                          child: OrderBoxProject(
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
  Future<void> addRequestType(BuildContext context) {
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
                          child: Column(children: <Widget>[

                            TextField(
                              decoration: const InputDecoration(
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
                                  'cat':"WorkerTypes",
                                  'add':b,




                                }).then((value) => print("Success"));
                                Get.back();


                                // Navigator.of(context).pop();
                                Fluttertoast.showToast(msg: "Request Sent");
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
                title: const Text("Request"),
              ),
              body: SingleChildScrollView(
                  child: Container(
                      margin: const EdgeInsets.only(top: 20.0),
                      height: MediaQuery
                          .of(context)
                          .size
                          .height,
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(children: <Widget>[

                            TextField(
                              decoration: const InputDecoration(
                                  labelText: "Service Name",
                                  border: OutlineInputBorder(

                                  )
                              ),

                              controller: serviceNameController,
                            ),
                            TextField(
                              decoration: const InputDecoration(
                                  labelText: "Expertise i.e Residential,Painter",
                                  border: OutlineInputBorder(

                                  )
                              ),

                              controller: basicController,
                            ),
                            InkWell(
                              onTap: () async {

                                num b=0;
                                FirebaseFirestore.instance
                                    .collection("ServiceRequests")
                                    .add({


                                  'name': serviceNameController.text,
                                  'cat':"AllServices",
                                  'add':b,
                                  'expertise':basicController.text




                                }).then((value) => print("Success"));
                                Get.back();


                                // Navigator.of(context).pop();
                                Fluttertoast.showToast(msg: "Request Sent");
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
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFCD3424),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text(
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

  Future<void> addService(BuildContext context, String cUid) async {
    TextEditingController serviceNameController = TextEditingController();
    TextEditingController basicController = TextEditingController();
    TextEditingController standardController = TextEditingController();
    TextEditingController premiumController = TextEditingController();
    List<String> expertise=<String>["Select Expertise"];
    List<String> items1=<String>["Select Service"];
    String? dropdownValue="Select Service";
    QuerySnapshot querySnapshot ;
    String? dropdownValue1="Select Expertise";
    @override
    void initState() {
      dropdownValue = 'Select Service';
      dropdownValue1 = 'Select Expertise';
      items1=<String>["Select Service"];
      super.initState();
    }

    var var1=await FirebaseFirestore.instance.collection("Constructors").doc(FirebaseAuth.instance.currentUser!.uid).get();
    String types=var1.data()!['type'].toString();
    if(types.contains("Residential")){
      expertise.add("Residential");
    }
    if(types.contains("Commercial")){
      expertise.add("Commercial");
    }
    if(types.contains("Painter")){
      expertise.add("Painter");
    }
    if(types.contains("Carpenter")){
      expertise.add("Carpenter");
    }
    if(types.contains("Infrastructural")){
      expertise.add("Infrastructural");
    }
    return showDialog(
        context: context,
        // barrierDismissible: false,
        builder: (BuildContext context) {
          return Scaffold(
              appBar: AppBar(
                title: Text("Add new Service"),
              ),
              body: SingleChildScrollView(
                  child: Container(
                      margin: EdgeInsets.only(top: 20.0),
                      height: MediaQuery
                          .of(context)
                          .size
                          .height,
                      child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Column(children: <Widget>[
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children:[
                                  Container(
                                    margin: const EdgeInsets.only(left:20,right: 20,top: 5),
                                    child:
                                    Text("Select Expertise",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: textColor,
                                          fontFamily: 'MetroPolis',
                                          fontWeight:FontWeight.bold                                      ),
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child:Container(
                                      width: 320,
                                      decoration:BoxDecoration(
                                        border: Border.all(color: Colors.blue,width: 1),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: DropdownButton<String>(
                                        value: dropdownValue1,
                                        dropdownColor: Colors.blue,
                                        icon: const Icon(Icons.arrow_drop_down),
                                        iconSize: 36,

                                        style: const TextStyle(color: Colors.black,fontSize: 15),
                                        underline: const SizedBox(),
                                        onChanged: (String? newValue) {
                                          setState(() async {
                                            items1.clear();
                                            items1.add("Select Service");
                                            dropdownValue1 = newValue;
                                            querySnapshot =
                                                await FirebaseFirestore.instance.collection("AllServices").where("cat",isEqualTo: newValue).get();
                                            for (int i = 0; i < querySnapshot.docs.length; i++) {
                                              var a = querySnapshot.docs[i];
                                              items1.add(a['name']);
                                            }

                                          });
                                        },
                                        items: expertise
                                            .map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ]
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children:[
                                  Container(
                                    margin: EdgeInsets.only(left:20,right: 20,top: 5),
                                    child:
                                    Text("Service Name",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: textColor,
                                          fontFamily: 'MetroPolis',
                                          fontWeight:FontWeight.bold                                      ),
                                    ),
                                  ),

                                  Padding(
                                    padding: EdgeInsets.all(12),
                                    child:Container(
                                      width: 320,
                                      decoration:BoxDecoration(
                                        border: Border.all(color: Colors.blueGrey,width: 1),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: DropdownButton<String>(
                                        value: dropdownValue,
                                        dropdownColor: Colors.grey,
                                        icon: const Icon(Icons.arrow_drop_down),
                                        iconSize: 36,

                                        style: const TextStyle(color: Colors.black,fontSize: 15),
                                        underline: SizedBox(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            dropdownValue = newValue;
                                          });
                                        },
                                        items: items1
                                            .map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ]
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            Container(
                              margin: const EdgeInsets.only(
                                  top: 12.0, left: 20.0, right: 20.0, bottom: 5.0),
                              height: 40,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                                  _buildType('With Material'),

                                  _buildType('Without Material'),


                                ],
                              ),
                            ),
                            CustomTextField(
                              label: "Basic work rate by square feet",
                              controller: basicController, keyboardType: TextInputType.text,
                            ),
                            CustomTextField(
                              label: "Standard work rate by square feet",
                              controller: standardController,
                              keyboardType: TextInputType.text,
                            ),
                            CustomTextField(
                              label: "Premium work rate by square feet",
                              controller: premiumController,
                              keyboardType: TextInputType.text,
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
                                final FirebaseAuth _auth = FirebaseAuth
                                    .instance;
                                final User? user = await _auth.currentUser;

                                // Firebase.Auth.FirebaseUser user1 = await FirebaseAuth.instance.currentUser;
                                FirebaseFirestore.instance
                                    .collection("Services")
                                    .add({

                                  'premium': premiumController.text,
                                  'serviceName': dropdownValue,
                                  'standard': standardController.text,
                                  'basic': basicController.text,
                                  'material':type,
                                  'contractor': user!.uid,

                                }).then((value) => print("Success"));
                                Get.back();

                                Get.snackbar(
                                    'Service Added',
                                    'Successfully',
                                    colorText: Colors.black,
                                    backgroundColor: Colors.white
                                );
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
                                    "Add Service",
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
  Future<void> addTeam(BuildContext context) async {


    bool isSelected=false;
    List<String> types=[];
    Widget _buildExpertise(String title ,int index) {
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


              types.remove(title);
            }
            else{
              isSelected=true;
              types.add(title);}
          });
        },
      );
    }

    TextEditingController nameController = TextEditingController();
    TextEditingController typeController = TextEditingController();
    TextEditingController expertiseController = TextEditingController();
    String valueChoose="Zero";
    List<String> items1=<String>["Select Role"];

    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection("WorkerTypes").get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i];
      items1.add(a['name']);
    }
    String dropdownValue = 'Select Role';
    return showDialog(
        context: context,
        // barrierDismissible: false,
        builder: (BuildContext context) {
          return Scaffold(
              appBar: AppBar(
                title: Text("Add Team Member"),
              ),
              body: SingleChildScrollView(
                  child: Container(
                      margin: EdgeInsets.only(top: 20.0),
                      height: MediaQuery
                          .of(context)
                          .size
                          .height,
                      child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Column(children: <Widget>[

                            CustomTextField(
                              label: "Name",
                              controller: nameController,
                              keyboardType: TextInputType.text,
                            ),
                            SizedBox(height: 20,),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children:[
                                  Container(
                                    margin: const EdgeInsets.only(left:20,right: 20,top: 5),
                                    child:
                                  Text("Select the Role",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: textColor,
                                        fontFamily: 'MetroPolis',
                                        fontWeight:FontWeight.bold                                    ),
                                  ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(top: 10,left: 20,right: 20),
                                    child:Container(
                                      width: 320,
                                      decoration:BoxDecoration(
                                        border: Border.all(color: Colors.blueGrey,width: 1),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: DropdownButton<String>(
                                        value: dropdownValue,
                                        dropdownColor: Colors.grey,
                                        icon: const Icon(Icons.arrow_drop_down),
                                        iconSize: 36,

                                        style: const TextStyle(color: Colors.black,fontSize: 15),
                                        underline: SizedBox(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            dropdownValue = newValue!;
                                          });
                                        },
                                        items: items1
                                            .map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ]
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
                            //           addRequestType(context);
                            //         },
                            //         child: const Text(
                            //           "Add custom Role ?",
                            //           style: TextStyle(color: Colors.blue),
                            //           textAlign: TextAlign.right,
                            //         ),
                            //       ),
                            //     )),

                            SizedBox(height: 20,),
                            Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:[
                                  Container(
                                    margin: EdgeInsets.only(left:25,right: 25),
                                    child:
                                  Text("Expertise",

                                    style: TextStyle(
                                        fontSize: 20,
                                        color: textColor,
                                        fontFamily: 'MetroPolis',
                                        fontWeight:FontWeight.bold                                    ),
                                  ),
                                  ),
                                  SizedBox(height: 4,),

                                  Container(
                                    height: 40,
margin: const EdgeInsets.only(left:25,right: 25),

                                    child:
                                    StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection("AllServices")
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        return !snapshot.hasData
                                            ? const Center(child: CircularProgressIndicator())
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
                                                      _buildExpertise(data['name'],index),
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

                                ]
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
                            //           "Add custom Expertise ?",
                            //           style: TextStyle(color: Colors.blue),
                            //           textAlign: TextAlign.right,
                            //         ),
                            //       ),
                            //     )),
                            SizedBox(height: 20,),

                            InkWell(
                              onTap: () async {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CircularProgressIndicator();
                                    });
                                String ty="";
                                if(types.isNotEmpty){
                                  int leng=types.length;
                                  int i=0;
                                  // ignore: unnecessary_statements
                                  for(i;i<leng;i++){
                                    ty=ty+types[i]+" | ";
                                  }
                                }
                                var r = "pending";
//addOrder(context, selectedDoc, name, price, time, cUid, sUid)
                                final FirebaseAuth _auth = FirebaseAuth
                                    .instance;
                                final User? user = await _auth.currentUser;

                                // Firebase.Auth.FirebaseUser user1 = await FirebaseAuth.instance.currentUser;
                                FirebaseFirestore.instance
                                    .collection("Teams")
                                    .add({
                                  'contractor': user!.uid,
                                  'expertise':ty,

                                  'name': nameController.text,

                                  'type': dropdownValue,
                                }).then((value) => print("Success"));
                                Get.back();

                                Get.snackbar(
                                    'Team Member added',
                                    'Successfully',
                                    colorText: Colors.black,
                                    backgroundColor: Colors.white
                                );
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
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFCD3424),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    "Add Team Member",
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
    final double _w = MediaQuery
        .of(context)
        .size
        .width;
    final double _h = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Project Description",
            style: TextStyle(
                fontFamily: 'MetroPolis',
                fontWeight: FontWeight.bold
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(10),

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
                                          borderRadius: BorderRadius.circular(
                                              16),
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
                                      Expanded(child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          Text(
                                            "Required Work",
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black54,
                                                fontFamily: 'MetroPolis',
                                                fontWeight: FontWeight.bold
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
                                          borderRadius: BorderRadius.circular(
                                              16),
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
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          Text(
                                            "Address",
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black54,
                                                fontFamily: 'MetroPolis',
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            widget.address,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black
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
                                          borderRadius: BorderRadius.circular(
                                              16),
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
                                      Expanded(child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          Text(
                                            "My Work",
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black54,
                                                fontFamily: 'MetroPolis',
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            widget.constructorWork,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black
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
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Container(
                                        child: const Text(
                                          "Project Photos", style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'MetroPolis',
                                          fontWeight: FontWeight.bold ,
                                          color: Colors.black54,
                                        ),),
                                      ),
                                      SizedBox(height: 20,),
                                      Container(
                                        height: 200.0,
                                        width: 330.0,
                                        child: Image.network(widget.image)
                                        // FutureBuilder(
                                        //     future: getCarouselWidget(
                                        //         widget.projectID),
                                        //     builder: (context, snapshot) {
                                        //       return CarouselSlider.builder(
                                        //           slideBuilder: (index) {
                                        //             // DocumentSnapshot sliderImage =
                                        //             // snapshot.data![index];
                                        //
                                        //             return Container(
                                        //                 child:
                                        //                 // snapshot
                                        //                 //     .data == null
                                        //                 //     ?
                                        //                 Text(
                                        //                   "No photos to show",
                                        //                   style: TextStyle(
                                        //                     backgroundColor: Colors
                                        //                         .greenAccent,
                                        //
                                        //                   ),)
                                        //             );
                                        //                     // : Image.network(
                                        //                     // sliderImage['url']));
                                        //           },
                                        //           slideTransform: CubeTransform(),
                                        //           itemCount: 3
                                        //       );
                                        //     }),
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
                                          borderRadius: BorderRadius.circular(
                                              16),
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
                                      Expanded(child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          const Text(
                                            "Feedback",
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black54,

                                                fontFamily: 'MetroPolis',
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            widget.userReview,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black
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

  class OrderBoxProject extends StatefulWidget {
  final String name;
  final String phone;
  final String id;
  final String description;
  final String address;

  // String weight;
  final DocumentSnapshot documentSnapshot;

  const OrderBoxProject(
      {Key? key,
        required this.name,
        required  this.phone,
        required  this.id,
        required this.description,
        required  this.address,
        required  this.documentSnapshot})
      : super(key: key);

  @override
  _OrderBoxProjectState createState() => _OrderBoxProjectState();
}

class _OrderBoxProjectState extends State<OrderBoxProject> {
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
          color: Colors.blue.withOpacity(0.1), // set border color
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
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
              padding: const EdgeInsets.only(top: 10.0, left: 8.0),
              child: Text("Description: ${widget.description}"),
            )
          ],
        ),
      ),
    );
  }
}

class AddImage extends StatefulWidget {
  @override
  _AddImageState createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  bool uploading = false;
  double val = 0;
  CollectionReference? imgRef;
  firebase_storage.Reference? ref;

  List<File> _image = [];
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Image'),
          actions: [
            FlatButton(
                onPressed: () {
                  setState(() {
                    uploading = true;
                  });
                  uploadFile().whenComplete(() => Navigator.of(context).pop());
                },
                child: Text(
                  'upload',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(4),
              child: GridView.builder(
                  itemCount: _image.length + 1,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    return index == 0
                        ? Center(
                            child: IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () =>
                                    !uploading ? chooseImage() : null),
                          )
                        : Container(
                            margin: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: FileImage(_image[index - 1]),
                                    fit: BoxFit.cover)),
                          );
                  }),
            ),
            uploading
                ? Center(
                    child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        child: Text(
                          'uploading...',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CircularProgressIndicator(
                        value: val,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      )
                    ],
                  ))
                : Container(),
          ],
        ));
  }

  chooseImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image.add(File(pickedFile!.path));
    });
    if (pickedFile!.path == null) retrieveLostData();
  }

  Future<void> retrieveLostData() async {
    final LostData response = await picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image.add(File(response.file!.path));
      });
    } else {
      print(response.file);
    }
  }

  Future uploadFile() async {
    int i = 1;
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    for (var img in _image) {
      setState(() {
        val = i / _image.length;
      });

      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/${Path.basename(img.path)}');
      await ref?.putFile(img).whenComplete(() async {
        await ref?.getDownloadURL().then((value) {
          imgRef?.add({
            'url': value,
            'uid': user!.uid,
          });
          i++;
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    imgRef = FirebaseFirestore.instance.collection('Catalog');
  }
}

class Slider extends StatefulWidget {
  @override
  _SliderState createState() => _SliderState();
}

class _SliderState extends State<Slider> {
  Future getCarouselWidget() async {
    User? user = FirebaseAuth.instance.currentUser;

    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore.collection("Catalog").get();
    return qn.docs;
  }

  Widget build(BuildContext context) {
    var idx = 1;
    return Scaffold(
        body: Container(
      height: 200.0,
      width: 300.0,
      child: FutureBuilder(
          future: getCarouselWidget(),
          builder: (context, snapshot) {
            return CarouselSlider.builder(
                slideBuilder: (index) {
                  //DocumentSnapshot sliderImage = snapshot.data![index];
                  return Container(


                    //child: Image.network(sliderImage['url']),
                  );
                },
                slideTransform: CubeTransform(),
                itemCount: 3
                //snapshot.data!.length
            );
          }),
    ));
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

        required  this.id,
        required  this.documentSnapshot,required  this.premium,required  this.serviceName,required  this.material,
        required  this.standard,required  this.basic})
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
              padding: const EdgeInsets.only(left: 8.0, right: 5),
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
              padding: const EdgeInsets.only(left: 8.0, right: 5),
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
              padding: const EdgeInsets.only(left: 8.0, right: 5, bottom: 5),
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
        required this.documentSnapshot, required this.expertise,required this.type})
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
              color: Colors.blue.withOpacity(0.1), // set border color
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
                    TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
                  Text(widget.type,
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 8.0, bottom: 5),
              child: Text("Expertise: ${widget.expertise}"),
            )
          ],
        ),
      ),
    );
  }
}
