abstract class Failure {
  final String message;
  const Failure(this.message);
}

// Server failures
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error occurred']);
}

// Network failures
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}

// Authentication failures
class AuthenticationFailure extends Failure {
  const AuthenticationFailure([super.message = 'Authentication failed']);
}

// Validation failures
class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Invalid input']);
}

// Timeout failures
class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = 'Request timeout']);
}

// Cache failures
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error']);
}

// Authentication failures
class AuthenticationException extends Failure {
  const AuthenticationException([super.message = 'Authentication failed']);
}