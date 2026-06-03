import 'package:apartment_client_app/models/gst_verification_model.dart';
import 'package:apartment_client_app/models/otp_model.dart';
import 'package:dio/dio.dart';

class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'http://192.168.0.2:5000',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  Future<Map<String, dynamic>> loginPostAPI({required String phone}) async {
    try {
      final response = await _dio.post(
        '/user/login',
        data: {'userPhone': phone},
      );

      return response.data;
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? e.message ?? 'Something went wrong';

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
      print('userName: $name');
      print('userPhone: $phone');
      print('customerType: $customerType');
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

  Future<OTPVerify> verifyOtpPostAPI({
    required String phone,
    required String otp,
    required String api,
    int? customerType,
  }) async {
    print('otp: $otp');
    print('api: $api');
    print('userPhone: $phone');
    print('customerType: $customerType');
    try {
      final response = await _dio.post(
        api,
        data: {
          'userPhone': phone,
          'otp': otp,
          if (customerType != null && customerType.toString().isNotEmpty)
            'customerType': customerType,
        },
      );
      print(response.realUri);
      return OTPVerify.fromJson(response.data);
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ??
          e.message ??
          'OTP verification failed';
      throw Exception(message);
    } catch (e) {
      throw Exception('API Error: $e');
    }
  }

  Future<Map<String, dynamic>> resendOtpPostAPI({
    required String phone,
    required String api,
  }) async {
    try {
      final response = await _dio.post(api, data: {'userPhone': phone});
      print(response.realUri);

      return response.data;
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ??
          e.message ??
          'OTP verification failed';
      throw Exception(message);
    } catch (e) {
      throw Exception('API Error: $e');
    }
  }

  Future<GstVerification> gstVerify(String? gstNumber) async {
    try {
      final response = await _dio.post(
        '/gstdetails/verify',
        data: GstVerification(gstNumber: gstNumber).toJson(),
      );
      print(response.realUri);

      return GstVerification.fromJson(response.data);
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ??
          e.message ??
          'GST verification failed';
      throw Exception(message);
    } catch (e) {
      throw Exception('API Error: $e');
    }
  }
}
