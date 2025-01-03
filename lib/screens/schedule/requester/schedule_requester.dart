import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:get/get.dart';

import '../../../common/data/data.dart';
import '../../../common/values/values.dart';
import '../schedule_index.dart';

class RequesterCard extends GetView<ScheduleController> {
  final List<String> selectedStatus;

  const RequesterCard({
    Key? key,
    required this.selectedStatus,
  }) : super(key: key);

  Widget requesterListItem(
    QueryDocumentSnapshot<ServiceData> item,
    UserData? userData,
  ) {
    Color statusColor = getStatusColor(item.data().status);

    return Card(
      elevation: 8,
      margin: const EdgeInsets.all(14),
      color: Colors.transparent,
      child: InkWell(
        onTap: () => controller.redirectToServiceDetail(item, "true"),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey, width: 0.2),
          ),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(width: 8.0, color: statusColor),
              ),
            ),
            padding: const EdgeInsets.all(6),
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    radius: 28.0,
                    backgroundColor: Colors.transparent,
                    child: ClipOval(
                      child: userData?.photourl != null &&
                              userData!.photourl!.isNotEmpty
                          ? FadeInImage.assetNetwork(
                              placeholder: AppImage.profile,
                              image: userData.photourl ?? "",
                              fadeInDuration: const Duration(milliseconds: 100),
                              fit: BoxFit.cover,
                              width: 58.w,
                              height: 58.w,
                            )
                          : Image.asset(AppImage.profile),
                    ),
                  ),
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Row(
                      children: [
                        Text(
                          userData?.username ?? "",
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black
                          )
                        ),
                        const SizedBox(width: 6),
                        // Rating(rating: userData?.rating ?? 0),
                      ],
                    ),
                  ),
                  subtitle: Text(
                    "${item.data().date}, ${item.data().starttime} - ${item.data().endtime}",
                    style: GoogleFonts.poppins()
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 5),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: AppColor.secondaryColor,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        item.data().location ?? "",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: GoogleFonts.poppins()
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: item.data().serviceName!.length * 12,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xffF2F2F2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            item.data().serviceName ?? "",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: item.data().status!.length * 13,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            "${item.data().status}",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'requested':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      case 'pending':
        return Colors.orangeAccent;
      case 'booked':
        return Colors.cyan;
      case 'started':
        return Colors.redAccent;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, UserData?>>(
      stream: controller.combinedRequesterStream,
      builder: (context, snapshot) {
        final userDataMap = snapshot.data ?? {};
        if (snapshot.connectionState == ConnectionState.waiting) {
          // return const ShimmerLoading();
          return const Center(child: CircularProgressIndicator());
        }
        // Filter requesterList based on selected rating
        final filteredList = controller.state.requesterList.where((item) {
          final userData = userDataMap[item.data().reqUserid];
          return userData != null;
          // return userData != null && userData.rating! >= selectedRating;
        }).toList();
        return SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          controller: controller.refreshControllerReq,
          onLoading: controller.onLoadingReq,
          onRefresh: controller.onRefreshReq,
          header: const WaterDropHeader(),
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.w),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      var serviceItem = filteredList[index];
                      var userData = userDataMap[serviceItem.data().reqUserid];
                      return requesterListItem(serviceItem, userData);
                    },
                    childCount: filteredList.length,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}