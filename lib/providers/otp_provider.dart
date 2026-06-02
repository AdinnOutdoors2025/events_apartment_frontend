import 'dart:async';

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

  Future<void> resendOtp() async {
    if (!state.canResend) return;

    try {
      state = state.copyWith(isResending: true);

      /// Call your resend OTP API
      /* await apiService.verifyOtpPostAPI(
        phone: phoneNumber, otp: '',
      );*/
      ref.read(otpViewModelProvider.notifier).startResendTimer();

      AppToast.showSuccess("OTP resent successfully");

      startResendTimer();
    } catch (e) {
      AppToast.showError(e.toString());
    } finally {
      state = state.copyWith(isResending: false);
    }
  }

  Future<bool> verifyOtp() async {
    try {
      state = state.copyWith(isLoading: true);

      final response = await apiService.verifyOtpPostAPI(
        phone: phoneNumber,
        otp: otpCode,
      );

      if (response["success"] == true) {
        /*  final token = response["data"]["token"];

        await StorageService.saveToken(token);*/

        AppToast.showSuccess(response["message"]);

        return true;
      } else {
        AppToast.showError(response["message"] ?? "Login failed");
        return false;
      }
    } catch (e) {
      AppToast.showError(e.toString());
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final otpViewModelProvider =
    NotifierProvider.autoDispose<OtpViewModel, OtpState>(OtpViewModel.new);
