import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'features/player/player_controller.dart';
import 'features/settings/settings_controller.dart';
import 'screens/home_screen.dart';

class HimalApp extends StatelessWidget {
  const HimalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsController()),
        ChangeNotifierProvider(create: (_) => PlayerController()),
      ],
      child: Consumer<SettingsController>(
        builder: (context, settings, _) {
          return MaterialApp(
            title: 'HIMAL Video Player',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(settings.accentColor),
            darkTheme: AppTheme.dark(settings.accentColor),
            themeMode: settings.themeMode,
            home: const HomeScreen(),
            supportedLocales: const [
              Locale('en'),
              Locale('ne'),
              Locale('hi'),
              Locale('es'),
              Locale('fr'),
              Locale('de'),
              Locale('ja'),
              Locale('zh'),
            ],
          );
        },
      ),
    );
  }
}