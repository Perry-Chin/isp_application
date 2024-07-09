import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import '../../../../common/data/data.dart';
import '../../../../common/values/values.dart';
import 'payment_index.dart';

class PaymentList extends StatelessWidget {
  const PaymentList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PaymentController>();
    return StreamBuilder<Map<String, UserData?>>(
      stream: controller.combinedStream, 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return Obx(
          () => SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            controller: controller.refreshControllerPayment,
            onLoading: controller.onLoadingPayment,
            onRefresh: controller.onRefreshPayment,
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            header: const WaterDropHeader(),
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        var item = controller.paymentList[index].data();
                        var itemId = controller.paymentList[index].id;
                        var userData = snapshot.data?[item.uid];
                        return Column(
                          children: [
                            Slidable(
                              key: ValueKey(itemId),
                              endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                dismissible: DismissiblePane(onDismissed: () {
                                  // Handle delete action here
                                  controller.deletePayment(itemId);
                                }),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) => controller.deletePayment(itemId),
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: 'Delete',
                                  ),
                                ],
                              ),
                              child: paymentListItem(context, item, userData, controller)
                            ),
                            // Divider to separate each item
                            if (index < controller.paymentList.length - 1)
                              Padding(
                                padding: const EdgeInsets.only(left: 75.0, right: 16.0),
                                child: Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                              ),
                          ],
                        );
                      },
                      childCount: controller.paymentList.length
                    )
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  Widget paymentListItem(context, item, userData, controller) {
    final bool income = item.income;
    return ListTile(
      leading: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 45.w
        ),
        child: ClipOval(
          child: userData?.photourl != null && userData!.photourl!.isNotEmpty ?
          FadeInImage.assetNetwork(
            placeholder: AppImage.profile,
            image: userData.photourl ?? "",
            fadeInDuration: const Duration(milliseconds: 100),

          ) :
          Image.asset(AppImage.profile),
        ),
      ),
      title: Row(
        children: [
          Text(
            userData?.username ?? "Unknown User", 
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColor.lightColor
            )
          ),
          if (userData?.id == controller.userToken)
            const Text(
              " (You)", 
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColor.lightColor
              )
          )
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 6.0),
        child: Text(
          DateFormat('HH:mm | dd MMMM yyyy').format(item.timestamp.toDate()), 
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: 14
          )
        ),
      ),
      trailing: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "\$${item.amount.toDouble().toStringAsFixed(2)}", 
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: income ? Colors.green : Colors.red,
              ) 
            ),
            const SizedBox(height: 2),
            Container(
              width: 84,
              alignment: Alignment.center,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    income ? Icons.arrow_circle_up : Icons.arrow_circle_down, 
                    color: income ? Colors.green : Colors.red,
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "Expense", 
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 15
                    )
                  ),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}