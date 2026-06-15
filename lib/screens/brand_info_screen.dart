import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/brand_form_provider.dart';
import '../providers/main_navigation_provider.dart';
import '../utils/api_service.dart';
import '../widgets/brand_text_field.dart';

class BrandInfoScreen extends ConsumerWidget {
  const BrandInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(brandFormProvider);
    final customerType = ModalRoute.of(context)?.settings.arguments as int?;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const Text(
          "Personal Details",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
       /* leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),*/
        actions: [
          TextButton(
            onPressed: () async {
              final response = await ApiService().skipProfile();

              if (response.success == true && context.mounted) {
                ref.read(bottomNavigationIndex.notifier).state = 0;
                Navigator.pushReplacementNamed(context, '/bottomNav');
              }
            },
            child: Text(
              'Skip',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'STEP 1 OF 2',
                  style: GoogleFonts.inter(
                    color: const Color(0xFFE5212A),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                SizedBox(height: 10),
                const Text(
                  "ACCOUNT",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  customerType == 1
                      ? "Tell us about your brand"
                      : 'Tell us about your agency',
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    letterSpacing: -0.5,
                  ),
                ),

                const SizedBox(height: 30),

                buildLabel(
                  customerType == 1 ? 'BRAND OWNER NAME' : 'Agency Owner Name',
                ),
                buildTextField(
                  'Rahul',
                  onChanged: (v) =>
                      ref.read(brandFormProvider.notifier).updateOwnerName(v),
                ),
                const SizedBox(height: 24),

                buildLabel(customerType == 1 ? 'BRAND NAME' : 'Agency Name'),
                buildTextField(
                  'Adinn Pvt. Ltd.',
                  onChanged: (v) =>
                      ref.read(brandFormProvider.notifier).updateCompanyName(v),
                ),
                const SizedBox(height: 24),

                buildLabel('EMAIL'),
                buildTextField(
                  'rahul@acme.com',
                  onChanged: (v) =>
                      ref.read(brandFormProvider.notifier).updateEmail(v),
                ),
                const SizedBox(height: 24),

                buildLabel('GST NUMBER (OPTIONAL)'),

                buildTextField(
                  '33ABCDE1234F1Z5',
                  onChanged: (v) =>
                      ref.read(brandFormProvider.notifier).updateGst(v),
                  suffixIcon: form.gst.length == 15
                      ? form.isGstVerified
                            ? const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              )
                            : TextButton(
                                onPressed: form.isGstVerifying
                                    ? null
                                    : () {
                                          ref
                                            .read(brandFormProvider.notifier)
                                            .verifyGst();
                                      },
                                child: form.isGstVerifying
                                    ? const SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text("Verify"),
                              )
                      : null,
                ),
                const SizedBox(height: 14),
                if (form.isGstVerified) ...[
                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          form.businessName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(height: 4),

                        Text(form.businessAddress),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: form.isValid
                        ? () {
                            debugPrint(form.ownerName);
                            debugPrint(form.companyName);
                            debugPrint(form.email);
                            debugPrint(form.gst);
                            Navigator.pushNamed(context, '/brandProfile',arguments: customerType);
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.black38,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: const Text(
                      "Continue",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
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
