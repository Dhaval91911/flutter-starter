import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_template_riverpod/core/theme/extension_theme.dart';
import 'package:starter_template_riverpod/features/check_version/notifier/version_notifier.dart';

import '../../../core/utils/language.dart';
import '../../../core/widgets/common_text_field.dart';
import '../../../route_config/route_config.dart';
import '../../../route_config/routes.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(versionNotifierProvider.notifier).checkVersion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(Languages.home)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: () => AppRouter.router.push(Routes.appearances), child: Text(Languages.goToAppearance)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => AppRouter.router.push(Routes.languages, extra: {'hello': 'how are you'}),
              child: Text(Languages.goToLanguage),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: () => AppRouter.router.push(Routes.people), child: Text(Languages.goToPeople)),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: () => AppRouter.router.push(Routes.user), child: Text(Languages.goToUser)),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: () => AppRouter.router.push(Routes.signup), child: const Text('Sign Up')),
            const SizedBox(height: 16),
            Container(color: ref.backGround, height: 50, width: 50),
            Padding(
              padding: const EdgeInsets.all(16),
              child: CommonTextField(
                controller: TextEditingController(),
                labelText: 'Enter something',
                hintText: 'Type here...',
                prefixIcon: const Icon(Icons.person),
                onChange: (val) {
                  debugPrint('Typed: $val');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
