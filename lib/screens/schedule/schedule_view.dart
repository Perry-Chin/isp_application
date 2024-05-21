import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'schedule_provider.dart'; // Ensure this imports the correct file
import 'schedule_requester.dart'; // Ensure this imports the correct file
// import '../../common/data/user.dart';
// import 'package:get/get_utils/get_utils.dart';
// import 'schedule_index.dart';


class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp( // Use GetMaterialApp instead of MaterialApp for GetX integration
      debugShowCheckedModeBanner: false,
      home: SchedulePage(),
    );
  }
}

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  List<String> selectedFilters = ['all'];
  List<String> selectedRating = ['all'];

  Future<void> _navigateAndDisplayFilter(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Filter(selectedFilters: selectedFilters, selectedRating: selectedRating)),
    );

    if (result != null && result is Map<String, List<String>>) {
      setState(() {
        selectedFilters = result['status']!;
        selectedRating = result['rating']!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Schedule',
          style: TextStyle(color: Colors.black, fontSize: 28, fontWeight: FontWeight.bold),
        ),
        toolbarHeight: 70,
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.black),
            onPressed: () {
              _navigateAndDisplayFilter(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.black,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xFFFFBA08),
                  ),
                  tabs: const [
                    Tab(
                      child: Text(
                        "Provider",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Requester',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    ProviderCard(),
                    RequesterProviderCards(statusFilter: selectedFilters, ratingFilter: selectedRating),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Filter extends StatefulWidget {
  final List<String> selectedFilters;
  final List<String> selectedRating;
  const Filter({Key? key, required this.selectedFilters, required this.selectedRating}) : super(key: key);

  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  late List<String> selectedStatus;
  late List<String> selectedRating;

  @override
  void initState() {
    super.initState();
    selectedStatus = List.from(widget.selectedFilters);
    selectedRating = List.from(widget.selectedRating);
    _checkAndSelectAllStatus();
    _checkAndSelectAllRating();
  }

  void _checkAndSelectAllStatus() {
    if (selectedStatus.isEmpty) {
      selectedStatus = ['all'];
    }
  }

  void _checkAndSelectAllRating() {
    if (selectedRating.isEmpty) {
      selectedRating = ['all'];
    }
  }

  void _updateSelectedStatus(String status) {
    setState(() {
      if (status == 'all') {
        selectedStatus = ['all'];
      } else {
        if (selectedStatus.contains(status)) {
          selectedStatus.remove(status);
        } else {
          selectedStatus.add(status);
        }

        if (selectedStatus.contains('cancelled') &&
            selectedStatus.contains('pending') &&
            selectedStatus.contains('finished')) {
          selectedStatus = ['all'];
        } else if (selectedStatus.isEmpty) {
          selectedStatus = ['all'];
        } else {
          selectedStatus.remove('all');
        }
      }
    });
  }

  void _updateSelectedRating(String rating) {
    setState(() {
      if (rating == 'all') {
        selectedRating = ['all'];
      } else {
        if (selectedRating.contains(rating)) {
          selectedRating.remove(rating);
        } else {
          selectedRating.add(rating);
        }

        if (selectedRating.contains('1 - 3') &&
            selectedRating.contains('3 - 5')) {
          selectedRating = ['all'];
        } else if (selectedRating.isEmpty) {
          selectedRating = ['all'];
        } else {
          selectedRating.remove('all');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.pop(context, {'status': selectedStatus, 'rating': selectedRating});
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Status",
                  style: TextStyle(color: Colors.black, fontSize: 28),
                ),
              ],
            ),
            const Divider(thickness: 1),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatusButton('all', Colors.grey),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatusButton('finished', Colors.green),
                _buildStatusButton('cancelled', Colors.red),
                _buildStatusButton('pending', Colors.blue),
              ],
            ),
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Reviews",
                  style: TextStyle(color: Colors.black, fontSize: 28),
                ),
              ],
            ),
            const Divider(thickness: 1),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildRatingButton('all'),
                _buildRatingButton('1 - 3'),
                _buildRatingButton('3 - 5'),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {'status': selectedStatus, 'rating': selectedRating});
              },
              child: const Text('Apply Filter'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusButton(String status, Color color) {
    return GestureDetector(
      onTap: () {
        _updateSelectedStatus(status);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: selectedStatus.contains(status) ? color : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black),
                ),
                child: selectedStatus.contains(status)
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      )
                    : null,
              ),
              const SizedBox(width: 10),
              Text(
                "${status}",
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRatingButton(String rating) {
    return GestureDetector(
      onTap: () {
        _updateSelectedRating(rating);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: selectedRating.contains(rating) ? Colors.yellow : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black),
                ),
                child: selectedRating.contains(rating)
                    ? const Icon(
                        Icons.check,
                        color: Colors.black,
                        size: 16,
                      )
                    : null,
              ),
              const SizedBox(width: 10),
              Text(
                rating,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}


class RatedStar extends StatelessWidget {
  final double rating;
  final Color starColor;
  final double iconSize;

  const RatedStar({
    super.key,
    required this.rating,
    required this.starColor,
    this.iconSize = 18.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5), // Add padding around the content
      decoration: BoxDecoration(
        color: Colors.yellow, // Set background color to yellow
        borderRadius: BorderRadius.circular(12), // Add border radius for rounded corners
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star,
            color: starColor,
            size: iconSize,
          ),
          const SizedBox(width: 3), // Add spacing between star icon and rating
          Text(
            '$rating',
            style: TextStyle(
              fontSize: iconSize - 4,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
