import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'add_constructor.dart';

class Constructor extends StatefulWidget {
  @override
  _ConstructorState createState() => _ConstructorState();
}

class _ConstructorState extends State<Constructor> {
  Query? _ref;
  bool searchState = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Data> dataList = [];
  DatabaseReference reference =
      FirebaseDatabase.instance.reference().child('Constructors');

  String? get key => null;

  @override
  void initState() {
    DatabaseReference referenceData =
        FirebaseDatabase.instance.reference().child("Constructors");

    referenceData.once().then(((dynamic dataSnapShot) {
      dataList.clear();

      var keys = dataSnapShot.value.keys;
      var values = dataSnapShot.value;

      for (var key in keys) {
        Data data = Data(values![key]['name'], values[key]['city'],
            values[key]['experience'], values[key]['type'], key
            //key is the uploadid
            );
        dataList.add(data);

        DatabaseReference reference =
            FirebaseDatabase.instance.reference().child("Constructors");

        //   reference.once().then((DataSnapshot snapShot) {});
      }

      Timer(Duration(seconds: 1), () {
        setState(() {
          //
        });
      });
    }));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  _showDeleteDialog({Map? contact}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete ${contact!['name']}'),
            content: Text('Are you sure you want to delete?'),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
              FlatButton(
                  onPressed: () {
                    reference
                        .child(contact!['key'])
                        .remove()
                        .whenComplete(() => Navigator.pop(context));
                  },
                  child: Text('Delete'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: !searchState
            ? Text('Constructors List')
            : TextField(
                decoration: InputDecoration(
                    icon: Icon(Icons.search),
                    hintText: 'Search ...',
                    hintStyle: TextStyle(
                      color: Colors.white,
                    )),
                onChanged: (String text) {
//            SearchMethod(text);
                },
              ),
        actions: <Widget>[
          !searchState
              ? IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 30,
                  ),
                  padding: const EdgeInsets.only(right: 30),
                  onPressed: () {
                    setState(() {
                      searchState = !searchState;
                    });
                  })
              : IconButton(
                  icon: Icon(
                    Icons.cancel,
                    color: Colors.white,
                    size: 30,
                  ),
                  padding: const EdgeInsets.only(right: 30),
                  onPressed: () {
                    setState(() {
                      searchState = !searchState;
                    });
                  })
        ],
      ),
      body: Center(
        child: ListView.builder(
            itemCount: dataList.length,
            itemBuilder: (_, index) {
              return CardUI(dataList[index].name, dataList[index].city,
                  dataList[index].experience, dataList[index].type, index);
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) {
              return AddConstructor();
            }),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Color getTypeColor(String type) {
    Color color = Theme.of(context).accentColor;

    if (type == 'Electrical') {
      color = Colors.brown;
    }

    if (type == 'Family') {
      color = Colors.green;
    }

    if (type == 'Friends') {
      color = Colors.teal;
    }
    return color;
  }

  Widget CardUI(String name, String city, String exp, String type, int index) {
    return Card(
      elevation: 7,
      margin: EdgeInsets.all(15),
      color: Color(0xffff2fc3),
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.all(1.5),
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Text(
              "$name",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 1,
            ),
            Text("$city", style: TextStyle(color: Colors.black54)),
            SizedBox(
              height: 1,
            ),
            Text("Experience: $exp Years",
                style: TextStyle(color: Colors.black54)),
            SizedBox(
              height: 1,
            ),
            Container(
              width: double.infinity,
              child: Text(
                type,
                style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,
              ),
            ),
            SizedBox(
              height: 1,
            ),
          ],
        ),
      ),
    );
  }
//   void SearchMethod(String text) {
//
//
//       DatabaseReference searchRef = FirebaseDatabase.instance.reference().child(
//           "Constructors");
//       searchRef.once().then((DataSnapshot snapshot) {
//         dataList.clear();
//
//         var keys = snapshot.value.keys;
//         var values = snapshot.value;
//         for (var key in keys) {
//           Data data = new Data(
//               values [key]['name'],
//               values [key]['number'],
//               values [key]['type'],
//               key
//           );
//           if (data.name.contains(text)) {
//
//             dataList.add(data);
//           }
//         }
//       });
//
//   }
}

class Data {
  String name, city, type, experience;

  Data(
    this.name,
    this.city,
    this.experience,
    this.type,
    key,
  );
}
