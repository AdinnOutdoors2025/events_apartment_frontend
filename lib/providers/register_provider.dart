import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/constant.dart';
import '../utils/api_service.dart';

class RegisterState {
  final bool obscurePassword;
  final bool isLoading;

  const RegisterState({
    this.obscurePassword = true,
    this.isLoading = false,
  });

  RegisterState copyWith({
    bool? obscurePassword,
    bool? isLoading,
  }) {
    return RegisterState(
      obscurePassword: obscurePassword ?? this.obscurePassword,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class RegisterViewModel extends Notifier<RegisterState> {

  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();

  final phoneFocus = FocusNode();
  final passwordFocus = FocusNode();
  final emailFocus = FocusNode();

  final ApiService apiService = ApiService();

  @override
  RegisterState build() {
    ref.onDispose(() {
      phoneController.dispose();
      passwordController.dispose();
      emailController.dispose();
      phoneFocus.dispose();
      passwordFocus.dispose();
      emailFocus.dispose();
    });

    return const RegisterState();
  }

  void togglePasswordVisibility() {
    state = state.copyWith(
      obscurePassword: !state.obscurePassword,
    );
  }


  Future<bool> register() async {


    try {
      state = state.copyWith(isLoading: true);

      final response = await apiService.registerPostAPI(
        phone: phoneController.text.trim(),
        password: passwordController.text.trim(),
        email: emailController.text.trim(),
      );

      if (response["success"] == true) {
        AppToast.showSuccess(response["message"] ?? "Registration successful");
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

final registerViewModelProvider =
    NotifierProvider.autoDispose<RegisterViewModel, RegisterState>(
  RegisterViewModel.new,
);
