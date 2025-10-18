import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';

import 'core/theme/app_theme_mode_provider.dart';
import 'core/utils/provider_observer.dart';
import 'core/widgets/keyboard_dismissible.dart';
import 'features/network/notifier/network_notifier.dart';
import 'injectable/injectable.dart';
import 'route_config/route_config.dart';

Future<void> main() async {
  await configuration(
    runApp: () => runApp(
      ProviderScope(
        observers: [AppObserver()],
        child: EasyLocalization(
          supportedLocales: const [Locale('en'), Locale('hi')],
          path: 'lib/translations',
          fallbackLocale: const Locale('en'),
          useOnlyLangCode: true,
          child: const MyApp(),
        ),
      ),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(networkProvider.notifier).init(context, ref);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(appThemeModeProvider);

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return OKToast(
          child: KeyboardDismissible(
            child: MaterialApp.router(
              builder: EasyLoading.init(),
              themeMode: themeMode.mode,
              theme: themeMode.lightTheme,
              darkTheme: themeMode.darkTheme,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              routerConfig: AppRouter.router,
              debugShowCheckedModeBanner: false,
            ),
          ),
        );
      },
    );
  }
}
