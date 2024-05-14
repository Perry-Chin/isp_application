import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:get/get.dart';

import '../../common/data/service.dart';
import '../../common/values/values.dart';
import 'home_index.dart';

class HomeList extends GetView<HomeController> {
  const HomeList({super.key});

  Widget homeListItem(QueryDocumentSnapshot<ServiceData> item) {
    return Container(
      padding: EdgeInsets.only(top: 15.w),
      child: InkWell(
        onTap: () {
          
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.grey,
              width: 0.1
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                spreadRadius: 2
              )
            ]
          ),
          child: Column(
            children: [
              ListTile(
                horizontalTitleGap: 12,
                leading: const CircleAvatar(
                  radius: 28,
                  backgroundImage: AssetImage("assets/images/profile.png"),
                  backgroundColor: Colors.transparent
                ),
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Row(
                    children: [
                      Text(
                        item.data().reqUsername ?? "",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.amber)
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "\$${item.data().rate?.toString() ?? "0"}/h",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 3), // Add spacing between star icon and rating
                            const Icon(
                              Icons.star,
                              color: Colors.yellow,
                              size: 16,
                            ),
                          ],
                        ),
                      )
                    ],
                  ), 
                ),
                subtitle: Text(
                  item.data().date ?? ""
                ),
              ),
              // Location Icon
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 5),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: AppColor.secondaryColor,
                    ),
                    const SizedBox(width: 2),
                    Text(item.data().location ?? ""),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: item.data().serviceName!.length * 10.0,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xffF2F2F2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          item.data().serviceName ?? "",
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          // Convert rate to string
                          "\$${item.data().rate?.toString() ?? "0"}/h", 
                          style: const TextStyle(
                            // Your desired text style
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    var item = controller.state.serviceList[index];
                    return homeListItem(item);
                  },
                  childCount: controller.state.serviceList.length
                )
              ),
            ),
          ],
        ),
      )
    );
  }
}
