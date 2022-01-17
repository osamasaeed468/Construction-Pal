import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalconstruction/app/constants/helpers.dart';
import 'package:digitalconstruction/models/constructor.dart';
import 'package:digitalconstruction/models/dailywager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rating_dialog/rating_dialog.dart';


class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> with SingleTickerProviderStateMixin {
  String? userId;
  dynamic data;
  String name="";
  String name1="";
  Future<dynamic> getDataWagers(String uID) async {
    final DocumentReference document =
    FirebaseFirestore.instance.collection("Wagers").doc(uID);

    await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        data = snapshot.data;
        name=data()['Name'].toString();
      });
    });
  }
  Future<dynamic> getDataCons(String uID) async {
    final DocumentReference document =
    FirebaseFirestore.instance.collection("Constructors").doc(uID);

    await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        data = snapshot.data;
        name1=data()['Name'].toString();
      });
    });
  }

  final User? user = FirebaseAuth.instance.currentUser;
  String? review;
  int? _rating;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
        centerTitle: true,
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream:
          FirebaseFirestore.instance.collection("Requests").where('user',isEqualTo: user!.uid).where('status',isEqualTo: 'complete').snapshots(),
          builder: (context, snapshot) {
            return !snapshot.hasData
                ? Center(child: CircularProgressIndicator())
                : SizedBox(
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot data = snapshot.data!.docs[index];
                  String? projectID= Text(data['projID']).data;
                  String? id;
                  print('Project Identity>>>>>>>'+ projectID!);
                  String name2="";
                  String? constructorID= Text(data['contractor']).data;
                  String type="";
                  if(constructorID=="null"){
                    id= Text(data['wagerID']).data!;
                    print('Wager Identity>>>>>>>>>>>>'+ id);
                    DailyWagers dw=Helper.fetchDailyWagerValue(id);
                    name2=dw.Name;
                    type="wager";
                    print(name);

                  }
                  else{
                    id=constructorID;
                    print('Constructor Identity>>>>>'+ constructorID!);
                    Constructors constructor=Helper.fetchConstructorValue(constructorID);
                    name2=constructor.Name;
                    type="const";

                    print(name);
                    print("Project Id is:"+data.id);

                  }
                  return GestureDetector(
                    onTap: ()  {

                      String c=data['countReviews'];
                      int d=int.parse(c);
                      if(d==0){
                        _showRatingAppDialog(data.id,id!,type);}
                      else{
                        _showDialog();
                      }


                    },
                    onLongPress: () {
                      // deleteData( snapshot.data.docs[index].id);
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
        ),
      ),
    );

  }

  Future<void> _showDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Yoh have submitted your review'),

          actions: <Widget>[

            TextButton(
              child: const Text('Ok'),
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
  void _showRatingAppDialog(String projectID, String constructorID,String type) {
    final _ratingDialog = RatingDialog (
      starColor:Colors.amber,
      title: const Text('Rating the Work!'),
      message: const Text('Please rate the work to know others about constructor work.'),

      submitButtonText: 'Submit',
      onCancelled: () => print('cancelled'),
      onSubmitted: (response) async{



        String b="1";
        FirebaseFirestore.instance
            .collection('Requests')
            .doc(projectID)
            .update({
          'countReviews': b,
        }
        );
        if(type=="const") {
        dynamic variable = await FirebaseFirestore.instance
            .collection("Constructors")
            .doc(constructorID)
            .get();

          String ratings = variable.data()!['totalRating'];
          print(ratings);

          String? reviews = variable.data()!['totalReviews'].toString();
          print(reviews);
          String rev = "1";
          int sumr = (int.parse(reviews) + int.parse(rev));
          String totalReviews = sumr.toString();

          String? num = '${response.rating}';
          print(num);
          double sum = (double.parse(ratings) + response.rating);
          String totalRating = sum.toString();
          print(sum);
          String myRating = (sum / sumr).toString();
          double rat=double.parse(myRating);
          print(myRating);
          print(rat);
          FirebaseFirestore.instance
              .collection('Constructors')
              .doc(constructorID)
              .update({
            'totalRating': totalRating,
            'totalReviews': totalReviews,
            'myRating': rat,
          });

          FirebaseFirestore.instance
              .collection('Requests')
              .doc(projectID)
              .update({
            'userReview': response.comment,
          }
          );
        }else{
          var variable = await FirebaseFirestore.instance
              .collection("Wagers")
              .doc(constructorID)
              .get();

          String ratings = variable.data()!['totalRating'].toString();
          String reviews = variable.data()!['totalReviews'].toString();
          String rev = "1";
          int sumr = (int.parse(reviews) + int.parse(rev));
          String totalReviews = sumr.toString();

          String num = '${response.rating}';
          double sum = (double.parse(ratings) + response.rating);
          String totalRating = sum.toString();
          String myRating = (sum / sumr).toString();
          double rat=double.parse(myRating);
          FirebaseFirestore.instance
              .collection('Wagers')
              .doc(constructorID)
              .update({
            'totalRating': totalRating,
            'totalReviews': totalReviews,
            'myRating': rat,
          }
          );
          FirebaseFirestore.instance
              .collection('Requests')
              .doc(projectID)
              .update({
            'userReview': response.comment,
          }
          );

        }

        print('rating: ${response.rating}, '
            'comment: ${response.comment}'
        );

        if (response.rating < 3.0) {
          print('response.rating: ${response.rating}');
        } else {
          Container();
        }
      },
    );

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => _ratingDialog,
    );
  }
}

class Completed extends StatefulWidget {
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
            .where('user', isEqualTo: user!.uid)
            .where("status", isEqualTo: "complete")
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
              blurRadius: 2,
              offset: const Offset(0, 3), // changes position of shadow
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
