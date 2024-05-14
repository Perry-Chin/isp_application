import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({Key? key}) : super(key: key);

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      title: const Text("Profile"),
      backgroundColor: Colors.amber,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: UserProfilePage(),
    );
  }
}

class UserProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align items to the top
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade200, // Light gray background
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.person, size: 70, color: Colors.grey),
                    ),
                  ),
                  Spacer(), // Pushes the icons to the far right
                  Padding(
                    padding: const EdgeInsets.only(
                        top:
                            -9.0), // Adjust the top padding to move icons higher
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.settings),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16), // Spacing between icon and text
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Username', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 4),
                  Text('BuzzBuddy accumulated points: 20'),
                ],
              ),
              SizedBox(height: 16), // Spacing after text
            ],
          ),
        ),
        DefaultTabController(
          length: 2,
          child: Column(
            children: [
              TabBar(
                labelColor: Colors.black,
                tabs: [
                  Tab(text: 'Your Listings'),
                  Tab(text: 'Reviews'),
                ],
              ),
              Container(
                height: 400, // Adjust height as needed
                child: TabBarView(
                  children: [
                    Center(child: Text('All Provider Requester')),
                    _buildReviewsTab(), // Build the Reviews tab content
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewsTab() {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 6,
                  offset: Offset(0, 3), // x=0, y=3
                ),
              ],
            ),
            child: TabBar(
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicator: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(25.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 0,
                    blurRadius: 14,
                    offset: Offset(0, 4), // x=0, y=4
                  ),
                ],
              ),
              tabs: [
                Tab(text: 'All'),
                Tab(text: 'Provider'),
                Tab(text: 'Requester'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                Center(child: Text('All Reviews')),
                Center(child: Text('Provider Reviews')),
                Center(child: Text('Requester Reviews')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
