import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalconstruction/app/constants/helpers.dart';
import 'package:digitalconstruction/app/widgets/text_fiels.dart';
import 'package:digitalconstruction/models/constructor.dart';
import 'package:digitalconstruction/models/dailywager.dart';
import 'package:digitalconstruction/models/reg_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class ChatPage1 extends StatefulWidget {
  final String user_id;
  final String type;
  final int timestamp;
  const ChatPage1({
    Key? key,
    required this.user_id,
    required this.type,
    required this.timestamp,
  }) : super(key: key);

  // const AvailableSlotsPage({ Key? key }) : super(key: key);
  @override
  _ChatPage1State createState() => _ChatPage1State();
}

class _ChatPage1State extends State<ChatPage1> {
  double myTextFieldWidth = 0.75;
  double myTextFieldHeight = 0.15;

  Widget _chatWidget(String messageText, String timeText) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      height: MediaQuery.of(context).size.height * 0.08,
      decoration: BoxDecoration(
        color: Colors.blue[50],
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 2,
            offset: const Offset(0, 2), //changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [Text('$messageText')],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [Text('$timeText')],
            ),
          ],
        ),
      ),
    );
  }
  String readTimestamps(int timestamp) {
    DateTime now = DateTime.now();
    var format = DateFormat('HH:mm a');
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var time = format.format(date);
    return time;
  }
  String readTimestamp(int timestamp) {
    if(timestamp==0){
      return "Today";
    }
    else {
      DateTime now = DateTime.now();
      var format = DateFormat('mm/dd/yyyy');
      DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
      var diff = now.difference(date);
      var time = '';
      bool condition1 = (diff.inSeconds > 0 && diff.inMinutes == 0);
      bool condition2 = (diff.inMinutes > 0 && diff.inHours == 0);
      bool condition3 = ((diff.inHours > 0 && diff.inDays == 0));
      if (condition1) {
        time = 'Today';
      }
      else if (condition2) {
        time = 'Today';
      }
      else if (condition3) {
        time = 'Today';
      }
      else if (diff.inDays > 0 && diff.inDays < 7) {
        if (diff.inDays == 1) {
          time = 'Yesterday';
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
  }
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
  Constructors cons=Constructors(
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
    // TODO: implement initState
    super.initState();
    if(widget.type=="Constructors"){
      cons = Helper.fetchConstructorValue(widget.user_id);
    }else{
      dw=Helper.fetchDailyWagerValue(widget.user_id);
    }
  }
  @override
  Widget build(BuildContext context) {
    TextEditingController chat=TextEditingController();
    double width= MediaQuery.of(context).size.width;
    double height= MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 70,
        title: const Text(
          'Chat',
        ),

      ),
      body: Stack(
        children: [
          Positioned(
            top: height*0.001,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.85,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 6), //changes position of shadow
                  ),
                ],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      const ListTile(
                        leading: CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage('assets/digi.jpg')
                        ),
                        title: Text(
                          'Admin',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:  [
                            const Text(
                              '___',
                              style:
                              TextStyle(fontSize: 30, color: Colors.grey),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 35, right: 35, top: 20),
                              child: Text(
                                readTimestamp(widget.timestamp),
                                style:
                                const TextStyle(fontSize: 20, color: Colors.grey),
                              ),
                            ),
                            const Text(
                              '___',
                              style:
                              TextStyle(fontSize: 30, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),

                      StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("users")
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .collection("chats")
                              .doc("YFl0tqN5sHGuSmAYbWP1")
                              .collection("messages")

                              .snapshots(),
                          builder: (context, snapshot) {

                            return
                              !snapshot.hasData
                                  ? const Center(
                                child: CircularProgressIndicator(),
                              )
                                  :
                              SizedBox(
                                width: MediaQuery.of(context).size.width ,
                                height: MediaQuery.of(context).size.height * 0.57,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (_, index) {
                                    DocumentSnapshot data =
                                    snapshot.data!.docs[index];
                                    String text = data["text"];
                                    bool flag=false;
                                    if(data['sender_id']==FirebaseAuth.instance.currentUser!.uid){
                                      flag=true;
                                    }
                                    //String last_message = data["last_message"];
                                    int timestamp = data["timestamp"];
                                    String readAbleTime = readTimestamps(timestamp);

                                    return
                                      Padding(
                                          padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                                          child: flag==true? Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,

                                            children: [
                                              _chatWidget(text, readAbleTime),
                                              SizedBox(height: 10,)
                                            ],

                                          ):
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              _chatWidget(text, readAbleTime),
                                              SizedBox(height: 10,)

                                            ],
                                          )                                  );
                                  },

                                ),
                              );

                          }
                      ),
                      //buttom container for write message in text field

                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.only(left: 15),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.075,
              color: Colors.pink[200],
              child: Row(
                children: [
                  myTextFieldWidget(
                      context,
                      'Write your Message',
                      myTextFieldWidth,
                      myTextFieldHeight,
                      false,
                      TextInputType.text,
                      chat

                  ),
                  SizedBox(
                    width: 5,
                  ),

                ],
              ),
            ),
          ),

          Positioned(
            bottom: height*0.01,
            right: 15,
            child: SizedBox(

              width: MediaQuery.of(context).size.width*0.15,
              height: MediaQuery.of(context).size.height *0.055,
              child: InkWell(
                onTap: (){
                  DateTime now=DateTime.now();
                  int time=now.millisecondsSinceEpoch;
                  String times=time.toString();
                  FirebaseFirestore.instance
                      .collection(widget.type)
                      .doc("YFl0tqN5sHGuSmAYbWP1")
                      .collection("chats")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection("messages")
                      .doc(times).set({
                    'id':times,
                    'receiver_id':widget.user_id,
                    'sender_id':FirebaseAuth.instance.currentUser!.uid,
                    'text':chat.text,
                    'timestamp':time
                  });
                  FirebaseFirestore.instance
                      .collection("users")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection("chats")
                      .doc("YFl0tqN5sHGuSmAYbWP1")
                      .collection("messages")
                      .doc(times).set({
                    'id':times,
                    'receiver_id':widget.user_id,
                    'sender_id':FirebaseAuth.instance.currentUser!.uid,
                    'text':chat.text,
                    'timestamp':time
                  });
                  FirebaseFirestore.instance
                      .collection("users")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection("chats")
                      .doc("YFl0tqN5sHGuSmAYbWP1")
                      .set({
                    'user_id':widget.user_id,
                    'last_message':chat.text,
                    'timestamp':time,
                    'sender':widget.type
                  });
                  FirebaseFirestore.instance
                      .collection(widget.type)
                      .doc("YFl0tqN5sHGuSmAYbWP1")
                      .collection("chats")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .set({
                    'user_id':FirebaseAuth.instance.currentUser!.uid,
                    'last_message':chat.text,
                    'timestamp':time,
                    'sender':widget.type
                  });
                  chat.clear();
                },
                child: Image.asset('assets/tele.png',
                  fit: BoxFit.fill,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}