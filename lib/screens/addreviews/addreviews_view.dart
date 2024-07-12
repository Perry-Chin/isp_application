import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/values/values.dart';
import '../../../common/widgets/widgets.dart';
import 'addreviews_controller.dart';

class AddReviewPage extends GetView<AddReviewController> {
  const AddReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        title: const Text("Add Review"),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 30),
                  Obx(() => Container(
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
                                    value: service['id'],
                                    child: Text(
                                        "${service['serviceName']} (${service['role']})"),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
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
                      )),
                  const SizedBox(height: 10),
                  Obx(() => Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          readOnly: true,
                          controller: TextEditingController(
                              text: controller.role.value),
                          decoration: InputDecoration(
                            labelText: 'Role',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: const EdgeInsets.all(10),
                          ),
                        ),
                      )),
                  const SizedBox(height: 10),
                  Obx(() => controller.selectedServiceId.value.isNotEmpty
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
                              child: Focus(
                                onFocusChange: (hasFocus) {
                                  controller.updateReviewTextBoxColor(hasFocus);
                                },
                                child: Obx(() => TextField(
                                      controller: controller
                                          .reviewDescriptionController,
                                      obscureText: false,
                                      maxLines: null,
                                      keyboardType: TextInputType.multiline,
                                      decoration: InputDecoration(
                                        hintText: 'Write your review here...',
                                        labelText: 'Review Description',
                                        prefixIcon:
                                            const Icon(Icons.description),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.all(10),
                                        filled: true,
                                        fillColor: controller
                                                .isReviewTextBoxFocused.value
                                            ? AppColor.secondaryColor
                                                .withOpacity(0.1)
                                            : Colors.white,
                                      ),
                                      onChanged: (_) =>
                                          controller.formatReviewText(),
                                    )),
                              ),
                            ),
                          ],
                        )
                      : Container()),
                  const SizedBox(height: 30),
                  ApplyButton(
                    onPressed: () => controller.addReview(context),
                    buttonText: "Submit Review",
                    buttonWidth: double.infinity,
                    textAlignment: Alignment.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
