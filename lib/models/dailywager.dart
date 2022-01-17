class DailyWagers {
  String uid,
      Name,
      type,
      email,
      price,
      phone,
      totalReviews,
      totalRating,
      orders,
      image,
      expertise,
      experience,
      description,
      cnic,
      city;
  //    countryCode;
  //notificationToken;
  double latitude, longitude, myRating,myDistance;

  DailyWagers({
    required this.uid,
    required this.Name,
    required this.city,
    required this.email,
    required this.cnic,
    required this.phone,
    required this.expertise,
    required this.image,
    required this.experience,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.myRating,
    required this.totalRating,
    required this.orders,
    required this.price,
    required this.totalReviews,
    required this.type,
    required this.myDistance
  });

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "Name": Name,
      "city": city,
      "email": email,
      "cnic": cnic,
      "phone": phone,
      "description": description,
      "image": image,
      "expertise": expertise,
      "experience": experience,
      "latitude": latitude,
      "longitude": longitude,
      "myRating": myRating,
      "totalReviews": totalReviews,
      "totalRating": totalRating,
      "orders": orders,
      "price": price,
      "type": type,
      "myDistance": myDistance
    };
  }

  factory DailyWagers.fromJson(Map<String, dynamic> jason) {
    return DailyWagers(
      uid: jason["uid"] as String,
      Name: jason["Name"] as String,
      city: jason["city"] as String,
      email: jason["email"] as String,
      cnic: jason["cnic"] as String,
      phone: jason["phone"] as String,
      orders: jason["orders"] as String,
      image: jason["image"] as String,
      type: jason["type"] as String,
      price: jason["price"] as String,
      latitude: double.tryParse("${jason["latitude"]}") ??
          (jason["latitude"] as int).toDouble(),
      myDistance: double.tryParse("${jason["myDistance"]}") ??
          (jason["myDistance"] as int).toDouble(),
      longitude: double.tryParse("${jason["longitude"]}") ??
          (jason["longitude"] as int).toDouble(),
      myRating: double.tryParse("${jason["myRating"]}") ??
          (jason["myRating"] as int).toDouble(),
      description: jason["description"] as String,
      experience: jason["experience"] as String,
      totalReviews: jason["totalReviews"] as String,
      totalRating: jason["totalRating"] as String,
      expertise: jason["expertise"] as String,
    );
  }
}
