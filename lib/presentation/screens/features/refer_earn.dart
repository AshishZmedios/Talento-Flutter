import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:talento_flutter/core/constants/constants.dart';
import 'package:talento_flutter/core/utils/time_tracker.dart';
import 'package:talento_flutter/core/utils/utils.dart';
import 'package:talento_flutter/presentation/widgets/helper.dart';

class ReferEarnScreen extends StatefulWidget {
  const ReferEarnScreen({super.key});

  @override
  State<ReferEarnScreen> createState() => _ReferEarnScreenState();
}

class _ReferEarnScreenState extends State<ReferEarnScreen>
    with SingleTickerProviderStateMixin {
  final String referralCode = "TALENTO@124";
  late AnimationController _controller;
  late Animation<double> _animation;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _copyCode() {
    Clipboard.setData(ClipboardData(text: referralCode));
    Utils.showSnackBar(context, "Referral code copied!");
  }

  @override
  Widget build(BuildContext context) {
    return TimeTracker(
      screenName: AppConstants.referEarnScreen,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppConstants.kBackgroundStart,
                AppConstants.kBackgroundEnd,
              ],
            ),
          ),
          child: SafeArea(
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                _buildSliverAppBar(),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        _buildHeroSection(),
                        getVerticalSpacer(30),
                        _buildReferralCodeCard(),
                        getVerticalSpacer(30),
                        _buildRewardsSection(),
                        getVerticalSpacer(30),
                        _buildStepsSection(),
                        getVerticalSpacer(40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 80,
      pinned: true,
      backgroundColor: Colors.white.withValues(alpha: 0.8),
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: FlexibleSpaceBar(
            expandedTitleScale: 1.0,
            titlePadding: EdgeInsets.only(left: 60, bottom: 16),
            title: Text(
              "Refer & Earn",
              style: TextStyle(
                color: AppConstants.kTextColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      leading: ModernBackButton(
        backgroundColor: Colors.white,
        onPressed: () => moveToPreviousScreen(),
      ),
      elevation: 0,
    );
  }

  Widget _buildHeroSection() {
    return FadeTransition(
      opacity: _animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(_animation),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  colors: [
                    AppConstants.kPrimaryColor.withValues(alpha: 0.1),
                    AppConstants.kSecondaryColor.withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Image.asset(
              AppConstants.iconReferEarn,
              height: 180,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReferralCodeCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppConstants.kPrimaryColor.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              "Your Referral Code",
              style: TextStyle(
                color: AppConstants.kTextColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            getVerticalSpacer(20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: AppConstants.kPrimaryColor.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: AppConstants.kPrimaryColor.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    referralCode,
                    style: TextStyle(
                      color: AppConstants.kPrimaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  getHorizontalSpacer(16),
                  _buildIconButton(Icons.copy, _copyCode),
                  getHorizontalSpacer(10),
                  _buildIconButton(
                    Icons.share,
                    () => shareReferralCode(referralCode),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(50),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppConstants.kPrimaryColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppConstants.kPrimaryColor, size: 20),
        ),
      ),
    );
  }

  Widget _buildRewardsSection() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          colors: [
            AppConstants.kPrimaryColor.withValues(alpha: 0.1),
            AppConstants.kSecondaryColor.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: AppConstants.kPrimaryColor.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildRewardItem("₹150", "Friend Gets", AppConstants.kSecondaryColor),
          Container(
            height: 60,
            width: 1,
            color: AppConstants.kTextSecondary.withValues(alpha: 0.5),
          ),
          _buildRewardItem("₹125", "You Get", AppConstants.kPrimaryColor),
        ],
      ),
    );
  }

  Widget _buildRewardItem(String amount, String label, Color color) {
    return Column(
      children: [
        Text(
          amount,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        getVerticalSpacer(8),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: AppConstants.kTextSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStepsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "How it works",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppConstants.kTextColor,
          ),
        ),
        getVerticalSpacer(24),
        _buildStep(
          "1",
          Icons.person_add_alt_1_rounded,
          "Invite Friends",
          "Share your unique referral code",
          AppConstants.kPrimaryColor,
        ),
        _buildStepConnector(),
        _buildStep(
          "2",
          Icons.rocket_launch_rounded,
          "They Join Talento",
          "Friend signs up using your code",
          AppConstants.kSecondaryColor,
        ),
        _buildStepConnector(),
        _buildStep(
          "3",
          Icons.celebration_rounded,
          "Earn Rewards",
          "Both of you get instant rewards",
          AppConstants.kAccentColor,
        ),
      ],
    );
  }

  Widget _buildStep(
    String number,
    IconData icon,
    String title,
    String subtitle,
    Color color,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        border: Border.all(color: color.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(child: Icon(icon, color: color, size: 24)),
          ),
          getHorizontalSpacer(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.kTextColor,
                  ),
                ),
                getVerticalSpacer(4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppConstants.kTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(color: color),
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(color: color, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepConnector() {
    return Padding(
      padding: const EdgeInsets.only(left: 45),
      child: Container(
        width: 2,
        height: 24,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppConstants.kPrimaryColor.withValues(alpha: 0.3),
              AppConstants.kSecondaryColor.withValues(alpha: 0.3),
            ],
          ),
        ),
      ),
    );
  }
}

void shareReferralCode(String referralCode) {
  final message =
      "Join me on Talento! Use my referral code: $referralCode to sign up and get ₹150 in rewards! Download now: [App Link]";
  Share.share(message);
}
