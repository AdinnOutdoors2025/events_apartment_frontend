import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/color.dart';
import '../providers/login_provider.dart';
import '../widgets/customButton.dart';
import '../widgets/customTextField.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginViewModelProvider);
    final viewModel = ref.read(loginViewModelProvider.notifier);
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'WELCOME BACK',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Login to ADINN',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Plan apartment activations, manage campaigns,\nand request quotes in minutes.',
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.4,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(24),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0A0A0A), Color(0xFF2B0000)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE5212A),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.ac_unit,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Campaigns for\npremium communities,\nbuilt in minutes.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                      SvgPicture.asset(
                        AppImages.loginAsset,
                        height: 80,
                        width: 40,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        prefixIcon: Icons.phone,
                        hintText: 'Mobile number',
                        iconColor: Colors.black54,
                        keyboardType: TextInputType.phone,
                        controller: viewModel.phoneNumber,
                        focusNode: viewModel.phoneNumberFocus,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Enter mobile number';
                          }

                          if (value.trim().length != 10) {
                            return 'Enter valid mobile number';
                          }

                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: 'Login',
                  isLoading: state.isLoading,
                  onPressed: () async {
                    if (!(formKey.currentState?.validate() ?? false)) {
                      return;
                    }

                    final success = await viewModel.login();
                    if (success && context.mounted) {
                      Navigator.pushNamed(context, '/otp',arguments: {
                        'phoneNumber':viewModel.phoneNumber.text.trim(),
                        'otpType': 'login'
                      });
                    }
                  },
                  color: Colors.black,
                  radius: 24,
                  textColor: Colors.white,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () {
                      ref.read(loginViewModelProvider.notifier).clear();
                      Navigator.pushNamed(context, '/register');
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                        children: [
                          TextSpan(text: "Don't have an account? "),
                          TextSpan(
                            text: "Register",
                            style: TextStyle(color: AppColors.red),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.verified_user_outlined,
                      color: Colors.grey.shade600,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Secure, trusted, and built for brand owners and agencies.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
