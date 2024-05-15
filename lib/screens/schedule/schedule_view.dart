import 'package:flutter/material.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> selectedFilters = ['all']; // Initialize with a default filter
  List<String> selectedRating = ['all']; // Initialize with a default rating filter

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
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0), // Adjust padding as needed
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9), // Set the background color of DefaultTabController
                  borderRadius: BorderRadius.circular(20), // Set rounded corners
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
                    FilteredProviderCards(statusFilter: selectedFilters, ratingFilter: selectedRating),
                    const RequesterCards(),
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
  // ignore: library_private_types_in_public_api
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
                status.capitalize(),
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
    // ignore: unnecessary_this
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

class ProviderCard extends StatelessWidget {
  final double rating;
  final Color starColor;
  final String status;

  const ProviderCard({
    Key? key,
    required this.rating,
    required this.starColor,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color statusColor = Colors.green; // Default green for "Finished"
    if (status.toLowerCase() == 'pending') {
      statusColor = Colors.blue; // Change color based on status
    } else if (status.toLowerCase() == 'cancelled') {
      statusColor = Colors.red;
    }

    return Card(
      elevation: 4, // Add elevation for a shadow effect
      margin: const EdgeInsets.all(16), // Add margin around the card
      child: Container(
        decoration: BoxDecoration(border: Border(left: BorderSide(width: 10.0, color: statusColor))),
        padding: const EdgeInsets.all(16), // Add padding inside the card
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start of the column
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(Icons.account_circle, size: 53, color: Colors.grey,),
                const SizedBox(width: 5,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text("Username",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                        const SizedBox(width: 10,),
                        RatedStar(rating: rating, starColor: starColor),
                      ],
                    ),
                    const Text("10:00am - 9:00am"),
                  ],
                )
              ],
            ),
            const SizedBox(height: 10,),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.location_on,size: 28,color: Colors.grey,),
                SizedBox(width: 10,),
                Text("Balam Road"),
              ],
            ),

            const SizedBox(height: 15,),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text("Light Housekeeping"),
                  ),
                ),

                const SizedBox(
                  width: 35,
                ),

                Container(
                  height: 43,
                  width: 110,
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(13),
                      child: Text(status,style: const TextStyle(fontSize: 15, color: Colors.white),),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}


class FilteredProviderCards extends StatelessWidget {
  final List<String> statusFilter;
  final List<String> ratingFilter;

  const FilteredProviderCards({Key? key, required this.statusFilter, required this.ratingFilter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<ProviderCard> allProviderCards = [
      const ProviderCard(rating: 4.5, starColor: Colors.white, status: 'finished'),
      const ProviderCard(rating: 4.2, starColor: Colors.white, status: 'pending'),
      const ProviderCard(rating: 3.9, starColor: Colors.white, status: 'cancelled'),
      const ProviderCard(rating: 2, starColor: Colors.white, status: 'pending'),
      // Add more ProviderCard widgets as needed
    ];

    List<ProviderCard> filteredProviderCards;

    if (statusFilter.contains('all') && ratingFilter.contains('all')) {
      // If both "all" status and "all" rating are selected, display all cards
      filteredProviderCards = allProviderCards;
    } else if (statusFilter.contains('all')) {
      // If "all" status is selected, filter cards based on rating
      filteredProviderCards = allProviderCards.where((card) {
        return ratingFilter.contains('all') ||
            ((ratingFilter.contains('3 - 5') && card.rating >= 3 && card.rating <= 5) ||
                (ratingFilter.contains('1 - 3') && card.rating >= 1 && card.rating <= 3));
      }).toList();
    } else if (ratingFilter.contains('all')) {
      // If "all" rating is selected, filter cards based on status
      filteredProviderCards = allProviderCards.where((card) {
        return statusFilter.contains('all') || statusFilter.contains(card.status.toLowerCase());
      }).toList();
    } else {
      // Filter based on both status and rating filters
      filteredProviderCards = allProviderCards.where((card) {
        bool matchesStatus = statusFilter.contains(card.status.toLowerCase());
        bool matchesRating =
            (ratingFilter.contains('3 - 5') && card.rating >= 3 && card.rating <= 5) ||
                (ratingFilter.contains('1 - 3') && card.rating >= 1 && card.rating <= 3);
        return matchesStatus && matchesRating;
      }).toList();
    }

    return ListView(
      children: filteredProviderCards,
    );
  }
}

class RatedStar extends StatelessWidget {
  final double rating;
  final Color starColor;
  final double iconSize;

  const RatedStar({super.key, 
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

class RequesterCard extends StatelessWidget {
  final double rating;
  final Color starColor;
  final String status;



  const RequesterCard({
    Key? key,
    required this.rating,
    required this.starColor,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color statusColor = Colors.green; // Default green for "Finished"
    if (status.toLowerCase() == 'pending') {
      statusColor = Colors.blue; // Change color based on status
    } else if (status.toLowerCase() == 'cancelled') {
      statusColor = Colors.red;
    }

    return Card(
      elevation: 4, // Add elevation for a shadow effect
      margin: const EdgeInsets.all(16), // Add margin around the card
      child: Container(
        decoration: BoxDecoration(border: Border(left: BorderSide(width: 10.0, color: statusColor))),
        padding: const EdgeInsets.all(16), // Add padding inside the card
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start of the column
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(Icons.account_circle, size: 53, color: Colors.grey,),
                const SizedBox(width: 5,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text("Username",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                        const SizedBox(width: 10,),
                        RatedStar(rating: rating, starColor: starColor),
                      ],
                    ),
                    const Text("10:00am - 9:00am"),
                  ],
                )
              ],
            ),
          const SizedBox(height: 10,),
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.location_on,size: 28,color: Colors.grey,),
              SizedBox(width: 10,),
              Text("Balam Road"),
            ],
            ),

          const SizedBox(height: 15,),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                border: Border.all(
                  color: Colors.black,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
              ),
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Text("Light Housekeeping"),
              ),
            ),

            const SizedBox(
              width: 35,
            ),

              Container(
              height: 43,
              width: 110,
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Padding(
                padding: const EdgeInsets.all(13),
                child: Text(status,style: const TextStyle(fontSize: 15, color: Colors.white),),
                ),
              ),
              ),
            ],)
          ],
        ),
      ),
    );
  }
}

class RequesterCards extends StatelessWidget {
  const RequesterCards({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        RequesterCard(rating: 4.5, starColor: Colors.white, status: "pending"),
        RequesterCard(rating: 4.2, starColor: Colors.white, status: "cancelled"),
        RequesterCard(rating: 3.9, starColor: Colors.white, status: "pending"),
        // Add more ProviderCard widgets as needed
      ],
    );
  }
}
