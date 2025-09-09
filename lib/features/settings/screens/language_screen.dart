import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/language.dart';

class LanguageScreen extends StatelessWidget {
  final String title;
  const LanguageScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(Languages.selectLanguage)),
      body: ListView(
        children: [
          ListTile(
            title: Text(Languages.english),
            onTap: () {
              context.setLocale(const Locale('en'));
            },
          ),
          ListTile(
            title: Text(Languages.hindi),
            onTap: () {
              context.setLocale(const Locale('hi'));
            },
          ),
          Text(title),
        ],
      ),
    );
  }
}
