import 'package:dio/dio.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
      await GoogleSignIn().signOut();
      await FacebookAuth.instance.logOut();
    }
  }

  // Social Login: Google
  Future<ApiResponse<Map<String, dynamic>>> signInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
        serverClientId:"1044181229454-lgt5dcunhu3k9113hr05dcefdo4gn62i.apps.googleusercontent.com"
      );
      
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return ApiResponse(success: false, message: 'Google sign in dibatalkan', code: 401);
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? serverAuthCode = googleUser.serverAuthCode;

      final response = await _apiClient.dio.get('/api/auth/google/callback', queryParameters: {
        'code': serverAuthCode,
        'id_token': googleAuth.idToken,
        'access_token': googleAuth.accessToken,
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
      return ApiResponse(success: false, message: 'Google login gagal', code: response.statusCode ?? 500);
    } catch (e) {
      return ApiResponse(success: false, message: 'Terjadi kesalahan: $e', code: 500);
    }
  }

  // Social Login: Facebook
  Future<ApiResponse<Map<String, dynamic>>> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      
      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        
        final response = await _apiClient.dio.post('/api/auth/facebook', data: {
          'access_token': accessToken.token,
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
        return ApiResponse(success: false, message: 'Facebook login gagal', code: response.statusCode ?? 500);
      } else {
        return ApiResponse(success: false, message: 'Facebook login dibatalkan atau error', code: 401);
      }
    } catch (e) {
      return ApiResponse(success: false, message: 'Terjadi kesalahan: $e', code: 500);
    }
  }
}
