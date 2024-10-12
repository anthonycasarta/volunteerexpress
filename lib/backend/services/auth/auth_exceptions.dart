// login exceptions
class InvalidCredentialAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}

class UserNotFoundAuthException implements Exception {}

// register exceptions
class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

// both
class InvalidEmailAuthException implements Exception {}

class GenericAuthException implements Exception {}
