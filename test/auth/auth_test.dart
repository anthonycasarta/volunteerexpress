import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:volunteerexpress/backend/services/auth/auth_exceptions.dart';
import 'package:volunteerexpress/backend/services/auth/auth_service.dart';
import 'package:volunteerexpress/backend/services/auth/auth_user.dart';
import 'package:volunteerexpress/backend/services/auth/firebase/firebase_auth_provider.dart';

import 'package:mockito/annotations.dart';

@GenerateNiceMocks([MockSpec<FirebaseAuthProvider>()])
import 'auth_test.mocks.dart';

void main() {
  // Mockito
  final mockFirebaseProvider = MockFirebaseAuthProvider();
  final mockAuthService = AuthService(authProvider: mockFirebaseProvider);

  // Firebase Auth Mocks
  final mockAuthServiceNotLoggedIn = AuthService(
      authProvider: FirebaseAuthProvider(MockFirebaseAuth(signedIn: false)));
  final mockAuthServiceLoggedIn = AuthService(
      authProvider: FirebaseAuthProvider(MockFirebaseAuth(signedIn: true)));

  // Testing variables
  const invalidEmail = 'email.com';
  const weakPass = 'pass';
  const validEmail = 'email@gmail.com';
  const strongPass = 'LemonLimeRime2387046!';

  // User for testing
  const mockUser = {
    'email': 'mockemail@gmail.com',
    'pass': 'mockPass284639366!',
  };

  // Tests

  // Create User
  group('Firebase Mock createUser', () {
    test('InvalidEmailAuthException thrown on invalid email', () async {
      when(mockFirebaseProvider.createUser(
        email: invalidEmail,
        password: strongPass,
      )).thenThrow(
        InvalidEmailAuthException(),
      );

      await expectLater(
          () => mockAuthService.createUser(
                email: invalidEmail,
                password: strongPass,
              ),
          throwsA(isA<InvalidEmailAuthException>()));
    });

    test('WeakPasswordAuthException thrown on weak password', () async {
      when(mockFirebaseProvider.createUser(
        email: validEmail,
        password: weakPass,
      )).thenThrow(
        WeakPasswordAuthException(),
      );

      await expectLater(
          () => mockAuthService.createUser(
                email: validEmail,
                password: weakPass,
              ),
          throwsA(isA<WeakPasswordAuthException>()));
    });

    test(
        'EmailAlreadyInUseAuthException thrown when creating a user that already exists',
        () async {
      when(mockFirebaseProvider.createUser(
        email: mockUser['email'],
        password: strongPass,
      )).thenThrow(
        EmailAlreadyInUseAuthException(),
      );

      await expectLater(
          () => mockAuthService.createUser(
                email: mockUser['email']!,
                password: strongPass,
              ),
          throwsA(isA<EmailAlreadyInUseAuthException>()));
    });

    test('A user is returned when createUser is successful', () async {
      await expectLater(
          mockAuthService.createUser(
            email: validEmail,
            password: strongPass,
          ),
          isA<Future<AuthUser>>());
    });
  });

  // Log in
  group('Firebase Mock logIn', () {
    test('InvalidCredentialAuthException thrown on wrong email', () async {
      when(mockFirebaseProvider.logIn(
        email: validEmail,
        password: mockUser['pass'],
      )).thenThrow(
        InvalidCredentialAuthException(),
      );

      await expectLater(
          () => mockAuthService.logIn(
                email: validEmail,
                password: mockUser['pass']!,
              ),
          throwsA(isA<InvalidCredentialAuthException>()));
    });
    test('InvalidCredentialAuthException thrown on wrong password', () async {
      when(mockFirebaseProvider.logIn(
        email: mockUser['email'],
        password: strongPass,
      )).thenThrow(
        InvalidCredentialAuthException(),
      );

      await expectLater(
          () => mockAuthService.logIn(
                email: mockUser['email']!,
                password: strongPass,
              ),
          throwsA(isA<InvalidCredentialAuthException>()));
    });
  });

  // Log out
  group('Firebase Mock logOut', () {
    test(
        'UserNotLoggedInAuthException thrown when logging out a user that is not logged in',
        () async {
      await expectLater(mockAuthServiceNotLoggedIn.logOut(),
          throwsA(isA<UserNotLoggedInAuthException>()));
    });
  });

  // Email Verification
  group('Firebase Mock sendEmailVerfication', () {
    test(
        'UserNotLoggedInAuthException thrown when trying to send email verification on user that is not logged in',
        () async {
      await expectLater(mockAuthServiceNotLoggedIn.sendEmailVerification(),
          throwsA(isA<UserNotLoggedInAuthException>()));
    });
  });

  group('Firebase Mock currentUser', () {
    test('currentUser should be null when a user is not logged in', () {
      expect(mockAuthServiceNotLoggedIn.currentUser, null);
    });

    test(
        'If there is a currentUser and instance of the AuthUser should be returned',
        () {
      expect(mockAuthServiceLoggedIn.currentUser, isA<AuthUser>());
    });
  });
}
