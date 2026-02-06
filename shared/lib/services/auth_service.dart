import 'package:dio/dio.dart';
import '../models/api_response.dart';
import 'api_client.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();

  // Cek login status berdasarkan keberadaan token
  Future<bool> isLoggedIn() async {
    final token = await _apiClient.getToken();
    return token != null;
  }

  // Login User
  Future<ApiResponse<Map<String, dynamic>>> login(String email, String password) async {
    try {
      final response = await _apiClient.dio.post('/api/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final apiRes = ApiResponse<Map<String, dynamic>>.fromJson(
          response.data,
          (json) => json as Map<String, dynamic>,
        );
        
        if (apiRes.success && apiRes.data != null) {
          final token = apiRes.data!['token'];
          if (token != null) {
            await _apiClient.saveToken(token);
          }
        }
        return apiRes;
      }
      
      return ApiResponse(
        success: false,
        message: 'Login gagal',
        code: response.statusCode ?? 500,
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data['message'] ?? 'Terjadi kesalahan koneksi',
        code: e.response?.statusCode ?? 500,
      );
    }
  }

  // Register User
  Future<ApiResponse<dynamic>> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.dio.post('/api/register', data: {
        'full_name': fullName,
        'email': email,
        'password': password,
      });

      return ApiResponse.fromJson(response.data, (json) => json);
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data['message'] ?? 'Gagal mendaftar',
        code: e.response?.statusCode ?? 500,
      );
    }
  }

  // Verify OTP
  Future<ApiResponse<Map<String, dynamic>>> verifyOtp(String email, String code) async {
    try {
      final response = await _apiClient.dio.post('/api/verify-otp', data: {
        'email': email,
        'code': code,
      });

      if (response.statusCode == 200) {
        final apiRes = ApiResponse<Map<String, dynamic>>.fromJson(
          response.data,
          (json) => json as Map<String, dynamic>,
        );
        
        if (apiRes.success && apiRes.data != null) {
          final token = apiRes.data!['token'];
          if (token != null) {
            await _apiClient.saveToken(token);
          }
        }
        return apiRes;
      }
      return ApiResponse(success: false, message: 'Verifikasi gagal', code: response.statusCode ?? 500);
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data['message'] ?? 'Gagal verifikasi',
        code: e.response?.statusCode ?? 500,
      );
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _apiClient.dio.post('/api/logout');
    } finally {
      await _apiClient.clearToken();
    }
  }
}
