import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/data/data.dart';
import '../../../common/routes/routes.dart';
import '../../../common/values/values.dart';
import '../../../common/widgets/widgets.dart';
import '../detail_index.dart';
// import '../reviews/detail_reviews_index.dart';

class ProviderInfo extends StatelessWidget {
  final DetailController controller;
  final UserData? userData;
  final bool hideButtons;

  const ProviderInfo({
    required this.controller,
    required this.userData,
    required this.hideButtons,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16, bottom: 5),
          child: Text(
            "Meet the Provider",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        ListTile(
          horizontalTitleGap: 12,
          leading: CircleAvatar(
            radius: 28.0,
            backgroundColor: Colors.transparent,
            child: ClipOval(
              child:
                  userData?.photourl != null && userData!.photourl!.isNotEmpty
                      ? FadeInImage.assetNetwork(
                          placeholder: AppImage.profile,
                          image: userData!.photourl ?? "",
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
                  userData?.username ?? "Username",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 6),
                Obx(() => Rating(rating: controller.serviceRating.value))
              ],
            ),
          ),
          subtitle: Text(userData?.email ?? ""),
          trailing: ReportUserMenu(
            userId: userData?.id ?? "",
            currentUserId: controller.token,
          ),
        ),
        actionButtons(userData!),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Divider(
            thickness: 2,
            color: Colors.black12,
            height: 35,
          ),
        ),
      ],
    );
  }

  Widget actionButtons(UserData userData) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // View reviews actions
                Get.toNamed(AppRoutes.detailReview,
                    parameters: {"doc_id": controller.doc_id});
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 4, // Small shadow
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 15), // Set padding
                child: const Text(
                  "View reviews",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                controller.goChat(userData);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 4, // Small shadow
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 15), // Set padding
                child: const Text(
                  "Chat",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
