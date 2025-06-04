import 'package:flutter/cupertino.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:talento_flutter/core/utils/globals.dart';
import 'package:talento_flutter/presentation/screens/auth/forgot_password.dart';
import 'package:talento_flutter/presentation/screens/auth/login.dart';
import 'package:talento_flutter/presentation/screens/auth/register.dart';
import 'package:talento_flutter/presentation/screens/auth/verify_otp.dart';
import 'package:talento_flutter/presentation/screens/dashboard/job_details.dart';
import 'package:talento_flutter/presentation/screens/dashboard/profile.dart';
import 'package:talento_flutter/presentation/screens/features/artificial_intelligence.dart';
import 'package:talento_flutter/presentation/screens/features/dashboard.dart';
import 'package:talento_flutter/presentation/screens/features/help_support.dart';
import 'package:talento_flutter/presentation/screens/features/notifications.dart';
import 'package:talento_flutter/presentation/screens/features/privacy_policy.dart';
import 'package:talento_flutter/presentation/screens/features/refer.dart';
import 'package:talento_flutter/presentation/screens/features/refer_earn.dart';
import 'package:talento_flutter/presentation/screens/features/settings.dart';
import 'package:talento_flutter/presentation/screens/features/splash.dart';

class AppRoutes {
  static const splash = '/splash';
  static const login = '/login';
  static const forgotPassword = '/forgot_password';
  static const register = '/register';
  static const dashboard = '/dashboard';
  static const myProfile = '/my_profile';
  static const jobDetails = '/job_details';
  static const notifications = '/notifications';
  static const settings = '/settings';
  static const referEarn = '/refer_earn';
  static const referAndEarn = '/refer_and_earn';
  static const privacyPolicy = '/privacy_policy';
  static const helpSupport = '/help_support';
  static const aiHelp = '/ai_help';
  static const verifyOtp = '/verify_otp';
  static final routes = _getRoutes();

  static List<GetPage> _getRoutes() {
    return [
      _getPage(splash, () => SplashScreen()),
      _getPage(login, () => LoginScreen()),
      _getPage(forgotPassword, () => ForgotPasswordScreen()),
      _getPage(register, () => RegisterScreen()),
      _getPage(dashboard, () => DashboardScreen(key: dashboardKey)),
      _getPage(jobDetails, () => JobDetailsScreen()),
      _getPage(myProfile, () => ProfileScreen()),
      _getPage(notifications, () => NotificationScreen()),
      _getPage(settings, () => SettingsScreen()),
      _getPage(referEarn, () => ReferEarnScreen()),
      _getPage(referAndEarn, () => ReferAndEarnScreen()),
      _getPage(privacyPolicy, () => PrivacyPolicyScreen()),
      _getPage(helpSupport, () => HelpSupportScreen()),
      _getPage(aiHelp, () => ArtificialIntelligence()),
      _getPage(verifyOtp, () => VerifyOtpScreen()),
    ];
  }

  static GetPage _getPage(String routeName, Widget Function() page) {
    return GetPage(name: routeName, page: page);
  }
}
