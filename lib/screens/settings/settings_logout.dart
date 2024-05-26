import 'package:firebase_auth/firebase_auth.dart';
import '../../common/storage/user.dart';

class AuthService {
  static Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    await UserStore.to.onLogout(); // Use onLogout method from UserStore
  }
}
