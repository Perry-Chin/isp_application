import 'package:cloud_firestore/cloud_firestore.dart';

//User information
class UserData {
  final String? id;
  final String? username;
  final String? email;
  final String? phoneNo;
  final String? photourl;
  final String? address;
  final double? rating;
  final String? account;

  //Constructor
  UserData({
    this.id,
    this.username,
    this.email,
    this.phoneNo,
    this.photourl,
    this.address,
    this.rating,
    this.account,
  });

  // Create UserData object from Firestore document snapshot
  factory UserData.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return UserData(
      id: data?['user_id'],
      username: data?['username'],
      email: data?['email'],
      phoneNo: data?['phone_number'],
      photourl: data?['photourl'],
      address: data?['address'],
      rating: data?['rating'],
      account: data?['account_type'],
    );
  }

  // Convert UserData object to Firestore document data
  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "user_id": id,
      if (username != null) "username": username,
      if (email != null) "email": email,
      if (phoneNo != null) "phone_number": phoneNo,
      if (photourl != null) "photourl": photourl,
      if (address != null) "address": address,
      if (rating != null) "rating": rating,
      if (account != null) "account_type": account,
    };
  }

}

//User login
class UserLoginResponseEntity {
  String? accessToken;
  String? email;
  String? username;

  //Constructor
  UserLoginResponseEntity({
    this.accessToken,
    this.email,
    this.username
  });

  factory UserLoginResponseEntity.fromJson(Map<String, dynamic> json) =>
    UserLoginResponseEntity(
      accessToken: json["access_token"],
      email: json["email"],
      username: json["name"]
    );

  Map<String, dynamic> toJson() => {
    "access_token": accessToken,
    "email": email,
    "name": username
  };
}