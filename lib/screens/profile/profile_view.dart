import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../settings/settings_index.dart';
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SettingsPage()),
                      );
                    },
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
              _buildReviewSection(), // Add the review section
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

  Widget _buildReviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Reviews',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 2,
          decoration: BoxDecoration(
            color: AppColor.secondaryColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16), // Spacing before the reviews tab
        _buildReviewsTab(),
      ],
    );
  }

Widget _buildReviewsTab() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Reviews',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 8),
      Container(
        height: 2,
        decoration: BoxDecoration(
          color: AppColor.secondaryColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      _CustomTabWidget(),
    ],
  );
}

class _CustomTabWidget extends StatefulWidget {
  @override
  _CustomTabWidgetState createState() => _CustomTabWidgetState();
}

class _CustomTabWidgetState extends State<_CustomTabWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: TabBar(
            controller: _tabController,
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
                  offset: const Offset(0, 4),
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
        SizedBox(
          height: 200, // Adjust the height as needed
          child: TabBarView(
            controller: _tabController,
            children: const [
              Center(child: Text('All Reviews')),
              Center(child: Text('Provider Reviews')),
              Center(child: Text('Requester Reviews')),
            ],
          ),
        ),
      ],
    );
  }
}