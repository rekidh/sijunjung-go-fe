import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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
          final refreshToken = apiRes.data!['refresh_token'];
          if (token != null) {
            await _apiClient.saveToken(token);
            if (refreshToken != null) {
              await _apiClient.saveRefreshToken(refreshToken);
            }
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

  // Verify OTP (Email)
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
          final refreshToken = apiRes.data!['refresh_token'];
          if (token != null) {
            await _apiClient.saveToken(token);
            if (refreshToken != null) {
              await _apiClient.saveRefreshToken(refreshToken);
            }
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

  // WhatsApp OTP: Send
  Future<ApiResponse<dynamic>> sendWhatsAppOtp(String phone) async {
    try {
      // Clear any stale token before login attempt to avoid 401 from invalid tokens
      await _apiClient.clearToken();
      
      final response = await _apiClient.dio.post('/api/whatsapp/send-otp', data: {
        'phone': phone,
      });
      return ApiResponse.fromJson(response.data, (json) => json);
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data['message'] ?? 'Gagal mengirim OTP via WhatsApp',
        code: e.response?.statusCode ?? 500,
      );
    }
  }

  // WhatsApp OTP: Verify
  Future<ApiResponse<Map<String, dynamic>>> verifyWhatsAppOtp(String phone, String code) async {
    try {
      final response = await _apiClient.dio.post('/api/whatsapp/verify-otp', data: {
        'phone': phone,
        'code': code,
      });

      if (response.statusCode == 200) {
        final apiRes = ApiResponse<Map<String, dynamic>>.fromJson(
          response.data,
          (json) => json as Map<String, dynamic>,
        );
        
        if (apiRes.success && apiRes.data != null) {
          final token = apiRes.data!['token'];
          final refreshToken = apiRes.data!['refresh_token'];
          if (token != null) {
            await _apiClient.saveToken(token);
            if (refreshToken != null) {
              await _apiClient.saveRefreshToken(refreshToken);
            }
          }
        }
        return apiRes;
      }
      return ApiResponse(success: false, message: 'Verifikasi WhatsApp gagal', code: response.statusCode ?? 500);
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: e.response?.data['message'] ?? 'Gagal verifikasi WhatsApp',
        code: e.response?.statusCode ?? 500,
      );
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _apiClient.dio.post('/api/logout');
    } catch (e) {
      // Ignore network errors for logout to ensure local logout completes
      debugPrint('Logout request failed: $e');
    } finally {
      await _apiClient.clearToken();
      // Safely sign out from social providers
      try {
        await GoogleSignIn().signOut();
      } catch (_) {}
      
      try {
        await FacebookAuth.instance.logOut();
      } catch (_) {}
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

      final response = await _apiClient.dio.post('/api/auth/google-mobile', data: {
        'id_token': googleAuth.idToken,
      });

      if (response.statusCode == 200) {
        final apiRes = ApiResponse<Map<String, dynamic>>.fromJson(
          response.data,
          (json) => json as Map<String, dynamic>,
        );
        
        if (apiRes.success && apiRes.data != null) {
          final token = apiRes.data!['token'];
          final refreshToken = apiRes.data!['refresh_token'];
          if (token != null) {
            await _apiClient.saveToken(token);
            if (refreshToken != null) {
              await _apiClient.saveRefreshToken(refreshToken);
            }
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
            final refreshToken = apiRes.data!['refresh_token'];
            if (token != null) {
              await _apiClient.saveToken(token);
              if (refreshToken != null) {
                await _apiClient.saveRefreshToken(refreshToken);
              }
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
