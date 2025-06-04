import 'dart:io';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talento_flutter/core/constants/constants.dart';
import 'package:talento_flutter/core/utils/utils.dart';
import 'package:talento_flutter/presentation/routes/routes.dart';

Widget gradientButton(
  BuildContext context,
  String text,
  VoidCallback onTap, {
  double width = double.infinity,
  bool showArrow = false,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: width,
      height: 50,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF9DA3F8), Color(0xDD000000)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          if (showArrow)
            Positioned(
              right: 8,
              top: 8.5,
              bottom: 8.5,
              child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward,
                  color: Colors.black,
                  size: 16,
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

Widget haveAccount({required VoidCallback onTap, bool isLogin = false}) {
  return Center(
    child: Text.rich(
      style: TextStyle(decoration: TextDecoration.underline),
      TextSpan(
        text: isLogin ? "Don't Have Account?" : "Already Have Account?",
        children: [
          TextSpan(
            text: isLogin ? " Sign Up" : " Log In",
            style: TextStyle(
              color: Colors.deepPurple,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()..onTap = onTap,
          ),
        ],
      ),
    ),
  );
}

Widget getHeader(BuildContext context) {
  return Center(
    child: Text("Talento", style: TextStyle(fontSize: 28, color: Colors.white)),
  );
}

Widget returnRichText(String first, String second, double fontSize) {
  return RichText(
    text: TextSpan(
      children: [
        TextSpan(
          text: first,
          style: TextStyle(
            color: Colors.black,
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
          ),
        ),
        TextSpan(
          text: second,
          style: TextStyle(
            color: Colors.blue,
            fontSize: fontSize + 1,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

void showCustomBottomSheet(BuildContext context, Widget child) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    ),
    builder:
        (context) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: child,
        ),
  );
}

Widget getTextView(
  BuildContext context,
  String txt,
  double fontSize, {
  int fontWeightIndex = 1,
  Color? color,
  bool isCenter = false,
  bool isBold = false,
}) {
  List<String> fonts = [
    'AnekDevanagari_Condensed-Bold', // weight 100
    'AnekDevanagari_Condensed-ExtraBold', // 200
    'AnekDevanagari_Condensed-SemiBold', // 300
    'AnekDevanagari_Condensed-Light', // 400
    'AnekDevanagari_Condensed-Medium', // 500
    'AnekDevanagari_Condensed-Regular', // 600
  ];

  String selectedFont = fonts[fontWeightIndex % fonts.length];

  return Text(
    txt,
    textAlign: isCenter ? TextAlign.center : TextAlign.start,
    style: TextStyle(
      fontSize: fontSize,
      color: color ?? Theme.of(context).textTheme.bodyMedium?.color,
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      fontFamily: selectedFont,
    ),
  );
}

Future<void> showConfirmationDialog(BuildContext context, bool isDelete) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    builder: (BuildContext dialogContext) {
      final String title = isDelete ? 'Delete Account' : 'Logout';
      final String message =
          isDelete
              ? 'Are you sure? This action cannot be undone.'
              : 'Are you sure you want to logout?';
      final String confirmText = isDelete ? 'Delete' : 'Logout';
      final Color accentColor =
          isDelete ? Colors.red : AppConstants.primaryColor;

      return TweenAnimationBuilder(
        duration: Duration(milliseconds: 300),
        tween: Tween<double>(begin: 0, end: 1),
        builder: (context, double value, child) {
          return Transform.scale(
            scale: value,
            child: AlertDialog(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              contentPadding: EdgeInsets.zero,
              content: Container(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isDelete
                            ? Icons.delete_forever_rounded
                            : Icons.logout_rounded,
                        color: accentColor,
                        size: 32,
                      ),
                    ),
                    getVerticalSpacer(16),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    getVerticalSpacer(8),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    getVerticalSpacer(24),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.of(dialogContext).pop(),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: Colors.grey[500]!),
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        getHorizontalSpacer(12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (!isDelete) {
                                setLoginStatus(false);
                              }
                              Navigator.of(dialogContext).pop();
                              moveToNextPage(AppRoutes.login);
                              Utils.showSnackBar(
                                Get.context!,
                                isDelete
                                    ? "Account deleted successfully"
                                    : "Logged out successfully",
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentColor,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 12),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              confirmText,
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

Widget customTextField(
  String label, {
  bool obscure = false,
  bool isPassword = false,
  String? prefixText,
  TextEditingController? controller,
  VoidCallback? onTap,
  bool readOnly = false,
  TextInputType? keyboardType,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextFormField(
      controller: controller,
      obscureText: obscure,
      readOnly: readOnly,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black87),
        prefixText: prefixText,
        prefixStyle: const TextStyle(color: Colors.black87),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
        suffixIcon:
            isPassword
                ? IconButton(
                  icon: Icon(
                    obscure ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: onTap,
                )
                : null,
      ),
    ),
  );
}

void printInDebugMode(String text) {
  if (kDebugMode) {
    print(text);
  }
}

void setLoginStatus(bool isLogin) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(AppConstants.isLogin, isLogin);
}

void checkLoginStatusAndMove() async {
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool(AppConstants.isLogin) ?? false;
  moveToNextPage(isLoggedIn ? AppRoutes.dashboard : AppRoutes.login);
}

void moveToNextPage(String route) {
  Get.toNamed(route);
}

void moveToPreviousScreen() {
  Get.back();
}

Widget getVerticalSpacer(double height) {
  return SizedBox(height: height);
}

Widget getHorizontalSpacer(double width) {
  return SizedBox(width: width);
}

void showGetXSnackBar(String title, {String message = ''}) {
  Get.snackbar(title, message, snackPosition: SnackPosition.BOTTOM);
}

Future<bool> checkInternet(BuildContext context) async {
  try {
    // First check if we have connectivity
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      showGetXSnackBar("No network connection");
      return false;
    }
    // Then verify we can actually reach the internet
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
  } on SocketException catch (e) {
    printInDebugMode('Socket exception while checking internet: $e');
    showGetXSnackBar("No internet connection");
    return false;
  } catch (e) {
    printInDebugMode('Error while checking internet: $e');
    showGetXSnackBar("Connection error occurred");
    return false;
  }
  return false;
}

class ModernBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? iconColor;

  const ModernBackButton({
    super.key,
    this.onPressed,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color:
              backgroundColor ??
              AppConstants.primaryColor.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: iconColor ?? AppConstants.primaryColor,
          size: 20,
        ),
      ),
      onPressed: onPressed ?? () => Navigator.of(context).pop(),
    );
  }
}

class JobSearchLoadingPainter extends CustomPainter {
  final Color primaryColor;
  final Color accentColor;
  final double animation;
  final double searchAnimation;

  JobSearchLoadingPainter({
    required this.primaryColor,
    required this.accentColor,
    required this.animation,
    required this.searchAnimation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Draw magnifying glass
    _drawMagnifyingGlass(canvas, center, size);

    // Draw animated search particles
    _drawSearchParticles(canvas, center, size);

    // Draw pulsing job cards
    _drawJobCards(canvas, center, size);
  }

  void _drawMagnifyingGlass(Canvas canvas, Offset center, Size size) {
    final paint =
        Paint()
          ..color = primaryColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round;

    // Draw glass circle
    final glassRadius = size.width * 0.2;
    final handleLength = glassRadius * 0.8;

    // Rotate the glass based on animation
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(animation * 2 * 3.14159);
    canvas.translate(-center.dx, -center.dy);

    // Draw the circle part
    canvas.drawCircle(
      Offset(center.dx - handleLength * 0.3, center.dy - handleLength * 0.3),
      glassRadius,
      paint,
    );

    // Draw the handle
    canvas.drawLine(
      Offset(center.dx + glassRadius * 0.5, center.dy + glassRadius * 0.5),
      Offset(center.dx + handleLength, center.dy + handleLength),
      paint,
    );

    canvas.restore();
  }

  void _drawSearchParticles(Canvas canvas, Offset center, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    final particleCount = 8;
    final baseRadius = size.width * 0.03;

    for (var i = 0; i < particleCount; i++) {
      final angle =
          (i * 2 * 3.14159 / particleCount) + (animation * 2 * 3.14159);
      final distance =
          size.width * 0.3 * (1 + sin(searchAnimation * 2 * 3.14159 + i));
      final particleCenter = Offset(
        center.dx + cos(angle) * distance,
        center.dy + sin(angle) * distance,
      );

      paint.color =
          i % 2 == 0
              ? primaryColor.withValues(
                alpha: 0.6 - (0.3 * sin(searchAnimation * 2 * 3.14159)),
              )
              : accentColor.withValues(
                alpha: 0.6 - (0.3 * cos(searchAnimation * 2 * 3.14159)),
              );

      canvas.drawCircle(
        particleCenter,
        baseRadius * (0.8 + 0.4 * sin(searchAnimation * 4 * 3.14159 + i)),
        paint,
      );
    }
  }

  void _drawJobCards(Canvas canvas, Offset center, Size size) {
    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

    final cardWidth = size.width * 0.15;
    final cardHeight = cardWidth * 0.6;

    for (var i = 0; i < 3; i++) {
      final progress = (searchAnimation + i / 3) % 1.0;
      final scale = 0.8 + 0.4 * sin(progress * 3.14159);
      final opacity = 0.7 - (0.5 * progress);

      paint.color = primaryColor.withValues(alpha: opacity);

      canvas.save();
      canvas.translate(
        center.dx - cardWidth / 2 + (size.width * 0.3 * progress),
        center.dy + size.height * 0.25,
      );
      canvas.scale(scale);

      // Draw card
      final rect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset.zero,
          width: cardWidth,
          height: cardHeight,
        ),
        Radius.circular(4),
      );
      canvas.drawRRect(rect, paint);

      // Draw card lines
      final linePaint =
          Paint()
            ..color = accentColor.withValues(alpha: opacity * 0.8)
            ..strokeWidth = 1;

      for (var j = 0; j < 2; j++) {
        canvas.drawLine(
          Offset(-cardWidth * 0.35, -cardHeight * 0.2 + (j * cardHeight * 0.3)),
          Offset(cardWidth * 0.35, -cardHeight * 0.2 + (j * cardHeight * 0.3)),
          linePaint,
        );
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(JobSearchLoadingPainter oldDelegate) {
    return oldDelegate.animation != animation ||
        oldDelegate.searchAnimation != searchAnimation ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.accentColor != accentColor;
  }
}

class JobSearchLoadingIndicator extends StatefulWidget {
  final Color primaryColor;
  final Color accentColor;
  final double size;

  const JobSearchLoadingIndicator({
    super.key,
    required this.primaryColor,
    required this.accentColor,
    this.size = 100,
  });

  @override
  State<JobSearchLoadingIndicator> createState() =>
      _JobSearchLoadingIndicatorState();
}

class _JobSearchLoadingIndicatorState extends State<JobSearchLoadingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _searchController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _searchAnimation;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );

    _searchController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.easeInOut),
    );

    _searchAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _searchController, curve: Curves.easeInOut),
    );

    _rotationController.repeat();
    _searchController.repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: Listenable.merge([_rotationAnimation, _searchAnimation]),
        builder: (context, child) {
          return CustomPaint(
            painter: JobSearchLoadingPainter(
              primaryColor: widget.primaryColor,
              accentColor: widget.accentColor,
              animation: _rotationAnimation.value,
              searchAnimation: _searchAnimation.value,
            ),
            size: Size(widget.size, widget.size),
          );
        },
      ),
    );
  }
}
