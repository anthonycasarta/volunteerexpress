import 'package:firebase_core/firebase_core.dart';
import 'package:volunteerexpress/backend/services/auth/auth_user.dart';
import 'package:volunteerexpress/backend/services/auth/auth_exceptions.dart';
import 'package:volunteerexpress/backend/services/auth/auth_provider.dart';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth
    show FirebaseAuth, FirebaseAuthException;
import 'package:volunteerexpress/firebase_options.dart';

class FirebaseAuthProvider implements AuthProvider {
  final firebase_auth.FirebaseAuth _firebaseAuth;

  // Constructor allows passing a custom FirebaseAuth instance (for testing)
  FirebaseAuthProvider({firebase_auth.FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ??
            firebase_auth
                .FirebaseAuth.instance; // Default to FirebaseAuth.instance

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    try {
      // create a user
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      }

      throw UserNotLoggedInAuthException();

      // Firebase exceptions
    } on firebase_auth.FirebaseAuthException catch (e) {
      // e.code is the error code from firebase
      switch (e.code) {
        case 'weak-password':
          throw WeakPasswordAuthException();
        case 'email-already-in-use':
          throw EmailAlreadyInUseAuthException();
        case 'invalid-email':
          throw InvalidEmailAuthException();

        // Handle unknown firebase exception
        default:
          throw GenericAuthException();
      }
      // Non-firebase exceptions
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  AuthUser? get currentUser {
    final user = _firebaseAuth.currentUser; // get user
    // check if there is a user
    if (user != null) {
      return AuthUser.fromFirebase(user); // return user
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      }
      throw UserNotLoggedInAuthException();

      // Firebase exceptions
    } on firebase_auth.FirebaseAuthException catch (e) {
      // e.code is the error code from firebase
      switch (e.code) {
        case 'invalid-credential':
          throw InvalidCredentialAuthException();

        // Handle unknown firebase exception
        default:
          throw GenericAuthException();
      }
      // Non-firebase exceptions
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> logOut() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      await _firebaseAuth.signOut(); // sign out if current user exists
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = _firebaseAuth.currentUser; // get user
    if (user != null) {
      await user
          .sendEmailVerification(); // send email verification if a user exists
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
