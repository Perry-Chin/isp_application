import 'package:cloud_firestore/cloud_firestore.dart';

//Service information
class ServiceData {
  //Service details
  final String? serviceid;
  final String? serviceName;
  final String? description;
  final int? rate;
  final String? image;
  //Service personal info
  final String? location;
  final String? date;
  final String? time;
  final int? duration;
  //Service info
  final String? status;
  //Personal information of requester
  final String? reqUserid;
  final String? reqUsername;
  //Personal information of provider
  final String? provUserid;
  final String? provUsername;

  //Constructor
  ServiceData({
    this.serviceid,
    this.serviceName,
    this.description,
    this.rate,
    this.image,
    this.location,
    this.date,
    this.time,
    this.duration,
    this.status,
    this.reqUserid,
    this.reqUsername,
    this.provUserid,
    this.provUsername,
  });

  // Create ServiceData object from Firestore document snapshot
  factory ServiceData.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return ServiceData(
      serviceid: data?['service_id'],
      serviceName: data?['service_name'],
      description: data?['description'],
      rate: data?['rate'],
      image: data?['photourl'],
      location: data?['location'],
      date: data?['date'],
      time: data?['start_time'],
      duration: data?['duration'],
      status: data?['status'],
      reqUserid: data?['requester_uid'],
      reqUsername: data?['requester_name'],
      provUserid: data?['provider_uid'],
      provUsername: data?['provider_name'],
    );
  }

  // Convert ServiceData object to Firestore document data
  Map<String, dynamic> toFirestore() {
    return {
      if (serviceid != null) "service_id": serviceid,
      if (serviceName != null) "service_name": serviceName,
      if (description != null) "description": description,
      if (rate != null) "rate": rate,
      if (image != null) "photourl": image,
      if (location != null) "location": location,
      if (date != null) "date": date,
      if (time != null) "start_time": time,
      if (duration != null) "duration": duration,
      if (status != null) "status": status,
      if (reqUserid != null) "requester_uid": reqUserid,
      if (reqUsername != null) "requester_name": reqUsername,
      if (provUserid != null) "provider_uid": provUserid,
      if (provUsername != null) "provider_name": provUsername,
    };
  }
}