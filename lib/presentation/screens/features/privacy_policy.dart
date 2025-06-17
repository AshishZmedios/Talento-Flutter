import 'package:flutter/material.dart';
import 'package:talento_flutter/core/constants/constants.dart';
import 'package:talento_flutter/core/utils/time_tracker.dart';
import 'package:talento_flutter/presentation/widgets/helper.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showElevation = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.offset > 0 && !_showElevation) {
      setState(() => _showElevation = true);
    } else if (_scrollController.offset <= 0 && _showElevation) {
      setState(() => _showElevation = false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildSectionCard({
    required String title,
    required String content,
    required IconData icon,
    required List<Color> gradientColors,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
                getHorizontalSpacer(12),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              content,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TimeTracker(
      screenName: AppConstants.privacyScreen,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: _showElevation ? 2 : 0,
          leading: Padding(
            padding: EdgeInsets.only(left: 0),
            child: ModernBackButton(onPressed: () => moveToPreviousScreen()),
          ),
          title: Text(
            "Privacy Policy",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          centerTitle: false,
        ),
        body: SafeArea(
          child: ListView(
            controller: _scrollController,
            padding: EdgeInsets.all(16),
            children: [
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppConstants.primaryColor,
                      AppConstants.primaryColor.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppConstants.primaryColor.withOpacity(0.2),
                      blurRadius: 15,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.shield_outlined,
                          color: Colors.white,
                          size: 32,
                        ),
                        getHorizontalSpacer(12),
                        Text(
                          "Talento Privacy Policy",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    getVerticalSpacer(12),
                    Text(
                      "Last updated: ${DateTime.now().toString().split(' ')[0]}",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              getVerticalSpacer(24),
              _buildSectionCard(
                title: "Information Collection",
                content:
                    "We collect information that you provide directly to us, including personal information such as your name, email address, and professional details.",
                icon: Icons.info_outline,
                gradientColors: [Color(0xFF7CB9E8), Color(0xFF4A90E2)],
              ),
              _buildSectionCard(
                title: "Data Usage",
                content:
                    "We use the information we collect to provide and improve our services, communicate with you, and enhance your job search experience.",
                icon: Icons.data_usage,
                gradientColors: [Color(0xFF98FB98), Color(0xFF32CD32)],
              ),
              _buildSectionCard(
                title: "Data Protection",
                content:
                    "We implement appropriate security measures to protect your personal information from unauthorized access, alteration, or destruction.",
                icon: Icons.security,
                gradientColors: [Color(0xFFFFB347), Color(0xFFFF8C00)],
              ),
              _buildSectionCard(
                title: "Your Rights",
                content:
                    "You have the right to access, correct, or delete your personal information. Contact us if you wish to exercise these rights.",
                icon: Icons.gavel,
                gradientColors: [Color(0xFFDDA0DD), Color(0xFF9370DB)],
              ),
              _buildSectionCard(
                title: "Contact Us",
                content:
                    "If you have any questions about this Privacy Policy, please contact us at support@talento.com",
                icon: Icons.contact_mail,
                gradientColors: [Color(0xFF87CEEB), Color(0xFF1E90FF)],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
