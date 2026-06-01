import 'package:flutter/material.dart';
import 'package:warung_circle/screens/admin_panel_screen.dart';
import 'package:warung_circle/screens/chat_screen.dart';
import 'package:warung_circle/screens/dapur_erni_screen.dart';
import 'package:warung_circle/screens/gosip_warung_screen.dart';
import 'package:warung_circle/screens/home_screen.dart';
import 'package:warung_circle/screens/kapsul_warung_screen.dart';
import 'package:warung_circle/screens/lagi_ngapain_screen.dart';
import 'package:warung_circle/screens/lapak_screen.dart';
import 'package:warung_circle/screens/lelang_waktu_screen.dart';
import 'package:warung_circle/screens/login_screen.dart';
import 'package:warung_circle/screens/onboarding_screen.dart';
import 'package:warung_circle/screens/open_circle_screen.dart';
import 'package:warung_circle/screens/ruang_tengah_screen.dart';
import 'package:warung_circle/screens/scan_warung_screen.dart';
import 'package:warung_circle/screens/social_feed_screen.dart';
import 'package:warung_circle/screens/splash_screen.dart';
import 'package:warung_circle/screens/titip_cerita_screen.dart';
import 'package:warung_circle/theme/warung_theme.dart';
import 'package:warung_circle/utils/constants.dart';
import 'package:warung_circle/utils/warung_state.dart';
import 'package:warung_circle/services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService().initialize();
  await WS.init(HomeScreen.globalPosts);
  runApp(const WarungCircleApp());
}

class WarungCircleApp extends StatelessWidget {
  const WarungCircleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Warung Circle',
      debugShowCheckedModeBanner: false,
      theme: WarungTheme.theme,
      initialRoute: Routes.splash,
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case Routes.splash:
            // Splash can use standard transition so it loads instantly without slide-up
            return MaterialPageRoute(
              builder: (_) => const SplashScreen(),
              settings: settings,
            );
          case Routes.onboarding:
            return SlideUpRoute(
              page: const OnboardingScreen(),
              settings: settings,
            );
          case Routes.login:
            return SlideUpRoute(
              page: const LoginScreen(),
              settings: settings,
            );
          case Routes.home:
            return SlideUpRoute(
              page: const HomeScreen(),
              settings: settings,
            );
          case Routes.ruangTengah:
            return SlideUpRoute(
              page: const RuangTengahScreen(),
              settings: settings,
            );
          case Routes.titipCerita:
            return SlideUpRoute(
              page: const TitipCeritaScreen(),
              settings: settings,
            );
          case Routes.openCircle:
            return SlideUpRoute(
              page: const OpenCircleScreen(),
              settings: settings,
            );
          case Routes.dapurErni:
            return SlideUpRoute(
              page: const DapurErniScreen(),
              settings: settings,
            );
          case Routes.lapak:
            return SlideUpRoute(
              page: const LapakScreen(),
              settings: settings,
            );
          case Routes.chat:
            return SlideUpRoute(
              page: const ChatScreen(),
              settings: settings,
            );
          case Routes.socialFeed:
            return SlideUpRoute(
              page: const SocialFeedScreen(),
              settings: settings,
            );
          // === 5 FITUR VIRAL BARU ===
          case Routes.kapsulWarung:
            return SlideUpRoute(
              page: const KapsulWarungScreen(),
              settings: settings,
            );
          case Routes.gosipWarung:
            return SlideUpRoute(
              page: const GosipWarungScreen(),
              settings: settings,
            );
          case Routes.lelangWaktu:
            return SlideUpRoute(
              page: const LelangWaktuScreen(),
              settings: settings,
            );
          case Routes.scanWarung:
            return SlideUpRoute(
              page: const ScanWarungScreen(),
              settings: settings,
            );
          case Routes.lagiNgapain:
            return SlideUpRoute(
              page: const LagiNgapainScreen(),
              settings: settings,
            );
          case Routes.adminPanel:
            return SlideUpRoute(
              page: const AdminPanelScreen(),
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

/// Bouncy slide-up transition from bottom using easeOutBack
class SlideUpRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  SlideUpRoute({required this.page, super.settings})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeOutBack; // Cute bouncy feel!

            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 550),
        );
}
