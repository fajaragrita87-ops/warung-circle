import 'package:flutter/material.dart';
import 'package:warung_circle/screens/chat_screen.dart';
import 'package:warung_circle/screens/dapur_erni_screen.dart';
import 'package:warung_circle/screens/home_screen.dart';
import 'package:warung_circle/screens/lapak_screen.dart';
import 'package:warung_circle/screens/onboarding_screen.dart';
import 'package:warung_circle/screens/open_circle_screen.dart';
import 'package:warung_circle/screens/ruang_tengah_screen.dart';
import 'package:warung_circle/screens/splash_screen.dart';
import 'package:warung_circle/screens/titip_cerita_screen.dart';
import 'package:warung_circle/theme/warung_theme.dart';
import 'package:warung_circle/utils/constants.dart';

void main() {
  runApp(const WarungCircleApp());
}

class WarungCircleApp extends StatelessWidget {
  const WarungCircleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Warung Circle',
      debugShowCheckedModeBanner: false,
      theme: WarungTheme.themeData(context),
      initialRoute: Routes.home,
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case Routes.splash:
            return MaterialPageRoute(
              builder: (_) => const SplashScreen(),
              settings: settings,
            );
          case Routes.onboarding:
            return MaterialPageRoute(
              builder: (_) => const OnboardingScreen(),
              settings: settings,
            );
          case Routes.home:
            return MaterialPageRoute(
              builder: (_) => const HomeScreen(),
              settings: settings,
            );
          case Routes.ruangTengah:
            return MaterialPageRoute(
              builder: (_) => const RuangTengahScreen(),
              settings: settings,
            );
          case Routes.titipCerita:
            return MaterialPageRoute(
              builder: (_) => const TitipCeritaScreen(),
              settings: settings,
            );
          case Routes.openCircle:
            return MaterialPageRoute(
              builder: (_) => const OpenCircleScreen(),
              settings: settings,
            );
          case Routes.dapurErni:
            return MaterialPageRoute(
              builder: (_) => const DapurErniScreen(),
              settings: settings,
            );
          case Routes.lapak:
            return MaterialPageRoute(
              builder: (_) => const LapakScreen(),
              settings: settings,
            );
          case Routes.chat:
            return MaterialPageRoute(
              builder: (_) => const ChatScreen(),
              settings: settings,
            );
          default:
            return MaterialPageRoute(
              builder: (_) => const SplashScreen(),
              settings: settings,
            );
        }
      },
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (_) => const SplashScreen(),
        settings: settings,
      ),
    );
  }
}
