import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talento_flutter/core/constants/constants.dart';
import 'package:talento_flutter/core/utils/time_tracker.dart';
import 'package:talento_flutter/core/utils/utils.dart';
import 'package:talento_flutter/presentation/routes/routes.dart';
import 'package:talento_flutter/presentation/widgets/helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  String _selectedFilter = "All";
  final List<String> _filters = [
    "All",
    "Remote",
    "Full Time",
    "Part Time",
    "Contract",
  ];
  final List<String> _experienceLevels = [
    "Entry Level",
    "Mid Level",
    "Senior Level",
    "Lead",
  ];
  final List<String> _salaryRanges = [
    "0-3 LPA",
    "3-6 LPA",
    "6-10 LPA",
    "10+ LPA",
  ];
  bool _showExperienceFilter = false;
  bool _showSalaryFilter = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TimeTracker(
      screenName: AppConstants.txtHome,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildWelcomeCard()),
                SliverToBoxAdapter(child: _buildFilterSection()),
                SliverToBoxAdapter(child: getVerticalSpacer(24)),
                _buildJobsList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      margin: EdgeInsets.all(16),
      height: 180,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppConstants.primaryColor,
                  AppConstants.primaryColor.withValues(alpha: 0.5),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppConstants.primaryColor.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
          ),
          Positioned(
            right: -30,
            bottom: -20,
            child: Image.asset(
              AppConstants.iconNewWay,
              width: 180,
              height: 180,
              opacity: AlwaysStoppedAnimation(0.7),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome Back!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                getVerticalSpacer(8),
                Text(
                  "Find Your Dream Job",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                getVerticalSpacer(8),
                Text(
                  "We've got something perfect\njust for you!",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilterSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Find Your Dream Job",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
              shadows: [
                Shadow(
                  offset: Offset(0, 2),
                  blurRadius: 4,
                  color: Colors.black.withValues(alpha: 0.2),
                ),
              ],
            ),
          ),
          getVerticalSpacer(8),
          Text(
            "Discover opportunities that match\nyour skills and aspirations",
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.4,
            ),
          ),
          getVerticalSpacer(16),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.trending_up, color: Colors.white, size: 16),
                getHorizontalSpacer(4),
                Text(
                  "1.2k+ New Jobs",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Job Type",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          getVerticalSpacer(12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  _filters
                      .map(
                        (filter) => Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: _buildFilterChip(
                            context,
                            filter,
                            icon: _getFilterIcon(filter),
                            isSelected: _selectedFilter == filter,
                            onTap:
                                () => setState(() => _selectedFilter = filter),
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),
          getVerticalSpacer(20),
          Row(
            children: [
              Expanded(
                child: _buildFilterExpander(
                  "Experience Level",
                  _showExperienceFilter,
                  () => setState(
                    () => _showExperienceFilter = !_showExperienceFilter,
                  ),
                ),
              ),
              getHorizontalSpacer(12),
              Expanded(
                child: _buildFilterExpander(
                  "Salary Range",
                  _showSalaryFilter,
                  () => setState(() => _showSalaryFilter = !_showSalaryFilter),
                ),
              ),
            ],
          ),
          if (_showExperienceFilter) ...[
            getVerticalSpacer(12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  _experienceLevels
                      .map(
                        (level) => _buildFilterChip(
                          context,
                          level,
                          icon: Icons.work_history_outlined,
                        ),
                      )
                      .toList(),
            ),
          ],
          if (_showSalaryFilter) ...[
            getVerticalSpacer(12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  _salaryRanges
                      .map(
                        (range) => _buildFilterChip(
                          context,
                          range,
                          icon: Icons.currency_rupee,
                        ),
                      )
                      .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterExpander(
    String title,
    bool isExpanded,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              size: 20,
              color: Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getFilterIcon(String filter) {
    switch (filter) {
      case "All":
        return Icons.dashboard_outlined;
      case "Remote":
        return Icons.computer;
      case "Full Time":
        return Icons.access_time;
      case "Part Time":
        return Icons.schedule;
      case "Contract":
        return Icons.description_outlined;
      default:
        return Icons.work_outline;
    }
  }

  Widget _buildJobsList() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return _buildJobCard(context, index);
        }, childCount: 10),
      ),
    );
  }

  Widget _buildJobCard(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () {
          Get.toNamed(AppRoutes.jobDetails, arguments: {'jobId': "1"});
        },
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildCompanyLogo(index),
                    getHorizontalSpacer(12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Senior Product Developer",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          getVerticalSpacer(4),
                          Text(
                            "Info Edge • Noida",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.bookmark_border),
                      onPressed: () {
                        Utils.showSnackBar(
                          context,
                          "This Job has been bookmarked",
                        );
                        // Handle bookmark button press
                      },
                      color: AppConstants.primaryColor,
                    ),
                  ],
                ),
                getVerticalSpacer(16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildTag("Full Time"),
                    _buildTag("₹7-9 LPA"),
                    _buildTag("2-3 Years"),
                    _buildTag("Remote"),
                  ],
                ),
                getVerticalSpacer(16),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                    getHorizontalSpacer(4),
                    Text(
                      "Posted 2 days ago",
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Apply Now",
                        style: TextStyle(
                          color: AppConstants.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompanyLogo(int index) {
    return Container(
      width: 50,
      height: 50,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Image.asset(
        (index % 2 == 0) ? AppConstants.iconLogo2 : AppConstants.iconLogo3,
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppConstants.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: AppConstants.primaryColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildSearchField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400]),
        prefixIcon: Icon(icon, color: AppConstants.primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[100],
      ),
    );
  }
}

Widget _buildFilterChip(
  BuildContext context,
  String label, {
  IconData? icon,
  bool isSelected = false,
  VoidCallback? onTap,
}) {
  return ActionChip(
    avatar: icon != null ? Icon(icon, size: 16) : null,
    label: Text(label),
    labelStyle: TextStyle(
      color: isSelected ? AppConstants.primaryColor : Colors.grey[700],
      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
    ),
    backgroundColor:
        isSelected
            ? AppConstants.primaryColor.withValues(alpha: 0.1)
            : Colors.grey[100],
    onPressed: onTap,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: BorderSide(
        color:
            isSelected
                ? AppConstants.primaryColor
                : Colors.black.withValues(alpha: 0.03),
      ),
    ),
  );
}
