import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talento_flutter/core/constants/constants.dart';
import 'package:talento_flutter/core/utils/time_tracker.dart';
import 'package:talento_flutter/core/utils/utils.dart';
import 'package:talento_flutter/presentation/routes/routes.dart';
import 'package:talento_flutter/presentation/screens/auth/repository/auth_repository.dart';
import 'package:talento_flutter/presentation/widgets/helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  final repo = Get.find<AuthRepository>();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

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
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void validateFields() async {
    final username = _userNameController.text.trim();
    final password = _passwordController.text.trim();
    if (username.isEmpty) {
      Utils.showSnackBar(context, "Username can't be empty");
      return;
    } else if (password.isEmpty) {
      Utils.showSnackBar(context, "Password can't be empty");
      return;
    } else if (await checkInternet(context)) {
      callLoginUserApi(username, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TimeTracker(
      screenName: AppConstants.loginUserScreen,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      getVerticalSpacer(50),
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
                      getVerticalSpacer(30),
                      Text(
                        "Talento",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.primaryColor,
                          letterSpacing: 1.5,
                        ),
                      ),
                      getVerticalSpacer(10),
                      Text(
                        "Welcome back! Please login to continue",
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      getVerticalSpacer(40),
                      // Login form
                      _buildInputField(
                        controller: _userNameController,
                        hint: "Phone or Email",
                        icon: Icons.person_outline,
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
                      getVerticalSpacer(15),
                      // Forgot password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed:
                              () => moveToNextPage(AppRoutes.forgotPassword),
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: AppConstants.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      getVerticalSpacer(30),
                      // Login button
                      Obx(() {
                        return repo.isLoading.value
                            ? const CircularProgressIndicator()
                            : _buildLoginButton();
                      }),
                      getVerticalSpacer(30),
                      // Social login
                      _buildSocialLogin(),
                      getVerticalSpacer(30),
                      // Sign up link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          TextButton(
                            onPressed: () => moveToNextPage(AppRoutes.register),
                            child: Text(
                              "Sign Up",
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
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscure = false,
    VoidCallback? onSuffixTap,
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
        style: TextStyle(fontSize: 16),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: Icon(icon, color: AppConstants.primaryColor),
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

  Widget _buildLoginButton() {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [
            AppConstants.primaryColor,
            AppConstants.primaryColor.withValues(alpha: 0.8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppConstants.primaryColor.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: MaterialButton(
        onPressed: () {
          //validateFields();
          moveToNextPage(AppRoutes.dashboard);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Text(
          "Login",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialLogin() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: Colors.grey[400])),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "Or continue with",
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            Expanded(child: Divider(color: Colors.grey[400])),
          ],
        ),
        getVerticalSpacer(20),
      ],
    );
  }

  void callLoginUserApi(String email, String password) async {
    printInDebugMode(email);
    printInDebugMode(password);
    final loginResponse = await repo.loginUser(email, password);
    if (Utils.isSuccessfulResponse(loginResponse)) {
      showGetXSnackBar(loginResponse.statusMessage.toString());
      moveToNextPage(AppRoutes.dashboard);
      setLoginStatus(true);
    } else {
      showGetXSnackBar(loginResponse.statusMessage.toString());
    }
  }
}
