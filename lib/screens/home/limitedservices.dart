import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../common/data/data.dart';
import '../../common/values/values.dart';
import 'home_controller.dart';

class limitedservicespage extends StatefulWidget {
  const limitedservicespage({Key? key}) : super(key: key);

  @override
  _limitedservicespageState createState() => _limitedservicespageState();
}

class _limitedservicespageState extends State<limitedservicespage> {
  final HomeController controller = Get.find<HomeController>();
  late RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: false);
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void _onRefresh() async {
    controller.onRefresh();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    controller.onLoading();
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<Map<String, UserData?>>(
        stream: controller.combinedStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          final userDataMap = snapshot.data ?? {};
          final serviceList = controller.state.serviceList;

          final currentUserId = controller.currentUserId;
          final filteredServiceList = serviceList
              .where((service) => service.data().reqUserid != currentUserId)
              .toList();

          // Limit the filteredServiceList to a maximum of 4 items
          final limitedServiceList = filteredServiceList.take(5).toList();

          if (limitedServiceList.isEmpty) {
            return const Center(
              child: Text(
                'No services available',
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            );
          }

          return SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            header: const WaterDropHeader(),
            child: CustomScrollView(
              slivers: [
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
                        var serviceItem = limitedServiceList[index];
                        var userData = userDataMap[serviceItem.data().reqUserid];
                        return _buildServiceListItem(serviceItem, userData);
                      },
                      childCount: limitedServiceList.length,
                      findChildIndexCallback: (Key key) {
                        final serviceId = (key as ValueKey<String>).value;
                        return limitedServiceList
                            .indexWhere((service) => service.id == serviceId);
                      },
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

  Widget _buildServiceListItem(
      QueryDocumentSnapshot<ServiceData> serviceItem, UserData? userData) {
    DateTime? parsedDate;
    String dateDisplay = "Invalid date";

    if (serviceItem.data().date != null && serviceItem.data().date!.isNotEmpty) {
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
            offset: const Offset(0, 2),
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
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: userData?.photourl != null && userData!.photourl!.isNotEmpty
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
                    userData?.username ?? "",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    dateDisplay,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.grey, size: 16),
                      const SizedBox(width: 2),
                      Text(serviceItem.data().location ?? "",
                          style: const TextStyle(fontSize: 12)),
                      const Spacer(),
                      Text(
                        "\$${serviceItem.data().rate?.toString() ?? "0"}/h",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
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
}
