import 'package:firebase_auth/firebase_auth.dart' as firebase_auth show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final bool isEmailVerified; // whether the user's email is verified or not
  const AuthUser(this.isEmailVerified);

  factory AuthUser.fromFirebase(firebase_auth.User user) =>
      AuthUser(user.emailVerified);
}
