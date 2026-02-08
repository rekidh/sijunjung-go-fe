import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/env_config.dart';

class ApiClient {
  static const String baseUrl = EnvConfig.baseUrl;
  final Dio dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  ApiClient()
      : dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ) {
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => debugPrint(obj.toString()),
      ),
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: 'token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          debugPrint('DIO ERROR: ${e.type} -> ${e.message}');
          if (e.response != null) {
            debugPrint('DIO ERROR DATA: ${e.response?.data}');
          }

          // Handle 401 Unauthorized - Try to refresh token
          if (e.response?.statusCode == 401) {
            final refreshToken = await _storage.read(key: 'refresh_token');
            if (refreshToken != null) {
              try {
                // Use a separate Dio instance to avoid interceptor recursion
                final refreshDio = Dio(BaseOptions(baseUrl: baseUrl));
                final response = await refreshDio.post('/api/user/refresh-token', data: {
                  'refresh_token': refreshToken,
                });

                if (response.statusCode == 200) {
                  final newToken = response.data['data']['token'];
                  final newRefreshToken = response.data['data']['refresh_token'];
                  
                  if (newToken != null) {
                    await saveToken(newToken);
                    if (newRefreshToken != null) {
                      await saveRefreshToken(newRefreshToken);
                    }

                    // Retry the original request with the new token
                    final options = e.requestOptions;
                    options.headers['Authorization'] = 'Bearer $newToken';
                    
                    final retryResponse = await dio.fetch(options);
                    return handler.resolve(retryResponse);
                  }
                }
              } catch (refreshError) {
                debugPrint('TOKEN REFRESH FAILED: $refreshError');
                // If refresh fails, clear tokens and let the error pass through
                await clearToken();
              }
            }
          }

          return handler.next(e);
        },
      ),
    );
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: 'refresh_token', value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'refresh_token');
  }

  Future<void> clearToken() async {
    await _storage.delete(key: 'token');
    await _storage.delete(key: 'refresh_token');
  }
}
