import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../providers/campaign_provider.dart';
import '../../widgets/animated_count_text.dart';
import '../../widgets/animated_price_text.dart';

class PromotersStep extends ConsumerWidget {
  const PromotersStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(campaignProvider);
    final viewModel = ref.read(campaignProvider.notifier);

    int days = state.days > 0 ? state.days : 1;
    int promotersTotal = 0;
    if (state.needPromoters && state.promoterCount > 0) {
      promotersTotal = 1500 * state.promoterCount * days;
    }

    final roles = ['Lead Promoter', 'Brand Ambassador', 'Sales Closer', 'Bilingual Host'];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'STEP · PROMOTERS',
            style: GoogleFonts.inter(
              color: const Color(0xFFE5212A),
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your on-ground team',
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
            'Trained, verified promoters who handle leads and engagement during the event.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 32),

          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: state.needPromoters ? const Color(0xFFFBBFBC) : Colors.grey[300]!,
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Need promoters?',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '₹1,500 per promoter per day, including training & ID.',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.grey[600],
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Switch(
                        value: state.needPromoters,
                        onChanged: (val) => viewModel.togglePromoters(val),
                        activeColor: Colors.white,
                        activeTrackColor: const Color(0xFFE5212A),
                        inactiveThumbColor: Colors.grey[400],
                        inactiveTrackColor: Colors.grey[200],
                      ),
                    ],
                  ),
                ),
                if (state.needPromoters) ...[
                  const Divider(height: 1, color: Color(0xFFFBBFBC)),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ROLE',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: roles.map((role) {
                            bool isSelected = state.promoterRole == role;
                            return GestureDetector(
                              onTap: () => viewModel.setPromoterRole(role),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected ? const Color(0xFFE5212A) : Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isSelected ? const Color(0xFFE5212A) : Colors.grey[300]!,
                                  ),
                                ),
                                child: Text(
                                  role,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                    color: isSelected ? Colors.white : Colors.black,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Number of promoters',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
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
                                    color: state.promoterCount > 0 ? Colors.black : Colors.grey[400],
                                    onPressed: state.promoterCount > 0 ? () => viewModel.updatePromoterCount(-1) : null,
                                    padding: const EdgeInsets.all(8),
                                    constraints: const BoxConstraints(),
                                  ),
                                  SizedBox(
                                    width: 24,
                                    child: Center(
                                      child: AnimatedCountText(
                                        count: state.promoterCount,
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: state.promoterCount > 0 ? const Color(0xFFE5212A) : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add, size: 18),
                                    color: Colors.white,
                                    style: IconButton.styleFrom(
                                      backgroundColor: const Color(0xFFE5212A),
                                      padding: const EdgeInsets.all(4),
                                      minimumSize: const Size(28, 28),
                                    ),
                                    onPressed: () => viewModel.updatePromoterCount(1),
                                    constraints: const BoxConstraints(),
                                  ),
                                  const SizedBox(width: 4),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (state.promoterCount > 0) ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF0EF).withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${state.promoterCount} × $days DAYS',
                              style: GoogleFonts.inter(
                                color: const Color(0xFFE5212A),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                            ),
                            AnimatedPriceText(
                              targetPrice: promotersTotal,
                              style: GoogleFonts.inter(
                                color: const Color(0xFFE5212A),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),

          const SizedBox(height: 120),
        ],
      ),
    );
  }
}
