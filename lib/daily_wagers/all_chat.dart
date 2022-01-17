import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalconstruction/app/constants/helpers.dart';
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
              "Wagers/${FirebaseAuth.instance.currentUser!.uid}/chats")
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
                  String last_message = data["last_message"];
                  int timestamp = data["timestamp"];

                  String readAbleTime = Helper.readTimestamp(timestamp);

                  RegUser user = Helper.fetchUserValue(userID);

                  return GestureDetector(
                    child: ListTile(
                      leading: const CircleAvatar(
                        radius: 30,
                        backgroundImage:AssetImage('assets/digi.jpg')
                        //NetworkImage(user.image_url),
                      ),
                      title: Text(
                          "${user.first_name} " + user.last_name),
                      subtitle: Text(last_message),
                      trailing: Text(readAbleTime),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,MaterialPageRoute(builder: (context)=>
                        ChatPage(
                           user_id: userID, timestamp: data['timestamp'],
                        ),
                      ));
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