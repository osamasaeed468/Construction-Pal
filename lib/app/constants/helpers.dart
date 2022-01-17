import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalconstruction/models/constructor.dart';
import 'package:digitalconstruction/models/dailywager.dart';
import 'package:digitalconstruction/models/reg_user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Helper {
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static String getAssetName(String fileName, String type) {
    return "assets/images/$type/$fileName";
  }

  static TextTheme getTheme(BuildContext context) {
    return Theme.of(context).textTheme;
  }
  static List<Constructors> allConsList = [];

// fetch all barbers
  static void fetchAllCons() {
    FirebaseFirestore.instance
        .collection('Constructors')
        .snapshots()
        .listen((querySnapshot) {
      allConsList = [];
// for each loop
      for (var doc in querySnapshot.docs) {
        Constructors constructor = Constructors.fromJson(doc.data());

        allConsList.add(constructor);
      }
    });
  }
  static List<Constructors> constructors(){
    return allConsList;
  }
  static const kDropdownItemsStyle = TextStyle(fontSize: 18, color: Colors.white);
// fetch all barber data
  static Constructors fetchConstructorValue(String barberID) {
    for (Constructors consData in allConsList) {
      if (consData.uid == barberID) {
        return consData;
      }
    }
    return Constructors(
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
  }
  static List<DailyWagers> allWagerList = [];
  static void fetchAllWagers() {
    FirebaseFirestore.instance
        .collection('Wagers')
        .snapshots()
        .listen((querySnapshot) {
      allWagerList = [];
      for (var doc in querySnapshot.docs) {
        DailyWagers constructor = DailyWagers.fromJson(doc.data());

        allWagerList.add(constructor);
      }
    });
  }
  static DailyWagers fetchDailyWagerValue(String barberID) {
    for (DailyWagers consData in allWagerList) {
      if (consData.uid == barberID) {
        return consData;
      }
    }
    return DailyWagers(
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
  }


  static String readTimestamp(int timestamp) {
    DateTime now = DateTime.now();
    var format = DateFormat('HH:mm a');
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var diff = now.difference(date);
    var time = '';
    bool condition1=(diff.inSeconds > 0 && diff.inMinutes == 0);
    bool condition2=(diff.inMinutes > 0 && diff.inHours == 0);
    bool condition3=((diff.inHours > 0 && diff.inDays == 0));
    if (condition1 ) {
      time = 'Now';
    }
    else if(condition2){
      time=diff.inMinutes.toString() + ' Minutes AGO';
    }
    else if(condition3){
      time=diff.inHours.toString() + ' Hours AGO';
    }
    else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + ' DAY AGO';
      } else {
        time = diff.inDays.toString() + ' DAYS AGO';
      }
    } else {
      if (diff.inDays == 7) {
        time = (diff.inDays / 7).floor().toString() + ' WEEK AGO';
      } else {

        time = (diff.inDays / 7).floor().toString() + ' WEEKS AGO';
      }
    }

    return time;
  }
  static List<RegUser> allUsersList = [];

// fetch all barbers
  static void fetchAllUsers() {
    FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .listen((querySnapshot) {
      allUsersList = [];
// for each loop
      for (var doc in querySnapshot.docs) {
        RegUser user = RegUser.fromJson(doc.data());

        allUsersList.add(user);
      }
    });
  }
  static List<RegUser> users(){
    return allUsersList;
  }
// fetch all barber data
  static RegUser fetchUserValue(String userID) {
    for (RegUser userData in allUsersList) {
      if (userData.uid == userID) {
        return userData;
      }
    }
    return RegUser(
      uid: "uid",
      first_name: "Name",
      address: "city",
      email: "email",
      cnic: "cnic",
      phone: "phone",
      last_name: "last_name",
    );
  }

}
