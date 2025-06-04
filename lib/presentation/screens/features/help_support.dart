import 'package:flutter/material.dart';
import 'package:talento_flutter/core/constants/constants.dart';
import 'package:talento_flutter/core/utils/time_tracker.dart';
import 'package:talento_flutter/core/utils/utils.dart';
import 'package:talento_flutter/presentation/widgets/helper.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  int? _expandedIndex;
  final List<Map<String, dynamic>> faqItems = [
    {
      'question': 'How do I create an account?',
      'answer':
          'To create an account, click on the "Sign Up" button on the login screen and follow the registration process. You\'ll need to provide your email or phone number.',
      'icon': Icons.person_add_outlined,
      'color': Color(0xFF7CB9E8),
    },
    {
      'question': 'How can I search for jobs?',
      'answer':
          'You can search for jobs using the search bar on the Jobs tab. Filter results by location, job type, and experience level to find the perfect match.',
      'icon': Icons.work_outline,
      'color': Color(0xFF98FB98),
    },
    {
      'question': 'How do I update my profile?',
      'answer':
          'Go to the Profile tab and tap the edit button. You can update your personal information, work experience, education, and skills.',
      'icon': Icons.edit_outlined,
      'color': Color(0xFFFFB347),
    },
    {
      'question': 'How do I apply for a job?',
      'answer':
          'Click on a job listing to view details, then tap the "Apply Now" button. Follow the application process and submit your resume.',
      'icon': Icons.send_outlined,
      'color': Color(0xFFDDA0DD),
    },
  ];

  final List<Map<String, dynamic>> contactOptions = [
    {
      'title': 'Email Support',
      'subtitle': 'help@talento.com',
      'icon': Icons.email_outlined,
      'color': Color(0xFF87CEEB),
      'bgColor': Color(0xFFE6F3F8),
      'action': 'mailto:help@talento.com',
    },
    {
      'title': 'Phone Support',
      'subtitle': '+91 (120) 567-8900',
      'icon': Icons.phone_outlined,
      'color': Color(0xFF90EE90),
      'bgColor': Color(0xFFE8F6E8),
      'action': 'tel:+911205678900',
    },
    {
      'title': 'WhatsApp Support',
      'subtitle': 'Chat with us on WhatsApp',
      'icon': Icons.whatshot,
      'color': Color(0xFF98FB98),
      'bgColor': Color(0xFFE8F8E8),
      'action': 'https://wa.me/911205678900',
    },
    {
      'title': 'Live Chat',
      'subtitle': 'Chat with our support team',
      'icon': Icons.chat_bubble_outline,
      'color': Color(0xFFFFB347),
      'bgColor': Color(0xFFFFF0E1),
      'action': 'chat',
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

  Future<void> _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      if (mounted) {
        Utils.showSnackBar(context, 'Could not launch $url');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return TimeTracker(
      screenName: AppConstants.helpScreen,
      child: Scaffold(
        backgroundColor: isDarkMode ? Colors.grey[900] : Color(0xFFF8F9FD),
        appBar: AppBar(
          leading: ModernBackButton(onPressed: () => moveToPreviousScreen()),
          title: getTextView(context, "Help & Support", 20, isBold: true),
          elevation: 0,
          backgroundColor: isDarkMode ? Colors.grey[900] : Color(0xFFF8F9FD),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.2),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: _animationController,
                  curve: const Interval(0, 0.5, curve: Curves.easeOut),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: getTextView(
                      context,
                      "Contact Us",
                      16,
                      isBold: true,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.5,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    itemCount: contactOptions.length,
                    itemBuilder: (context, index) {
                      final option = contactOptions[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: isDarkMode ? Colors.grey[800] : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              if (option['action'] != 'chat') {
                                _launchUrl(option['action']);
                              } else {
                                Utils.showSnackBar(
                                  context,
                                  'Live chat coming soon!',
                                );
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: option['bgColor'],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      option['icon'],
                                      color: option['color'],
                                      size: 28,
                                    ),
                                  ),
                                  getVerticalSpacer(8),
                                  getTextView(
                                    context,
                                    option['title'],
                                    12,
                                    isBold: true,
                                  ),
                                  getVerticalSpacer(4),
                                  getTextView(
                                    context,
                                    option['subtitle'],
                                    10,
                                    color: Color(0xFF6B7280),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            getVerticalSpacer(24),
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.2),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: _animationController,
                  curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: getTextView(
                      context,
                      "Frequently Asked Questions",
                      16,
                      isBold: true,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey[800] : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: faqItems.length,
                      itemBuilder: (context, index) {
                        final isExpanded = _expandedIndex == index;
                        final item = faqItems[index];
                        return Column(
                          children: [
                            if (index != 0)
                              Divider(
                                height: 1,
                                color: Colors.grey.withValues(alpha: 0.2),
                              ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _expandedIndex = isExpanded ? null : index;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: item['color'].withOpacity(
                                                0.1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Icon(
                                              item['icon'],
                                              color: item['color'],
                                              size: 20,
                                            ),
                                          ),
                                          getHorizontalSpacer(12),
                                          Expanded(
                                            child: getTextView(
                                              context,
                                              item['question'],
                                              14,
                                              isBold: true,
                                            ),
                                          ),
                                          Icon(
                                            isExpanded
                                                ? Icons.keyboard_arrow_up
                                                : Icons.keyboard_arrow_down,
                                            color: Color(0xFF6B7280),
                                          ),
                                        ],
                                      ),
                                      if (isExpanded) ...[
                                        getVerticalSpacer(12),
                                        getTextView(
                                          context,
                                          item['answer'],
                                          14,
                                          color: Color(0xFF6B7280),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            getVerticalSpacer(24),
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.2),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: _animationController,
                  curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[800] : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFE6F3F8), Color(0xFFF0E6F8)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.support_agent,
                            color: Color(0xFF9B6DFF),
                            size: 24,
                          ),
                        ),
                        getHorizontalSpacer(12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              getTextView(
                                context,
                                "Need More Help?",
                                16,
                                isBold: true,
                              ),
                              getVerticalSpacer(4),
                              getTextView(
                                context,
                                "Our support team is here to help you",
                                14,
                                color: Color(0xFF6B7280),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    getVerticalSpacer(16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Color(0xFF9B6DFF), Color(0xFF7B6DFF)],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: getTextView(
                          context,
                          "Contact Support Team",
                          14,
                          isBold: true,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
