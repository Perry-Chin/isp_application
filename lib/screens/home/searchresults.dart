import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../common/data/data.dart';
import '../../common/values/image.dart';
import 'home_controller.dart';

class SearchedService extends StatefulWidget {
  final String selectedService;

  const SearchedService({Key? key, required this.selectedService}) : super(key: key);

  @override
  _SearchedServiceState createState() => _SearchedServiceState();
}

class _SearchedServiceState extends State<SearchedService> {
  late RefreshController _refreshController;
  late HomeController _homeController;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    _homeController = Get.find<HomeController>();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3E9E9),
      body: StreamBuilder<Map<String, UserData?>>(
        stream: _homeController.combinedStream,
        builder: (context, snapshot) {
          final userDataMap = snapshot.data ?? {};
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final filteredServiceList = _homeController.state.serviceList
              .where((serviceItem) =>
                  widget.selectedService.isEmpty ||
                  serviceItem.data().serviceName!.toLowerCase().contains(widget.selectedService.toLowerCase()))
              .toList();

          if (filteredServiceList.isEmpty) {
            return Center(
              child: Text(
                'No services available for "${widget.selectedService}"',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            );
          }

          return SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            controller: _refreshController,
            onLoading: _onLoading,
            onRefresh: _onRefresh,
            header: const WaterDropHeader(),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _buildCategoryRow(),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.w),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.w,
                      mainAxisSpacing: 10.w,
                      childAspectRatio: 0.7,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        var serviceItem = filteredServiceList[index];
                        var userData = userDataMap[serviceItem.data().reqUserid];
                        return _buildHomeListItem(serviceItem, userData);
                      },
                      childCount: filteredServiceList.length,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryRow() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Quicksand',
                  color: Colors.black,
                ),
                children: [
                  const TextSpan(text: "Searched results for:\n"),
                  TextSpan(
                    text: "${widget.selectedService} services",
                    style: const TextStyle(
                      color: Colors.blueGrey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Image.asset(
              'assets/images/back.png',
              width: 30,
              height: 30,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeListItem(
      QueryDocumentSnapshot<ServiceData> serviceItem, UserData? userData) {
    DateTime? parsedDate;
    String dateDisplay = "Invalid date";

    if (serviceItem.data().date != null &&
        serviceItem.data().date!.isNotEmpty) {
      String dateString = serviceItem.data().date!.trim();

      try {
        parsedDate = DateTime.parse(dateString);
        dateDisplay = DateFormat('yyyy-MM-dd').format(parsedDate);
      } catch (e) {
        print('Error parsing date: "$dateString" - $e');
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey, width: 0.2),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          var reqUserid = serviceItem.data().reqUserid ?? "";
          Get.toNamed("/detail", parameters: {
            "doc_id": serviceItem.id,
            "req_uid": reqUserid,
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
              child:
                  userData?.photourl != null && userData!.photourl!.isNotEmpty
                      ? FadeInImage.assetNetwork(
                          placeholder: AppImage.profile,
                          image: userData.photourl!,
                          fadeInDuration: const Duration(milliseconds: 100),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 120,
                        )
                      : Image.asset(AppImage.profile),
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userData?.username ?? "Unknown User",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    dateDisplay,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          color: Colors.grey, size: 16),
                      const SizedBox(width: 2),
                      Text(serviceItem.data().location ?? "Unknown location",
                          style: const TextStyle(fontSize: 12)),
                      const Spacer(),
                      Text(
                        "\$${serviceItem.data().rate?.toString() ?? "0"}/h",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onLoading() {
    _homeController.onLoading();
    _refreshController.loadComplete();
  }

  void _onRefresh() {
    _homeController.onRefresh();
    _refreshController.refreshCompleted();
  }
}
