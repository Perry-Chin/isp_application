import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/widgets.dart';
import 'payment_index.dart';

Future<void> paymentFilter(BuildContext context) async {
  final controller = Get.find<PaymentController>();
  await showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            topIndicator(),
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'Sort payments',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ) 
              ),
            ),
            const Divider(color: Colors.black12, thickness: 1),
            filterOption(context, controller, PaymentFilter.newestFirst, 'Newest first'),
            filterOption(context, controller, PaymentFilter.oldestFirst, 'Oldest first'),
          ],
        ),
      );
    },
  );
}

Widget filterOption(context, controller, filter, label) {
  return Obx(
    () => InkWell(
      onTap: () {
        controller.changeFilter(filter);
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label, 
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500
              )
            ),
            Radio<PaymentFilter>(
              value: filter,
              groupValue: controller.currentFilter.value,
              onChanged: (PaymentFilter? value) {
                if (value != null) {
                  controller.changeFilter(value);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    ),
  );
}