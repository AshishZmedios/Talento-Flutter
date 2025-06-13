import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:talento_flutter/core/constants/constants.dart';
import 'package:talento_flutter/core/utils/time_tracker.dart';
import 'package:talento_flutter/core/utils/utils.dart';
import 'package:talento_flutter/domain/repositories/job_repository.dart';
import 'package:talento_flutter/presentation/routes/routes.dart';
import 'package:talento_flutter/presentation/widgets/helper.dart';

class JobDetailsScreen extends StatefulWidget {
  final String jobId;

  JobDetailsScreen({super.key}) : jobId = Get.arguments['jobId'];

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  bool isReadMore = false;
  final repo = Get.find<JobRepository>();

  @override
  void initState() {
    super.initState();
    getJobDetailsData();
  }

  @override
  Widget build(BuildContext context) {
    return TimeTracker(
      screenName: AppConstants.jobDetailScreen,
      child: Scaffold(
        backgroundColor: Color(0xFFF8F9FD),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF7CB9E8).withValues(alpha: 0.6),
                        Color(0xFF4A90E2).withValues(alpha: 0.5),
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Hero(
                          tag: 'company_logo',
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                AppConstants.iconLogo1,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              leading: ModernBackButton(
                backgroundColor: Colors.white,
                onPressed: () => moveToPreviousScreen(),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.share_outlined, color: Colors.black),
                  onPressed: () => referJob(),
                ),
                IconButton(
                  icon: Icon(Icons.bookmark_border, color: Colors.black),
                  onPressed: () {},
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Transform.translate(
                offset: Offset(0, -30),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF8F9FD),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getVerticalSpacer(20),
                            Text(
                              "Junior Graphic Designer",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            getVerticalSpacer(8),
                            Text(
                              "TCS Education System",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            getVerticalSpacer(16),
                            Row(
                              children: [
                                _buildInfoChip(
                                  Icons.location_on_outlined,
                                  "Noida / Delhi",
                                ),
                                getHorizontalSpacer(12),
                                _buildInfoChip(Icons.work_outline, "Full Time"),
                              ],
                            ),
                            getVerticalSpacer(20),
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFDAE9EF),
                                    Color(0xFFECE1F6),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _buildStatItem("2", "Days ago"),
                                  _buildDivider(),
                                  _buildStatItem("322", "Applicants"),
                                  _buildDivider(),
                                  _buildStatItem("80%", "Match"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _buildDetailCard(
                                    icon: Icons.currency_rupee,
                                    title: "Salary",
                                    value: "₹10K-15K",
                                    gradientColors: [
                                      Color(0xFFFFB347),
                                      Color(0xFFFF8C00),
                                    ],
                                  ),
                                ),
                                getHorizontalSpacer(16),
                                Expanded(
                                  child: _buildDetailCard(
                                    icon: Icons.access_time,
                                    title: "Working Hours",
                                    value: "9 AM - 6 PM",
                                    gradientColors: [
                                      Color(0xFF98FB98),
                                      Color(0xFF32CD32),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            getVerticalSpacer(16),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildDetailCard(
                                    icon: Icons.work,
                                    title: "Experience",
                                    value: "2-5 Years",
                                    gradientColors: [
                                      Color(0xFF87CEEB),
                                      Color(0xFF1E90FF),
                                    ],
                                  ),
                                ),
                                getHorizontalSpacer(16),
                                Expanded(
                                  child: _buildDetailCard(
                                    icon: Icons.star,
                                    title: "Skills",
                                    value: "Expert",
                                    gradientColors: [
                                      Color(0xFFDDA0DD),
                                      Color(0xFF9370DB),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      getVerticalSpacer(24),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Job Description",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            getVerticalSpacer(16),
                            AnimatedCrossFade(
                              firstChild: _buildDescriptionText(false),
                              secondChild: _buildDescriptionText(true),
                              crossFadeState:
                                  isReadMore
                                      ? CrossFadeState.showSecond
                                      : CrossFadeState.showFirst,
                              duration: Duration(milliseconds: 600),
                            ),
                            getVerticalSpacer(16),
                            Center(
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    isReadMore = !isReadMore;
                                  });
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      isReadMore ? "Read Less" : "Read More",
                                      style: TextStyle(
                                        color: Color(0xFF4A90E2),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Icon(
                                      isReadMore
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                      color: Color(0xFF4A90E2),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      getVerticalSpacer(24),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: ElevatedButton(
                          onPressed: () {
                            Utils.showSnackBar(
                              context,
                              "You have applied to this job successfully.",
                            );
                            moveToNextPage(AppRoutes.dashboard);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF4A90E2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Center(
                            child: Text(
                              "Apply Now",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      getVerticalSpacer(32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Color(0xFF4A90E2)),
          getHorizontalSpacer(6),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        getVerticalSpacer(4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(height: 24, width: 0.5, color: Colors.black);
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required String value,
    required List<Color> gradientColors,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradientColors[0].withValues(alpha: 0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: gradientColors[1]),
          ),
          getVerticalSpacer(12),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          getVerticalSpacer(4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionText(bool isExpanded) {
    return Text(
      isExpanded
          ? "Job Description - Designer\n"
              "Company - TCS Education System (Tcs edu system Edu)\n"
              "Position - Junior Graphic Designer\n"
              "Location - Noida/Delhi\n"
              "Employment Type - Full Time\n"
              "Experience - 2-5 Years\n"
              "Tools - Photoshop, Illustrator\n"
              "Responsibilities - Create graphics, collaborate with team, manage branding assets, etc."
          : "Job Description - Designer\n"
              "Company - TCS Education System (Tcs edu system Edu)\n"
              "Position - Junior Graphic Designer\n"
              "Location - Noida/Delhi\n"
              "Employment Type - Full Time",
      style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.6),
    );
  }

  void getJobDetailsData() {
    final jobDetails = repo.getJobDetails(widget.jobId);
    printInDebugMode(jobDetails.toString());
  }
}

void referJob() {
  Share.shareUri(Uri.parse('https://www.google.com'));
}
