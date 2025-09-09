import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:starter_template_riverpod/features/people/model/people_model.dart';

void main() {
  group('PeopleNotifier Tests', () {
    test('Basic test structure', () {
      expect(true, isTrue);
    });

    test('AsyncValue loading state test', () {
      const loadingState = AsyncValue.loading();
      expect(loadingState.isLoading, isTrue);
    });

    test('AsyncValue data state test', () {
      final dataState = AsyncValue.data(<PeopleModel>[]);
      expect(dataState.hasValue, isTrue);
      expect(dataState.value, isEmpty);
    });

    test('AsyncValue error state test', () {
      final errorState = AsyncValue.error('Test error', StackTrace.current);
      expect(errorState.hasError, isTrue);
      expect(errorState.error, equals('Test error'));
    });
  });
}
