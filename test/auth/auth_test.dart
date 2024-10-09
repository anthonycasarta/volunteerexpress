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
  final mockFirebaseProvider = MockFirebaseAuthProvider();
  final mockAuthService = AuthService(authProvider: mockFirebaseProvider);
  const invalidEmail = 'emailgmail.com';
  const weakPass = 'pass';
  const validEmail = 'email@gmail.com';
  const strongPass = 'LemonLimeRime2387046!';

  const mockUser = {
    'email': 'mockemail@gmail.com',
    'pass': 'mockPass284639366!',
  };

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
