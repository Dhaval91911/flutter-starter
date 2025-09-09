// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:package_info_plus/package_info_plus.dart' as _i655;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:starter_template_riverpod/core/shared_pref/shared_pref.dart'
    as _i628;
import 'package:starter_template_riverpod/features/check_version/state_notifier/version_notifier.dart'
    as _i462;
import 'package:starter_template_riverpod/features/pagination/state_notifier/user_notifier.dart'
    as _i385;
import 'package:starter_template_riverpod/features/people/state_notifier/people_notifier.dart'
    as _i1013;
import 'package:starter_template_riverpod/injectable/injectable.dart' as _i791;
import 'package:starter_template_riverpod/services/web_service/api_service.dart'
    as _i33;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.factory<String>(() => registerModule.baseUrl);
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs(),
      preResolve: true,
    );
    await gh.factoryAsync<_i655.PackageInfo>(
      () => registerModule.getAppInfo(),
      preResolve: true,
    );
    gh.singleton<_i361.Dio>(() => registerModule.dio());
    gh.lazySingleton<_i628.SharedPrefService>(
      () => _i628.SharedPrefService(pref: gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i33.ApiService>(
      () => _i33.ApiService.new(gh<_i361.Dio>(), baseUrl: gh<String>()),
    );
    gh.factory<_i385.UserNotifier>(
      () => _i385.UserNotifier(gh<_i33.ApiService>()),
    );
    gh.factory<_i1013.PeopleNotifier>(
      () => _i1013.PeopleNotifier(gh<_i33.ApiService>()),
    );
    gh.factory<_i462.VersionNotifier>(
      () => _i462.VersionNotifier(gh<_i33.ApiService>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i791.RegisterModule {}
