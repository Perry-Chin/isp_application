import 'package:cloud_firestore/cloud_firestore.dart';

//User information
class UserData {
  final String? id;
  final String? username;
  final String? email;
  final String? photourl;
  final String? address;
  final String? rating;
  final String? account;

  UserData({
    this.id,
    this.username,
    this.email,
    this.photourl,
    this.address,
    this.rating,
    this.account,
  });

  factory UserData.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return UserData(
      id: data?['user_id'],
      username: data?['username'],
      email: data?['email'],
      photourl: data?['photourl'],
      address: data?['address'],
      rating: data?['rating'],
      account: data?['account_type'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "user_id": id,
      if (username != null) "username": username,
      if (email != null) "email": email,
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

  UserLoginResponseEntity({
    this.accessToken,
    this.email,
  });

  factory UserLoginResponseEntity.fromJson(Map<String, dynamic> json) =>
    UserLoginResponseEntity(
      accessToken: json["access_token"],
      email: json["email"],
    );

  Map<String, dynamic> toJson() => {
    "access_token": accessToken,
    "email": email,
  };
}