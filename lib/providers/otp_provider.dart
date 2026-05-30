import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/constant.dart';
import '../utils/api_service.dart';

class OtpState {
  final bool isLoading;

  const OtpState({
    this.isLoading = false,
  });

  OtpState copyWith({
    bool? isLoading,
  }) {
    return OtpState(
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class OtpViewModel extends Notifier<OtpState> {
  final ApiService apiService = ApiService();
  String otpCode = '';
  String phoneNumber = '';

  @override
  OtpState build() {
    return const OtpState();
  }

  void setPhoneNumber(String phone) {
    phoneNumber = phone;
  }
  
  void setOtp(String otp) {
    otpCode = otp;
  }

  Future<bool> verifyOtp() async {
    if (otpCode.length != 6) {
      AppToast.showError("Please enter a valid 6-digit OTP");
      return false;
    }

    try {
      state = state.copyWith(isLoading: true);

      final response = await apiService.verifyOtpPostAPI(
        phone: phoneNumber,
        otp: otpCode,
      );

      if (response["success"] == true) {
        final token = response["data"]?["token"];
        if (token != null) {
          await StorageService.saveToken(token);
        }
        AppToast.showSuccess(response["message"] ?? "OTP verified");
        return true;
      } else {
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
    NotifierProvider.autoDispose<OtpViewModel, OtpState>(
  OtpViewModel.new,
);
