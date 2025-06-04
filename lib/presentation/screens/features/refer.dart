import 'package:flutter/material.dart';
import 'package:talento_flutter/core/constants/constants.dart';
import 'package:talento_flutter/core/utils/time_tracker.dart';
import 'package:talento_flutter/presentation/routes/routes.dart';
import 'package:talento_flutter/presentation/widgets/helper.dart';

class ReferAndEarnScreen extends StatefulWidget {
  const ReferAndEarnScreen({super.key});

  @override
  State<ReferAndEarnScreen> createState() => _ReferAndEarnScreenState();
}

class _ReferAndEarnScreenState extends State<ReferAndEarnScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TimeTracker(
      screenName: AppConstants.referAndEarnScreen,
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
            child: Column(
              children: [
                _buildHeader(),
                getVerticalSpacer(10),
                _buildTabBar(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildActiveTab(),
                      _buildPendingTab(),
                      _buildRejectedTab(),
                      _buildHiredTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppConstants.kPrimaryColor.withValues(alpha: 0.8),
            AppConstants.kSecondaryColor.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              getHorizontalSpacer(1),
              Text(
                "Refer & Earn",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              _buildReferButton(),
            ],
          ),
          getVerticalSpacer(20),
          FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem("₹2000", "Reward Wallet"),
                    _buildVerticalDivider(),
                    _buildStatItem("₹1000", "Pending"),
                    _buildVerticalDivider(),
                    _buildStatItem("₹1500", "Earned"),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReferButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => moveToNextPage(AppRoutes.referEarn),
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.share, color: Colors.white, size: 15),
              getHorizontalSpacer(5),
              Text(
                "Share & Earn",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        getVerticalSpacer(4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.white.withValues(alpha: 0.2),
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 45,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppConstants.kPrimaryColor.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppConstants.kPrimaryColor, AppConstants.kSecondaryColor],
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppConstants.kTextSecondary,
        labelStyle: TextStyle(fontWeight: FontWeight.w600),
        labelPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        indicatorPadding: EdgeInsets.symmetric(horizontal: -25, vertical: 0),
        tabs: [
          Tab(text: "Active"),
          Tab(text: "Pending"),
          Tab(text: "Rejected"),
          Tab(text: "Hired"),
        ],
      ),
    );
  }

  Widget _buildActiveTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          _buildReferralCard(
            name: "David J. Allen",
            code: "TU02918",
            status: "Shortlisted",
            statusColor: AppConstants.kPrimaryColor,
          ),
          getVerticalSpacer(16),
          _buildReferralCard(
            name: "Sarah Wilson",
            code: "TU02920",
            status: "In Review",
            statusColor: AppConstants.kAccentColor,
          ),
          getVerticalSpacer(16),
          _buildReferralCard(
            name: "David J. Allen",
            code: "TU02918",
            status: "Shortlisted",
            statusColor: AppConstants.kPrimaryColor,
          ),
          getVerticalSpacer(16),
          _buildReferralCard(
            name: "Sarah Wilson",
            code: "TU02920",
            status: "In Review",
            statusColor: AppConstants.kAccentColor,
          ),
        ],
      ),
    );
  }

  Widget _buildReferralCard({
    required String name,
    required String code,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppConstants.kPrimaryColor.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          statusColor.withValues(alpha: 0.2),
                          statusColor.withValues(alpha: 0.1),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        name[0],
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  getHorizontalSpacer(16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppConstants.kTextColor,
                          ),
                        ),
                        getVerticalSpacer(4),
                        Text(
                          code,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppConstants.kTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
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

  Widget _buildPendingTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.hourglass_empty,
            size: 64,
            color: AppConstants.kTextSecondary.withValues(alpha: 0.5),
          ),
          getVerticalSpacer(16),
          Text(
            "No pending referrals",
            style: TextStyle(color: AppConstants.kTextSecondary, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildRejectedTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cancel_outlined,
            size: 64,
            color: AppConstants.kTextSecondary.withValues(alpha: 0.5),
          ),
          getVerticalSpacer(16),
          Text(
            "No rejected referrals",
            style: TextStyle(color: AppConstants.kTextSecondary, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildHiredTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          _buildReferralCard(
            name: "Michael Brown",
            code: "TU02915",
            status: "Hired",
            statusColor: Colors.green,
          ),
          getVerticalSpacer(16),
          _buildReferralCard(
            name: "David J. Allen",
            code: "TU02918",
            status: "Shortlisted",
            statusColor: AppConstants.kPrimaryColor,
          ),
          getVerticalSpacer(16),
          _buildReferralCard(
            name: "Sarah Wilson",
            code: "TU02920",
            status: "In Review",
            statusColor: AppConstants.kAccentColor,
          ),
        ],
      ),
    );
  }
}

class ActiveReferralScreen extends StatefulWidget {
  const ActiveReferralScreen({super.key});

  @override
  State<ActiveReferralScreen> createState() => _ActiveReferralScreenState();
}

class _ActiveReferralScreenState extends State<ActiveReferralScreen> {
  bool isReadMore = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: 1,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        returnRow(context, "Reward Wallet"),
                        getTextView(context, "\u20B9 2000", 16, isBold: true),
                        const Divider(thickness: 0.3, color: Colors.grey),
                        returnRow(context, "Pending Reward"),
                        getTextView(context, "\u20B9 1000", 16, isBold: true),
                        const Divider(thickness: 0.3, color: Colors.grey),
                        returnRow(context, "Transactions"),
                        getTextView(context, "\u20B9 1500", 16, isBold: true),
                      ],
                    ),
                  ),
                ),
              ),
              getVerticalSpacer(10),
              SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: 1.5,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              getTextView(
                                context,
                                "User Name",
                                12,
                                isBold: true,
                              ),
                              getTextView(
                                context,
                                "Job Post",
                                12,
                                isBold: true,
                              ),
                              getTextView(
                                context,
                                "Applied Date",
                                12,
                                isBold: true,
                              ),
                              getTextView(context, "Status", 12, isBold: true),
                            ],
                          ),
                        ),
                        const Divider(thickness: 1),
                        ...List.generate(
                          isReadMore ? 10 : 5,
                          (index) => Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 8,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    getTextView(
                                      context,
                                      "User ${index + 1}",
                                      12,
                                    ),
                                    getTextView(context, "Developer", 12),
                                    getTextView(context, "24 March 2025", 12),
                                    getTextView(
                                      context,
                                      index % 2 == 0
                                          ? "Pending"
                                          : "Shortlisted",
                                      12,
                                      color: Colors.blue,
                                    ),
                                  ],
                                ),
                                const Divider(
                                  thickness: 0.4,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              isReadMore = !isReadMore;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              isReadMore ? "Read Less" : "Read More",
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget returnRow(BuildContext context, String heading) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      getHorizontalSpacer(15),
      getTextView(context, heading, 14, color: Colors.blueAccent),
      getHorizontalSpacer(5),
      Icon(Icons.arrow_forward_ios, color: Colors.blueAccent, size: 15),
    ],
  );
}

class HiredReferralScreen extends StatefulWidget {
  const HiredReferralScreen({super.key});

  @override
  State<HiredReferralScreen> createState() => _HiredReferralScreenState();
}

class _HiredReferralScreenState extends State<HiredReferralScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: 1,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        returnRow(context, "Reward Wallet"),
                        getTextView(context, "\u20B9 2000", 16, isBold: true),
                        const Divider(thickness: 0.3, color: Colors.grey),
                        returnRow(context, "Pending Reward"),
                        getTextView(context, "\u20B9 1000", 16, isBold: true),
                        const Divider(thickness: 0.3, color: Colors.grey),
                        returnRow(context, "Transactions"),
                        getTextView(context, "\u20B9 1500", 16, isBold: true),
                      ],
                    ),
                  ),
                ),
              ),
              getVerticalSpacer(10),
              returnCard(context, "David J. Allen", "TU02918"),
              getVerticalSpacer(10),
              returnCard(context, "David J. Allen", "TU02918"),
              getVerticalSpacer(10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  2,
                  (index) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: listItem(context, index),
                  ),
                ),
              ),
              getVerticalSpacer(10),
            ],
          ),
        ),
      ),
    );
  }

  Widget returnRow(BuildContext context, String heading) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        getHorizontalSpacer(15),
        getTextView(context, heading, 14, color: Colors.blueAccent),
        getHorizontalSpacer(5),
        Icon(Icons.arrow_forward_ios, color: Colors.blueAccent, size: 15),
      ],
    );
  }
}

Widget returnCard(BuildContext context, String header, String code) {
  return Card(
    elevation: 1,
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(child: Image.asset(AppConstants.iconNewWay, scale: 4)),
          getHorizontalSpacer(10),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getTextView(context, header, 16, isBold: true),
              getTextView(context, code, 12),
            ],
          ),
          Spacer(),
          getTextView(context, "Status", 12, color: Colors.blueAccent),
          Spacer(),
          Row(
            children: [
              getTextView(
                context,
                "ShortListed",
                14,
                color: Colors.blueAccent,
                isBold: true,
              ),
              getHorizontalSpacer(5),
              Icon(Icons.arrow_forward_ios, color: Colors.blueAccent, size: 15),
            ],
          ),
        ],
      ),
    ),
  );
}

class PendingReferralScreen extends StatefulWidget {
  const PendingReferralScreen({super.key});

  @override
  State<PendingReferralScreen> createState() => _PendingReferralScreenState();
}

class _PendingReferralScreenState extends State<PendingReferralScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [getTextView(context, "Coming Soon", 16)],
          ),
        ),
      ),
    );
  }
}

class RejectedReferralScreen extends StatefulWidget {
  const RejectedReferralScreen({super.key});

  @override
  State<RejectedReferralScreen> createState() => _RejectedReferralScreenState();
}

class _RejectedReferralScreenState extends State<RejectedReferralScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

Widget listItem(BuildContext context, int index) {
  return Card(
    elevation: 1,
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage(AppConstants.iconNewWay),
              ),
              getHorizontalSpacer(12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Referral ${index + 1}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  getVerticalSpacer(4),
                  Text(
                    "Software Developer",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "₹${(index + 1) * 100}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.kPrimaryColor,
                ),
              ),
              getVerticalSpacer(4),
              Text(
                index % 2 == 0 ? "Pending" : "Completed",
                style: TextStyle(
                  fontSize: 14,
                  color: index % 2 == 0 ? Colors.orange : Colors.green,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
