import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/apartment_field_list.dart';
import '../../providers/campaign_provider.dart';
import '../../widgets/countingContainer.dart';

class StageSetupStep extends ConsumerWidget {
  final ApartmentFieldsList apartmentFieldsList;

  const StageSetupStep({super.key, required this.apartmentFieldsList});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(campaignProvider);
    final viewModel = ref.read(campaignProvider.notifier);

    // Extract items belonging to the "Stage" category
    final elementDetails =
        apartmentFieldsList.data?.elementsDetails ?? <ElementsDetails>[];
    
    ElementsDetails? stageCategory;
    for (final category in elementDetails) {
      if (category.categoryName?.toLowerCase() == 'stage') {
        stageCategory = category;
        break;
      }
    }

    final stageItems = stageCategory?.itemsData ?? <ItemsData>[];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ==========================
          /// HEADER
          /// ==========================
          Text(
            'STEP · STAGE SETUP',
            style: GoogleFonts.inter(
              color: const Color(0xFFE5212A),
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Stage Setup Requirements',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              letterSpacing: -0.5,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Select whether you require a stage setup for your activation campaign.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),

          const SizedBox(height: 32),

          /// ==========================
          /// ARE YOU NEED STAGE CARD / TOGGLE
          /// ==========================
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: state.stageSetup
                    ? const Color(0xFFE5212A).withValues(alpha: 0.5)
                    : Colors.grey.shade200,
                width: state.stageSetup ? 1.5 : 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Are you need stage?',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Enable to view and select available stage configurations.',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch.adaptive(
                      value: state.stageSetup,
                      activeColor: const Color(0xFFE5212A),
                      onChanged: (val) {
                        viewModel.toggleStageSetup(val);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          /// ==========================
          /// STAGE ITEMS LIST (COUNTER CONTAINER)
          /// ==========================
          if (state.stageSetup) ...[
            Text(
              'SELECT STAGE DETAILS',
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 16),
            if (stageItems.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Center(
                  child: Text(
                    'No stage items available in the API response.',
                    style: GoogleFonts.inter(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: stageItems.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final item = stageItems[index];

                  return QuantityItemCard(
                    title: item.itemName ?? '',
                    price: item.amount ?? 0,
                    count: state.stageCounts[item.itemName ?? ''] ?? 0,
                    unitLabel: item.amountUnit == 1
                        ? 'day'
                        : item.amountUnit == 2
                        ? 'hour'
                        : item.amountUnit == 3
                        ? 'sq.ft'
                        : 'feet',
                    onChanged: (delta) {
                      viewModel.updateStageCount(
                        item.itemName ?? '',
                        delta,
                      );
                    },
                    priceFormatter: (price) => '₹$price', stepName: 'stage',
                  );
                },
              ),
          ],

          const SizedBox(height: 120),
        ],
      ),
    );
  }
}
