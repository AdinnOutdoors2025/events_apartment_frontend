import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/constant.dart';
import '../utils/api_service.dart';

class LoginState {
  final bool obscurePassword;
  final bool isLoading;

  const LoginState({
    this.obscurePassword = true,
    this.isLoading = false,
  });

  LoginState copyWith({
    bool? obscurePassword,
    bool? isLoading,
  }) {
    return LoginState(
      obscurePassword: obscurePassword ?? this.obscurePassword,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class LoginViewModel extends Notifier<LoginState> {

  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  final phoneFocus = FocusNode();
  final passwordFocus = FocusNode();

  final ApiService apiService = ApiService();

  @override
  LoginState build() {
    ref.onDispose(() {
      phoneController.dispose();
      passwordController.dispose();
      phoneFocus.dispose();
      passwordFocus.dispose();
    });

    return const LoginState();
  }

  void togglePasswordVisibility() {
    state = state.copyWith(
      obscurePassword: !state.obscurePassword,
    );
  }


  Future<bool> login() async {

    try {
      state = state.copyWith(isLoading: true);

      final response = await apiService.loginPostAPI(
        phone: phoneController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (response["success"] == true) {
        final token = response["data"]["token"];

        await StorageService.saveToken(token);

        AppToast.showSuccess(response["message"]);

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

final loginViewModelProvider =
NotifierProvider.autoDispose<LoginViewModel, LoginState>(
  LoginViewModel.new,
);