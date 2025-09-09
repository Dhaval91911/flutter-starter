class Constants {
  Constants._();

  static const String tag = 'FMR';

  static const String supabaseLoginCallback = 'com.areser.flutter_mvvm_riverpod://login-callback/';
  static const String supabaseProfileTable = 'profile';
  static const String googleEmailScope = 'email';
  static const String googleUserInfoScope = 'https://www.googleapis.com/auth/userinfo.profile';

  // Generic placeholder values - configure these for your app
  static const String defaultName = 'User Name';
  static const String defaultEmail = 'user@example.com';
  static const String termOfService = 'https://your-app.com/terms';
  static const String privacyPolicy = 'https://your-app.com/privacy';
  static const String aboutUs = 'https://your-app.com/about';
  static const String appStore = 'https://apps.apple.com/your-app';
  static const String playStore = 'https://play.google.com/store/apps/your-app';
  static const String facebookPage = 'https://facebook.com/your-app';

  static const String premium = 'premium';
  static const String premiumMonthly = '\$rc_monthly';
  static const String premiumYearly = '\$rc_annual';
  static const String premiumLifeTime = '\$rc_lifetime';

  // SharedPreferences key
  static const String themeModeKey = 'theme_mode_key';
  static const String profileKey = 'profile_key';
  static const String isLoginKey = 'is_login_key';
  static const String isExistAccountKey = 'is_exist_account_key';
  static const String lastDayShowPremiumKey = 'last_day_show_premium_key';
}
