import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';
import '../constants/color.dart';
import '../constants/constant.dart';
import '../providers/otp_provider.dart';
import '../widgets/customButton.dart';

class OtpPage extends ConsumerWidget {
  const OtpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We expect the phone number to be passed as an argument
    final phoneArgs = ModalRoute.of(context)?.settings.arguments as String?;
    
    final state = ref.watch(otpViewModelProvider);
    final viewModel = ref.read(otpViewModelProvider.notifier);
    
    if (phoneArgs != null && viewModel.phoneNumber.isEmpty) {
      viewModel.setPhoneNumber(phoneArgs);
    }
    
    final keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;
    final isKeyboardOpen = keyboardHeight > 0;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenHeight = MediaQuery.sizeOf(context).height;
            final screenWidth = MediaQuery.sizeOf(context).width;

            final headerHeight = isKeyboardOpen
                ? screenHeight * 0.36
                : screenHeight * 0.46;

            return Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                  height: headerHeight,
                  child: OtpHeader(
                    height: headerHeight,
                    keyboardOpen: isKeyboardOpen,
                  ),
                ),
                SizedBox(
                  height: 13,
                ),
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
                                Text(
                                  'Enter the 6-digit OTP sent to \n+91 ${phoneArgs ?? "your number"}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    height: 1.3,
                                    color: AppColors.textGrey,
                                  ),
                                ),
                                const SizedBox(height: 14),
                              ] else
                                const SizedBox(height: 13),
                              OtpForm(state: state, viewModel: viewModel),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class OtpHeader extends StatelessWidget {
  final double height;
  final bool keyboardOpen;

  const OtpHeader({
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

class OtpForm extends StatelessWidget {
  final OtpState state;
  final OtpViewModel viewModel;

  const OtpForm({super.key, required this.state, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: AppColors.red,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.red, width: 2),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Colors.grey.shade50,
      ),
    );

    return Container(
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
          Pinput(
            length: 6,
            defaultPinTheme: defaultPinTheme,
            focusedPinTheme: focusedPinTheme,
            submittedPinTheme: submittedPinTheme,
            onChanged: (value) => viewModel.setOtp(value),
            onCompleted: (pin) async {
               viewModel.setOtp(pin);
               // optionally auto-submit here
            },
            pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
            showCursor: true,
            cursor: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 9),
                  width: 22,
                  height: 2,
                  color: AppColors.red,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          CustomButton(
            text: 'Verify OTP',
            isLoading: state.isLoading,
            onPressed: () async {
              final success = await viewModel.verifyOtp();
              if (success && context.mounted) {
                // Navigate to main app or wherever next
                Navigator.pushReplacementNamed(context, '/bottomNav');
              }
            },
            radius: 14,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
