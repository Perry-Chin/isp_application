import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/values/values.dart';
import '../../../common/widgets/widgets.dart';
import 'addreviews_index.dart';

class AddReviewPage extends GetView<AddReviewController> {
  const AddReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    controller.loadUserAccounts();

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text("Add Review"),
        backgroundColor: AppColor.secondaryColor,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                Obx(() {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: controller.selectedUserId.value.isNotEmpty
                          ? controller.selectedUserId.value
                          : null,
                      items: controller.userAccounts
                          .map((user) => DropdownMenuItem<String>(
                                value: user['id'],
                                child: Text(user['name']),
                              ))
                          .toList(),
                      onChanged: (value) {
                        controller.selectedUserId.value = value!;
                        controller
                            .loadServices(); // Load services when user changes
                      },
                      decoration: InputDecoration(
                        labelText: 'Select User',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.all(10),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: controller.role.value,
                    items: const [
                      DropdownMenuItem<String>(
                        value: 'all',
                        child: Text('All'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'requester',
                        child: Text('Requester'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'provider',
                        child: Text('Provider'),
                      ),
                    ],
                    onChanged: (value) {
                      controller.role.value = value!;
                      controller
                          .loadServices(); // Load services when role changes
                    },
                    decoration: InputDecoration(
                      labelText: 'Role',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.all(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Obx(() {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: controller.selectedServiceId.value.isNotEmpty
                          ? controller.selectedServiceId.value
                          : null,
                      items: controller.services.isNotEmpty
                          ? controller.services
                              .map((service) => DropdownMenuItem<String>(
                                    value: service['id'],
                                    child: Text(service['name']),
                                  ))
                              .toList()
                          : [],
                      onChanged: controller.services.isNotEmpty
                          ? (value) {
                              controller.selectedServiceId.value = value!;
                            }
                          : null,
                      decoration: InputDecoration(
                        labelText: 'Select Service',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.all(10),
                      ),
                      disabledHint: const Text('No services available'),
                    ),
                  );
                }),
                const SizedBox(height: 10),
                Obx(() {
                  return controller.selectedServiceId.value.isNotEmpty
                      ? Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(5, (index) {
                                return IconButton(
                                  icon: Icon(
                                    index < controller.rating.value
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.amber,
                                  ),
                                  onPressed: () {
                                    controller.rating.value = index + 1;
                                  },
                                );
                              }),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextField(
                                controller:
                                    controller.reviewDescriptionController,
                                obscureText: false,
                                maxLines: null,
                                decoration: InputDecoration(
                                  hintText: 'Write your review here...',
                                  labelText: 'Review Description',
                                  prefixIcon: const Icon(Icons.description),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  contentPadding: const EdgeInsets.all(10),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container();
                }),
                const SizedBox(height: 30),
                ApplyButton(
                  onPressed: () {
                    controller.addReview(context);
                  },
                  buttonText: "Submit Review",
                  buttonWidth: double.infinity,
                  textAlignment: Alignment.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
