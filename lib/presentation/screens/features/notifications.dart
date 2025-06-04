import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:talento_flutter/core/constants/constants.dart';
import 'package:talento_flutter/core/utils/time_tracker.dart';
import 'package:talento_flutter/presentation/widgets/helper.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final List<Map<String, dynamic>> notifications = [
    {
      'title': 'New Job Recommendation',
      'subtitle': 'A job matching your profile is available now!',
      'isRead': false,
      'time': "2:51 PM",
      'date': "May 8, 2025",
      'icon': Icons.work_outline,
      'color': Colors.blue,
    },
    {
      'title': 'Application Update',
      'subtitle': 'Your application for UI Designer has been viewed.',
      'isRead': false,
      'time': "1:30 PM",
      'date': "May 7, 2025",
      'icon': Icons.update,
      'color': Colors.green,
    },
    {
      'title': 'Reminder',
      'subtitle': 'Don not forget to complete your profile.',
      'isRead': false,
      'time': "11:15 AM",
      'date': "May 7, 2025",
      'icon': Icons.notifications_active_outlined,
      'color': Colors.orange,
    },
    {
      'title': 'Interview Scheduled',
      'subtitle': 'You have an interview with Tech Corp on May 3rd.',
      'isRead': false,
      'time': "4:00 PM",
      'date': "May 6, 2025",
      'icon': Icons.calendar_today_outlined,
      'color': Colors.purple,
    },
    {
      'title': 'New Message',
      'subtitle': 'Recruiter Anna has sent you a message.',
      'isRead': false,
      'time': "9:20 AM",
      'date': "May 6, 2025",
      'icon': Icons.message_outlined,
      'color': Colors.pink,
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

  void _markAsRead(int index) {
    setState(() {
      notifications[index]['isRead'] = true;
    });
  }

  Map<String, List<Map<String, dynamic>>> _groupNotificationsByDate() {
    final groupedNotifications = <String, List<Map<String, dynamic>>>{};

    for (var notification in notifications) {
      final date = notification['date'] as String;
      if (!groupedNotifications.containsKey(date)) {
        groupedNotifications[date] = [];
      }
      groupedNotifications[date]!.add(notification);
    }

    return groupedNotifications;
  }

  String _getRelativeDate(String date) {
    final now = DateTime.now();
    final notificationDate = DateFormat('MMM d, y').parse(date);
    final difference = now.difference(notificationDate).inDays;

    if (difference == 0) return 'Today';
    if (difference == 1) return 'Yesterday';
    if (difference < 7) return '$difference days ago';
    return date;
  }

  @override
  Widget build(BuildContext context) {
    final groupedNotifications = _groupNotificationsByDate();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return TimeTracker(
      screenName: AppConstants.notificationScreen,
      child: Scaffold(
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[50],
        appBar: AppBar(
          leading: ModernBackButton(onPressed: () => moveToPreviousScreen()),
          title: getTextView(context, "Notifications", 20, isBold: true),
          actions: [
            TextButton.icon(
              onPressed: () {
                setState(() {
                  for (var notification in notifications) {
                    notification['isRead'] = true;
                  }
                });
              },
              icon: const Icon(Icons.done_all, size: 20),
              label: getTextView(context, "Mark all as read", 14),
            ),
          ],
          elevation: 0,
          backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[50],
        ),
        body:
            notifications.isEmpty
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_off_outlined,
                        size: 64,
                        color: Colors.grey,
                      ),
                      getVerticalSpacer(16),
                      getTextView(
                        context,
                        "No notifications yet",
                        16,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                )
                : ListView.builder(
                  itemCount: groupedNotifications.length,
                  itemBuilder: (context, groupIndex) {
                    final date = groupedNotifications.keys.elementAt(
                      groupIndex,
                    );
                    final notificationsInGroup = groupedNotifications[date]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                          child: getTextView(
                            context,
                            _getRelativeDate(date),
                            14,
                            isBold: true,
                            color: Colors.grey[600],
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: notificationsInGroup.length,
                          itemBuilder: (context, index) {
                            final notification = notificationsInGroup[index];
                            final isRead = notification['isRead'];

                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(1, 0),
                                end: Offset.zero,
                              ).animate(
                                CurvedAnimation(
                                  parent: _animationController,
                                  curve: Interval(
                                    index * 0.1,
                                    1.0,
                                    curve: Curves.easeOut,
                                  ),
                                ),
                              ),
                              child: TweenAnimationBuilder<double>(
                                duration: const Duration(milliseconds: 300),
                                tween: Tween<double>(
                                  begin: 0,
                                  end: isRead ? 0.5 : 1,
                                ),
                                builder: (context, value, child) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          isDarkMode
                                              ? Colors.grey[800]
                                              : Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.05,
                                          ),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(12),
                                        onTap: () => _markAsRead(index),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(
                                                  12,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: notification['color']
                                                      .withOpacity(0.1),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  notification['icon'],
                                                  color: notification['color'],
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
                                                      notification['title'],
                                                      16,
                                                      isBold: !isRead,
                                                      color:
                                                          isDarkMode
                                                              ? Colors.white
                                                                  .withValues(
                                                                    alpha:
                                                                        value,
                                                                  )
                                                              : Colors.black
                                                                  .withValues(
                                                                    alpha:
                                                                        value,
                                                                  ),
                                                    ),
                                                    getVerticalSpacer(4),
                                                    getTextView(
                                                      context,
                                                      notification['subtitle'],
                                                      14,
                                                      color: Colors.grey[600],
                                                    ),
                                                    getVerticalSpacer(8),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.access_time,
                                                          size: 14,
                                                          color:
                                                              Colors.grey[600],
                                                        ),
                                                        getHorizontalSpacer(4),
                                                        getTextView(
                                                          context,
                                                          notification['time'],
                                                          12,
                                                          color:
                                                              Colors.grey[600],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              if (!isRead)
                                                Container(
                                                  width: 8,
                                                  height: 8,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        notification['color'],
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
      ),
    );
  }
}
