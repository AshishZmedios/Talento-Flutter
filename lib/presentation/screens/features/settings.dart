import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart' show Share;
import 'package:talento_flutter/core/constants/constants.dart';
import 'package:talento_flutter/core/theme/theme_notifier.dart';
import 'package:talento_flutter/core/utils/time_tracker.dart';
import 'package:talento_flutter/core/utils/utils.dart';
import 'package:talento_flutter/presentation/routes/routes.dart';
import 'package:talento_flutter/presentation/widgets/helper.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  bool _notificationsEnabled = true;
  late AnimationController _animationController;
  final List<Map<String, dynamic>> settingSections = [
    {
      'title': 'Preferences',
      'items': [
        {
          'icon': Icons.notifications_none_outlined,
          'title': 'Notifications',
          'subtitle': 'Manage your notification preferences',
          'isToggle': true,
          'color': Colors.blue,
          'route': null,
        },
        {
          'icon': Icons.dark_mode_outlined,
          'title': 'Dark Mode',
          'subtitle': 'Switch between light and dark theme',
          'isToggle': true,
          'color': Colors.purple,
          'route': null,
        },
      ],
    },
    {
      'title': 'Account & Support',
      'items': [
        {
          'icon': Icons.account_circle_outlined,
          'title': 'About',
          'subtitle': 'Learn more about Talento',
          'isToggle': false,
          'color': Colors.green,
          'route': null,
        },
        {
          'icon': Icons.share_outlined,
          'title': 'Share App',
          'subtitle': 'Share Talento with friends',
          'isToggle': false,
          'color': Colors.orange,
          'route': null,
        },
        {
          'icon': Icons.star_outline,
          'title': 'Rate Us',
          'subtitle': 'Rate your experience with Talento',
          'isToggle': false,
          'color': Colors.amber,
          'route': null,
        },
      ],
    },
    {
      'title': 'Privacy & Security',
      'items': [
        {
          'icon': Icons.privacy_tip_outlined,
          'title': 'Privacy Policy',
          'subtitle': 'Read our privacy policy',
          'isToggle': false,
          'color': Colors.indigo,
          'route': AppRoutes.privacyPolicy,
        },
        {
          'icon': Icons.help_outline,
          'title': 'Help & Support',
          'subtitle': 'Get help with Talento',
          'isToggle': false,
          'color': Colors.teal,
          'route': AppRoutes.helpSupport,
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void shareApp() {
    Share.share(
      'Check out Talento: https://play.google.com/store/apps/details?id=com.talento.com',
      subject: 'Check out this amazing job search app!',
    );
  }

  Future<void> requestReview() async {
    final InAppReview inAppReview = InAppReview.instance;
    if (await inAppReview.isAvailable()) {
      await inAppReview.requestReview();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return TimeTracker(
      screenName: AppConstants.settingsScreen,
      child: Scaffold(
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[50],
        appBar: AppBar(
          leading: ModernBackButton(onPressed: () => moveToPreviousScreen()),
          title: getTextView(context, "Settings", 20, isBold: true),
          elevation: 0,
          backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[50],
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: settingSections.length + 2,
          // +2 for logout and delete account
          itemBuilder: (context, sectionIndex) {
            if (sectionIndex < settingSections.length) {
              final section = settingSections[sectionIndex];
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.2),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: Interval(
                      sectionIndex * 0.2,
                      1.0,
                      curve: Curves.easeOut,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: getTextView(
                        context,
                        section['title'],
                        16,
                        isBold: true,
                        color: Colors.grey[600],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.grey[800] : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: List.generate(section['items'].length, (
                          index,
                        ) {
                          final item = section['items'][index];
                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.vertical(
                                top:
                                    index == 0
                                        ? const Radius.circular(12)
                                        : Radius.zero,
                                bottom:
                                    index == section['items'].length - 1
                                        ? const Radius.circular(12)
                                        : Radius.zero,
                              ),
                              onTap: () {
                                if (item['title'] == 'Share App') {
                                  shareApp();
                                } else if (item['title'] == 'Rate Us') {
                                  requestReview();
                                } else if (item['route'] != null) {
                                  Navigator.pushNamed(context, item['route']);
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: item['color'].withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        item['icon'],
                                        color: item['color'],
                                        size: 24,
                                      ),
                                    ),
                                    getHorizontalSpacer(16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          getTextView(
                                            context,
                                            item['title'],
                                            16,
                                            isBold: true,
                                          ),
                                          getVerticalSpacer(4),
                                          getTextView(
                                            context,
                                            item['subtitle'],
                                            14,
                                            color: Colors.grey[600],
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (item['isToggle'])
                                      Switch.adaptive(
                                        value:
                                            item['title'] == 'Notifications'
                                                ? _notificationsEnabled
                                                : themeNotifier.isDarkMode,
                                        onChanged: (value) {
                                          setState(() {
                                            if (item['title'] ==
                                                'Notifications') {
                                              _notificationsEnabled = value;
                                              Utils.showSnackBar(
                                                context,
                                                value
                                                    ? "Notifications enabled"
                                                    : "Notifications disabled",
                                              );
                                            } else if (item['title'] ==
                                                'Dark Mode') {
                                              themeNotifier.toggleTheme();
                                            }
                                          });
                                        },
                                        activeColor: item['color'],
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    getVerticalSpacer(16),
                  ],
                ),
              );
            } else if (sectionIndex == settingSections.length) {
              // Logout button
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.2),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: Interval(0.8, 1.0, curve: Curves.easeOut),
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[800] : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => showConfirmationDialog(context, false),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.logout_rounded,
                                color: Colors.red,
                                size: 24,
                              ),
                            ),
                            getHorizontalSpacer(16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  getTextView(
                                    context,
                                    "Logout",
                                    16,
                                    isBold: true,
                                    color: Colors.red,
                                  ),
                                  getVerticalSpacer(4),
                                  getTextView(
                                    context,
                                    "Sign out of your account",
                                    14,
                                    color: Colors.grey[600],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            } else {
              // Delete account button
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.2),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: Interval(0.9, 1.0, curve: Curves.easeOut),
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[800] : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => showConfirmationDialog(context, true),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.red.shade900.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.delete_forever_rounded,
                                color: Colors.red.shade900,
                                size: 24,
                              ),
                            ),
                            getHorizontalSpacer(16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  getTextView(
                                    context,
                                    "Delete Account",
                                    16,
                                    isBold: true,
                                    color: Colors.red.shade900,
                                  ),
                                  getVerticalSpacer(4),
                                  getTextView(
                                    context,
                                    "Permanently delete your account and data",
                                    14,
                                    color: Colors.grey[600],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
