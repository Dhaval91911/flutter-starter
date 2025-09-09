abstract class Failure {
  final String message;
  final String? code;
  final dynamic originalError;

  const Failure(this.message, [this.code, this.originalError]);

  @override
  String toString() => 'Failure: $message${code != null ? ' (Code: $code)' : ''}';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Failure && other.message == message && other.code == code;
  }

  @override
  int get hashCode => message.hashCode ^ code.hashCode;
}

class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure(super.message, [super.code, this.statusCode, super.originalError]);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message, [super.code, super.originalError]);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message, [super.code, super.originalError]);
}

class ValidationFailure extends Failure {
  final Map<String, String>? fieldErrors;

  const ValidationFailure(super.message, [super.code, this.fieldErrors, super.originalError]);
}

class PermissionFailure extends Failure {
  const PermissionFailure(super.message, [super.code, super.originalError]);
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message, [super.code, super.originalError]);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure(super.message, [super.code, super.originalError]);
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure(super.message, [super.code, super.originalError]);
}

class AuthorizationFailure extends Failure {
  const AuthorizationFailure(super.message, [super.code, super.originalError]);
}
