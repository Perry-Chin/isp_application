import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../common/data/data.dart';
import '../../common/values/values.dart';
import '../../common/widgets/widgets.dart';
import 'home_index.dart';

class HomeList extends StatelessWidget {
  final String selectedService; // Define selectedService here

  HomeList({Key? key, required this.selectedService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>(); // Retrieve HomeController instance

    return StreamBuilder<Map<String, UserData?>>(
      stream: controller.combinedStream,
      builder: (context, snapshot) {
        final userDataMap = snapshot.data ?? {};
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return Obx(
          () => SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            controller: controller.refreshController,
            onLoading: controller.onLoading,
            onRefresh: controller.onRefresh,
            header: const WaterDropHeader(),
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.w),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        var serviceItem = controller.state.serviceList[index];
                        var userData = userDataMap[serviceItem.data().reqUserid];

                        // Check if selectedService matches the current serviceItem
                        if (selectedService.isNotEmpty && serviceItem.data().serviceName != selectedService) {
                          return SizedBox.shrink(); // Skip rendering if not matching
                        }

                        return homeListItem(serviceItem, userData);
                      },
                      childCount: controller.state.serviceList.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget homeListItem(QueryDocumentSnapshot<ServiceData> serviceItem, UserData? userData) {
    return Card(
      color: Colors.transparent,
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: InkWell(
        onTap: () {
          var reqUserid = serviceItem.data().reqUserid ?? "";
          Get.toNamed("/detail", parameters: {
            "doc_id": serviceItem.id,
            "req_uid": reqUserid,
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey, width: 0.2),
          ),
          padding: const EdgeInsets.all(6),
          child: Column(
            children: [
              ListTile(
                horizontalTitleGap: 12,
                leading: CircleAvatar(
                  radius: 28.0,
                  backgroundColor: Colors.transparent,
                  child: ClipOval(
                    child: userData?.photourl != null && userData!.photourl!.isNotEmpty
                        ? FadeInImage.assetNetwork(
                            placeholder: AppImage.profile,
                            image: userData.photourl!,
                            fadeInDuration: const Duration(milliseconds: 100),
                            fit: BoxFit.cover,
                            width: 54.w,
                            height: 54.w,
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
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Rating(rating: 4.5),
                    ],
                  ),
                ),
                subtitle: Text(
                  "${serviceItem.data().date}, ${serviceItem.data().starttime}",
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
                    Text(serviceItem.data().location ?? ""),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: serviceItem.data().serviceName!.length * 11,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xffF2F2F2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          serviceItem.data().serviceName ?? "",
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Text("\$${serviceItem.data().rate?.toString() ?? "0"}/h"),
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
