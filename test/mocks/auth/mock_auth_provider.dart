import 'package:volunteerexpress/backend/services/auth/auth_exceptions.dart';
import 'package:volunteerexpress/backend/services/auth/auth_provider.dart';
import 'package:volunteerexpress/backend/services/auth/auth_user.dart';

import 'mock_auth_exceptions.dart';

class MockAuthProvider implements AuthProvider {
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  AuthUser? _mockUser;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    // Check if the provider is initialized
    if (!isInitialized) {
      throw NotInitializedMockAuthException();
    }
    await Future.delayed(const Duration(seconds: 1)); // Fake a async call

    // Create user
    const user = AuthUser(isEmailVerified: false);
    _mockUser = user;
    return Future.value(_mockUser); // Return user
  }

  @override
  AuthUser? get currentUser => _mockUser;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1)); // Fake a async call
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) {
    // Check if the provider is initialized
    if (!isInitialized) {
      throw NotInitializedMockAuthException();
    }
    if (email == 'wrongEmail@gmail.com') {
      throw InvalidCredentialAuthException();
    }
    if (password == 'wrongPassword') {
      throw InvalidCredentialAuthException();
    }

    const user = AuthUser(isEmailVerified: false);
    _mockUser = user;
    return Future.value(_mockUser);
  }

  @override
  Future<void> logOut() async {
    // Check if the provider is initialized
    if (!isInitialized) {
      throw NotInitializedMockAuthException();
    }

    // No user logged in
    if (_mockUser == null) {
      throw UserNotLoggedInAuthException();
    }

    await Future.delayed(const Duration(seconds: 1)); // Fake a async call
    _mockUser = null; // log out user
  }

  @override
  Future<void> sendEmailVerification() async {
    // Check if the provider is initialized
    if (!isInitialized) {
      throw NotInitializedMockAuthException();
    }

    final user = _mockUser;
    // Check if user exists
    if (user == null) {
      throw UserNotFoundAuthException();
    }

    // Update the user's email verification status
    const updatedUser = AuthUser(isEmailVerified: true);
    _mockUser = updatedUser;
  }
}
