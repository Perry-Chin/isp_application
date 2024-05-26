import 'dart:convert';
import 'package:get/get.dart';
import 'package:isp_application/common/storage/storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/user.dart';
import '../values/storage.dart';

class UserStore extends GetxController {
  static UserStore get to => Get.find();

  final _isLogin = false.obs;
  String token = '';
  final _profile = UserLoginResponseEntity().obs;

  bool get isLogin => _isLogin.value;
  UserLoginResponseEntity get profile => _profile.value;
  bool get hasToken => token.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    token = StorageService.to.getString(token_key) ?? '';
    var profileOffline = StorageService.to.getString(profile_key);
    if (profileOffline.isNotEmpty) {
      _isLogin.value = true;
      _profile(UserLoginResponseEntity.fromJson(jsonDecode(profileOffline)));
    }
  }

  Future<void> setToken(String? value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value != null) {
      await prefs.setString(token_key, value);
    } else {
      await prefs.remove(token_key);
    }
    token = value ?? ''; // Update the token in memory
    update();
  }

  Future<void> onLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(token_key);
    await prefs.remove(profile_key);
    token = '';
    _isLogin.value = false;
    _profile(UserLoginResponseEntity());
    update(); // Notify all widgets listening to this controller
  }

  Future<void> saveProfile(UserLoginResponseEntity profile) async {
    _isLogin.value = true;
    _profile(profile);
    await StorageService.to.setString(profile_key, jsonEncode(profile));
    await setToken(profile.accessToken!);
  }

  void reloadUserState() {
    var profileOffline = StorageService.to.getString(profile_key);
    if (profileOffline.isNotEmpty) {
      _profile(UserLoginResponseEntity.fromJson(jsonDecode(profileOffline)));
    }
    _isLogin.value = StorageService.to.getString(token_key).isNotEmpty;
    update(); // Notify all widgets listening to this controller
  }
}
