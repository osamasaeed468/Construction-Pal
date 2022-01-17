class RegUser {
  String uid, first_name, last_name, email, cnic, phone, address;
  // image_url;
  // bool phoneVerified;

//constructor
  RegUser({
    required this.uid,
    required this.first_name,
    required this.last_name,
    required this.email,
    required this.address,
    required this.cnic,
    required this.phone,
    //required this.image_url,
    //required this.notification_token,
  });

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "first_name": first_name,
      "last_name": last_name,
      "email": email,
      "cnic": cnic,
      "address": address,
      "phone": phone,
      //  "image_url": image_url,
      //"notification_token": notification_token,
    };
  }

  factory RegUser.fromJson(Map<String, dynamic> jason) {
    return RegUser(
        //jason!["userId"] as String,
        uid: jason["uid"] as String,
        first_name: jason["first_name"] as String,
        last_name: jason["last_name"] as String,
        email: jason["email"] as String,
        address: jason["address"] as String,
        cnic: jason["cnic"] as String,
        phone: jason["phone"] as String);
    //image_url: jason["image_url"] as String,
    //notification_token: jason["notification_token"] as String);
  }
}
