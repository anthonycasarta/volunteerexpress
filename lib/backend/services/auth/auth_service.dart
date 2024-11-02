import 'package:firebase_auth/firebase_auth.dart';
import 'package:volunteerexpress/backend/services/auth/auth_provider.dart'
    as provider;
import 'package:volunteerexpress/backend/services/auth/auth_user.dart';
import 'package:volunteerexpress/backend/services/auth/firebase/firebase_auth_provider.dart';

class AuthService implements provider.AuthProvider {
  final provider.AuthProvider authProvider;
  const AuthService({required this.authProvider});

  // Return instance of AuthService that uses Firebase as the AuthProvider
  factory AuthService.firebase() =>
      AuthService(authProvider: FirebaseAuthProvider());

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) =>
      authProvider.createUser(
        email: email,
        password: password,
      );

  @override
  AuthUser? get currentUser => authProvider.currentUser;

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) =>
      authProvider.logIn(
        email: email,
        password: password,
      );

  @override
  Future<void> logOut() => authProvider.logOut();

  @override
  Future<void> sendEmailVerification() => authProvider.sendEmailVerification();

  @override
  Future<void> initialize() => authProvider.initialize();
}
