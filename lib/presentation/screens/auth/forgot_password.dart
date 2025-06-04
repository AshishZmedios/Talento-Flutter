import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talento_flutter/core/constants/constants.dart';
import 'package:talento_flutter/core/utils/utils.dart';
import 'package:talento_flutter/presentation/routes/routes.dart';
import 'package:talento_flutter/presentation/screens/auth/repository/auth_repository.dart';
import 'package:talento_flutter/presentation/widgets/helper.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  final _emailMobileController = TextEditingController();
  final repo = Get.find<AuthRepository>();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutQuart),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailMobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFD7D9FF),
              Theme.of(context).scaffoldBackgroundColor,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 10,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: AppConstants.primaryColor,
                          size: 20,
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    getHorizontalSpacer(16),
                    Text(
                      "Forgot Password",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          children: [
                            getVerticalSpacer(40),
                            // Logo
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 10,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                AppConstants.iconLogo2,
                                height: 80,
                                width: 80,
                              ),
                            ),
                            getVerticalSpacer(30),
                            // Title and description
                            Text(
                              "Reset Password",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppConstants.primaryColor,
                                letterSpacing: 1.5,
                              ),
                            ),
                            getVerticalSpacer(16),
                            Text(
                              "Enter your email or phone number and we'll send you a code to reset your password",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                height: 1.5,
                              ),
                            ),
                            getVerticalSpacer(40),
                            // Input field
                            _buildInputField(
                              controller: _emailMobileController,
                              hint: "Email or Phone Number",
                              icon: Icons.alternate_email,
                            ),
                            getVerticalSpacer(40),
                            // Submit button
                            _buildSubmitButton(),
                            getVerticalSpacer(24),
                            // Back to login
                            TextButton(
                              onPressed: () => moveToNextPage(AppRoutes.login),
                              child: Text(
                                "Back to Login",
                                style: TextStyle(
                                  color: AppConstants.primaryColor,
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(fontSize: 16),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: Icon(icon, color: AppConstants.primaryColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_emailMobileController.text.toString().trim().isEmpty) {
            Utils.showSnackBar(context, "Please enter email or mobile first.");
          } else {
            Get.toNamed(
              AppRoutes.verifyOtp,
              arguments: {
                AppConstants.argumnetMobileEmail:
                    _emailMobileController.text.toString().trim(),
              },
            );
            // sendOTPWithMobileOrEmail(
            //   _emailMobileController.text.toString().trim(),
            // );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.primaryColor,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 2,
        ),
        child: Text(
          "Send Reset Code",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void sendOTPWithMobileOrEmail(String emailPhone) async {
    final sendOTPResponse = await repo.loginOtpRequest(emailPhone);
    if (Utils.isSuccessfulResponse(sendOTPResponse)) {
      showGetXSnackBar(sendOTPResponse.data['message']);
      Get.toNamed(
        AppRoutes.verifyOtp,
        arguments: {AppConstants.argumnetMobileEmail: emailPhone},
      );
    }
  }
}
