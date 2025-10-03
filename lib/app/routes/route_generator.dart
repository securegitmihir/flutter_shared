import 'dart:developer';

import 'package:assisted_living/app/routes/app_routes.dart';
import 'package:assisted_living/presentation/screens/about_screen.dart';
import 'package:assisted_living/presentation/screens/add_member_screen.dart';
import 'package:assisted_living/presentation/screens/language_selector_screen.dart';
import 'package:assisted_living/presentation/screens/login_screen.dart';
import 'package:assisted_living/presentation/screens/main_dashboard_screen.dart';
import 'package:assisted_living/presentation/screens/privacy_policy_screen.dart';
import 'package:assisted_living/presentation/screens/profile_setup_screen.dart';
import 'package:assisted_living/presentation/screens/terms_and_conditions_screen.dart';
import 'package:flutter/material.dart';
import '../../presentation/screens/contact_screen.dart';
import '../../presentation/screens/feedback_screen.dart';
import '../../presentation/screens/help_and_support.dart';
import '../../presentation/screens/splash_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(
          builder: (_) =>
              //   OrientationLock(
              // orientations: const [DeviceOrientation.portraitUp],
              // child:
              SplashScreen(),
          settings: const RouteSettings(name: AppRoutes.splash),
          // ),
        );
      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) =>
              //   OrientationLock(
              // orientations: const [DeviceOrientation.portraitUp],
              // child:
              LoginScreen(),
          settings: const RouteSettings(name: AppRoutes.login),
          // ),
        );
      case AppRoutes.profileSetup:
        return MaterialPageRoute(
          builder: (_) => ProfileSetup(),
          settings: const RouteSettings(name: AppRoutes.profileSetup),
        );
      case AppRoutes.dashboard:
        final args = settings.arguments as Map<String, dynamic>;
        final username = args['username'] ?? '';
        final gender = args['gender'] ?? '';
        log('Received username: $username');
        log('Received gender: $gender');
        return MaterialPageRoute(
          builder: (_) =>
              MainDashboardScreen(username: username, gender: gender),
          settings: const RouteSettings(name: AppRoutes.dashboard),
        );
      case AppRoutes.terms:
        return MaterialPageRoute(
          builder: (_) => TermsScreen(),
          settings: const RouteSettings(name: AppRoutes.terms),
        );
      case AppRoutes.privacy:
        return MaterialPageRoute(
          builder: (_) => PrivacyPolicyScreen(),
          settings: const RouteSettings(name: AppRoutes.privacy),
        );
      case AppRoutes.about:
        return MaterialPageRoute(
          builder: (_) => AboutScreen(),
          settings: const RouteSettings(name: AppRoutes.about),
        );
      case AppRoutes.help:
        return MaterialPageRoute(
          builder: (_) => HelpSupportScreen(),
          settings: const RouteSettings(name: AppRoutes.help),
        );
      // case AppRoutes.contactUs:
      //   return MaterialPageRoute(builder: (_) => ContactUsScreen());
      case AppRoutes.feedback:
        return MaterialPageRoute(
          builder: (_) => FeedbackScreen(),
          settings: const RouteSettings(name: AppRoutes.feedback),
        );
      case AppRoutes.addMember:
        return MaterialPageRoute(
          builder: (_) => AddMemberScreen(),
          settings: const RouteSettings(name: AppRoutes.addMember),
        );
      case AppRoutes.language:
        return MaterialPageRoute(
          builder: (_) => LanguageSelectorScreen(),
          settings: const RouteSettings(name: AppRoutes.language),
        );
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: const Center(child: Text('Page Not Found')),
        );
      },
    );
  }
}
