import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/brand_form_provider.dart';
import '../widgets/brand_text_field.dart';

class BrandInfoScreen extends ConsumerWidget {
  const BrandInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(brandFormProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          "Sign In",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/bottomNav');
            },
            child: Text(
              'Skip',
              style: GoogleFonts.inter(
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
                  "Tell us about your brand",
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    letterSpacing: -0.5,
                  ),
                ),

                const SizedBox(height: 30),

                buildLabel('BRAND OWNER NAME'),
                buildTextField(
                  'Rahul Iyer',
                  onChanged: (v) =>
                      ref.read(brandFormProvider.notifier).updateOwnerName(v),
                ),
                const SizedBox(height: 24),

                buildLabel('COMPANY / BRAND NAME'),
                buildTextField('Acme Mobility Pvt. Ltd.',onChanged: (v) =>
                    ref.read(brandFormProvider.notifier).updateCompanyName(v),),
                const SizedBox(height: 24),

                buildLabel('EMAIL'),
                buildTextField('rahul@acme.com',onChanged: (v) =>
                    ref.read(brandFormProvider.notifier).updateEmail(v),),
                const SizedBox(height: 24),

                buildLabel('GST (OPTIONAL)'),
                buildTextField('33ABCDE1234F1Z5',onChanged: (v) =>
                    ref.read(brandFormProvider.notifier).updateGst(v),),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: /*form.isValid
                        ?*/ () {
                      /* debugPrint(form.ownerName);
                            debugPrint(form.companyName);
                            debugPrint(form.email);
                            debugPrint(form.gst);*/
                      Navigator.pushNamed(context, '/brandProfile');
                    },
                    /*: null*/
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
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
