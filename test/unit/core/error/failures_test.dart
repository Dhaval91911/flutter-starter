import 'package:flutter_test/flutter_test.dart';
import 'package:starter_template_riverpod/core/error/failures.dart';

void main() {
  group('Failure Classes Tests', () {
    group('Base Failure', () {
      test('should create failure with message only', () {
        const failure = ServerFailure('Test error');
        expect(failure.message, equals('Test error'));
        expect(failure.code, isNull);
        expect(failure.originalError, isNull);
      });

      test('should create failure with message and code', () {
        const failure = ServerFailure('Test error', 'ERR001');
        expect(failure.message, equals('Test error'));
        expect(failure.code, equals('ERR001'));
        expect(failure.originalError, isNull);
      });

      test('should create failure with message, code and original error', () {
        final originalError = Exception('Original exception');
        final failure = ServerFailure('Test error', 'ERR001', null, originalError);
        expect(failure.message, equals('Test error'));
        expect(failure.code, equals('ERR001'));
        expect(failure.originalError, equals(originalError));
      });

      test('should return correct string representation', () {
        const failure = ServerFailure('Test error', 'ERR001');
        expect(failure.toString(), equals('Failure: Test error (Code: ERR001)'));

        const failureNoCode = ServerFailure('Test error');
        expect(failureNoCode.toString(), equals('Failure: Test error'));
      });

      test('should implement equality correctly', () {
        const failure1 = ServerFailure('Test error', 'ERR001');
        const failure2 = ServerFailure('Test error', 'ERR001');
        const failure3 = ServerFailure('Different error', 'ERR001');

        expect(failure1, equals(failure2));
        expect(failure1, isNot(equals(failure3)));
      });

      test('should implement hashCode correctly', () {
        const failure1 = ServerFailure('Test error', 'ERR001');
        const failure2 = ServerFailure('Test error', 'ERR001');

        expect(failure1.hashCode, equals(failure2.hashCode));
      });
    });

    group('ServerFailure', () {
      test('should create server failure with status code', () {
        const failure = ServerFailure('Server error', 'ERR500', 500);
        expect(failure.message, equals('Server error'));
        expect(failure.code, equals('ERR500'));
        expect(failure.statusCode, equals(500));
      });

      test('should create server failure without status code', () {
        const failure = ServerFailure('Server error', 'ERR500');
        expect(failure.message, equals('Server error'));
        expect(failure.code, equals('ERR500'));
        expect(failure.statusCode, isNull);
      });
    });

    group('NetworkFailure', () {
      test('should create network failure', () {
        const failure = NetworkFailure('Network error');
        expect(failure.message, equals('Network error'));
        expect(failure.code, isNull);
      });
    });

    group('CacheFailure', () {
      test('should create cache failure', () {
        const failure = CacheFailure('Cache error');
        expect(failure.message, equals('Cache error'));
        expect(failure.code, isNull);
      });
    });

    group('ValidationFailure', () {
      test('should create validation failure with field errors', () {
        final fieldErrors = {'email': 'Invalid email', 'password': 'Too short'};
        final failure = ValidationFailure('Validation error', 'VAL001', fieldErrors);
        expect(failure.message, equals('Validation error'));
        expect(failure.code, equals('VAL001'));
        expect(failure.fieldErrors, equals(fieldErrors));
      });

      test('should create validation failure without field errors', () {
        const failure = ValidationFailure('Validation error');
        expect(failure.message, equals('Validation error'));
        expect(failure.fieldErrors, isNull);
      });
    });

    group('PermissionFailure', () {
      test('should create permission failure', () {
        const failure = PermissionFailure('Permission denied');
        expect(failure.message, equals('Permission denied'));
      });
    });

    group('UnknownFailure', () {
      test('should create unknown failure', () {
        const failure = UnknownFailure('Unknown error');
        expect(failure.message, equals('Unknown error'));
      });
    });

    group('TimeoutFailure', () {
      test('should create timeout failure', () {
        const failure = TimeoutFailure('Request timeout');
        expect(failure.message, equals('Request timeout'));
      });
    });

    group('AuthenticationFailure', () {
      test('should create authentication failure', () {
        const failure = AuthenticationFailure('Authentication failed');
        expect(failure.message, equals('Authentication failed'));
      });
    });

    group('AuthorizationFailure', () {
      test('should create authorization failure', () {
        const failure = AuthorizationFailure('Access denied');
        expect(failure.message, equals('Access denied'));
      });
    });
  });
}
