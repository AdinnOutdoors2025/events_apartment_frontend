import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/color.dart';
import '../constants/constant.dart';
import '../providers/register_provider.dart';
import '../widgets/customButton.dart';
import '../widgets/customTextField.dart';

class RegisterPage extends ConsumerWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(registerViewModelProvider);
    final viewModel = ref.read(registerViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'GET STARTED',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                    color: AppColors.textGrey,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Create your account',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Book apartment activations, add stage and promoters, and request quotes for premium communities.',
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: AppColors.textGrey,
                  ),
                ),

                const SizedBox(height: 20),

                /// HERO CARD
                Container(
                  height: 170,
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF000000), Color(0xFF2B0000)],
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Color(0xFFE5212A),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.ac_unit,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),

                            const SizedBox(height: 14),

                            const Text(
                              'Launch apartment\ncampaigns with the\nright spaces and\non-ground support.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                height: 1.15,
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// SVG BUILDING HERE
                      SizedBox(
                        width: 100,
                        child: Center(
                          child: Text(
                            'SVG',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                RegisterForm(state: state, viewModel: viewModel),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterForm extends ConsumerStatefulWidget {
  final RegisterState state;
  final RegisterViewModel viewModel;

  const RegisterForm({super.key, required this.state, required this.viewModel});

  @override
  ConsumerState<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          /// FULL NAME
          CustomTextField(
            prefixIcon: Icons.person_outline,
            hintText: "Full name",
            controller: widget.viewModel.nameController,
            focusNode: widget.viewModel.nameFocus,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Name is required";
              }

              if (value.trim().length < 3) {
                return "Enter a valid name";
              }

              return null;
            },
          ),

          const SizedBox(height: 12),

          /// PHONE
          CustomTextField(
            prefixIcon: Icons.phone_outlined,
            hintText: "Phone number",
            keyboardType: TextInputType.phone,
            controller: widget.viewModel.phoneController,
            focusNode: widget.viewModel.phoneFocus,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Phone number is required";
              }

              if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value.trim())) {
                return "Enter a valid 10 digit mobile number";
              }

              return null;
            },
          ),

          const SizedBox(height: 12),

          /// EMAIL
          CustomTextField(
            prefixIcon: Icons.mail_outline,
            hintText: "Email(Optional)",
            keyboardType: TextInputType.emailAddress,
            controller: widget.viewModel.emailController,
            focusNode: widget.viewModel.emailFocus,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return null;
              }

              if (!RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              ).hasMatch(value.trim())) {
                return "Enter a valid email";
              }

              return null;
            },
          ),

          const SizedBox(height: 18),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "I am a",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _roleButton(
                  title: "Brand Owner",
                  icon: Icons.apartment,
                  selected: widget.state.selectedRole == "Brand Owner",
                  onTap: () {
                    widget.viewModel.setRole("Brand Owner");
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _roleButton(
                  title: "Agency",
                  icon: Icons.groups_outlined,
                  selected: widget.state.selectedRole == "Agency",
                  onTap: () {
                    widget.viewModel.setRole("Agency");
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          SizedBox(
            height: 52,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                if (!(_formKey.currentState?.validate() ?? false)) {
                  return;
                }

                final success = await widget.viewModel.register(
                  widget.state.selectedRole == "Brand Owner" ? 1 : 2,
                );

                if (success && context.mounted) {
                  Navigator.pushNamed(
                    context,
                    '/otp',
                    arguments: {
                      'phoneNumber': widget.viewModel.phoneController.text
                          .trim(),
                      'otpType': 'register',
                      'customerType': widget.state.selectedRole == "Brand Owner"
                          ? 1
                          : 2,
                    },
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: const StadiumBorder(),
              ),
              child: const Text(
                "Create account",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            height: 52,
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              style: OutlinedButton.styleFrom(
                shape: const StadiumBorder(),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              child: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(color: Colors.black54),
                    ),
                    TextSpan(
                      text: "Login",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "By continuing, you agree to the ",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
                const TextSpan(
                  text: "Terms & Privacy Policy.",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _roleButton({
    required String title,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: selected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? Colors.red : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: selected ? Colors.red : Colors.grey),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
