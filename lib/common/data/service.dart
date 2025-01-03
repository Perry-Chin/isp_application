import 'package:cloud_firestore/cloud_firestore.dart';

import 'data.dart';

class ServiceData {
  final String? serviceid;
  final String? serviceName;
  final String? description;
  final int? rate;
  final String? image;
  final String? location;
  final String? date;
  final String? starttime;
  final String? endtime;
  final double? duration;
  final String? status;
  final int? statusid;
  final String? reqUserid;
  final String? provUserid;
  late final String? proposedTime;
  UserData? userData;

  ServiceData({
    this.serviceid,
    this.serviceName,
    this.description,
    this.rate,
    this.image,
    this.location,
    this.date,
    this.starttime,
    this.endtime,
    this.duration,
    this.status,
    this.statusid,
    this.reqUserid,
    this.provUserid,
    this.proposedTime,
    this.userData,
  });

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
      starttime: data?['start_time'],
      endtime: data?['end_time'],
      duration: (data?['duration'] as num?)?.toDouble(),
      status: data?['status'],
      statusid: data?['statusid'],
      reqUserid: data?['requester_uid'],
      provUserid: data?['provider_uid'],
      proposedTime: data?['proposedTime'],
      userData: data?['userData'] != null ? UserData.fromFirestore(snapshot, options) : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (serviceid != null) "service_id": serviceid,
      if (serviceName != null) "service_name": serviceName,
      if (description != null) "description": description,
      if (rate != null) "rate": rate,
      if (image != null) "photourl": image,
      if (location != null) "location": location,
      if (date != null) "date": date,
      if (starttime != null) "start_time": starttime,
      if (endtime != null) "end_time": endtime,
      if (duration != null) "duration": duration,
      if (status != null) "status": status,
      if (statusid != null) "statusid": statusid,
      if (reqUserid != null) "requester_uid": reqUserid,
      if (provUserid != null) "provider_uid": provUserid,
      if (proposedTime != null) "proposedTime": proposedTime,
      'userData': userData?.toFirestore(),
    };
  }
}
