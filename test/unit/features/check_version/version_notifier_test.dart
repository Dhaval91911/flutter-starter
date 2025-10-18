import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starter_template_riverpod/core/shared_pref/shared_pref.dart';
import 'package:starter_template_riverpod/features/check_version/model/check_version_model.dart';
import 'package:starter_template_riverpod/features/check_version/notifier/version_notifier.dart';
import 'package:starter_template_riverpod/services/web_service/api_service.dart';

class _FakeApiService implements ApiService {
  CheckAppVersionModel response;
  _FakeApiService(this.response);

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakePrefs extends SharedPrefService {
  final Map<String, String> store = {};
  _FakePrefs() : super(pref: _MemoryPrefs());

  @override
  Future<bool> setString(String key, String value) async {
    store[key] = value;
    return true;
  }
}

class _MemoryPrefs implements SharedPreferences {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

CheckAppVersionModel _buildModel({required bool need, required bool force, required bool maintenance}) {
  return CheckAppVersionModel(
    success: true,
    statuscode: 1,
    message: 'ok',
    data: Data(isNeedUpdate: need, isForceUpdate: force, isMaintenance: maintenance, termsAndConditions: 't', privacyPolicy: 'p', about: 'a'),
  );
}

void main() {
  testWidgets('blocks navigation on maintenance', (tester) async {
    final api = _FakeApiService(_buildModel(need: false, force: false, maintenance: true));
    final prefs = _FakePrefs();
    final notifier = VersionNotifier(api, prefs);

    final app = ProviderScope(
      child: Builder(
        builder: (context) {
          notifier.setContext(context);
          return const SizedBox.shrink();
        },
      ),
    );

    await tester.pumpWidget(MaterialApp(home: app));
    await notifier.checkVersion();
    expect(notifier.blockNavigation, true);
  });

  testWidgets('blocks navigation and shows dialog on force update', (tester) async {
    final api = _FakeApiService(_buildModel(need: true, force: true, maintenance: false));
    final prefs = _FakePrefs();
    final notifier = VersionNotifier(api, prefs);

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            notifier.setContext(context);
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    await notifier.checkVersion();
    expect(notifier.blockNavigation, true);
  });

  testWidgets('optional update does not block navigation', (tester) async {
    final api = _FakeApiService(_buildModel(need: true, force: false, maintenance: false));
    final prefs = _FakePrefs();
    final notifier = VersionNotifier(api, prefs);

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            notifier.setContext(context);
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    await notifier.checkVersion();
    expect(notifier.blockNavigation, false);
  });
}
