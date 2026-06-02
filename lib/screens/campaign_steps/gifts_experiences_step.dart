import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../providers/campaign_provider.dart';
import '../../widgets/animated_count_text.dart';
import '../../widgets/animated_price_text.dart';

class GiftsExperiencesStep extends ConsumerWidget {
  const GiftsExperiencesStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(campaignProvider);
    final viewModel = ref.read(campaignProvider.notifier);

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
                const Icon(Icons.card_giftcard, color: Color(0xFFE5212A), size: 20),
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

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'BRANDED GIFTS',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                  letterSpacing: 1.0,
                ),
              ),
              Text(
                'Per unit',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _buildItem('Cap', 100, true, state.giftCounts, (val) => viewModel.updateGiftCount('Cap', val)),
          const SizedBox(height: 12),
          _buildItem('Key Chain', 50, true, state.giftCounts, (val) => viewModel.updateGiftCount('Key Chain', val)),
          const SizedBox(height: 12),
          _buildItem('Water Can', 30, true, state.giftCounts, (val) => viewModel.updateGiftCount('Water Can', val)),

          const SizedBox(height: 32),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'LIVE EXPERIENCES',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                  letterSpacing: 1.0,
                ),
              ),
              Text(
                'Per day',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _buildItem('Nail Artist', 4000, false, state.experienceCounts, (val) => viewModel.updateExperienceCount('Nail Artist', val)),
          const SizedBox(height: 12),
          _buildItem('Tattoo Activity', 3500, false, state.experienceCounts, (val) => viewModel.updateExperienceCount('Tattoo Activity', val)),

          const SizedBox(height: 120),
        ],
      ),
    );
  }

  Widget _buildItem(
    String title,
    int price,
    bool perUnit,
    Map<String, int> countMap,
    Function(int) onUpdate,
  ) {
    int count = countMap[title] ?? 0;
    bool isSelected = count > 0;
    int lineTotal = price * count;


    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFFFF0EF).withValues(alpha: 0.3) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isSelected ? const Color(0xFFE5212A).withValues(alpha: 0.5) : Colors.grey[300]!,
          width: isSelected ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '₹${price.toString().replaceAllMapped(RegExp(r'(\\d{1,3})(?=(\\d{3})+(?!\\d))'), (Match m) => '${m[1]},')} / ${perUnit ? 'unit' : 'day'}',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, size: 18),
                        color: count > 0 ? Colors.black : Colors.grey[400],
                        onPressed: count > 0 ? () => onUpdate(-1) : null,
                        padding: const EdgeInsets.all(8),
                        constraints: const BoxConstraints(),
                      ),
                      SizedBox(
                        width: 24,
                        child: Center(
                          child: AnimatedCountText(
                            count: count,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? const Color(0xFFE5212A) : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, size: 18),
                        color: Colors.white,
                        style: IconButton.styleFrom(
                          backgroundColor: isSelected ? const Color(0xFFE5212A) : Colors.black,
                          padding: const EdgeInsets.all(4),
                          minimumSize: const Size(28, 28),
                        ),
                        onPressed: () => onUpdate(1),
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 4),
                    ],
                  ),
                ),


              ],
            ),

          ),
          if (isSelected) ...[
            Divider(
              height: 1,
              color: const Color(0xFFE5212A).withValues(alpha: 0.2),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'LINE TOTAL',
                    style: GoogleFonts.inter(
                      color: const Color(0xFFE5212A),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  AnimatedPriceText(
                    targetPrice: lineTotal,
                    style: GoogleFonts.inter(
                      color: const Color(0xFFE5212A),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),

    );
  }
}
