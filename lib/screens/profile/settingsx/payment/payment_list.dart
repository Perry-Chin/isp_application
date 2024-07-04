// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

// import '../../../../common/data/data.dart';

// class PaymentList extends StatelessWidget {
//   const PaymentList({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<Map<String, UserData?>>(
//       stream: ,
//       builder: (context, snapshot) {
//         return Obx(
//           () => SmartRefresher(
//             child: CustomScrollView(
//               slivers: [
//                 SliverPadding(
//                   padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.w),
//                   sliver: SliverList(
//                     delegate: SliverChildBuilderDelegate(
//                       (context, index) {
//                         var item = controller.state.filteredPaymentList[index];
//                         return paymentListItem(item);
//                       },
//                       childCount: controller.state.filteredPaymentList.length
//                     )
//                   ),
//                 ),
//               ],
//             ),
//           )
//         );
//       }
//     );
//   }
// }