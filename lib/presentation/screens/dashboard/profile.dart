import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:talento_flutter/core/constants/constants.dart';
import 'package:talento_flutter/core/utils/time_tracker.dart';
import 'package:talento_flutter/presentation/widgets/helper.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  final ImagePicker _picker = ImagePicker();
  XFile? _profileImage;
  late ScrollController _scrollController;
  bool _isCollapsed = false;
  late AnimationController _animationController;
  late Animation<double> _animation;
  String? _expandedSection;
  bool _isScrolling = false;
  late AnimationController _shimmerController;

  final Map<String, Map<String, dynamic>> _sections = {
    'Personal Information': {
      'expanded': false,
      'icon': Icons.person,
      'completeness': 0.8,
    },
    'Professional Summary': {
      'expanded': false,
      'icon': Icons.description_outlined,
      'completeness': 0.6,
    },
    'Job Preferences': {
      'expanded': false,
      'icon': Icons.work_outline,
      'completeness': 0.9,
    },
    'Skills': {
      'expanded': false,
      'icon': Icons.star_outline,
      'completeness': 0.7,
      'items': ['Flutter', 'React', 'Node.js', 'Python', 'AWS'],
    },
    'Past Experiences': {
      'expanded': false,
      'icon': Icons.history,
      'completeness': 1.0,
    },
    'Education': {
      'expanded': false,
      'icon': Icons.school_outlined,
      'completeness': 1.0,
    },
    'Certifications': {
      'expanded': false,
      'icon': Icons.card_membership,
      'completeness': 0.4,
    },
    'Resume': {
      'expanded': false,
      'icon': Icons.upload_file,
      'completeness': 1.0,
    },
    'Portfolio': {'expanded': false, 'icon': Icons.link, 'completeness': 0.3},
    'Languages': {
      'expanded': false,
      'icon': Icons.language_outlined,
      'completeness': 0.8,
    },
  };

  double get _profileCompleteness {
    double total = 0;
    _sections.forEach((_, value) => total += value['completeness'] as double);
    return total / _sections.length;
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _animationController.forward();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _animationController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (!_isScrolling) {
      _isScrolling = true;
      if (_scrollController.offset > 180 != _isCollapsed) {
        setState(() {
          _isCollapsed = _scrollController.offset > 180;
        });
      }
      Future.delayed(const Duration(milliseconds: 100), () {
        _isScrolling = false;
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    Permission permission =
        source == ImageSource.camera
            ? Permission.camera
            : Platform.isAndroid && Platform.version.contains("13")
            ? Permission.mediaLibrary
            : Permission.storage;

    if (await permission.request().isGranted) {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() => _profileImage = image);
      }
    }
  }

  void _openBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(color: Colors.black, blurRadius: 10, spreadRadius: 0),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: AppConstants.primaryColor,
                  ),
                ),
                title: Text(
                  "Take Photo",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.photo_library,
                    color: AppConstants.primaryColor,
                  ),
                ),
                title: Text(
                  "Choose from Gallery",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              getVerticalSpacer(20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TimeTracker(
      screenName: AppConstants.profileScreen,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: Stack(
          children: [
            CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildSliverAppBar(),
                SliverToBoxAdapter(child: _buildProfileStats()),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final title = _sections.keys.elementAt(index);
                      return _buildSectionCard(title);
                    }, childCount: _sections.length),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 320,
      floating: false,
      pinned: true,
      stretch: true,
      automaticallyImplyLeading: false,
      elevation: _isCollapsed ? 0 : 0,
      backgroundColor: _isCollapsed ? Colors.white : Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: _buildHeader(),
        stretchModes: [StretchMode.zoomBackground],
      ),
      bottom:
          _isCollapsed
              ? PreferredSize(
                preferredSize: Size.fromHeight(1),
                child: Container(
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
              )
              : null,
      title: _isCollapsed ? _buildCollapsedHeader() : null,
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppConstants.primaryColor,
            AppConstants.primaryColor.withValues(alpha: 0.8),
            AppConstants.primaryColor.withValues(alpha: 0.6),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Background design elements
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -30,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
          ),
          // Profile content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              getVerticalSpacer(60),
              _buildProfileImage(),
              getVerticalSpacer(16),
              Text(
                "Ashish Kumar",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
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
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Senior Product Developer",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return Hero(
      tag: 'profile_image',
      child: GestureDetector(
        onTap: () => _openBottomSheet(context),
        child: Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 66,
                backgroundColor: Colors.white,
                backgroundImage:
                    _profileImage != null
                        ? FileImage(File(_profileImage!.path))
                        : AssetImage(AppConstants.iconLogo1) as ImageProvider,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Icon(Icons.camera_alt, size: 20, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileStats() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Profile Completeness',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              Text(
                '${(_profileCompleteness * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.primaryColor,
                ),
              ),
            ],
          ),
          getVerticalSpacer(12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              children: [
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                AnimatedBuilder(
                  animation: _shimmerController,
                  builder: (context, child) {
                    return FractionallySizedBox(
                      widthFactor: _profileCompleteness,
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppConstants.primaryColor,
                              AppConstants.primaryColor.withValues(alpha: 0.7),
                              AppConstants.primaryColor,
                            ],
                            stops: [0.0, _shimmerController.value, 1.0],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(String title) {
    final bool isExpanded = _expandedSection == title;
    final section = _sections[title]!;
    final completeness = section['completeness'] as double;

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color:
                  isExpanded
                      ? AppConstants.primaryColor.withValues(alpha: 0.2)
                      : Colors.black.withValues(alpha: 0.05),
              blurRadius: isExpanded ? 15 : 10,
              spreadRadius: isExpanded ? 2 : 0,
              offset: Offset(0, isExpanded ? 4 : 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: ExpansionTile(
            key: PageStorageKey<String>(title),
            initiallyExpanded: isExpanded,
            onExpansionChanged: (expanded) {
              setState(() => _expandedSection = expanded ? title : null);
            },
            leading: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppConstants.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                section['icon'] as IconData,
                color: AppConstants.primaryColor,
              ),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(completeness).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${(completeness * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _getStatusColor(completeness),
                    ),
                  ),
                ),
              ],
            ),
            children: [_buildSectionContent(title, section)],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(double completeness) {
    if (completeness >= 0.8) return Colors.green;
    if (completeness >= 0.5) return Colors.orange;
    return Colors.red;
  }

  Widget _buildSectionContent(String title, Map<String, dynamic> section) {
    // Example content for Skills section
    if (title == 'Skills') {
      return Container(
        padding: EdgeInsets.all(16),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              (section['items'] as List<String>).map((skill) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: AppConstants.primaryColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    skill,
                    style: TextStyle(
                      color: AppConstants.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
        ),
      );
    }

    // Default content
    return Container(
      padding: EdgeInsets.all(16),
      child: Center(
        child: Text(
          'Tap to edit ${title.toLowerCase()}',
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildCollapsedHeader() {
    return Container(
      child: Row(
        children: [
          Hero(
            tag: 'profile_image',
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppConstants.primaryColor, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image:
                          _profileImage != null
                              ? FileImage(File(_profileImage!.path))
                              : AssetImage(AppConstants.iconLogo1)
                                  as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          getHorizontalSpacer(12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Ashish Kumar",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppConstants.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "Senior Product Developer",
                        style: TextStyle(
                          fontSize: 12,
                          color: AppConstants.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    getHorizontalSpacer(8),
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle,
                        size: 12,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for animated background
class BackgroundPainter extends CustomPainter {
  final Color color1;
  final Color color2;
  final double scrollOffset;

  BackgroundPainter({
    required this.color1,
    required this.color2,
    required this.scrollOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint1 =
        Paint()
          ..color = color1.withValues(alpha: 0.1)
          ..style = PaintingStyle.fill;
    final paint2 =
        Paint()
          ..color = color2.withValues(alpha: 0.1)
          ..style = PaintingStyle.fill;

    final baseOffset = scrollOffset * 0.3;

    // Animated circles
    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.1 + baseOffset),
      80,
      paint1,
    );
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.3 + baseOffset),
      100,
      paint2,
    );
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.5 + baseOffset),
      120,
      paint1,
    );
  }

  @override
  bool shouldRepaint(BackgroundPainter oldDelegate) =>
      color1 != oldDelegate.color1 ||
      color2 != oldDelegate.color2 ||
      scrollOffset != oldDelegate.scrollOffset;
}

Widget getSectionContent(BuildContext context, String title) {
  final sectionData = _sectionData[title];
  if (sectionData == null) {
    return Text('No data available');
  }

  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 2),
    padding: const EdgeInsets.all(10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [getTextView(context, title, 20)],
        ),
        getVerticalSpacer(10),
        ...sectionData.map((row) => _buildContentRow(context, row)),
      ],
    ),
  );
}

Widget _buildContentRow(BuildContext context, Map<String, dynamic> row) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      children: [
        Icon(row['icon'], size: 18),
        getHorizontalSpacer(10),
        Expanded(child: getTextView(context, row['text'], 14)),
      ],
    ),
  );
}

void _showEditDialog(BuildContext context, String title) {
  showDialog(
    context: context,
    builder:
        (_) => AlertDialog(
          title: getTextView(context, 'Edit $title', 14, isBold: true),
          content: Text(
            'Here you can edit your $title details',
            style: TextStyle(fontSize: 12),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
  );
}

const IconData defaultIcon = Icons.add_circle_outline_sharp;
final Map<String, List<Map<String, dynamic>>> _sectionData = {
  'Personal Information': [
    {'icon': Icons.person, 'text': 'Name: Amanda Copeland'},
    {'icon': Icons.cake, 'text': 'DOB: 12/08/1995'},
    {'icon': Icons.badge, 'text': 'Gender: Female'},
    {'icon': Icons.flag, 'text': 'Nationality: American'},
    {'icon': Icons.info_outline, 'text': 'Marital Status: Single'},
  ],
  'Contact Info': [
    {'icon': Icons.email, 'text': 'Email: amanda@example.com'},
    {'icon': Icons.phone, 'text': 'Phone: +91 1234567890'},
    {'icon': Icons.message, 'text': 'Alt Contact: +91 9876543210'},
    {'icon': Icons.web, 'text': 'Website: amanda.dev'},
    {'icon': Icons.chat, 'text': 'LinkedIn: linkedin.com/in/amanda'},
  ],
  'Address': [
    {'icon': Icons.home, 'text': 'Street: 123, Main Street'},
    {'icon': Icons.location_city, 'text': 'City: New York'},
    {'icon': Icons.map, 'text': 'State: NY'},
    {'icon': Icons.flag, 'text': 'Country: USA'},
    {'icon': Icons.markunread_mailbox, 'text': 'ZIP: 10001'},
  ],
  'Professional Summary': [
    {
      'icon': defaultIcon,
      'text':
          'Short bio or headline (e.g. "Graphic Designer\n| 3+ Yrs Exp in Branding & Motion Graphics")',
    },
    {'icon': defaultIcon, 'text': 'About Me (250–500 chars)'},
  ],
  'Job Preferences': [
    {'icon': defaultIcon, 'text': 'Preferred Job Roles'},
    {
      'icon': defaultIcon,
      'text': 'Employment Type (Full-Time, Freelance, Part-Time)',
    },
    {'icon': defaultIcon, 'text': 'Preferred Location'},
    {'icon': defaultIcon, 'text': 'Expected Salary'},
    {'icon': defaultIcon, 'text': 'Notice Period'},
  ],
  'Skills': [
    {
      'icon': defaultIcon,
      'text': 'List of Technical & Soft Skills\n(Searchable Tag-Style Input)',
    },
    {'icon': defaultIcon, 'text': 'Skill rating (e.g., Beginner to Expert)'},
  ],
  'Past Experiences': [
    {'icon': defaultIcon, 'text': 'Job Title'},
    {'icon': defaultIcon, 'text': 'Company Name'},
    {'icon': defaultIcon, 'text': 'Duration (From–To)'},
    {'icon': defaultIcon, 'text': 'Description of role/responsibilities'},
  ],
  'Education': [
    {'icon': defaultIcon, 'text': 'Degree Name'},
    {'icon': defaultIcon, 'text': 'Institution'},
    {'icon': defaultIcon, 'text': 'Year of Passing'},
    {'icon': defaultIcon, 'text': 'Grade/CGPA (optional)'},
  ],
  'Certifications': [
    {'icon': defaultIcon, 'text': 'Course/Certificate Name'},
    {
      'icon': defaultIcon,
      'text': 'Institution/Platform (e.g., Coursera, Udemy,\nDice Academy)',
    },
    {'icon': defaultIcon, 'text': 'Year Completed'},
    {'icon': defaultIcon, 'text': 'upload a photo of certificate'},
  ],
  'Resume': [
    {'icon': defaultIcon, 'text': 'Upload new resume (PDF/DOC)'},
    {'icon': defaultIcon, 'text': 'View or Download existing resume'},
  ],
  'Portfolio': [
    {
      'icon': defaultIcon,
      'text': 'Behance, Dribble, GitHub, LinkedIn, Personal Website',
    },
  ],
  'Languages': [
    {'icon': defaultIcon, 'text': 'Language name'},
    {'icon': defaultIcon, 'text': 'Proficiency level (Basic, Fluent, Native)'},
  ],
  'Additional Options': [
    {'icon': defaultIcon, 'text': 'Download profile as PDF'},
    {'icon': defaultIcon, 'text': 'Add social media links'},
  ],
};
