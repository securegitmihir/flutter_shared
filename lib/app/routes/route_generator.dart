import 'dart:developer';

import 'package:assisted_living/app/routes/app_routes.dart';
import 'package:assisted_living/presentation/screens/about_screen.dart';
import 'package:assisted_living/presentation/screens/add_member_screen.dart';
import 'package:assisted_living/presentation/screens/diary_screen.dart';
import 'package:assisted_living/presentation/screens/login_screen.dart';
import 'package:assisted_living/presentation/screens/main_dashboard_screen.dart';
import 'package:assisted_living/presentation/screens/privacy_policy_screen.dart';
import 'package:assisted_living/presentation/screens/profile_setup_screen.dart';
import 'package:assisted_living/presentation/screens/terms_and_conditions_screen.dart';
import 'package:assisted_living/responsive/responsive.dart';
import 'package:flutter/material.dart';
import '../../presentation/screens/feedback_screen.dart';
import '../../presentation/screens/help_and_support.dart';
import '../../presentation/screens/language_selector_screen.dart';
import '../../presentation/screens/splash_screen.dart';

class RouteGenerator {
  static MaterialPageRoute buildRoute(Widget screen, String routeName) {
    return MaterialPageRoute(
      builder: (context) {
        context.responsive.setOrientationLocks(routeName);
        return screen;
      },
    );
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return buildRoute(SplashScreen(), AppRoutes.splash);
      case AppRoutes.login:
        return buildRoute(LoginScreen(), AppRoutes.login);
      case AppRoutes.profileSetup:
        return buildRoute(ProfileSetup(), AppRoutes.profileSetup);
      case AppRoutes.dashboard:
        final args = settings.arguments as Map<String, dynamic>;
        final username = args['username'] ?? '';
        final gender = args['gender'] ?? '';
        log('Received username: $username');
        log('Received gender: $gender');
        return buildRoute(
          MainDashboardScreen(username: username, gender: gender),
          AppRoutes.dashboard,
        );

      case AppRoutes.terms:
        return buildRoute(TermsScreen(), AppRoutes.terms);
      case AppRoutes.privacy:
        return buildRoute(PrivacyPolicyScreen(), AppRoutes.privacy);
      case AppRoutes.about:
        return buildRoute(AboutScreen(), AppRoutes.about);
      case AppRoutes.help:
        return buildRoute(HelpSupportScreen(), AppRoutes.help);
      case AppRoutes.feedback:
        return buildRoute(FeedbackScreen(), AppRoutes.feedback);
      case AppRoutes.diary:
        return buildRoute(DiaryScreen(), AppRoutes.diary);
      case AppRoutes.addMember:
        return buildRoute(AddMemberScreen(), AppRoutes.addMember);
      case AppRoutes.language:
        return buildRoute(LanguageSelectorScreen(), AppRoutes.language);
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
