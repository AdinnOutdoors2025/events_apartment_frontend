import 'package:dio/dio.dart';

class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'http://localhost:5000',
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
  }) async {
    try {
      final response = await _dio.post(
        '/user/login',
        data: {
          'userPhone': phone,
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
    required String name,
    required String phone,
    required int customerType,
    String? email,
  }) async {
    try {
      final response = await _dio.post(
        '/user/register',
        data: {
          'userName': name,
          'userPhone': phone,
          'customerType': customerType,
          if (email != null && email.isNotEmpty) 'userEmail': email,
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
        '/user/verify-otp',
        data: {
          'userPhone': phone,
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