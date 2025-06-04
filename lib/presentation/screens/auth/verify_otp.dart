import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:talento_flutter/core/constants/constants.dart';
import 'package:talento_flutter/core/utils/time_tracker.dart';
import 'package:talento_flutter/core/utils/utils.dart';
import 'package:talento_flutter/presentation/routes/routes.dart';
import 'package:talento_flutter/presentation/widgets/helper.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String mobileEmail;

  VerifyOtpScreen({super.key})
    : mobileEmail = Get.arguments[AppConstants.argumnetMobileEmail];

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen>
    with SingleTickerProviderStateMixin {
  final _otpController = TextEditingController();
  Timer? _timer;
  int _secondsRemaining = 30;
  bool _isResendEnabled = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  void _startResendOtpTimer() {
    setState(() {
      _secondsRemaining = 30;
      _isResendEnabled = false;
    });

    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
        setState(() {
          _isResendEnabled = true;
        });
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _startResendOtpTimer();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TimeTracker(
      screenName: AppConstants.verifyOtpScreen,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    children: [
                      AppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        leading: ModernBackButton(
                          onPressed: () => moveToPreviousScreen(),
                        ),
                      ),
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppConstants.primaryColor.withValues(
                            alpha: 0.1,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.lock_outline_rounded,
                          size: 48,
                          color: AppConstants.primaryColor,
                        ),
                      ),
                      getVerticalSpacer(32),
                      Text(
                        "OTP Verification",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                      getVerticalSpacer(12),
                      Text(
                        "Enter the verification code we just sent to",
                        style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      ),
                      getVerticalSpacer(8),
                      Text(
                        widget.mobileEmail,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppConstants.primaryColor,
                        ),
                      ),
                      getVerticalSpacer(40),
                      PinCodeTextField(
                        appContext: context,
                        length: 6,
                        controller: _otpController,
                        keyboardType: TextInputType.number,
                        animationType: AnimationType.fade,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(12),
                          fieldHeight: 56,
                          fieldWidth: 44,
                          activeFillColor: Colors.white,
                          inactiveColor: Colors.grey[300],
                          selectedColor: AppConstants.primaryColor,
                          activeColor: AppConstants.primaryColor,
                          selectedFillColor: Colors.white,
                          inactiveFillColor: Colors.grey[50],
                          borderWidth: 1.5,
                        ),
                        cursorColor: AppConstants.primaryColor,
                        animationDuration: const Duration(milliseconds: 300),
                        enableActiveFill: true,
                        onChanged: (value) {},
                      ),
                      getVerticalSpacer(40),
                      Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppConstants.primaryColor,
                              AppConstants.primaryColor.withValues(alpha: 0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppConstants.primaryColor.withValues(
                                alpha: 0.3,
                              ),
                              blurRadius: 12,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              if (_otpController.text.isEmpty ||
                                  _otpController.text.length < 6) {
                                Utils.showSnackBar(
                                  context,
                                  "Please enter a valid 6 digit OTP",
                                );
                              } else {
                                Utils.showSnackBar(
                                  context,
                                  "OTP verified successfully",
                                );
                                moveToNextPage(AppRoutes.login);
                              }
                            },
                            child: Center(
                              child: Text(
                                "Verify & Proceed",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      getVerticalSpacer(32),
                      _isResendEnabled
                          ? TextButton(
                            onPressed: () {
                              Utils.showSnackBar(
                                context,
                                "OTP resent successfully",
                              );
                              _startResendOtpTimer();
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              "Resend OTP",
                              style: TextStyle(
                                color: AppConstants.primaryColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                          : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.timer_outlined,
                                size: 18,
                                color: Colors.grey[600],
                              ),
                              getHorizontalSpacer(8),
                              Text(
                                "Resend OTP in $_secondsRemaining seconds",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                      getVerticalSpacer(24),
                      TextButton(
                        onPressed: () => moveToPreviousScreen(),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Change Email/Mobile Number",
                          style: TextStyle(
                            color: AppConstants.primaryColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
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
      ),
    );
  }
}
