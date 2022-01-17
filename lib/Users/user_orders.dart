import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalconstruction/app/constants/helpers.dart';
import 'package:digitalconstruction/models/constructor.dart';
import 'package:digitalconstruction/models/dailywager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

var anId;
var uId;

class TabBarDemo extends StatefulWidget {
  const TabBarDemo({Key? key}) : super(key: key);

  @override
  _TabBarDemoState createState() => _TabBarDemoState();
}

class _TabBarDemoState extends State<TabBarDemo>
    with SingleTickerProviderStateMixin {
  TabController? _controller;
  int _selectedIndex = 0;

  List<Widget> list = [
    Tab(
      child: Container(
        height: 30.0,
        width: 100.0,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.blue.withOpacity(0.2),
            ),
            borderRadius: BorderRadius.circular(10)),
        child: Center(
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
              color: Colors.blue.withOpacity(0.2),
            ),
            borderRadius: BorderRadius.circular(10)),
        child: const Center(
            child: Text(
          "Confirmed",
          style: TextStyle(color: Colors.green),
        )),
      ),
    ),
  ];
  dynamic data;String name="";

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: Text('Bookings',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: TabBarView(
        controller: _controller,
        children: const [
          PendingOrders(),
          Bookings(),
        ],
      ),
    );
  }
}


class Bookings extends StatefulWidget {
  const Bookings({Key? key}) : super(key: key);

  @override
  _BookingsState createState() => _BookingsState();
}

class _BookingsState extends State<Bookings> {
  String? userId;

  final User? user = FirebaseAuth.instance.currentUser;
  String? review;
  dynamic data;
  String name="";
  String name1="";


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("Requests")
          .where('user', isEqualTo: user!.uid)
          .where("status", isEqualTo: "in-progress")
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
                    String? projectID= Text(data['projID']).data;
                    String? id;
                    print('Project Identity>>>>>>>'+ projectID!);
String name2="";
                    String? constructorID= Text(data['contractor']).data;
                    if(constructorID=="null"){
                      id= Text(data['wagerID']).data!;
                      print('Wager Identity>>>>>>>>>>>>'+ id);
                      DailyWagers dw=Helper.fetchDailyWagerValue(id);
                      name2=dw.Name;
                      print(name);

                    }
                    else{
                      id=constructorID;
                      print('Constructor Identity>>>>>'+ constructorID!);
                      Constructors constructor=Helper.fetchConstructorValue(constructorID);
                      name2=constructor.Name;

                      print(name);

                    }
                    return GestureDetector(
                      onTap: () {
                        _showMyDialog(data.id);
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
                        name: name2,
                        phone: data['phone'],
                        address: data['address'],
                      ),
                    );
                  },
                ),
              );
      },
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

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  void initState() {
    // print(u);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text("Book");
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
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          border: Border.all(
              color: Colors.blue.withOpacity(0.1), // set border color
              width: 2.0),
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue.withOpacity(0.2), // set border color
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
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
                        const TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
                  Text(widget.address,
                      style: const TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold)),
                ],
              ),
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

class PendingOrders extends StatefulWidget {
  const PendingOrders({Key? key}) : super(key: key);

  @override
  _PendingOrdersState createState() => _PendingOrdersState();
}

class _PendingOrdersState extends State<PendingOrders> {
  String? userId;

  final User? user = FirebaseAuth.instance.currentUser;
  String? review;
  dynamic data;
  String name1="";
  String name="";

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("Requests")
          .where('user', isEqualTo: user!.uid)
          .where("status", isEqualTo: "pending")
          .snapshots(),
      builder: (context, snapshot) {
        return !snapshot.hasData
            ? const Center(child: CircularProgressIndicator())
            : SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  shrinkWrap: true,
                  // scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot data = snapshot.data!.docs[index];
                    String? projectID= Text(data['projID']).data;
                    String? id;
                    print('Project Identity>>>>>>>'+ projectID!);
String name2="";
                    String? constructorID= Text(data['contractor']).data;
                    if(constructorID=="null"){
                      id= Text(data['wagerID']).data!;
                      print('Wager Identity>>>>>>>>>>>>'+ id);
                      DailyWagers dw=Helper.fetchDailyWagerValue(id);
                      name2=dw.Name;
                      print(name);

                    }
                    else{
                      id=constructorID;
                      print('Constructor Identity>>>>>'+ constructorID!);
                      Constructors constructor=Helper.fetchConstructorValue(constructorID);
                      name2=constructor.Name;
                      print(name);

                    }
                    return GestureDetector(
                      onTap: () {
                        _showMyDialog(data.id);

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
                      },
                      onLongPress: () {
                        //     deleteData( snapshot.data.docs[index].id);
                        //Fluttertoast.showToast(msg: "Deleted");
                      },
                      child: OrderBox(
                        documentSnapshot: data,
                        id: data.id,
                        description: data['description'],
                        name: name2,
                        phone: data['phone'],
                        address: data['address'],
                      ),
                    );
                  },
                ),
              );
      },
    );
  }

  Future<void> updateDialog(BuildContext context) {
    return showDialog(
        context: context,
        // barrierDismissible: false,
        builder: (BuildContext context) {
          return Scaffold(
              appBar: AppBar(
                actions: <Widget>[],
              ),
              body: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return ListView.builder(
                      itemBuilder: (listContext, index) =>
                          buildItem(snapshot.data!.docs[index]),
                      itemCount: snapshot.data!.docs.length,
                    );
                  }

                  return Container();
                },
              ));
        });
  }

  buildItem(doc) {
    return (userId != uId)
        ? GestureDetector(
            onTap: () {
              // Navigator.push(context,
              //   //  MaterialPageRoute(builder: (context) => ChatPage(docs: doc,)));
            },
            child: Card(
              color: Colors.lightBlue,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(uId),
                ),
              ),
            ),
          )
        : Container();
  }

  Future<void> _showMyDialog(var id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation Dialog'),
          content: SingleChildScrollView(
            child: Column(
              children: const <Widget>[
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
