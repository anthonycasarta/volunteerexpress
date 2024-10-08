import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:volunteerexpress/backend/services/auth/auth_exceptions.dart';
import 'package:volunteerexpress/backend/services/auth/firebase/firebase_auth_provider.dart';

import 'package:mockito/annotations.dart';

@GenerateNiceMocks([MockSpec<FirebaseAuthProvider>()])
import 'auth_test.mocks.dart';

void main() {
  final provider = MockFirebaseAuthProvider();
  const invalidEmail = 'emailgmail.com';

  group('Firebase mock authentication', () {
    test('weak pass exception', () async {});
  });

  // group('Mock Authentication', () {
  //   final provider = MockAuthProvider();

  //   test('Provider should not be initialized by default', () {
  //     expect(provider.isInitialized, false);
  //   });

  //   test('Cannot log out when provider is not initialized', () {
  //     expect(
  //       provider.logOut(),
  //       throwsA(
  //         const TypeMatcher<NotInitializedMockAuthException>(),
  //       ),
  //     );
  //   });

  //   test('Provider should initialize on initialize call', () async {
  //     await provider.initialize();

  //     expect(provider.isInitialized, true);
  //   });

  //   test('User should be null after initialization', () {
  //     expect(provider.currentUser, null);
  //   });

  //   test(
  //     'Initialization should take less than 2 seconds',
  //     () async {
  //       await provider.initialize();
  //       expect(provider.isInitialized, true);
  //     },
  //     timeout: const Timeout(Duration(seconds: 2)),
  //   );

  //   test(
  //       'logIn function should throw exceptions on wrong email and/or password',
  //       () {
  //     const wrongEmail = 'wrongEmail@gmail.com';
  //     const password = 'password';
  //     const email = 'email@gmail.com';
  //     const wrongPassword = 'wrongPassword';

  //     expect(provider.logIn(email: wrongEmail, password: password),
  //         throwsA(const TypeMatcher<InvalidCredentialAuthException>()));

  //     expect(provider.logIn(email: email, password: wrongPassword),
  //         throwsA(const TypeMatcher<InvalidCredentialAuthException>()));

  //     expect(provider.logIn(email: wrongEmail, password: wrongPassword),
  //         throwsA(const TypeMatcher<InvalidCredentialAuthException>()));
  //   });

  //   test(
  //       'When logging in with correct credentials, logIn should return that user',
  //       () {
  //     final user =
  //         provider.logIn(email: 'email@gmail.com', password: 'password');

  //     expect(provider.currentUser, user);
  //   });
  // });
}
