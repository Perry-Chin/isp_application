import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/values/values.dart';
import 'profile_index.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({Key? key}) : super(key: key);

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      title: const Text("Profile"),
      backgroundColor: AppColor.secondaryColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: const UserProfilePage(),
    );
  }
}

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({Key? key}) : super(key: key); // Add the key parameter

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
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
                      border: Border.all(
                        color: AppColor.secondaryColor, // Yellow border color
                        width: 4.0, // Border width
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.person, size: 70, color: Colors.grey),
                    ),
                  ),
                  const Spacer(), // Pushes the icons to the far right
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 16), // Spacing between icon and text
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Username',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 8),
                  _buildRatingRectangle(),
                ],
              ),
              const SizedBox(height: 16), // Spacing after text
            ],
          ),
        ),
        DefaultTabController(
          length: 1,
          child: Column(
            children: [
              const TabBar(
                labelColor: Colors.black,
                tabs: [
                  Tab(text: 'Reviews'),
                ],
              ),
              SizedBox(
                height: 400, // Adjust height as needed
                child: TabBarView(
                  children: [
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

  Widget _buildRatingRectangle() {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.secondaryColor,
        borderRadius: BorderRadius.circular(15.0),
      ),
      padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 7.0),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '4.6',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 4),
          Icon(
            Icons.star,
            color: Colors.white,
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsTab() {
    return SizedBox(
      height: 500, // Adjust the height as needed
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 6,
                  offset: const Offset(0, 3), // x=0, y=3
                ),
              ],
            ),
            child: TabBar(
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicator: BoxDecoration(
                color: AppColor.secondaryColor,
                borderRadius: BorderRadius.circular(25.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 0,
                    blurRadius: 14,
                    offset: const Offset(0, 4), // x=0, y=4
                  ),
                ],
              ),
              tabs: const [
                Tab(text: 'All'),
                Tab(text: 'Provider'),
                Tab(text: 'Requester'),
              ],
            ),
          ),
          const Expanded(
            child: TabBarView(
              children: [
                Center(child: Text('All Reviews')),
                Center(child: Text('Provider Reviews')),
                Center(child: Text('Requester Reviews')),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColor.secondaryColor,
                side: const BorderSide(color: AppColor.secondaryColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              onPressed: () {
                // Implement your sorting functionality here
              },
              child: const Text(
                'Sort by newest',
                style: TextStyle(color: AppColor.secondaryColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
