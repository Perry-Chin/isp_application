import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({Key? key}) : super(key: key);

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      centerTitle: false,
      title: const Text("Profile"),
      backgroundColor: Colors.amber,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: UserProfilePage(), // Using UserProfilePage here
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
          alignment: Alignment.centerLeft, // Aligning the content to the left
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.person, size: 100),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Username', style: TextStyle(fontSize: 24)),
                      SizedBox(height: 4),
                      Text('BuzzBuddy accumulated points: 20'),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16),
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
                labelColor:
                    Colors.black, // Changing text color of the selected tab
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
