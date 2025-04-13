import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static bool get signedIn => FirebaseAuth.instance.currentUser != null;

  static bool get signedOut => FirebaseAuth.instance.currentUser == null;

  static String get uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  static String get email => FirebaseAuth.instance.currentUser?.email ?? '';
}
