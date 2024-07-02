import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/values/values.dart';
import '../../../common/widgets/widgets.dart';
import 'addreviews_controller.dart';

class AddReviewPage extends GetView<AddReviewController> {
  const AddReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    print("Building AddReviewPage"); // Debug print
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
                  print(
                      "Rebuilding dropdown. Selected service: ${controller.selectedServiceId.value}"); // Debug print
                  print(
                      "Number of completed services: ${controller.completedServices.length}"); // Debug print
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: controller.selectedServiceId.value.isNotEmpty
                          ? controller.selectedServiceId.value
                          : null,
                      items: controller.completedServices
                          .map((service) => DropdownMenuItem<String>(
                                value: service.id,
                                child: Text(
                                    "${service.serviceName} (${service.role})"),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          print("Service selected: $value"); // Debug print
                          controller.updateSelectedService(value);
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'Select Completed Service',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.all(10),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 10),
                Obx(() {
                  print(
                      "Rebuilding role field. Current role: ${controller.role.value}"); // Debug print
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      readOnly: true,
                      controller:
                          TextEditingController(text: controller.role.value),
                      decoration: InputDecoration(
                        labelText: 'Role',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.all(10),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 10),
                Obx(() {
                  print(
                      "Rebuilding review section. Selected service: ${controller.selectedServiceId.value}"); // Debug print
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
                                    print(
                                        "Rating set to: ${controller.rating.value}"); // Debug print
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
                    print("Submit Review button pressed"); // Debug print
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
