import 'package:get/get.dart';

class NavbarState {
  final _page = 0.obs;
  int get page=> _page.value;
  set page(value) => _page.value = value;
}