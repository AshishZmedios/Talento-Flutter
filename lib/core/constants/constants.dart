import 'package:flutter/cupertino.dart';

class AppConstants {
  // Texts
  static const String txtMyAccount = "My Account";
  static const String txtMyJobs = "My Jobs";
  static const String txtMyReviews = "My Reviews";
  static const String txtMyReferral = "My Referral";
  static const String txtSettings = "Settings";
  static const String txtHelpSupport = "Help & Support";
  static const String txtPrivacyCentre = "Privacy Centre";
  static const String txtDarkMode = "Dark Mode";
  static const String txtLogout = "Logout";
  static const String txtJobs = "Jobs";
  static const String txtApply = "Apply";
  static const String txtHome = "Home";
  static const String txtProfile = "Profile";

  // Screens Name
  static const _screenSuffix = " Screen";
  static const String splashScreen = "Splash$_screenSuffix";
  static const String registerUserScreen = "Register$_screenSuffix";
  static const String loginUserScreen = "Login$_screenSuffix";
  static const String forgotPasswordScreen = "Forgot Password$_screenSuffix";
  static const String otpVerificationScreen = "Otp Verification$_screenSuffix";
  static const String dashboardScreen = "Dashboard$_screenSuffix";
  static const String jobDetailScreen = "Job Detail$_screenSuffix";
  static const String profileScreen = "Profile$_screenSuffix";
  static const String notificationScreen = "Notification$_screenSuffix";
  static const String settingsScreen = "Settings$_screenSuffix";
  static const String referEarnScreen = "Refer Earn$_screenSuffix";
  static const String referAndEarnScreen = "Refer$_screenSuffix";
  static const String privacyScreen = "Privacy$_screenSuffix";
  static const String helpScreen = "Help$_screenSuffix";
  static const String jobsScreen = "Jobs$_screenSuffix";
  static const String applyJobsScreen = "Apply Jobs$_screenSuffix";
  static const String verifyOtpScreen = "Verify OTP$_screenSuffix";
  static const String artificialIntelligenceScreen = "AI Help$_screenSuffix";

  // Colors
  static const Color primaryColor = kWarningColor;
  static const Color kPrimaryColor = Color(0xFF7C4DFF);
  static const Color kSecondaryColor = Color(0xFFFF4B8A);
  static const Color kAccentColor = Color(0xFFFFB300);
  static const Color kBackgroundStart = Color(0xFFF6F9FF);
  static const Color kBackgroundEnd = Color(0xFFFFFFFF);
  static const Color kCardColor = Color(0xFFFFFFFF);
  static const Color kTextColor = Color(0xFF2D3142);
  static const Color kTextSecondary = Color(0xFF6B7280);
  static const Color kColorGreen = Color(0xFF49EF14);
  static const Color kColorGreen1 = Color(0xFF5CAA43);
  static const Color kColorGreen12 = Color(0xFF113704);
  static const Color kColorRed1 = Color(0xFFD52D2D);
  static const Color kBackgroundColor = Color(0xFFF5F5F5); // light grey
  static const Color kSubTextColor = Color(0xFF757575); // medium grey
  static const Color kBorderColor = Color(0xFFE0E0E0); // light border
  static const Color kSuccessColor = Color(0xFF4CAF50); // green
  static const Color kWarningColor = Color(0xFFFFC107); // amber
  static const Color kErrorColor = Color(0xFFF44336); // red
  static const Color kInfoColor = Color(0xFF2196F3); // blue
  static const Color kLightPrimaryColor = Color(0xFFD1C4E9); // light purple
  static const Color kDarkPrimaryColor = Color(0xFF512DA8); // deep purple
  static const Color kLightSecondaryColor = Color(0xFFFFCDD2); // light pink
  static const Color kDarkSecondaryColor = Color(0xFFC2185B); // deep pink
  static const Color kAccentLightColor = Color(0xFFFFF8E1); // light amber
  static const Color kAccentDarkColor = Color(0xFFFF6F00); // dark amber

  // Icons
  static const String iconPrefix = "assets/images/";
  static const String iconSuffix = ".png";
  static const String iconFilter = '${iconPrefix}filter$iconSuffix';
  static const String iconHandShake = '${iconPrefix}handshake$iconSuffix';
  static const String iconVerifyOtp =
      '${iconPrefix}otp_verification$iconSuffix';
  static const String iconUnion = '${iconPrefix}union$iconSuffix';
  static const String iconFab = '${iconPrefix}fab$iconSuffix';
  static const String iconMenu = '${iconPrefix}menu$iconSuffix';
  static const String iconNewWay = '${iconPrefix}new_way$iconSuffix';
  static const String iconLogo1 = '${iconPrefix}logo1$iconSuffix';
  static const String iconLogo2 = '${iconPrefix}logo2$iconSuffix';
  static const String iconLogo3 = '${iconPrefix}essence_logo$iconSuffix';
  static const String iconMyAccounts = '${iconPrefix}my_account$iconSuffix';
  static const String iconMyJob = '${iconPrefix}my_jobs$iconSuffix';
  static const String iconSettingsIcon = '${iconPrefix}settings$iconSuffix';
  static const String iconHelp = '${iconPrefix}help$iconSuffix';
  static const String iconDark = '${iconPrefix}dark$iconSuffix';
  static const String iconRefer = '${iconPrefix}refer$iconSuffix';
  static const String iconApply = '${iconPrefix}apply$iconSuffix';
  static const String iconMyReferral = '${iconPrefix}my_referral$iconSuffix';
  static const String iconSettings = '${iconPrefix}settings$iconSuffix';
  static const String iconPrivacy = '${iconPrefix}privacy$iconSuffix';
  static const String iconJobs = '${iconPrefix}jobs$iconSuffix';
  static const String iconHome = '${iconPrefix}home$iconSuffix';
  static const String iconProfile = '${iconPrefix}profile$iconSuffix';
  static const String iconReferEarn = '${iconPrefix}refer_a_friend$iconSuffix';
  static const String lottieReferEarn =
      '${iconPrefix}refer_and_earn$iconSuffix';
  static const String txtAppVersion = "App Version v1.0";
  static const String iconReferAndEarn =
      '${iconPrefix}refer_and_earn_$iconSuffix';

  // Used in shared preferences
  static const String isLogin = "isLoggedIn";

  // Used as key to send arguments
  static const String argumnetMobileEmail = "mobileEmail";
}
