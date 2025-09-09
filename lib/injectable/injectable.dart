import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starter_template_riverpod/injectable/injectable.config.dart';

import '../core/config/environment.dart' as env;
import '../core/notification_helper/notification_helper.dart';
import '../route_config/route_config.dart';
import '../services/connectivity_interceptor/connectivity_interceptor.dart';
import '../services/http_interceptor/http_interceptor.dart';

final getIt = GetIt.instance;

@injectableInit
Future<void> configuration({required void Function() runApp}) async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Set environment - change this based on your build configuration
      env.EnvironmentConfig.setEnvironment(env.Environment.dev);

      AppRouter.init();
      await getIt.init();
      await EasyLocalization.ensureInitialized();
      // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      AppNotificationHandler();
      AppNotificationHandler.initialize();
      getIt<Dio>().interceptors.add(PrettyDioLogger(responseBody: false));
      getIt<Dio>().interceptors.add(TokenInterceptor());
      getIt<Dio>().interceptors.add(ConnectivityInterceptor());

      await Permission.notification.isDenied.then((value) {
        if (value) {
          Permission.notification.request();
        }
      });

      await Permission.location.isDenied.then((value) {
        if (value) {
          Permission.location.request();
        }
      });

      configLoading();
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

      HttpOverrides.global = MyHttpOverrides();
      // FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance; // Change here

      // await firebaseMessaging.getToken().then((token) {
      // PreferenceUtils.setString(key: keyGCMToken, value: token.toString());
      // debugPrint("token is $token");
      // });

      // AppNotificationHandler();
      // AppNotificationHandler.initialize();

      // await FlutterBranchSdk.init();

      runApp();
    },
    (error, stackTrace) {},
    zoneSpecification: ZoneSpecification(
      handleUncaughtError: (Zone zone, ZoneDelegate delegate, Zone parent, Object error, StackTrace stackTrace) {},
    ),
  );
}

@module
abstract class RegisterModule {
  @singleton
  Dio dio() => Dio();

  String get baseUrl => env.EnvironmentConfig.baseUrl;

  String get socketBaseUrl => env.EnvironmentConfig.socketBaseUrl;

  @preResolve
  Future<SharedPreferences> prefs() => SharedPreferences.getInstance();

  // @preResolve
  // Future<Directory> temporaryDirectory() => getTemporaryDirectory();

  @preResolve
  Future<PackageInfo> getAppInfo() => PackageInfo.fromPlatform();
  //
  // @preResolve
  // Future<FirebaseApp> initializeFireBase() =>
  //     Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.circle
    ..loadingStyle = EasyLoadingStyle.dark
    ..userInteractions = false
    ..dismissOnTap = false
    ..maskType = EasyLoadingMaskType.black
    ..animationStyle = EasyLoadingAnimationStyle.offset;
}
