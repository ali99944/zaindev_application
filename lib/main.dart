import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zaindev_application/core/routing/app_router.dart';
import 'package:zaindev_application/presentation/screens/home/home_navigator_screen.dart';


import 'core/theme/app_theme.dart';

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
      initialRoute: HomeNavigatorScreen.route,
      title: 'Zaindev',
      theme: AppTheme.lightTheme
    );
  }
}
