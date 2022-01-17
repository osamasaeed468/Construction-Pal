import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalconstruction/app/constants/helpers.dart';
import 'package:digitalconstruction/models/constructor.dart';
import 'package:digitalconstruction/models/dailywager.dart';
import 'package:digitalconstruction/models/reg_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'chat.dart';


class ChatWithBarberLayout extends StatelessWidget {
  // String? barberID;
  const ChatWithBarberLayout({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 70,
        title: const Text(
          'All Chats',
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection(
              "users/${FirebaseAuth.instance.currentUser!.uid}/chats")
              .orderBy("timestamp", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            return !snapshot.hasData
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: snapshot.data!.docs.isNotEmpty
                  ? ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (_, index) {
                  DocumentSnapshot data =
                  snapshot.data!.docs[index];
                  // yaha pr hum firebase sey jo data aa raha hai jason ki form mey osey hum apni Comment wali class mey map krwa rahey hain

                  String userID = data["user_id"];
                  String type = data["sender"];

                  String last_message = data["last_message"];
                  int timestamp = data["timestamp"];

                  String readAbleTime = Helper.readTimestamp(timestamp);
                  Constructors constructors=Constructors(
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
                  DailyWagers dw = DailyWagers(
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
                  if(type=="Constructors"){
                    constructors = Helper.fetchConstructorValue(userID);

                  }
                  else{
                    dw=Helper.fetchDailyWagerValue(userID);
                  }
                  String name="";
                  if(constructors.Name=="Name" && dw.Name=="Name"){
                    name="Admin";
                  }else if(constructors.Name=="Name"){
                    name=dw.Name;
                  }else{
                    name=constructors.Name;
                  }

                  return GestureDetector(
                    child: ListTile(
                      leading: const CircleAvatar(
                        radius: 30,
                        backgroundImage:AssetImage('assets/digi.jpg')
                        //NetworkImage(user.image_url),
                      ),
                      title: Text(name),
                      subtitle: Text(last_message),
                      trailing: Text(readAbleTime),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,MaterialPageRoute(builder: (context)=>
                        ChatPage(
                           user_id: userID, timestamp: data['timestamp'], type: type,
                        ),
                      )
                      );
                    },
                  );
                },
                separatorBuilder: (_, index) {
                  return const Divider();
                },
              )
                  : const Center(
                child: Text(
                  "No Chat",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            );
          }),
    );

  }
}