import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/shared_pref/shared_pref.dart';
import '../../../core/shared_pref/storage_keys.dart';
import '../../../injectable/injectable.dart';
import '../../check_version/notifier/version_notifier.dart';

class AboutScreen extends ConsumerStatefulWidget {
  const AboutScreen({super.key});

  @override
  ConsumerState<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends ConsumerState<AboutScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  Future<String?> _getAboutContent() async {
    // First try to get from SharedPreferences
    final storedContent = getIt<SharedPrefService>().getString(StorageKeys.appAbout);
    if (storedContent != null && storedContent.isNotEmpty) {
      return _cleanHtmlContent(storedContent);
    }

    // If not found, try to get from version notifier
    try {
      final versionData = await ref.read(versionNotifierProvider.notifier).checkVersion();
      if (versionData != null && versionData.data.about.isNotEmpty) {
        return _cleanHtmlContent(versionData.data.about);
      }
    } catch (e) {
      // Handle error silently
    }

    return null;
  }

  String _cleanHtmlContent(String htmlContent) {
    // Extract content between <main> and </main> tags, or fallback to <body> content
    String cleanedContent = htmlContent;

    // Try to extract main content
    final mainMatch = RegExp(r'<main[^>]*>(.*?)</main>', dotAll: true).firstMatch(htmlContent);
    if (mainMatch != null) {
      cleanedContent = mainMatch.group(1) ?? htmlContent;
    } else {
      // Try to extract body content
      final bodyMatch = RegExp(r'<body[^>]*>(.*?)</body>', dotAll: true).firstMatch(htmlContent);
      if (bodyMatch != null) {
        cleanedContent = bodyMatch.group(1) ?? htmlContent;
      }
    }

    // Remove style tags and their content
    cleanedContent = cleanedContent.replaceAll(RegExp(r'<style[^>]*>.*?</style>', dotAll: true), '');

    // Remove script tags and their content
    cleanedContent = cleanedContent.replaceAll(RegExp(r'<script[^>]*>.*?</script>', dotAll: true), '');

    // Remove meta tags
    cleanedContent = cleanedContent.replaceAll(RegExp(r'<meta[^>]*>', dotAll: true), '');

    // Remove title tags
    cleanedContent = cleanedContent.replaceAll(RegExp(r'<title[^>]*>.*?</title>', dotAll: true), '');

    // Remove head tags
    cleanedContent = cleanedContent.replaceAll(RegExp(r'<head[^>]*>.*?</head>', dotAll: true), '');

    // Remove html and body tags
    cleanedContent = cleanedContent.replaceAll(RegExp(r'</?html[^>]*>', dotAll: true), '');
    cleanedContent = cleanedContent.replaceAll(RegExp(r'</?body[^>]*>', dotAll: true), '');
    cleanedContent = cleanedContent.replaceAll(RegExp(r'</?main[^>]*>', dotAll: true), '');

    return cleanedContent;
  }

  Widget _buildHtmlContent(String htmlContent, ThemeData theme) {
    try {
      return Html(
        data: htmlContent,
        onLinkTap: (url, attributes, element) {
          // Handle link taps if needed
        },
        style: {
          'body': Style(
            margin: Margins.zero,
            padding: HtmlPaddings.zero,
            fontSize: FontSize(14.sp),
            lineHeight: const LineHeight(1.5),
            color: theme.colorScheme.onSurface,
          ),
          'h1': Style(
            fontSize: FontSize(20.sp),
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
            margin: Margins.only(bottom: 16.h),
          ),
          'h2': Style(
            fontSize: FontSize(18.sp),
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
            margin: Margins.only(bottom: 12.h, top: 16.h),
          ),
          'h3': Style(
            fontSize: FontSize(16.sp),
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
            margin: Margins.only(bottom: 8.h, top: 12.h),
          ),
          'p': Style(
            fontSize: FontSize(14.sp),
            lineHeight: const LineHeight(1.6),
            color: theme.colorScheme.onSurface,
            margin: Margins.only(bottom: 12.h),
          ),
          'ul': Style(margin: Margins.only(bottom: 12.h)),
          'ol': Style(margin: Margins.only(bottom: 12.h)),
          'li': Style(
            fontSize: FontSize(14.sp),
            lineHeight: const LineHeight(1.6),
            color: theme.colorScheme.onSurface,
            margin: Margins.only(bottom: 4.h),
          ),
          'strong': Style(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
          'em': Style(fontStyle: FontStyle.italic, color: theme.colorScheme.onSurface),
          'a': Style(color: theme.primaryColor, textDecoration: TextDecoration.underline),
          'blockquote': Style(
            fontSize: FontSize(14.sp),
            fontStyle: FontStyle.italic,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            margin: Margins.symmetric(vertical: 12.h, horizontal: 16.w),
            padding: HtmlPaddings.all(12.w),
            backgroundColor: theme.colorScheme.surface,
            border: Border(
              left: BorderSide(color: theme.primaryColor, width: 4.w),
            ),
          ),
        },
      );
    } catch (e) {
      // Fallback to plain text
      return Text(
        htmlContent.replaceAll(RegExp(r'<[^>]*>'), ''), // Remove HTML tags
        style: theme.textTheme.bodyMedium,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('About Us')),
      body: FutureBuilder<String?>(
        future: _getAboutContent(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snap.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48.w, color: theme.colorScheme.error),
                  SizedBox(height: 16.h),
                  Text('Failed to load about information', style: theme.textTheme.titleMedium),
                  SizedBox(height: 8.h),
                  Text('Please try again later', style: theme.textTheme.bodyMedium),
                ],
              ),
            );
          }

          final htmlContent = snap.data ?? '';

          if (htmlContent.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info_outline, size: 48.w, color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
                  SizedBox(height: 16.h),
                  Text('No about information available', style: theme.textTheme.titleMedium),
                  SizedBox(height: 8.h),
                  Text('About information is not available', style: theme.textTheme.bodyMedium),
                ],
              ),
            );
          }

          return SingleChildScrollView(padding: EdgeInsets.all(16.w), child: _buildHtmlContent(htmlContent, theme));
        },
      ),
    );
  }
}
