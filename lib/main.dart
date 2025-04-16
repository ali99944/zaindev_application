import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zaindev_application/core/constants/app_routes.dart';
import 'package:zaindev_application/core/routing/app_router.dart';
import 'package:zaindev_application/core/theme/app_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/constants/app_colors.dart';

void main() {
  runApp(
    ProviderScope(
      child: ZaindevApplication(),
    )
  );
}

class ZaindevApplication extends StatelessWidget {
  const ZaindevApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: AppRoutes.resetPassword,
      title: 'Zaindev',
      theme: createTheme(brightness: Brightness.light, languageCode: 'ar').copyWith(
        scaffoldBackgroundColor: AppColors.background
      ),
      // Localization setup
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English, no country code
        Locale('ar', ''), // Arabic, no country code
      ],
      locale: const Locale('ar', '')
    );
  }
}
