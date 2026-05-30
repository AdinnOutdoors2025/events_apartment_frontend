import 'package:dio/dio.dart';

class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://yourapi.com/api',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  Future<Map<String, dynamic>> loginPostAPI({
    required String phone,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {
          'phone': phone,
          'password': password,
        },
      );

      return response.data;
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ??
              e.message ??
              'Something went wrong';

      throw Exception(message);
    } catch (e) {
      throw Exception('API Error: $e');
    }
  }

  Future<Map<String, dynamic>> registerPostAPI({
    required String phone,
    required String password,
    String? email,
  }) async {
    try {
      final response = await _dio.post(
        '/register',
        data: {
          'phone': phone,
          'password': password,
          if (email != null && email.isNotEmpty) 'email': email,
        },
      );
      return response.data;
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? e.message ?? 'Registration failed';
      throw Exception(message);
    } catch (e) {
      throw Exception('API Error: $e');
    }
  }

  Future<Map<String, dynamic>> verifyOtpPostAPI({
    required String phone,
    required String otp,
  }) async {
    try {
      final response = await _dio.post(
        '/verify-otp',
        data: {
          'phone': phone,
          'otp': otp,
        },
      );
      return response.data;
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? e.message ?? 'OTP verification failed';
      throw Exception(message);
    } catch (e) {
      throw Exception('API Error: $e');
    }
  }
}