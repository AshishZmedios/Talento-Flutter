import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:talento_flutter/data/services/api_client.dart';
import 'package:talento_flutter/presentation/widgets/helper.dart';

class AuthRepository extends GetxController {
  // Apis end points
  static const String login = 'login';
  static const String register = 'signup';
  static const String otpRequest = 'login/otp/request';
  static const String otpVerify = 'login/otp/verify';
  var isLoading = false.obs;

  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  Future<dio.Response> loginUser(String email, String password) async {
    try {
      isLoading.value = true;
      final response = await _apiClient.dio.post(
        login,
        data: '''{"email": "$email","password": "$password"}''',
      );
      return response;
    } catch (e) {
      isLoading.value = false;
      showGetXSnackBar(e.toString());
      printInDebugMode('Login failed: $e');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<dio.Response> registerUser(
    String fullName,
    String email,
    String mobileNo,
    String password,
  ) async {
    try {
      final response = await _apiClient.dio.post(
        register,
        data: '''{
        "fullName": "$fullName",
        "email": "$email",
        "password": "$password",
        "mobileNum": "$mobileNo",
        "confirmPassword": "$password"}''',
      );
      return response;
    } catch (e) {
      showGetXSnackBar(e.toString());
      printInDebugMode('Register failed: $e');
      rethrow;
    }
  }

  Future<dio.Response> loginOtpRequest(String email) async {
    try {
      final response = await _apiClient.dio.post(
        otpRequest,
        data: '''{"email": "$email"}''',
      );
      return response;
    } catch (e) {
      showGetXSnackBar(e.toString());
      printInDebugMode('Error in getting otp: $e');
      rethrow;
    }
  }

  Future<dio.Response> loginOtpVerify(String email, String otp) async {
    try {
      final response = await _apiClient.dio.post(
        otpVerify,
        data: '''{"email": "$email","otp": "$otp"}''',
      );
      return response;
    } catch (e) {
      showGetXSnackBar(e.toString());
      printInDebugMode('Error in otp verification: $e');
      rethrow;
    }
  }
}
