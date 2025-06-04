import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:talento_flutter/core/constants/constants.dart';
import 'package:talento_flutter/core/utils/globals.dart' as widget;
import 'package:talento_flutter/core/utils/time_tracker.dart';
import 'package:talento_flutter/presentation/screens/features/dashboard.dart';
import 'package:talento_flutter/presentation/widgets/helper.dart';

class AppliedJobsScreen extends StatefulWidget {
  final GlobalKey<DashboardScreenState> dashboardKey;

  const AppliedJobsScreen({super.key, required this.dashboardKey});

  @override
  State<AppliedJobsScreen> createState() => _ApplyScreenState();
}

class _ApplyScreenState extends State<AppliedJobsScreen>
    with SingleTickerProviderStateMixin {
  final List<String> _filters = [
    'All',
    'Shortlisted',
    'In Progress',
    'Rejected',
  ];
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return TimeTracker(
      screenName: AppConstants.applyJobsScreen,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildFilters(),
              Expanded(child: _buildJobsList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Applied Jobs',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.primaryColor,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: AppConstants.primaryColor,
                    ),
                    getHorizontalSpacer(4),
                    Text(
                      'Last 30 Days',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppConstants.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          getVerticalSpacer(8),
          Text(
            'Track your job applications and their status',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = _selectedFilter == filter;
          return Padding(
            padding: EdgeInsets.only(right: 8),
            child: FilterChip(
              selected: isSelected,
              showCheckmark: false,
              backgroundColor:
                  isSelected ? _getBackgroundColor(filter) : Colors.grey[200],
              selectedColor: _getBackgroundColor(filter),
              label: Text(
                filter,
                style: TextStyle(
                  color:
                      isSelected
                          ? _getBorderColor(filter)
                          : Colors.black.withValues(alpha: 0.5),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color:
                      isSelected
                          ? _getBorderColor(filter)
                          : Colors.grey.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildJobsList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: 10,
      itemBuilder: (context, index) {
        String status = _getStatusForIndex(index);

        // Filter items based on selected filter
        if (_selectedFilter != 'All' && status != _selectedFilter) {
          return SizedBox.shrink();
        }

        return Hero(
          tag: 'job_card_$index',
          child: _buildJobCard(context, index, status),
        );
      },
    );
  }

  String _getStatusForIndex(int index) {
    // Distribute statuses evenly for demo purposes
    if (index < 4) {
      return 'Shortlisted';
    } else if (index < 7) {
      return 'In Progress';
    } else {
      return 'Rejected';
    }
  }
}

Color _getBackgroundColor(String filter) {
  switch (filter) {
    case "All":
    case "In Progress":
      return AppConstants.primaryColor.withValues(alpha: 0.1);
    case "Shortlisted":
      return Colors.green.withValues(alpha: 0.1);
    case "Rejected":
      return Colors.red.withValues(alpha: 0.1);
    default:
      return Colors.grey[100]!;
  }
}

Color _getBorderColor(String filter) {
  switch (filter) {
    case "All":
      return AppConstants.primaryColor;
    case "In Progress":
      return Colors.blue.withValues(alpha: 0.5);
    case "Shortlisted":
      return Colors.green.withValues(alpha: 0.5);
    case "Rejected":
      return Colors.red.withValues(alpha: 0.6);
    default:
      return Colors.black;
  }
}

Widget _buildJobCard(BuildContext context, int index, String status) {
  return Container(
    margin: EdgeInsets.only(bottom: 10),
    child: GestureDetector(
      onTap: () {
        widget.dashboardKey.currentState?.onTabTapped(2);
      },
      child: Card(
        elevation: 1,
        shadowColor: Colors.black.withValues(alpha: 0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _getStatusColors(status),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCompanyLogo(),
                  getHorizontalSpacer(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getJobTitle(status),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        getVerticalSpacer(4),
                        Text(
                          _getLocation(status),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        getVerticalSpacer(4),
                        Text(
                          "Info Edge",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppConstants.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              getVerticalSpacer(16),
              _buildRatingRow(),
              getVerticalSpacer(12),
              _buildLastActiveRow(),
              getVerticalSpacer(16),
              _buildStatusRow(context, status),
            ],
          ),
        ),
      ),
    ),
  );
}

List<Color> _getStatusColors(String status) {
  switch (status) {
    case 'Shortlisted':
      return [Colors.white, Color(0xFFF0FFF0)];
    case 'In Progress':
      return [Colors.white, Color(0xFFE3F2FD)];
    case 'Rejected':
      return [Colors.white, Color(0xFFF8E4E4)];
    default:
      return [Colors.white, Colors.white];
  }
}

String _getJobTitle(String status) {
  switch (status) {
    case 'Shortlisted':
      return "Senior Product Developer";
    case 'In Progress':
      return "Full Stack Developer";
    case 'Rejected':
      return "Senior Software Developer";
    default:
      return "Software Developer";
  }
}

String _getLocation(String status) {
  switch (status) {
    case 'Shortlisted':
      return "Noida";
    case 'In Progress':
      return "Bangalore";
    case 'Rejected':
      return "Mumbai";
    default:
      return "Delhi";
  }
}

Widget _buildCompanyLogo() {
  return Container(
    height: 50,
    width: 50,
    padding: EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.black, width: 0.2),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Image.asset(AppConstants.iconLogo2, fit: BoxFit.contain),
  );
}

Widget _buildRatingRow() {
  return Row(
    children: [
      Icon(Icons.star, color: Color(0xFFFFCD00), size: 20),
      getHorizontalSpacer(4),
      Text(
        "3.9",
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      getHorizontalSpacer(4),
      Text(
        "(1K Reviews)",
        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
      ),
    ],
  );
}

Widget _buildLastActiveRow() {
  return Row(
    children: [
      Icon(Icons.access_time, color: Colors.grey[600], size: 16),
      getHorizontalSpacer(4),
      Text(
        "Recruiter Last Active 2 days ago",
        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
      ),
    ],
  );
}

Widget _buildStatusRow(BuildContext context, String status) {
  Color bgColor;
  Color textColor;
  IconData statusIcon;
  String statusText;

  switch (status) {
    case 'Shortlisted':
      bgColor = Colors.green.withValues(alpha: 0.1);
      textColor = Colors.green;
      statusIcon = Icons.verified_outlined;
      statusText = "Resume Shortlisted • Applied Yesterday";
      break;
    case 'In Progress':
      bgColor = Colors.blue.withValues(alpha: 0.1);
      textColor = Colors.blue;
      statusIcon = Icons.hourglass_empty;
      statusText = "Application Under Review • Applied 3 days ago";
      break;
    case 'Rejected':
      bgColor = Colors.red.withValues(alpha: 0.1);
      textColor = Colors.red;
      statusIcon = Icons.cancel_outlined;
      statusText = "Not Shortlisted • Applied last week";
      break;
    default:
      bgColor = Colors.grey.withValues(alpha: 0.1);
      textColor = Colors.grey;
      statusIcon = Icons.info_outline;
      statusText = "Status Unknown";
  }

  return Row(
    children: [
      Expanded(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(statusIcon, size: 16, color: textColor),
              getHorizontalSpacer(4),
              Text(
                statusText,
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
      getHorizontalSpacer(12),
      _buildActionButton(
        icon: FontAwesomeIcons.copy,
        label: "Similar",
        onTap: () => widget.dashboardKey.currentState?.onTabTapped(2),
      ),
    ],
  );
}

Widget _buildActionButton({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppConstants.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppConstants.primaryColor),
          getHorizontalSpacer(4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppConstants.primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
  );
}
