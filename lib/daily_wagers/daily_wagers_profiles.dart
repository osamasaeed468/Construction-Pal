import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'add_daily_wagers.dart';

class DailyWager extends StatefulWidget {
  @override
  _DWState createState() => _DWState();
}

class _DWState extends State<DailyWager> {
  Query? _ref;
  bool searchState = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<DataDW> dataList = [];
  DatabaseReference reference =
      FirebaseDatabase.instance.reference().child('DailyWager');

//  String get key => null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    DatabaseReference referenceData =
        FirebaseDatabase.instance.reference().child("DailyWager");
    referenceData.once().then((dynamic dataSnapShot) {
      dataList.clear();

      var keys = dataSnapShot.value.keys;
      var values = dataSnapShot.value;

      for (var key in keys) {
        DataDW data = new DataDW(
            values[key]['name'], values[key]['city'], values[key]['type'], key
            //key is the uploadid
            );
        dataList.add(data);

        DatabaseReference reference =
            FirebaseDatabase.instance.reference().child("DailyWager");

        //  reference.once().then((dynamic snapShot) {});
      }

      Timer(Duration(seconds: 1), () {
        setState(() {
          //
        });
      });
    });
  }

  _showDeleteDialog({required Map contact}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete ${contact['name']}'),
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
                        .child(contact['key'])
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
            ? Text('Daily Wagers')
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
                  dataList[index].type, index);
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) {
              return AddWager();
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

    if (type == 'Plumber') {
      color = Colors.green;
    }

    if (type == 'Carpenter') {
      color = Colors.teal;
    }
    return color;
  }

  Widget CardUI(String name, String city, String type, int index) {
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

class DataDW {
  String name, city, type;

  DataDW(
    this.name,
    this.city,
    this.type,
    key,
  );
}
