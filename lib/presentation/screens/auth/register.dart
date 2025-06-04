import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:talento_flutter/core/constants/constants.dart';
import 'package:talento_flutter/core/utils/time_tracker.dart';
import 'package:talento_flutter/core/utils/utils.dart';
import 'package:talento_flutter/presentation/routes/routes.dart';
import 'package:talento_flutter/presentation/screens/auth/repository/auth_repository.dart';
import 'package:talento_flutter/presentation/widgets/helper.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _otpController = TextEditingController();
  final isOtpVerified = false.obs;
  final repo = Get.find<AuthRepository>();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;
  final isOtpSent = false.obs;

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
    super.dispose();
  }

  void validateFields() {
    final fullName = _fullNameController.text.toString().trim();
    final email = _emailController.text.toString().trim();
    final mobile = _mobileController.text.toString().trim();
    final password = _passwordController.text.toString().trim();
    final confirmPassword = _confirmPasswordController.text.toString().trim();

    if (fullName.isEmpty) {
      Utils.showSnackBar(context, "Please enter your full name");
      return;
    } else if (email.isEmpty) {
      Utils.showSnackBar(context, "Please enter your email address");
      return;
    } else if (mobile.isEmpty || mobile.length != 10) {
      Utils.showSnackBar(context, "Please enter a valid mobile number first.");
      return;
    } else if (!isOtpVerified.value) {
      Utils.showSnackBar(context, "Please verify your OTP first");
      return;
    } else if (password.isEmpty) {
      Utils.showSnackBar(context, "Please enter your password");
      return;
    } else if (confirmPassword.isEmpty) {
      Utils.showSnackBar(context, "Please confirm your password");
      return;
    } else if (password != confirmPassword) {
      Utils.showSnackBar(context, "Passwords don't match");
      return;
    } else if (!_agreeToTerms) {
      Utils.showSnackBar(context, "Please agree to the terms and conditions");
      return;
    } else {
      callRegisterUserApi(context, fullName, email, mobile, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TimeTracker(
      screenName: AppConstants.registerUserScreen,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        getVerticalSpacer(40),
                        // Logo and branding
                        Container(
                          padding: EdgeInsets.all(15),
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
                            height: 60,
                            width: 60,
                          ),
                        ),
                        getVerticalSpacer(20),
                        Text(
                          "Create Account",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppConstants.primaryColor,
                            letterSpacing: 1.5,
                          ),
                        ),
                        getVerticalSpacer(10),
                        Text(
                          "Join the fastest growing professional community",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        getVerticalSpacer(30),
                        // Social signup buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildSocialButton(
                              icon: FontAwesomeIcons.google,
                              label: "Google",
                              onTap: () {},
                            ),
                            getHorizontalSpacer(20),
                            _buildSocialButton(
                              icon: FontAwesomeIcons.github,
                              label: "GitHub",
                              onTap: () {},
                            ),
                          ],
                        ),
                        getVerticalSpacer(30),
                        // Divider with text
                        Row(
                          children: [
                            Expanded(child: Divider(color: Colors.grey[300])),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                "Or register with",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(child: Divider(color: Colors.grey[300])),
                          ],
                        ),
                        getVerticalSpacer(30),
                        // Registration form
                        _buildInputField(
                          controller: _fullNameController,
                          hint: "Full Name",
                          icon: Icons.person_outline,
                        ),
                        getVerticalSpacer(20),
                        _buildInputField(
                          controller: _emailController,
                          hint: "Email Address",
                          icon: Icons.email_outlined,
                        ),
                        getVerticalSpacer(20),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: _buildInputField(
                                controller: _mobileController,
                                hint: "Mobile Number",
                                icon: Icons.phone_outlined,
                                prefixText: "+91 ",
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            getHorizontalSpacer(12),
                            _buildOtpButton(),
                          ],
                        ),
                        getVerticalSpacer(20),
                        _buildInputField(
                          controller: _passwordController,
                          hint: "Password",
                          icon: Icons.lock_outline,
                          isPassword: true,
                          obscure: _obscurePassword,
                          onSuffixTap: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        getVerticalSpacer(20),
                        _buildInputField(
                          controller: _confirmPasswordController,
                          hint: "Confirm Password",
                          icon: Icons.lock_outline,
                          isPassword: true,
                          obscure: _obscureConfirmPassword,
                          onSuffixTap: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                        ),
                        getVerticalSpacer(20),
                        // Terms and conditions
                        Row(
                          children: [
                            SizedBox(
                              height: 24,
                              width: 24,
                              child: Checkbox(
                                value: _agreeToTerms,
                                onChanged: (val) {
                                  setState(() {
                                    _agreeToTerms = val!;
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                activeColor: AppConstants.primaryColor,
                              ),
                            ),
                            getHorizontalSpacer(8),
                            Expanded(
                              child: Text(
                                "I agree to the Terms of Service and Privacy Policy",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ],
                        ),
                        getVerticalSpacer(30),
                        // Register button
                        _buildRegisterButton(),
                        getVerticalSpacer(30),
                        // Login link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account? ",
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            TextButton(
                              onPressed: () => moveToNextPage(AppRoutes.login),
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  color: AppConstants.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        getVerticalSpacer(20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscure = false,
    VoidCallback? onSuffixTap,
    String? prefixText,
    TextInputType? keyboardType,
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
        obscureText: isPassword && obscure,
        keyboardType: keyboardType,
        style: TextStyle(fontSize: 16),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: Icon(icon, color: AppConstants.primaryColor),
          prefixText: prefixText,
          prefixStyle: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          suffixIcon:
              isPassword
                  ? IconButton(
                    icon: Icon(
                      obscure ? Icons.visibility_off : Icons.visibility,
                      color: AppConstants.primaryColor,
                    ),
                    onPressed: onSuffixTap,
                  )
                  : null,
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

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20, color: Colors.grey[800]),
              getHorizontalSpacer(8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpButton() {
    return Obx(
      () =>
          isOtpVerified.value
              ? Container(
                width: 120,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.green.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      color: Colors.green,
                      size: 20,
                    ),
                    getHorizontalSpacer(8),
                    Text(
                      "Verified",
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )
              : SizedBox(
                width: 120,
                child: ElevatedButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    final mobile = _mobileController.text.toString().trim();
                    if (mobile.isEmpty || mobile.length != 10) {
                      Utils.showSnackBar(
                        context,
                        "Please enter a valid mobile number",
                      );
                      return;
                    }
                    sendLoginOtp(
                      context,
                      _emailController.text.toString().trim(),
                      repo,
                      _otpController,
                      isOtpVerified,
                      isOtpSent,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "Get OTP",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: validateFields,
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
          "Create Account",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void callRegisterUserApi(
    BuildContext context,
    String fullName,
    String email,
    String mobileNo,
    String password,
  ) async {
    final registerUserResponse = await repo.registerUser(
      fullName,
      email,
      mobileNo,
      password,
    );
    // if (Utils.isSuccessfulResponse(registerUserResponse)) {
    moveToNextPage(AppRoutes.login);
    //     showGetXSnackBar(registerUserResponse.statusMessage.toString());
    //   } else {
    //     showGetXSnackBar(registerUserResponse.statusMessage.toString());
    //   }
    // }
  }

  void sendLoginOtp(
    BuildContext context,
    String email,
    AuthRepository repo,
    TextEditingController otpController,
    RxBool isOtpVerified,
    RxBool isOtpSent,
  ) async {
    // final loginOtpResponse = await repo.loginOtpRequest(email);
    // if (Utils.isSuccessfulResponse(loginOtpResponse)) {
    showBottomSheet(context, otpController, isOtpVerified, email, isOtpSent);
    //   isOtpSent.value = true;
    //   showGetXSnackBar(loginOtpResponse.statusMessage.toString());
    // } else {
    //   isOtpSent.value = false;
    //   showGetXSnackBar(loginOtpResponse.statusMessage.toString());
    // }
  }

  void showBottomSheet(
    BuildContext context,
    TextEditingController otpController,
    RxBool isOtpVerified,
    String email,
    RxBool isOtpSent,
  ) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Drag handle
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    getVerticalSpacer(30),
                    // OTP Icon
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppConstants.primaryColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.lock_outline_rounded,
                        size: 32,
                        color: AppConstants.primaryColor,
                      ),
                    ),
                    getVerticalSpacer(24),
                    // Title
                    Text(
                      "OTP Verification",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    getVerticalSpacer(12),
                    // Subtitle
                    Text(
                      "Enter the 6-digit code sent to your mobile number",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                    ),
                    getVerticalSpacer(30),
                    // OTP Input
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: PinCodeTextField(
                        appContext: context,
                        length: 6,
                        controller: otpController,
                        keyboardType: TextInputType.number,
                        animationType: AnimationType.fade,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(12),
                          fieldHeight: 56,
                          fieldWidth: 44,
                          activeFillColor: Colors.white,
                          inactiveColor: Colors.grey[200],
                          selectedColor: AppConstants.primaryColor,
                          activeColor: AppConstants.primaryColor,
                          selectedFillColor: Colors.white,
                          inactiveFillColor: Colors.grey[50],
                          borderWidth: 1.5,
                        ),
                        animationDuration: const Duration(milliseconds: 300),
                        enableActiveFill: true,
                        cursorColor: AppConstants.primaryColor,
                        onChanged: (value) {},
                      ),
                    ),
                    getVerticalSpacer(32),
                    // Verify Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          final otp = otpController.text.toString().trim();
                          if (otp.isEmpty || otp.length != 6) {
                            Utils.showSnackBar(
                              context,
                              "Please enter a valid OTP",
                            );
                            return;
                          } else {
                            verifyLoginOtp(otp, isOtpVerified, email);
                            Navigator.of(context).pop();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConstants.primaryColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          "Verify OTP",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    getVerticalSpacer(24),
                    // Resend OTP
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Didn't receive the code? ",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            resendLoginOtp(email, isOtpVerified, isOtpSent);
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            "Resend OTP",
                            style: TextStyle(
                              color: AppConstants.primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
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
      },
    );
  }

  void resendLoginOtp(
    String email,
    RxBool isOtpVerified,
    RxBool isOtpSent,
  ) async {
    final repo = Get.find<AuthRepository>();
    final loginOtpResponse = await repo.loginOtpRequest(email);
    if (Utils.isSuccessfulResponse(loginOtpResponse)) {
      isOtpSent.value = true;
      showGetXSnackBar(loginOtpResponse.statusMessage.toString());
    } else {
      isOtpSent.value = false;
      showGetXSnackBar(loginOtpResponse.statusMessage.toString());
    }
  }

  void verifyLoginOtp(String otp, RxBool isOtpVerified, String email) async {
    // final repo = Get.find<AuthRepository>();
    // final verifyOtpResponse = await repo.loginOtpVerify(otp, email);
    // if (Utils.isSuccessfulResponse(verifyOtpResponse)) {
    isOtpVerified.value = true;
    // Get.snackbar(
    //   "OTP verified successfully",
    //   verifyOtpResponse.statusMessage.toString(),
    // );
    // } else {
    //   isOtpVerified.value = false;
    //   Get.snackbar(
    //     'There is some error in OTP verification',
    //     verifyOtpResponse.statusMessage.toString(),
    //   );
  }
}
