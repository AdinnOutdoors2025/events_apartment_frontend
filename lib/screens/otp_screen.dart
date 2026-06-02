import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';
import '../constants/color.dart';
import '../providers/otp_provider.dart';

class OtpPage extends ConsumerWidget {
  const OtpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final phoneNumber = arguments['phoneNumber'] as String?;
    final otpType = arguments['otpType'] as String?;

    final state = ref.watch(otpViewModelProvider);
    final viewModel = ref.read(otpViewModelProvider.notifier);

    if (phoneNumber != null && viewModel.phoneNumber.isEmpty) {
      viewModel.setPhoneNumber(phoneNumber);
    }

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
                const SizedBox(height: 10),

                Text(
                  'VERIFICATION',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                    color: AppColors.textGrey,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Enter OTP',
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700),
                ),

                const SizedBox(height: 12),

                Text(
                  'Enter the 4-digit OTP sent to +91 ${phoneNumber ?? ""}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.4,
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
                      colors: [Color(0xFF2B0000), Color(0xFF000000)],
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
                                Icons.security,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),

                            const SizedBox(height: 14),

                            const Text(
                              'Securely verify your\naccount to unlock\npremium campaigns.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        width: 90,
                        child: Center(
                          child: Icon(
                            Icons.shield_outlined,
                            color: Colors.red,
                            size: 50,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                OtpForm(state: state, viewModel: viewModel),
              ],
            ),
          ),
        ),
      ),
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
      width: 60,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.red,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
    );

    return Column(
      children: [
        Pinput(
          length: 4,
          closeKeyboardWhenCompleted: true,
          keyboardType: TextInputType.number,
          defaultPinTheme: defaultPinTheme,
          focusedPinTheme: defaultPinTheme.copyDecorationWith(
            border: Border.all(color: AppColors.red, width: 2),
          ),
          onChanged: viewModel.setOtp,
        ),

        const SizedBox(height: 20),

        state.canResend
            ? TextButton(
                onPressed: state.isResending
                    ? null
                    : () {
                        viewModel.resendOtp();
                      },
                child: state.isResending
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        "Resend OTP",
                        style: TextStyle(
                          color: AppColors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              )
            : Text(
                "Resend OTP in ${state.resendSeconds}s",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),

        const SizedBox(height: 24),

        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/brandDetails');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: const StadiumBorder(),
            ),
            child: state.isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Verify OTP'),
          ),
        ),
      ],
    );
  }
}
