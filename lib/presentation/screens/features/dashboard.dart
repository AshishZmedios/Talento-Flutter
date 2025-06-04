import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:talento_flutter/core/constants/constants.dart';
import 'package:talento_flutter/core/controller/dashboard_controller.dart';
import 'package:talento_flutter/core/utils/globals.dart';
import 'package:talento_flutter/core/utils/time_tracker.dart';
import 'package:talento_flutter/core/utils/utils.dart';
import 'package:talento_flutter/presentation/routes/routes.dart';
import 'package:talento_flutter/presentation/screens/dashboard/applied_jobs.dart';
import 'package:talento_flutter/presentation/screens/dashboard/home.dart';
import 'package:talento_flutter/presentation/screens/dashboard/jobs.dart';
import 'package:talento_flutter/presentation/screens/dashboard/profile.dart';
import 'package:talento_flutter/presentation/widgets/helper.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  final DashboardController controller = Get.put(DashboardController());
  int _currentIndex = 0;
  DateTime? _lastBackPressTime;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _pages = [
    JobsScreen(dashboardKey: dashboardKey),
    AppliedJobsScreen(dashboardKey: dashboardKey),
    HomeScreen(),
    ProfileScreen(),
  ];

  final List<String> _titles = [
    AppConstants.txtJobs,
    AppConstants.txtApply,
    AppConstants.txtHome,
    AppConstants.txtProfile,
  ];

  final List<IconData> _icons = [
    Icons.work_outline,
    Icons.assignment_outlined,
    Icons.home_outlined,
    Icons.person_outline,
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    controller.changeTabIndex(index);
    _animationController.reset();
    _animationController.forward();
  }

  Future<bool> _handleBackPress() async {
    final now = DateTime.now();
    if (_lastBackPressTime == null ||
        now.difference(_lastBackPressTime!) > Duration(seconds: 2)) {
      _lastBackPressTime = now;
      Utils.showSnackBar(context, "Press back again to exit.");
      return false;
    }
    SystemNavigator.pop();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          final shouldPop = await _handleBackPress();
          if (shouldPop) Navigator.of(context).maybePop();
        }
      },
      child: TimeTracker(
        screenName: AppConstants.dashboardScreen,
        child: Scaffold(
          key: scaffoldKey,
          drawer: _buildDrawer(),
          body: FadeTransition(
            opacity: _fadeAnimation,
            child: IndexedStack(index: _currentIndex, children: _pages),
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(
                    _pages.length,
                    (index) => _buildNavItem(
                      icon: _icons[index],
                      label: _titles[index],
                      isSelected: _currentIndex == index,
                      onTap: () => onTabTapped(index),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppConstants.primaryColor.withValues(alpha: 0.2)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppConstants.primaryColor : Colors.grey,
              size: 24,
            ),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppConstants.primaryColor : Colors.grey,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return SizedBox(
      width: 240,
      child: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Colors.grey[50]!],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppConstants.primaryColor.withValues(alpha: 0.1),
                        AppConstants.primaryColor.withValues(alpha: 0.1),
                      ],
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppConstants.primaryColor,
                            width: 2,
                          ),
                          image: DecorationImage(
                            image: AssetImage(AppConstants.iconLogo2),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      getHorizontalSpacer(16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "John Doe",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            getVerticalSpacer(4),
                            Text(
                              "Software Developer",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    children: [
                      _buildDrawerItem(
                        icon: Icons.person_outline,
                        title: "My Profile",
                        onTap: () => onTabTapped(3),
                      ),
                      _buildDrawerItem(
                        icon: Icons.work_outline,
                        title: "My Jobs",
                        onTap: () => onTabTapped(0),
                      ),
                      _buildDrawerItem(
                        icon: Icons.star_outline,
                        title: "My Reviews",
                        onTap: () {},
                      ),
                      _buildDrawerItem(
                        icon: Icons.people_outline,
                        title: "My Referrals",
                        onTap: () => moveToNextPage(AppRoutes.referAndEarn),
                      ),
                      Divider(color: Colors.grey[300]),
                      _buildDrawerItem(
                        icon: Icons.settings_outlined,
                        title: "Settings",
                        onTap: () => moveToNextPage(AppRoutes.settings),
                      ),
                      _buildDrawerItem(
                        icon: Icons.help_outline,
                        title: "Help & Support",
                        onTap: () => moveToNextPage(AppRoutes.helpSupport),
                      ),
                      _buildDrawerItem(
                        icon: Icons.privacy_tip_outlined,
                        title: "Privacy Centre",
                        onTap: () => moveToNextPage(AppRoutes.privacyPolicy),
                      ),
                    ],
                  ),
                ),
                Divider(color: Colors.grey[300]),
                _buildDrawerItem(
                  icon: Icons.logout,
                  title: "Logout",
                  onTap: () {
                    showConfirmationDialog(context, false);
                  },
                  isDestructive: true,
                ),
                getVerticalSpacer(8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            scaffoldKey.currentState?.closeDrawer();
            onTap();
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    isDestructive
                        ? Colors.red.withValues(alpha: 0.2)
                        : Colors.black.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color:
                        isDestructive
                            ? Colors.red.withValues(alpha: 0.1)
                            : AppConstants.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: (isDestructive
                                ? Colors.red
                                : AppConstants.primaryColor)
                            .withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    color:
                        isDestructive ? Colors.red : AppConstants.primaryColor,
                    size: 20,
                  ),
                ),
                getHorizontalSpacer(16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDestructive ? Colors.red : Colors.black87,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color:
                      isDestructive
                          ? Colors.red.withValues(alpha: 0.8)
                          : Colors.black.withValues(alpha: 0.8),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
