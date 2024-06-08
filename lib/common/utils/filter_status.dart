import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class FilterService extends Equatable {
  final int id;
  final String status;

  const FilterService({
    required this.id, 
    required this.status
  });

  @override
  List<Object?> get props => [id, status];

  static List<FilterService> get filters => [
    const FilterService(id: 0, status: 'Grooming'),
    const FilterService(id: 1, status: 'Walking'),
    const FilterService(id: 2, status: 'Petting'),
    const FilterService(id: 3, status: 'Sitting'),
    const FilterService(id: 4, status: ''),
    const FilterService(id: 5, status: ''),
    const FilterService(id: 6, status: ''),
  ];
}

class FilterStatus extends Equatable {
  final int id;
  final String status;
  final Color color;

  const FilterStatus({
    required this.id, 
    required this.status,
    required this.color
  });

  @override
  List<Object?> get props => [id, status];

  static List<FilterStatus> get filters => [
    const FilterStatus(id: 0, status: 'Started', color: Colors.redAccent),
    const FilterStatus(id: 1, status: 'Pending', color: Colors.orangeAccent),
    const FilterStatus(id: 2, status: 'Booked', color: Colors.cyan),
    const FilterStatus(id: 3, status: 'Requested', color: Colors.blue),
    const FilterStatus(id: 4, status: 'Completed', color: Colors.green),
    const FilterStatus(id: 5, status: 'Cancelled', color: Colors.red),
  ];
}