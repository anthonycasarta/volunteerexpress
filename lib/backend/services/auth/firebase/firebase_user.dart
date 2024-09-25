import 'package:firebase_auth/firebase_auth.dart' as firebase_auth show User;
import 'package:volunteerexpress/backend/services/auth/auth_user.dart';

// define a firebase specific user
class FirebaseUser extends AuthUser {
  const FirebaseUser(super.isEmailVerified);

  // learn more about factory constructors to explain
  factory FirebaseUser.fromFirebase(firebase_auth.User user) =>
      FirebaseUser(user.emailVerified);
}
