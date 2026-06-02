import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/constant.dart';
import '../utils/api_service.dart';

class RegisterState {
  final bool isLoading;
  final String selectedRole;

  const RegisterState({
    this.isLoading = false,
    this.selectedRole = 'Brand Owner',
  });

  RegisterState copyWith({
    bool? obscurePassword,
    bool? isLoading,
    String? selectedRole,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      selectedRole: selectedRole ?? this.selectedRole,
    );
  }
}

class RegisterViewModel extends Notifier<RegisterState> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  final nameFocus = FocusNode();
  final phoneFocus = FocusNode();
  final emailFocus = FocusNode();

  final ApiService apiService = ApiService();

  @override
  RegisterState build() {
    ref.onDispose(() {
      nameController.dispose();
      phoneController.dispose();
      emailController.dispose();
      nameFocus.dispose();
      phoneFocus.dispose();
      emailFocus.dispose();
    });

    return const RegisterState();
  }

  void setRole(String role) {
    state = state.copyWith(selectedRole: role);
  }

  void clear() {
    nameController.clear();
    phoneController.clear();
    emailController.clear();
    state = const RegisterState();
  }

  Future<bool> register(int selectedRole) async {
    try {
      state = state.copyWith(isLoading: true);

      final response = await apiService.registerPostAPI(
        phone: phoneController.text.trim(),
        email: emailController.text.trim(),
        name: nameController.text.trim(),
        customerType: selectedRole,
      );

      if (response["success"] == true) {
        AppToast.showSuccess(
          response["message"] ?? "Registration successful",
        );
        return true;
      } else {
        AppToast.showError(
          response["message"] ?? "Registration failed",
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

final registerViewModelProvider =
    NotifierProvider.autoDispose<RegisterViewModel, RegisterState>(
      RegisterViewModel.new,
    );
