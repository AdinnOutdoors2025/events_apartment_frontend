import 'dart:async';

import 'package:apartment_client_app/models/otp_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/constant.dart';
import '../utils/api_service.dart';

class OtpState {
  final bool isLoading;
  final bool isResending;
  final int resendSeconds;

  const OtpState({
    this.isLoading = false,
    this.isResending = false,
    this.resendSeconds = 30,
  });

  bool get canResend => resendSeconds == 0;

  OtpState copyWith({bool? isLoading, bool? isResending, int? resendSeconds}) {
    return OtpState(
      isLoading: isLoading ?? this.isLoading,
      isResending: isResending ?? this.isResending,
      resendSeconds: resendSeconds ?? this.resendSeconds,
    );
  }
}

class OtpViewModel extends Notifier<OtpState> {
  final ApiService apiService = ApiService();

  Timer? _timer;

  String otpCode = '';
  String phoneNumber = '';

  @override
  OtpState build() {
    ref.onDispose(() {
      _timer?.cancel();
    });

    Future.microtask(() {
      startResendTimer();
    });

    return const OtpState();
  }

  void setPhoneNumber(String phone) {
    phoneNumber = phone;
  }

  void setOtp(String otp) {
    otpCode = otp;
  }

  void startResendTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.resendSeconds <= 1) {
        timer.cancel();
        state = state.copyWith(resendSeconds: 0);
      } else {
        state = state.copyWith(resendSeconds: state.resendSeconds - 1);
      }
    });
  }

  Future<void> resendOtp(String? otpType) async {
    if (!state.canResend) return;

    try {
      state = state.copyWith(isResending: true);

      otpCode = '';
      final response = await apiService.resendOtpPostAPI(
        phone: phoneNumber,
        api: otpType == 'login' ? '/user/resend-login-otp' : '/user/resend-otp',
      );

      if (response["success"] == true) {
        print(response["message"]);
        print(response["testOtp"]);
        AppToast.showSuccess(
          '${response["message"]} and your test Otp is ${response['testOtp']}' ??
              "OTP sent successfully",
        );
        startResendTimer();
        return;
      } else {
        print(response["message"]);
        AppToast.showError(response["message"] ?? "Registration failed");
        return;
      }
    } catch (e) {
      print(e.toString());
      AppToast.showError(e.toString());
    } finally {
      state = state.copyWith(isResending: false);
    }
  }

  Future<OTPVerify?> verifyOtp(String otpType, int? customerType) async {
    try {
      state = state.copyWith(isLoading: true);

      final response = await apiService.verifyOtpPostAPI(
        phone: phoneNumber,
        otp: otpCode,
        customerType: customerType,
        api: otpType == 'login' ? '/user/login-verify' : '/user/verify-otp',
      );

      if (response.success == true) {
        await StorageService.saveToken(response.token!);
        await StorageService.saveId(response.user!.sId!);

        AppToast.showSuccess(response.message ?? '');

        return response;
      }

      AppToast.showError(response.message ?? "Login failed");
      return null;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final otpViewModelProvider =
    NotifierProvider.autoDispose<OtpViewModel, OtpState>(OtpViewModel.new);
