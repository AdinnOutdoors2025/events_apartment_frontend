import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/apartment_field_list.dart';
import '../../providers/campaign_provider.dart';
import '../../widgets/animated_count_text.dart';
import '../../widgets/animated_price_text.dart';
import '../../widgets/countingContainer.dart';

class GiftsExperiencesStep extends ConsumerWidget {
  final ApartmentFieldsList apartmentFieldsList;

  const GiftsExperiencesStep({super.key, required this.apartmentFieldsList});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(campaignProvider);
    final viewModel = ref.read(campaignProvider.notifier);
    final normalGifts =
        apartmentFieldsList.data?.giftsDetails?.normalGifts ?? <NormalGifts>[];

    final liveExpGifts =
        apartmentFieldsList.data?.giftsDetails?.liveCounterGifts ??
        <LiveCounterGifts>[];

    final Map<String, List<dynamic>> giftSections = {
      'BRANDED GIFTS': normalGifts,
      'LIVE EXPERIENCES': liveExpGifts,
    };

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'STEP · ENGAGEMENT',
            style: GoogleFonts.inter(
              color: const Color(0xFFE5212A),
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Gifts and experiences',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              letterSpacing: -0.5,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Drive footfall with branded gifts and on-spot experiences.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),

          // Recommendation Box
          Container(
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
                  Icons.card_giftcard,
                  color: Color(0xFFE5212A),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'RECOMMENDED FOR HIGH FOOTFALL',
                        style: GoogleFonts.inter(
                          color: const Color(0xFFE5212A),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Key chains at 50–80 pieces convert footfall to leads at the highest rate in family communities.',
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

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: giftSections.entries.map((section) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section.key,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                      letterSpacing: 1.0,
                    ),
                  ),

                  const SizedBox(height: 16),

                  ListView.separated(
                    padding: const EdgeInsets.all(5),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: section.value.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final item = section.value[index];
                      final isExperience = item.giftType == 2;
                      final count = isExperience
                          ? (state.experienceCounts[item.giftName ?? ''] ?? 0)
                          : (state.giftCounts[item.giftName ?? ''] ?? 0);

                      return QuantityItemCard(
                        title: item.giftName ?? '',
                        price: item.price ?? 0,
                        count: count,
                        quantity: item.unit ?? 0,
                        unitLabel: item.priceType == 1
                            ? 'quantity'
                            : item.priceType == 2
                            ? 'unit'
                            : item.priceType == 3
                            ? 'day'
                            : item.priceType == 4
                            ? 'hour'
                            : 'person',
                        onChanged: (delta) {
                          if (isExperience) {
                            viewModel.updateExperienceCount(
                              item.giftName ?? '',
                              delta,
                            );
                          } else {
                            viewModel.updateGiftCount(
                              item.giftName ?? '',
                              delta,
                            );
                          }
                        },
                        priceFormatter: (price) => '₹$price',
                        stepName: 'gift',
                      );
                    },
                  ),

                  const SizedBox(height: 32),
                ],
              );
            }).toList(),
          ),

          const SizedBox(height: 120),
        ],
      ),
    );
  }
}
