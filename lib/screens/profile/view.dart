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
                mainAxisAlignment: MainAxisAlignment.start, // Align to left
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                height: 200,
                child: TabBarView(
                  children: [
                    Center(child: Text('All Provider Requester')),
                    Center(child: Text('No Reviews Yet')),
                  ],
                ),
              ),
            ],
          ),
        ),
        // You can add more content here if needed
      ],
    );
  }
}
