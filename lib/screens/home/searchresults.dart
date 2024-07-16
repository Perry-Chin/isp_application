import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_controller.dart';

class SearchResultsPage extends StatelessWidget {
  const SearchResultsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    final String searchQuery = Get.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results for "$searchQuery"'),
      ),
      body: Obx(() {
        final filteredServices = controller.state.filteredServiceList;

        if (filteredServices.isEmpty) {
          return const Center(
            child: Text('No services found for this username'),
          );
        }

        return ListView.builder(
          itemCount: filteredServices.length,
          itemBuilder: (context, index) {
            final serviceItem = filteredServices[index];
            final userData = controller.state.userDataMap[serviceItem.data().reqUserid];

            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(userData?.photourl ?? ''),
              ),
              title: Text(userData?.username ?? ''),
              subtitle: Text(serviceItem.data().serviceName ?? ''),
              trailing: Text('\$${serviceItem.data().rate?.toString() ?? "0"}/h'),
              onTap: () {
                Get.toNamed("/detail", parameters: {
                  "doc_id": serviceItem.id,
                  "req_uid": serviceItem.data().reqUserid ?? "",
                });
              },
            );
          },
        );
      }),
    );
  }
}