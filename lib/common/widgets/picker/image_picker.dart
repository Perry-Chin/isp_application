import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

Future<void> imgFromGallery(Function(File?) onImageSelected) async {
  final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (pickedImage != null) {
    final File imageFile = File(pickedImage.path);
    onImageSelected(imageFile);
  } 
  else {
    //Nothing happens
    print("No image selected");
  }
}

Future<void> imgFromCamera(Function(File?) onImageSelected) async {
  final pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
  if (pickedImage != null) {
    final File imageFile = File(pickedImage.path);
    onImageSelected(imageFile);
  } 
  else {
    //Nothing happens
    print("No image selected");
  }
}

Future<void> showImagePicker(BuildContext context, Function(File?) onImageSelected) async {
  showModalBottomSheet(
    context: context, 
    builder: (BuildContext bc) {
      return SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Gallery"),
              onTap: () {
                imgFromGallery(onImageSelected);
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text("Camera"),
              onTap: () {
                imgFromCamera(onImageSelected);
                Get.back();
              },
            )
          ],
        )
      );
    }
  );
}