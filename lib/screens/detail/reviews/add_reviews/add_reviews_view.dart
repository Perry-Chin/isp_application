import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../common/theme/custom/custom_theme.dart';
import '../../../../common/widgets/widgets.dart';
import 'add_reviews_index.dart';

class DetailAddReviewPage extends StatelessWidget {
  const DetailAddReviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DetailAddReviewController());
    return Obx(() {
      if (controller.hasAlreadyReviewed.value) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: const Center(
            child: Text(
              "You have already reviewed this service.",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
      return Form(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                topIndicator(),
                const SizedBox(height: 10),
                Text(
                  "What is your rating?",
                  style: CustomTextTheme.lightTheme.labelMedium,
                ),
                const SizedBox(height: 10),
                StarRatingFilterBig(
                  rating: controller.selectedRating.value,
                  onChanged: (selectedRating) {
                    controller.setSelectedRating(selectedRating ?? 0);
                  },
                ),
                const SizedBox(height: 30),
                Text(
                  "Add your review here",
                  style: CustomTextTheme.lightTheme.labelMedium,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  style: GoogleFonts.poppins(),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black.withOpacity(0.5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black.withOpacity(0.5)),
                    ),
                    hintText: "Enter your review here",
                  ),
                  minLines: 6,
                  maxLines: 6,
                  onChanged: controller.setReviewText,
                ),
                const SizedBox(height: 20),
                ApplyButton(
                    onPressed: controller.submitReview,
                    buttonText: "Send Review",
                    buttonWidth: double.infinity,
                    textAlignment: Alignment.center)
              ],
            ),
          ),
        ),
      );
    });
  }
}
