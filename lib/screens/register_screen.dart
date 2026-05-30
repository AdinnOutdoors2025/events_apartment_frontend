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
    final keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;
    final isKeyboardOpen = keyboardHeight > 0;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenHeight = constraints.maxHeight;
            final screenWidth = constraints.maxWidth;

            final headerHeight = isKeyboardOpen
                ? screenHeight * 0.36
                : screenHeight * 0.46;

            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut,
                        height: headerHeight,
                        child: RegisterHeader(
                          height: headerHeight,
                          keyboardOpen: isKeyboardOpen,
                        ),
                      ),
                      SizedBox(height: 13),
                      Expanded(
                        child: Transform.translate(
                          offset: Offset(0, isKeyboardOpen ? -25 : -40),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 26),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.topCenter,
                              child: SizedBox(
                                width: screenWidth - 52,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Apartment Events',
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.red,
                                      ),
                                    ),
                                    if (!isKeyboardOpen) ...[
                                      const SizedBox(height: 5),
                                      const Text(
                                        'Join us to manage events and visitors.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 15,
                                          height: 1.3,
                                          color: AppColors.textGrey,
                                        ),
                                      ),
                                      const SizedBox(height: 14),
                                    ] else
                                      const SizedBox(height: 13),
                                    RegisterForm(
                                      state: state,
                                      viewModel: viewModel,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15.0),
                                      child: RichText(
                                        text: TextSpan(
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                          ),
                                          children: [
                                            const TextSpan(
                                              text: "Already have an account? ",
                                            ),
                                            TextSpan(
                                              text: "Login",
                                              style: TextStyle(
                                                color: AppColors.red,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  Navigator.pushNamed(
                                                    context,
                                                    '/login',
                                                  );
                                                },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class RegisterHeader extends StatelessWidget {
  final double height;
  final bool keyboardOpen;

  const RegisterHeader({
    super.key,
    required this.height,
    required this.keyboardOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Image.asset(
          AppImages.background,
          width: double.infinity,
          height: height,
          fit: BoxFit.fill,
          alignment: Alignment.topCenter,
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: keyboardOpen ? 100 : 130,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.white70, Colors.white],
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: -5,
          bottom: keyboardOpen ? 20 : 35,
          child: Center(
            child: Container(
              width: 80,
              height: 80,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(AppImages.logo, fit: BoxFit.contain),
              ),
            ),
          ),
        ),
      ],
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
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 35,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              prefixIcon: Icons.person_outline,
              hintText: 'Mobile Number',
              iconColor: Colors.red,
              keyboardType: TextInputType.number,
              controller: widget.viewModel.phoneController,
              onChanged: (value) {
                if (value.length == 10) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      widget.viewModel.passwordFocus.requestFocus();
                    }
                  });
                }
              },
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              focusNode: widget.viewModel.phoneFocus,
              validator: (value) => Validator.validate(value, "Mobile number"),
            ),
            const SizedBox(height: 14),
            CustomTextField(
              prefixIcon: Icons.lock_outline,
              hintText: 'Password',
              obscureText: widget.state.obscurePassword,
              suffixIcon: widget.state.obscurePassword
                  ? Icons.visibility_off
                  : Icons.visibility,
              iconColor: Colors.red,
              controller: widget.viewModel.passwordController,
              focusNode: widget.viewModel.passwordFocus,
              onSuffixTap: widget.viewModel.togglePasswordVisibility,
              validator: (value) => Validator.validate(value, "Password"),
            ),
            const SizedBox(height: 14),
            CustomTextField(
              prefixIcon: Icons.email_outlined,
              hintText: 'Email (Optional)',
              iconColor: Colors.red,
              keyboardType: TextInputType.emailAddress,
              controller: widget.viewModel.emailController,
              focusNode: widget.viewModel.emailFocus,
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Register',
              isLoading: widget.state.isLoading,
              onPressed: () async {
                if (!_formKey.currentState!.validate()) return;

                /* final success = await viewModel.register();
                if (success && context.mounted) {*/
                Navigator.pushNamed(
                  context,
                  '/otp',
                  // arguments: viewModel.phoneController.text,
                );
                /* }*/
              },
              radius: 14,
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
