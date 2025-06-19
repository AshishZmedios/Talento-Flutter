import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talento_flutter/core/constants/constants.dart';
import 'package:talento_flutter/core/utils/time_tracker.dart';
import 'package:talento_flutter/core/utils/utils.dart';
import 'package:talento_flutter/domain/repositories/job_repository.dart';
import 'package:talento_flutter/presentation/routes/routes.dart';
import 'package:talento_flutter/presentation/screens/features/dashboard.dart';
import 'package:talento_flutter/presentation/screens/features/notifications.dart';
import 'package:talento_flutter/presentation/widgets/helper.dart';

class JobsScreen extends StatefulWidget {
  final GlobalKey<DashboardScreenState> dashboardKey;

  const JobsScreen({super.key, required this.dashboardKey});

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = "All";
  final repo = Get.find<JobRepository>();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late AnimationController _fabAnimationController;
  late Animation<Offset> _fabSlideAnimation;
  late Animation<double> _fabScaleAnimation;
  late Animation<double> _fabOpacityAnimation;
  final ScrollController _scrollController = ScrollController();
  bool _isCollapsed = false;
  bool _isFabVisible = true;
  double _lastScrollPosition = 0;
  late AnimationController _introAnimationController;
  late Animation<double> _introScaleAnimation;
  late Animation<double> _introOpacityAnimation;
  bool _hasShownIntro = false;
  bool _isRefreshing = false;
  late AnimationController _refreshAnimationController;
  late Animation<double> _refreshAnimation;

  final List<String> _filters = [
    "All",
    "Remote",
    "Full Time",
    "Part Time",
    "Hybrid",
    "Contract",
  ];

  @override
  void initState() {
    super.initState();
    fetchJobs();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _refreshAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _refreshAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _refreshAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // Initialize FAB animation controller
    _fabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Slide animation from bottom with bounce
    _fabSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _fabAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    // Scale animation for bounce effect
    _fabScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fabAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    // Opacity animation
    _fabOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fabAnimationController,
        curve: Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _animationController.forward();

    // Delay FAB animation
    Future.delayed(Duration(milliseconds: 500), () {
      _fabAnimationController.forward();
    });

    _scrollController.addListener(_onScroll);

    _introAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _introScaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _introAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    _introOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _introAnimationController, curve: Curves.easeOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowIntroDialog();
    });
  }

  Future<void> _checkAndShowIntroDialog() async {
    final prefs = await SharedPreferences.getInstance();
    final hasShown = prefs.getBool(AppConstants.hasShownAiIntro) ?? false;

    if (!hasShown && mounted) {
      setState(() => _hasShownIntro = true);
      _introAnimationController.forward();

      await Future.delayed(Duration(seconds: 5));

      if (mounted) {
        _introAnimationController.reverse().then((_) {
          setState(() => _hasShownIntro = false);
        });
        prefs.setBool(AppConstants.hasShownAiIntro, true);
      }
    }
  }

  void _onScroll() {
    final currentScroll = _scrollController.offset;
    if (currentScroll > 100 && !_isCollapsed) {
      setState(() => _isCollapsed = true);
    } else if (currentScroll <= 100 && _isCollapsed) {
      setState(() => _isCollapsed = false);
    }

    // Handle FAB visibility
    if (currentScroll > _lastScrollPosition &&
        _isFabVisible &&
        currentScroll > 100) {
      // Scrolling down and FAB is visible - hide it
      setState(() => _isFabVisible = false);
      _fabAnimationController.reverse();
    } else if (currentScroll < _lastScrollPosition && !_isFabVisible) {
      // Scrolling up and FAB is hidden - show it
      setState(() => _isFabVisible = true);
      _fabAnimationController.forward();
    }
    _lastScrollPosition = currentScroll;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    _fabAnimationController.dispose();
    _scrollController.dispose();
    _introAnimationController.dispose();
    _refreshAnimationController.dispose();
    super.dispose();
  }

  Widget _buildRefreshIndicator() {
    return SizedBox(
      height: 120,
      child: Center(
        child: AnimatedBuilder(
          animation: _refreshAnimation,
          builder: (context, child) {
            final opacity = _refreshAnimation.value.clamp(0.0, 1.0);
            return Opacity(
              opacity: opacity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  JobSearchLoadingIndicator(
                    primaryColor: AppConstants.primaryColor,
                    accentColor: Color(0xFF6C63FF),
                    size: 80,
                  ),
                  getVerticalSpacer(12),
                  Text(
                    "Finding the best jobs for you...",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    if (_isRefreshing) return;

    setState(() => _isRefreshing = true);
    _refreshAnimationController.reset();
    _refreshAnimationController.forward();

    try {
      fetchJobs();
      await Future.delayed(Duration(milliseconds: 2000));
    } finally {
      if (mounted) {
        await _refreshAnimationController.reverse();
        setState(() => _isRefreshing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double expandedHeight = 340.0;
    final double collapsedHeight = 60;

    return TimeTracker(
      screenName: AppConstants.jobsScreen,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Stack(
          children: [
            RefreshIndicator(
              onRefresh: _handleRefresh,
              color: AppConstants.primaryColor,
              backgroundColor: Colors.white,
              displacement: 20,
              strokeWidth: 3,
              triggerMode: RefreshIndicatorTriggerMode.onEdge,
              child: SafeArea(
                child: CustomScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  controller: _scrollController,
                  slivers: [
                    SliverAppBar(
                      floating: false,
                      pinned: true,
                      expandedHeight: expandedHeight,
                      toolbarHeight: kToolbarHeight,
                      collapsedHeight: collapsedHeight,
                      elevation: _isCollapsed ? 0 : 0,
                      backgroundColor:
                          _isCollapsed ? Colors.white : Colors.transparent,
                      leading: IconButton(
                        icon: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppConstants.primaryColor.withValues(
                              alpha: 0.2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.menu_rounded,
                            color: AppConstants.primaryColor,
                            size: 20,
                          ),
                        ),
                        onPressed: () {
                          widget
                              .dashboardKey
                              .currentState
                              ?.scaffoldKey
                              .currentState
                              ?.openDrawer();
                        },
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Talento",
                            style: TextStyle(
                              fontSize: _isCollapsed ? 20 : 28,
                              fontWeight: FontWeight.bold,
                              color: AppConstants.primaryColor,
                              letterSpacing: 1,
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            icon: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppConstants.primaryColor.withValues(
                                  alpha: 0.2,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                FontAwesomeIcons.bell,
                                color: AppConstants.primaryColor,
                                size: 20,
                              ),
                            ),
                            onPressed: () => Get.to(() => NotificationScreen()),
                          ),
                        ],
                      ),
                      flexibleSpace: LayoutBuilder(
                        builder: (
                          BuildContext context,
                          BoxConstraints constraints,
                        ) {
                          final double currentHeight = constraints.maxHeight;
                          final double welcomeOpacity =
                              _isCollapsed
                                  ? 0.0
                                  : ((currentHeight - collapsedHeight) /
                                          (expandedHeight - collapsedHeight))
                                      .clamp(0.0, 1.0);

                          return FlexibleSpaceBar(
                            background: Stack(
                              children: [
                                // Welcome Section
                                Positioned(
                                  top: kToolbarHeight + 16,
                                  left: 0,
                                  right: 0,
                                  child: Opacity(
                                    opacity: welcomeOpacity,
                                    child: _buildWelcomeSection(),
                                  ),
                                ),
                                // Search Box
                                if (!_isCollapsed)
                                  Positioned(
                                    bottom: 8,
                                    left: 16,
                                    right: 16,
                                    child: Opacity(
                                      opacity: welcomeOpacity,
                                      child: _buildSearchBox(),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                      bottom:
                          _isCollapsed
                              ? PreferredSize(
                                preferredSize: Size.fromHeight(61),
                                child: Column(
                                  children: [
                                    Container(
                                      color: Colors.white,
                                      padding: EdgeInsets.all(8),
                                      child: _buildSearchBox(),
                                    ),
                                    Container(
                                      height: 1,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.transparent,
                                            Colors.grey.withValues(alpha: 0.1),
                                            Colors.grey.withValues(alpha: 0.1),
                                            Colors.transparent,
                                          ],
                                          stops: [0.0, 0.2, 0.8, 1.0],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              : null,
                    ),
                    if (_isRefreshing)
                      SliverToBoxAdapter(child: _buildRefreshIndicator()),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: _buildFilterChips(),
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      sliver: _buildJobsList(),
                    ),
                  ],
                ),
              ),
            ),
            if (_hasShownIntro) _buildIntroDialog(),
          ],
        ),
        floatingActionButton: SlideTransition(
          position: _fabSlideAnimation,
          child: ScaleTransition(
            scale: _fabScaleAnimation,
            child: FadeTransition(
              opacity: _fabOpacityAnimation,
              child: FloatingActionButton(
                onPressed: () {
                  // Add bounce effect on tap
                  _fabAnimationController.reset();
                  _fabAnimationController.forward();
                  moveToNextPage(AppRoutes.aiHelp);
                },
                elevation: _isFabVisible ? 4 : 0,
                backgroundColor: AppConstants.primaryColor,
                child: Icon(Icons.assistant, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(24),
      height: 180,
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
            color: AppConstants.primaryColor.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
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
          ),
          Image.asset(AppConstants.iconNewWay, height: 100, width: 100),
        ],
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border:
            _isCollapsed
                ? Border.all(color: Colors.grey[200]!, width: 1.5)
                : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.grey),
          getHorizontalSpacer(12),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search jobs, companies...",
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey[400]),
              ),
            ),
          ),
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: Icon(Icons.close, color: Colors.grey),
              onPressed: () {
                _searchController.clear();
                FocusScope.of(context).unfocus();
              },
            ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:
            _filters.map((filter) {
              final isSelected = _selectedFilter == filter;
              return Padding(
                padding: EdgeInsets.only(right: 8),
                child: FilterChip(
                  selected: isSelected,
                  label: Text(filter),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[700],
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  backgroundColor: Colors.grey[100],
                  selectedColor: AppConstants.primaryColor.withValues(
                    alpha: 0.5,
                  ),
                  onSelected: (selected) {
                    setState(() => _selectedFilter = filter);
                  },
                  shape: StadiumBorder(),
                  elevation: isSelected ? 2 : 0,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildJobsList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => FadeTransition(
          opacity: _fadeAnimation,
          child: _buildJobCard(context, index),
        ),
        childCount: 10,
      ),
    );
  }

  Widget _buildJobCard(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap:
            () => Get.toNamed(AppRoutes.jobDetails, arguments: {'jobId': "1"}),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: EdgeInsets.all(16),
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
                            (index % 3 == 0)
                                ? "Senior Software Developer"
                                : (index % 3 == 1)
                                ? "Software Engineer"
                                : "UI/UX Designer",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          getVerticalSpacer(4),
                          Text(
                            (index % 3 == 0)
                                ? "TCS • Noida"
                                : (index % 3 == 1)
                                ? "Infosys • Bangalore"
                                : " Wipro • Pune",
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
                      onPressed:
                          () => Utils.showSnackBar(
                            context,
                            "Job saved successfully",
                          ),
                      color: AppConstants.primaryColor,
                    ),
                  ],
                ),
                getVerticalSpacer(16),
                Row(
                  children: [
                    _buildTag("Full Time"),
                    getHorizontalSpacer(8),
                    _buildTag("Remote"),
                  ],
                ),
                getVerticalSpacer(16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "₹12L - ₹18L",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.primaryColor,
                      ),
                    ),
                    Text(
                      "2 days ago",
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppConstants.primaryColor.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          (index % 3 == 0)
              ? AppConstants.iconLogo1
              : (index % 3 == 1)
              ? AppConstants.iconLogo2
              : AppConstants.iconLogo3,
          fit: BoxFit.contain,
        ),
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

  Widget _buildIntroDialog() {
    return Positioned(
      bottom: 100,
      right: 20,
      child: ScaleTransition(
        scale: _introScaleAnimation,
        child: FadeTransition(
          opacity: _introOpacityAnimation,
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppConstants.primaryColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppConstants.primaryColor.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Need help finding jobs?",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                getVerticalSpacer(8),
                Text(
                  "Try our AI assistant to get\npersonalized job recommendations",
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
                getVerticalSpacer(12),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.arrow_downward_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    getHorizontalSpacer(4),
                    Text(
                      "Try it now!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
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
}

void fetchJobs() async {
  // final repo = Get.find<JobRepository>();
  // final jobs = await repo.fetchJobs();
  // printInDebugMode(jobs.toString());
}
