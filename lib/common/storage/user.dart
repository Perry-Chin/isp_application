import 'dart:convert';
import 'package:get/get.dart';

import '../data/user.dart';
import '../values/storage.dart';
import 'service.dart'; 

// UserStore class responsible for managing user-related data and authentication state
class UserStore extends GetxController {
  // Get instance of UserStore using GetX dependency injection
  static UserStore get to => Get.find();

  // Observable boolean indicating whether the user is logged in
  final _isLogin = false.obs;

  // User token
  String token = '';

  // Observable representing user profile
  final _profile = UserLoginResponseEntity().obs;

  // Getter for checking if the user is logged in
  bool get isLogin => _isLogin.value;

  // Getter for accessing user profile
  UserLoginResponseEntity get profile => _profile.value;

  // Getter for checking if user has a token
  bool get hasToken => token.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    // Get token from storage during initialization
    token = StorageService.to.getString(token_key);
    // Get profile from storage if available
    var profileOffline = StorageService.to.getString(profile_key);
    if (profileOffline.isNotEmpty) {
      _isLogin.value = true; // Set login status to true
      _profile(UserLoginResponseEntity.fromJson(jsonDecode(profileOffline))); // Set user profile
    }
  }

  // Method to save token in storage
  Future<void> setToken(String value) async {
    await StorageService.to.setString(token_key, value);
  }

  // Method to get profile from storage
  Future<String> getProfile() async {
    if (token.isEmpty) return ""; // Return empty string if token is empty
    return StorageService.to.getString(profile_key);
  }

  // Method to save profile in storage
  Future<void> saveProfile(UserLoginResponseEntity profile) async {
    _isLogin.value = true; // Set login status to true
    StorageService.to.setString(profile_key, jsonEncode(profile)); // Save profile in storage
    setToken(profile.accessToken!); // Save token
  }

  // Method to logout user
  Future<void> onLogout() async {
    // Remove token and profile from storage
    await StorageService.to.remove(token_key);
    await StorageService.to.remove(profile_key);
    _isLogin.value = false; // Set login status to false
    token = ''; // Clear token
  }
}
