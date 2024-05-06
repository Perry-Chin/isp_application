import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Service for managing storage using shared preferences
class StorageService extends GetxService {
  // Get instance of StorageService using GetX dependency injection
  static StorageService get to => Get.find();

  // Instance of SharedPreferences
  late final SharedPreferences _prefs;

  // Initialize the service asynchronously
  Future<StorageService> init() async {
    // Get instance of SharedPreferences
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  // Set a string value in storage
  Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  // Set a boolean value in storage
  Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  // Set a list of strings in storage
  Future<bool> setList(String key, List<String> value) async {
    return await _prefs.setStringList(key, value);
  }

  // Get a string value from storage
  String getString(String key) {
    // Return empty string if value is null
    return _prefs.getString(key) ?? '';
  }

  // Get a boolean value from storage
  bool getBool(String key) {
    // Return false if value is null
    return _prefs.getBool(key) ?? false;
  }

  // Get a list of strings from storage
  List<String> getList(String key) {
    // Return empty list if value is null
    return _prefs.getStringList(key) ?? [];
  }

  // Remove a value from storage
  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }
}