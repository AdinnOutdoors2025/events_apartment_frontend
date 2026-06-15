import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/apartment_field_list.dart';
import '../../providers/campaign_provider.dart';
import '../../widgets/countingContainer.dart';

class BasicSetupStep extends ConsumerWidget {
  final ApartmentFieldsList apartmentFieldsList;

  const BasicSetupStep({super.key, required this.apartmentFieldsList});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(campaignProvider);
    final viewModel = ref.read(campaignProvider.notifier);

    final List<ItemsData> uncategorized = [];

    final elementDetails =
        apartmentFieldsList.data?.elementsDetails ?? <ElementsDetails>[];

    for (final category in elementDetails) {
      final items = category.itemsData ?? [];

      for (final item in items) {
        if (item.itemType == 1) {
          uncategorized.add(item);
        }
      }
    }

    debugPrint('Uncategorized: ${uncategorized.length}');

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'STEP · BRANDING & SETUP',
            style: GoogleFonts.inter(
              color: const Color(0xFFE5212A),
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Design your event presence',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add canopies, counters, backdrops and signage — all priced per day, hour, square feet, feet.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 32),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SETUP ESSENTIALS',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          ListView.separated(
            padding: const EdgeInsets.all(5),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: uncategorized.length,
            separatorBuilder: (_, _) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final unCategory = uncategorized[index];

              return QuantityItemCard(
                title: unCategory.itemName ?? '',
                price: unCategory.amount ?? 0,
                quantity: unCategory.quantity ?? 0,
                count:
                    state.unCategoryBrandingCounts[unCategory.itemName ?? ''] ??
                    0,
                unitLabel: unCategory.amountUnit == 1
                    ? 'day'
                    : unCategory.amountUnit == 2
                    ? "hour"
                    : unCategory.amountUnit == 3
                    ? "sq.ft"
                    : unCategory.amountUnit == 4
                    ? 'feet'
                    : 'piece',
                onChanged: (delta) {
                  viewModel.updateUnCategoryCount(
                    unCategory.itemName ?? '',
                    delta,
                  );
                },
                priceFormatter: (price) {
                  return '₹${price.toString()}';
                },
                stepName: 'unCategorized',
              );
            },
          ),

          const SizedBox(height: 24),

          // Smart Suggestion
          /* Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0EF),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFFBBFBC)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.lightbulb_outline,
                  color: Color(0xFFE5212A),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SMART SUGGESTION',
                        style: GoogleFonts.inter(
                          color: const Color(0xFFE5212A),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Recommended setup: Canopy + Backdrop + Table + 2 Chairs',
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          Text(
            'BRAND BRIEF',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 16),

          _buildTextField('Royal Enfield'),
          const SizedBox(height: 12),
          _buildTextField('Promotion + Lead Generation'),*/
          const SizedBox(height: 120),
        ],
      ),
    );
  }

  Widget _buildObjectiveRadio(
    String title,
    int price,
    int amountType,
    CampaignState state,
    CampaignViewModel viewModel,
  ) {
    bool isSelected = state.campaignObjective == title;
    return GestureDetector(
      onTap: () => viewModel.setObjective(title),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? const Color(0xFFE5212A) : Colors.grey[300]!,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                        '₹${price.toString().replaceAllMapped(RegExp(r'(\\d{1,3})(?=(\\d{3})+(?!\\d))'), (Match m) => '${m[1]},')}',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: '/day',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hint) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: Colors.black),
        ),
      ),
    );
  }
}
