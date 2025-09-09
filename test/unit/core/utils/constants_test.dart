import 'package:flutter_test/flutter_test.dart';
import 'package:starter_template_riverpod/core/utils/constants.dart';

void main() {
  group('Constants Tests', () {
    test('should have correct tag value', () {
      expect(Constants.tag, equals('FMR'));
    });

    test('should have correct shared preferences keys', () {
      expect(Constants.themeModeKey, equals('theme_mode_key'));
      expect(Constants.profileKey, equals('profile_key'));
      expect(Constants.isLoginKey, equals('is_login_key'));
      expect(Constants.isExistAccountKey, equals('is_exist_account_key'));
      expect(Constants.lastDayShowPremiumKey, equals('last_day_show_premium_key'));
    });

    test('should have correct premium values', () {
      expect(Constants.premium, equals('premium'));
      expect(Constants.premiumMonthly, equals('\$rc_monthly'));
      expect(Constants.premiumYearly, equals('\$rc_annual'));
      expect(Constants.premiumLifeTime, equals('\$rc_lifetime'));
    });

    test('should have placeholder values for configurable constants', () {
      expect(Constants.defaultName, equals('User Name'));
      expect(Constants.defaultEmail, equals('user@example.com'));
      expect(Constants.termOfService, contains('your-app.com'));
      expect(Constants.privacyPolicy, contains('your-app.com'));
      expect(Constants.aboutUs, contains('your-app.com'));
      expect(Constants.appStore, contains('your-app'));
      expect(Constants.playStore, contains('your-app'));
      expect(Constants.facebookPage, contains('your-app'));
    });
  });
}
