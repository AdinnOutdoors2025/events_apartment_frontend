import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../providers/campaign_provider.dart';
import '../../widgets/animated_count_text.dart';
import '../../widgets/animated_price_text.dart';

class StageAudioStep extends ConsumerWidget {
  const StageAudioStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(campaignProvider);
    final viewModel = ref.read(campaignProvider.notifier);

    int stageSubtotal = 0;
    if (state.stageSetup && state.stageFootprint != null) {
      stageSubtotal += viewModel.stagePrices[state.stageFootprint!]! * (state.days > 0 ? state.days : 1);
    }
    state.audioCounts.forEach((item, count) {
      if (count > 0 && viewModel.audioPrices.containsKey(item)) {
        stageSubtotal += viewModel.audioPrices[item]! * count;
      }
    });

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'STEP · STAGE & AUDIO',
            style: GoogleFonts.inter(
              color: const Color(0xFFE5212A),
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create a high-impact\napartment event',
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
            'Add a stage, MIC host, sound or LED screen — billed per hour.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 32),

          // Stage Setup Card
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: const Color(0xFF0C0C0C),
              borderRadius: BorderRadius.circular(24),
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
                              'Stage setup',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'A branded stage anchors the activation and lifts engagement by ~40%.',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.grey[400],
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Switch(
                        value: state.stageSetup,
                        onChanged: (val) => viewModel.toggleStageSetup(val),
                        activeColor: Colors.white,
                        activeTrackColor: const Color(0xFFE5212A),
                        inactiveThumbColor: Colors.grey[400],
                        inactiveTrackColor: Colors.grey[800],
                      ),
                    ],
                  ),
                ),
                if (state.stageSetup) ...[
                  const Divider(height: 1, color: Color(0xFF222222)),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.music_note, color: Color(0xFFE5212A), size: 16),
                            const SizedBox(width: 8),
                            Text(
                              'Pick a stage footprint',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(child: _buildStageFootprintOption('Small', 11000, state, viewModel)),
                            const SizedBox(width: 12),
                            Expanded(child: _buildStageFootprintOption('Medium', 15000, state, viewModel)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 32),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'AUDIO & VISUAL',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                  letterSpacing: 1.0,
                ),
              ),
              Text(
                'Per hour',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _buildAudioItem('MIC Host', 500, state, viewModel),
          const SizedBox(height: 12),
          _buildAudioItem('Sound System', 1500, state, viewModel),
          const SizedBox(height: 12),
          _buildAudioItem('DJ Setup', 2000, state, viewModel),
          const SizedBox(height: 12),
          _buildAudioItem('LED Screen', 3000, state, viewModel),

          const SizedBox(height: 24),

          // Subtotal
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'STAGE & AUDIO SUBTOTAL',
                  style: GoogleFonts.inter(
                    color: Colors.grey[400],
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
                AnimatedPriceText(
                  targetPrice: stageSubtotal,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 120),
        ],
      ),
    );
  }

  Widget _buildStageFootprintOption(String title, int price, CampaignState state, CampaignViewModel viewModel) {
    bool isSelected = state.stageFootprint == title;
    return GestureDetector(
      onTap: () => viewModel.setStageFootprint(title),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1C0D0D) : const Color(0xFF111111),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFFE5212A) : const Color(0xFF222222),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '₹${price.toString().replaceAllMapped(RegExp(r'(\\d{1,3})(?=(\\d{3})+(?!\\d))'), (Match m) => '${m[1]},')}/day',
              style: GoogleFonts.inter(
                fontSize: 10,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioItem(String title, int price, CampaignState state, CampaignViewModel viewModel) {
    int count = state.audioCounts[title] ?? 0;
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
                        '₹${price.toString().replaceAllMapped(RegExp(r'(\\d{1,3})(?=(\\d{3})+(?!\\d))'), (Match m) => '${m[1]},')} / hour',
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
                        onPressed: count > 0 ? () => viewModel.updateAudioCount(title, -1) : null,
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
                        onPressed: () => viewModel.updateAudioCount(title, 1),
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
            Divider(height: 1, color: const Color(0xFFE5212A).withValues(alpha: 0.2)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$count HOURS',
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
