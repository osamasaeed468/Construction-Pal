import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_count_down/countdown.dart';
import 'package:date_count_down/date_count_down.dart';
import 'package:digitalconstruction/app/modules/constructors/profile_screen.dart';
import 'package:digitalconstruction/app/modules/login/views/AuthService.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import 'package:digitalconstruction/app/routes/app_pages.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:digitalconstruction/app/widgets/color_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

import 'all_chat.dart';
import 'dashboard_screen.dart';

var anId;
var u;

class ContractorsMain extends StatefulWidget {
  const ContractorsMain({Key? key}) : super(key: key);

  @override
  _ContractorsMainState createState() => _ContractorsMainState();
}

class _ContractorsMainState extends State<ContractorsMain>
    with SingleTickerProviderStateMixin {
  TabController? _controller;
  int _selectedIndex = 0;
  final AuthService _auth = new AuthService();

  List<Widget> list = [
    Tab(
      child: Container(
        height: 30.0,
        width: 100.0,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.black.withOpacity(0.2),
            ),
            borderRadius: BorderRadius.circular(10)),
        child: const Center(
            child: Text("Pending", style: TextStyle(color: Colors.green))),
      ),
    ),
    Tab(
      child: Container(
        height: 30.0,
        width: 100.0,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.black.withOpacity(0.2),
            ),
            borderRadius: BorderRadius.circular(10)),
        child: const Center(
            child: Text(
          "In Progress",
          style: TextStyle(color: Colors.green),
        )),
      ),
    ),
    Tab(
      child: Container(
        height: 30.0,
        width: 100.0,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.black.withOpacity(0.2),
            ),
            borderRadius: BorderRadius.circular(10)),
        child: const Center(
            child: Text(
          "Completed",
          style: TextStyle(color: Colors.green),
        )),
      ),
    ),
  ];

  @override
  void initState() {
    //getUserId();

    // TODO: implement initState
    super.initState();
    // Create TabController for getting the index of current tab
    _controller = TabController(length: list.length, vsync: this);

    _controller?.addListener(() {
      setState(() {
        _selectedIndex = _controller!.index;
      });
      print("Selected Index: " + _controller!.index.toString());
    });
  }

  dynamic data;
  var use;
  Future<dynamic> getData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = await auth.currentUser;
    use = user!.uid;
    final DocumentReference document =
        FirebaseFirestore.instance.collection("Constructors").doc(use);

    await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        data = snapshot.data;
      });
    });
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
                    MaterialPageRoute(builder: (context) => const Dashboard()));
              },
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              //trailing: Icon(Icons.arrow_forward),
            ),
            ListTile(
              onTap: () async {
                FirebaseAuth auth = FirebaseAuth.instance;
                final User? user = auth.currentUser;
                u = user!.uid;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ChatWithBarberLayout()));
              },
              leading: const Icon(Icons.all_inbox_sharp),
              title: const Text("Inbox"),
              //trailing: Icon(Icons.arrow_forward),
            ),
            ListTile(
              onTap: () async {
                FirebaseAuth auth = FirebaseAuth.instance;
                final User? user = await auth.currentUser;
                u = user!.uid;
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Profile()));
              },
              leading: const Icon(Icons.supervised_user_circle_outlined),
              title: const Text("Profile"),
              //trailing: Icon(Icons.arrow_forward),
            ),
            ListTile(
              title: const Text(
                "Logout",
              ),
              leading: const Icon(Icons.logout),
              onTap: () async {
                await _auth.signOut();
                Get.offNamed(Routes.LOGIN);
                //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginView()));
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        bottom: TabBar(
          onTap: (index) {
            // Should not used it as it only called when tab options are clicked,
            // not when user swapped
          },
          controller: _controller,
          tabs: list,
        ),
        title: const Text('Contractors Orders',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: TabBarView(
        controller: _controller,
        children: [
          // Ongoing(),
          PendingOrders(),
          Bookings(),
          Completed()
        ],
      ),
    );
  }
}

class Bookings extends StatefulWidget {
  @override
  _BookingsState createState() => _BookingsState();
}

class _BookingsState extends State<Bookings> {
  String? userId;
  final User? user = FirebaseAuth.instance.currentUser;
  String? review;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Requests")
            .where('contractor', isEqualTo: user!.uid)
            .where("status", isEqualTo: "in-progress")
            .snapshots(),
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? Center(child: CircularProgressIndicator())
              : SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    shrinkWrap: true,
                    // scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot data = snapshot.data!.docs[index];

                      String? projectID = Text(data['projID']).data;
                      print(projectID);
                      return GestureDetector(
                        onTap: () {
                          _showMyDialog(data.id, projectID!);
                        },
                        onLongPress: () {
                          //     deleteData( snapshot.data.docs[index].id);
                          //Fluttertoast.showToast(msg: "Deleted");
                        },
                        child: OrderBoxx(
                          documentSnapshot: data,
                          id: data.id,
                          description: data['description'],
                          projectID: data['projID'],
                          start: data['start'],
                          dueTime: data['dueTime'],
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
  }

  Future<void> _showMyDialog(var id, String projectID) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation Dialog'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                    'Are you sure you want to Delete or Project is completed?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                print('Confirmed');
                deleteData("$id");
                Navigator.of(context).pop();
                Fluttertoast.showToast(msg: "Deleted");

                setState(() {});
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                //    deleteData("$id");
                Navigator.of(context).pop();
                //  Fluttertoast.showToast(msg: "Deleted");
              },
            ),
          ],
        );
      },
    );
  }

  void deleteData(docId) {
    FirebaseFirestore.instance
        .collection("Requests")
        .doc(docId)
        .delete()
        .catchError((e) {
      print(e);
    });
  }
}

class AddImage extends StatefulWidget {
  final String projectID;
  AddImage(this.projectID);

  @override
  _AddImageState createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  bool uploading = false;
  double val = 0;
  late CollectionReference imgRef;
  late firebase_storage.Reference ref;

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
      await ref.putFile(img).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          imgRef.add({
            'url': value,
            'projID': widget.projectID,
          });
          i++;
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    imgRef = FirebaseFirestore.instance.collection('PastProject');
  }
}

class CompleteWorkDetail extends StatefulWidget {
  final String projectID;
  final String id;
  const CompleteWorkDetail(this.projectID, this.id);

  @override
  _CompleteWorkState createState() => _CompleteWorkState();
}

class _CompleteWorkState extends State<CompleteWorkDetail> {
  XFile? _pickedImage;
  final picker = ImagePicker();
  bool pick=false;
  List<Asset> images = <Asset>[];
  dynamic _pickImageError;
  void _pickImageGallery() async {
    try {
      final pickedFileList = await picker.pickImage(
        source:ImageSource.gallery);
      final XFile? pickedImageFile = pickedFileList;
      //File(pickedImage!.path);
      setState(() {
        _pickedImage = pickedImageFile;
        if(_pickedImage!=null){
          pick=true;
        }
      });
    }catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  TextEditingController workDesController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final double _w = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          title: Text("Details for project"),
        ),
        body: SingleChildScrollView(
            child: Container(
                margin: EdgeInsets.only(top: 20.0),
                height: MediaQuery.of(context).size.height,
                child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(children: <Widget>[
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              "Tell us, what you done!",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                                maxLines: 4,
                                controller: workDesController,
                                decoration: const InputDecoration(
                                  labelText: "Work details...",
                                  border: OutlineInputBorder(
                                    gapPadding: 10,
                                  ),
                                )),
                          ]),
                      const SizedBox(
                        height: 30,
                      ),
                    pick==false?
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
                            //filePicker();
                            _pickImageGallery();
                          },
                          child: const Text(
                            'Add Images',
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                                fontFamily: 'MetroPolis',
                                fontWeight:FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    ):
                    Container(
                      child: _pickedImage == null? null:Image.file(File(_pickedImage!.path))
                    ),

           //          : Semantics(
           //           child: ListView.builder(
           //            key: UniqueKey(),
           //            itemBuilder: (context, index) {
           //      // Why network for web?
           //      // See https://pub.dev/packages/image_picker#getting-ready-for-the-web-platform
           //            return Semantics(
           //              //label: 'image_picker_example_picked_image',
           //            child: kIsWeb
           //            ? Image.network(_pickedImage![index].path)
           //            : Image.file(File(_pickedImage![index].path)),
           //        );
           //        },
           //        itemCount: _pickedImage!.length,
           //  ),
           // // label: 'image_picker_example_picked_images'
           //          ),

                      Column(
                          children: [
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 8,
                                  right: 8,
                                  top: 2,
                                  bottom: 10,
                                ),
                                child:FlatButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              minWidth: _w * 0.9,
                              height: 50,
                              color: const Color(0xFFCD3424),
                              child: const Text(
                                "Save",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () async {
                                final User? user = FirebaseAuth.instance.currentUser;
                                final String uid = user!.uid.toString();
                                Reference storageReference = FirebaseStorage.instance
                                    .ref()
                                    .child('posts/$uid.png');
                                UploadTask uploadTask = storageReference.putFile(File(_pickedImage!.path));
                                final TaskSnapshot url=(await uploadTask.whenComplete(() => print('Uploaded')));
                                final String postImage=await url.ref.getDownloadURL();

//addOrder(context, selectedDoc, name, price, time, cUid, sUid)

                                FirebaseFirestore.instance
                                    .collection("Requests")
                                    .doc("${widget.id}")
                                    .update({
                                  'myWork': workDesController.text,
                                  'image':postImage
                                }).then((value) => print("Success"));
                                print('Confirmed');
                                FirebaseFirestore.instance
                                    .collection('Requests')
                                    .doc("${widget.id}")
                                    .update({
                                  'status': "complete",
                                });
                                print(uid);
                                var lSum;
                                var variable = await FirebaseFirestore.instance
                                    .collection("Constructors")
                                    .doc(uid)
                                    .get();
                                String orders =
                                    variable.data()!['orders'].toString();
                                String num = "1";
                                int sum = (int.parse(orders) + int.parse(num));
                                print(sum);
                                String order = sum.toString();
                                FirebaseFirestore.instance
                                    .collection('Constructors')
                                    .doc(uid)
                                    .update({
                                  'orders': order,
                                });
                                Navigator.of(context).pop();

                                Get.offNamed(Routes.HOME);
                                // Navigator.of(context).pop();
                                Fluttertoast.showToast(msg: "Success");
                                //  addOrder(context, selectedDoc, name, price, time, user.uid, sUid,imageUrl,uName,uLocation,uPrice);
                              },
                            ),
                          ),
                        ),
                      ])
                    ])))));
  }
}

class Completed extends StatefulWidget {
  const Completed({Key? key}) : super(key: key);

  @override
  _CompletedState createState() => _CompletedState();
}

class _CompletedState extends State<Completed> {
  String? userId;

  final User? user = FirebaseAuth.instance.currentUser;
  String? review;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Requests")
            .where('contractor', isEqualTo: user!.uid)
            .where("status", isEqualTo: "complete")
            .snapshots(),
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? Center(child: const CircularProgressIndicator())
              : SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    shrinkWrap: true,
                    // scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot data = snapshot.data!.docs[index];
                      return GestureDetector(
                        onTap: () {
                          // Navigator.push(context,
                          //     MaterialPageRoute(builder: (context) => Home()));                    // getDetailsDialog(
                          // //     context,
                          // //     snapshot.data.docs[index],
                          // //     data['title'],
                          //     data['time'],
                          //     data['image'],
                          //     data['price'],
                          //     data['details'],
                          //     data['uid']);
                          //   _showMyDialog();
                        },
                        onLongPress: () {
                          //     deleteData( snapshot.data.docs[index].id);
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
  }

  Future<void> _showMyDialog(var id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation Dialog'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Are you sure you want to Delete?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                print('Confirmed');
                deleteData("$id");
                Navigator.of(context).pop();
                Fluttertoast.showToast(msg: "Deleted");

                setState(() {});
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                //    deleteData("$id");
                Navigator.of(context).pop();
                //  Fluttertoast.showToast(msg: "Deleted");
              },
            ),
          ],
        );
      },
    );
  }

  void deleteData(docId) {
    FirebaseFirestore.instance
        .collection("Requests")
        .doc(docId)
        .delete()
        .catchError((e) {
      print(e);
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

class OrderBoxx extends StatefulWidget {
  final String name;
  final String phone;
  final String start;
  final String dueTime;
  final String id;
  final String description;
  final String address;
  final String projectID;
  // String weight;
  final DocumentSnapshot documentSnapshot;

  const OrderBoxx(
      {Key? key,
      required this.name,
      required this.phone,
      required this.id,
      required this.description,
      required this.address,
      required this.documentSnapshot,
      required this.projectID,
      required this.start,
      required this.dueTime})
      : super(key: key);

  @override
  _OrderBoxxState createState() => _OrderBoxxState();
}

class _OrderBoxxState extends State<OrderBoxx> {
  String countTime = "Loading...";
  Timer? _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    countTime =
        CountDown().timeLeft(DateTime.parse(widget.dueTime), 'Time Ended');
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
                  Text(widget.address,
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Remaining Time",
                    style:
                        TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                  ),
                  Text(countTime,
                      style: TextStyle(
                          fontSize: 13.0, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 8.0),
              child: Text("Description: ${widget.description}"),
            ),
            Container(
              padding: const EdgeInsets.only(top: 10.0, left: 250.0),
              child: RaisedButton(
                color: Color(0xFFCD3424),
                child: Text('Complete'),
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CompleteWorkDetail(widget.projectID, widget.id)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PendingOrders extends StatefulWidget {
  @override
  _PendingOrdersState createState() => _PendingOrdersState();
}

class _PendingOrdersState extends State<PendingOrders> {
  String? userId;

  final User? user = FirebaseAuth.instance.currentUser;
  String? review;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Requests")
            .where('contractor', isEqualTo: user!.uid)
            .where("status", isEqualTo: "pending")
            .snapshots(),
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? Center(child: CircularProgressIndicator())
              : SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    shrinkWrap: true,
                    // scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot data = snapshot.data!.docs[index];
                      return GestureDetector(
                        onTap: () {
                          // Navigator.push(context,
                          //     MaterialPageRoute(builder: (context) => Home()));                    // getDetailsDialog(
                          // //     context,
                          // //     snapshot.data.docs[index],
                          // //     data['title'],
                          //     data['time'],
                          //     data['image'],
                          //     data['price'],
                          //     data['details'],
                          //     data['uid']);
                          _showMyDialog(data.id);
                        },
                        onLongPress: () {
                          //     deleteData( snapshot.data.docs[index].id);
                          //Fluttertoast.showToast(msg: "Deleted");
                        },
                        child: OrderBoxPend(
                          documentSnapshot: data,
                          id: data.id,
                          description: data['description'],
                          dueDays: data['dueDays'],
                          start: data['start'],
                          dueTime: data['dueTime'],
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
  }

  Future<void> _showMyDialog(var id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation Dialog'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Are you want to Accept or Reject'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Accept'),
              onPressed: () async {
                print('Confirmed');
                FirebaseFirestore.instance
                    .collection('Requests')
                    .doc("$id")
                    .update({
                  'status': "in-progress",
                });
                Navigator.of(context).pop();

                Fluttertoast.showToast(msg: "Accepted");

                setState(() {});
              },
            ),
            TextButton(
              child: Text('Reject'),
              onPressed: () async {
                print('Rejected');

                deleteData("$id");

                Navigator.of(context).pop();
                Fluttertoast.showToast(msg: "Deleted");

                setState(() {});
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                // deleteData("$id");
                Navigator.of(context).pop();
                // Fluttertoast.showToast(msg: "Deleted");
              },
            ),
          ],
        );
      },
    );
  }

  void deleteData(docId) {
    FirebaseFirestore.instance
        .collection("Requests")
        .doc(docId)
        .delete()
        .catchError((e) {
      print(e);
    });
  }
}

class OrderBoxPend extends StatefulWidget {
  final String name;
  final String start;
  final String phone;
  final String dueTime;
  final String dueDays;
  final String id;
  final String description;
  final String address;

  // String weight;
  final DocumentSnapshot documentSnapshot;

  const OrderBoxPend(
      {Key? key,
      required this.name,
      required this.phone,
      required this.id,
      required this.description,
      required this.address,
      required this.documentSnapshot,
      required this.start,
      required this.dueTime,
      required this.dueDays})
      : super(key: key);

  @override
  _OrderBoxPendState createState() => _OrderBoxPendState();
}

class _OrderBoxPendState extends State<OrderBoxPend> {
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
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Phone Number:",
                    style: TextStyle(
                      fontSize: 12.0,
                    ),
                  ),
                  Text(widget.phone,
                      style: TextStyle(
                        fontSize: 12.0,
                      )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Start Date",
                    style: TextStyle(
                      fontSize: 12.0,
                    ),
                  ),
                  Text(widget.start,
                      style: TextStyle(
                        fontSize: 12.0,
                      )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Given Time:",
                    style: TextStyle(
                      fontSize: 12.0,
                    ),
                  ),
                  Text('${widget.dueDays} days',
                      style: TextStyle(
                        fontSize: 12.0,
                      )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 8.0),
              child: Text("Description: ${widget.description}",
                  style: TextStyle(
                    fontSize: 12.0,
                  )),
            )
          ],
        ),
      ),
    );
  }
}
