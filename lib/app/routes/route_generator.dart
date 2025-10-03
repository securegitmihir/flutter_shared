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
          // ),
        );
      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) =>
              //   OrientationLock(
              // orientations: const [DeviceOrientation.portraitUp],
              // child:
              LoginScreen(),
          // ),
        );
      case AppRoutes.profileSetup:
        return MaterialPageRoute(builder: (_) => ProfileSetup());
      case AppRoutes.dashboard:
        final args = settings.arguments as Map<String, dynamic>;
        final username = args['username'] ?? '';
        final gender = args['gender'] ?? '';
        log('Received username: $username');
        log('Received gender: $gender');
        return MaterialPageRoute(
          builder: (_) =>
              MainDashboardScreen(username: username, gender: gender),
        );
      case AppRoutes.terms:
        return MaterialPageRoute(builder: (_) => TermsScreen());
      case AppRoutes.privacy:
        return MaterialPageRoute(builder: (_) => PrivacyPolicyScreen());
      case AppRoutes.about:
        return MaterialPageRoute(builder: (_) => AboutScreen());
      case AppRoutes.help:
        return MaterialPageRoute(builder: (_) => HelpSupportScreen());
      // case AppRoutes.contactUs:
      //   return MaterialPageRoute(builder: (_) => ContactUsScreen());
      case AppRoutes.feedback:
        return MaterialPageRoute(builder: (_) => FeedbackScreen());
      case AppRoutes.addMember:
        return MaterialPageRoute(builder: (_) => AddMemberScreen());
      case AppRoutes.language:
        return MaterialPageRoute(builder: (_) => LanguageSelectorScreen());
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
