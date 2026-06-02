import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../providers/campaign_provider.dart';
import '../../widgets/animated_count_text.dart';
import '../../widgets/animated_price_text.dart';

class BrandingSetupStep extends ConsumerWidget {
  const BrandingSetupStep({super.key});

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
            'Add canopies, counters, backdrops and signage — all priced per day or per piece.',
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
              Text(
                'Per day',
                style: GoogleFonts.inter(fontSize: 10, color: Colors.grey[500]),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _buildItem('Canopy', 800, false, state, viewModel),
          const SizedBox(height: 12),
          _buildItem('Arabian Tent', 1200, false, state, viewModel),
          const SizedBox(height: 12),
          _buildItem('Table', 250, false, state, viewModel),
          const SizedBox(height: 12),
          _buildItem('Chair', 75, false, state, viewModel),
          const SizedBox(height: 12),
          _buildItem('Product Display Counter', 700, false, state, viewModel),

          const SizedBox(height: 32),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'BRAND VISIBILITY',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                  letterSpacing: 1.0,
                ),
              ),
              Text(
                'Per piece',
                style: GoogleFonts.inter(fontSize: 10, color: Colors.grey[500]),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildItem('Backdrop 6 × 4 ft', 2000, true, state, viewModel),
          const SizedBox(height: 12),
          _buildItem('Backdrop 8 × 6 ft', 3500, true, state, viewModel),
          const SizedBox(height: 12),
          _buildItem('Standee', 1200, true, state, viewModel),
          const SizedBox(height: 12),
          _buildItem('Flex / Banner', 1500, true, state, viewModel),

          const SizedBox(height: 120),
        ],
      ),
    );
  }

  Widget _buildItem(
    String title,
    int price,
    bool perPiece,
    CampaignState state,
    CampaignViewModel viewModel,
  ) {
    int count = state.brandingCounts[title] ?? 0;
    bool isSelected = count > 0;
    int lineTotal = price * count;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFFFFF0EF).withValues(alpha: 0.3)
            : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isSelected
              ? const Color(0xFFE5212A).withValues(alpha: 0.5)
              : Colors.grey[300]!,
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
                      Row(
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '₹${price.toString().replaceAllMapped(RegExp(r'(\\d{1,3})(?=(\\d{3})+(?!\\d))'), (Match m) => '${m[1]},')} / ${perPiece ? 'piece' : 'day'}',
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
                        onPressed: count > 0
                            ? () => viewModel.updateBrandingCount(title, -1)
                            : null,
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
                              color: isSelected
                                  ? const Color(0xFFE5212A)
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, size: 18),
                        color: isSelected ? Colors.white : Colors.white,
                        style: IconButton.styleFrom(
                          backgroundColor: isSelected
                              ? const Color(0xFFE5212A)
                              : Colors.black,
                          padding: const EdgeInsets.all(4),
                          minimumSize: const Size(28, 28),
                        ),
                        onPressed: () =>
                            viewModel.updateBrandingCount(title, 1),
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
