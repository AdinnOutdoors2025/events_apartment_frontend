import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/constant.dart';
import '../utils/api_service.dart';

class LoginState {
  final bool isLoading;

  const LoginState({
    this.isLoading = false,
  });

  LoginState copyWith({
    bool? isLoading,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class LoginViewModel extends Notifier<LoginState> {

  final phoneNumber = TextEditingController();

  final phoneNumberFocus = FocusNode();

  final ApiService apiService = ApiService();

  @override
  LoginState build() {
    ref.onDispose(() {
      phoneNumber.dispose();
      phoneNumberFocus.dispose();
    });

    return const LoginState();
  }


  void clear() {
    phoneNumber.clear();
    state = const LoginState();
  }


  Future<bool> login() async {

    try {
      state = state.copyWith(isLoading: true);

      final response = await apiService.loginPostAPI(
        phone: phoneNumber.text.trim(),
      );

      if (response["success"] == true) {

        print(response["message"]);
        print(response["data"]["testOtp"]);
        AppToast.showSuccess(
          '${response["message"]} and your test Otp is ${response["data"]['testOtp']}',
        );

        return true;
      } else {
        AppToast.showError(
          response["message"] ?? "Login failed",
        );
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

final loginViewModelProvider =
NotifierProvider.autoDispose<LoginViewModel, LoginState>(
  LoginViewModel.new,
);