import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../values/values.dart';

class Filter extends Equatable {
  final int id;
  final String status;
  final Color color;

  const Filter({
    required this.id, 
    required this.status,
    required this.color
  });

  @override
  List<Object?> get props => [id, status];

  static List<Filter> get filters => [
    const Filter(id: 0, status: 'All', color: AppColor.secondaryColor),
    const Filter(id: 1, status: 'Started', color: Colors.redAccent),
    const Filter(id: 2, status: 'Pending', color: Colors.orangeAccent),
    const Filter(id: 3, status: 'Booked', color: Colors.white),
    const Filter(id: 4, status: 'Requested', color: Colors.blue),
    const Filter(id: 5, status: 'Completed', color: Colors.green),
    const Filter(id: 6, status: 'Cancelled', color: Colors.red),
  ];
}

class FilterService extends Equatable {
  final int id;
  final String status;
  final Color color;

  const FilterService({
    required this.id, 
    required this.status,
    required this.color
  });

  @override
  List<Object?> get props => [id, status];

  static List<FilterService> get filters => [
    const FilterService(id: 0, status: 'All', color: AppColor.secondaryColor),
    const FilterService(id: 1, status: 'Started', color: Colors.redAccent),
    const FilterService(id: 2, status: 'Pending', color: Colors.orangeAccent),
    const FilterService(id: 3, status: 'Booked', color: Colors.white),
    const FilterService(id: 4, status: 'Requested', color: Colors.blue),
    const FilterService(id: 5, status: 'Completed', color: Colors.green),
    const FilterService(id: 6, status: 'Cancelled', color: Colors.red),
  ];
}