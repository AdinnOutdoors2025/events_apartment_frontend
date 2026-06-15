import 'package:apartment_client_app/utils/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../providers/brand_form_provider.dart';
import '../providers/main_navigation_provider.dart';
import '../widgets/brand_text_field.dart';

class BrandProfileScreen extends ConsumerStatefulWidget {
  const BrandProfileScreen({super.key});

  @override
  ConsumerState<BrandProfileScreen> createState() => _BrandProfileScreenState();
}

class _BrandProfileScreenState extends ConsumerState<BrandProfileScreen> {
  final List<String> industries = [
    'Real Estate',
    'Automobile',
    'FMCG',
    'Food & Beverage',
    'Education',
    'Healthcare',
    'Finance',
    'Fashion',
    'Electronics',
    'Other',
  ];

  final List<String> goals = [
    'Brand Awareness',
    'Lead Generation',
    'Spot Sales',
    'Product Sampling',
    'Festival Promotion',
  ];

  @override
  Widget build(BuildContext context) {
    final customerType = ModalRoute.of(context)?.settings.arguments as int?;
    final form = ref.watch(brandFormProvider);
    final notifier = ref.read(brandFormProvider.notifier);
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          customerType == 1 ? 'Brand Profile' : 'Agency Profile',
          style: GoogleFonts.inter(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
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
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'STEP 2 OF 2',
              style: GoogleFonts.inter(
                color: const Color(0xFFE5212A),
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              customerType == 1
                  ? 'Set up your brand profile'
                  : 'Set up your agency profile',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 24),

            // Upload Logo
            GestureDetector(
              onTap: () => showLogoPicker(context, ref),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: form.logoImage != null
                          ? Stack(
                              clipBehavior: Clip.none,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    form.logoImage!,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),

                                Positioned(
                                  top: -6,
                                  right: -6,
                                  child: GestureDetector(
                                    onTap: () {
                                      notifier.removeLogo();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        size: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Icon(
                              Icons.upload_outlined,
                              color: Colors.grey[700],
                            ),
                    ),

                    const SizedBox(width: 16),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          customerType == 1
                              ? 'Upload brand logo'
                              : 'Upload agency logo',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'PNG / JPG - up to 2 MB',
                          style: GoogleFonts.inter(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            /* buildLabel('BRAND NAME'),
            buildTextField('Acme Mobility'),
            const SizedBox(height: 24),*/
            buildLabel('INDUSTRY CATEGORY'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: industries.map((industry) {
                return _buildChip(
                  label: industry,
                  isSelected: form.selectedIndustry == industry,
                  onTap: () {
                    notifier.setIndustry(industry);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            buildLabel('PRODUCT / SERVICE DESCRIPTION'),
            buildTextField(
              'Premium electric SUV',
              onChanged: (value) {
                notifier.updateProductDescription(value);
              },
            ),
            const SizedBox(height: 24),

            buildLabel('TARGET CUSTOMER'),
            buildTextField(
              'Urban families, 35–55, ₹1Cr+ home value',
              onChanged: (value) {
                notifier.updateTargetCustomer(value);
              },
            ),
            const SizedBox(height: 24),

            buildLabel('AVERAGE PRODUCT PRICE'),
            buildTextField(
              '₹ 65,00,000',
              onChanged: (value) {
                notifier.updateAvgProductPrice(int.tryParse(value) ?? 0);
              },
            ),
            const SizedBox(height: 24),

            buildLabel('CAMPAIGN GOAL'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: goals.map((goal) {
                return _buildChip(
                  label: goal,
                  isSelected: form.selectedCampaignGoal == goal,
                  onTap: () {
                    notifier.setCampaignRole(goal);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 32),

            // Save Profile Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: form.canSubmit
                    ? () async {
                        final success = await ref
                            .read(brandFormProvider.notifier)
                            .saveProfile();
                        if (success && context.mounted) {
                          ref.read(bottomNavigationIndex.notifier).state = 0;
                          Navigator.pushReplacementNamed(context, '/bottomNav');
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: Text(
                  'Save Profile',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void showLogoPicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.white),
                title: const Text(
                  'Camera',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  ref
                      .read(brandFormProvider.notifier)
                      .pickLogo(ImageSource.camera);
                },
              ),

              ListTile(
                leading: const Icon(Icons.photo, color: Colors.white),
                title: const Text(
                  'Gallery',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  ref
                      .read(brandFormProvider.notifier)
                      .pickLogo(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey[300]!,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            color: isSelected ? Colors.white : Colors.black,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
