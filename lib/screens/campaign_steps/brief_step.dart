import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../providers/campaign_provider.dart';

class BriefStep extends ConsumerWidget {
  final String communityName;
  const BriefStep({super.key, required this.communityName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(campaignProvider);

    final df = DateFormat('E, d MMM yyyy');
    String dateRange = '';
    if (state.startDate != null && state.endDate != null) {
      if (state.startDate == state.endDate) {
        dateRange = df.format(state.startDate!);
      } else {
        dateRange = '${df.format(state.startDate!)} → ${df.format(state.endDate!)}';
      }
    }

    // Build lists for summary
    List<String> setups = [];
    List<String> brandings = [];
    state.brandingCounts.forEach((key, val) {
      if (val > 0) {
        // Just rough logic: Backdrops/Standees are branding, others are setup
        if (key.contains('Backdrop') || key.contains('Standee') || key.contains('Flex')) {
          brandings.add('$val × $key');
        } else {
          setups.add('$val × $key');
        }
      }
    });

    List<String> stageAudio = [];
    if (state.stageSetup && state.stageFootprint != null) {
      stageAudio.add('Stage Setup — ${state.stageFootprint}');
    }
    state.audioCounts.forEach((key, val) {
      if (val > 0) {
        stageAudio.add('$val × $key');
      }
    });

    String promoters = 'Not included';
    if (state.needPromoters && state.promoterCount > 0) {
      promoters = '${state.promoterCount} × ${state.promoterRole ?? 'Promoter'}';
    }

    List<String> engagements = [];
    state.giftCounts.forEach((key, val) {
      if (val > 0) engagements.add('$val × $key');
    });
    state.experienceCounts.forEach((key, val) {
      if (val > 0) engagements.add('$val × $key');
    });

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CAMPAIGN BRIEF',
            style: GoogleFonts.inter(
              color: const Color(0xFFE5212A),
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your premium activation brief',
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
            'Generated from your selections. Share with stakeholders or continue to estimate.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 32),

          // Brief Card
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.only(right: 60,left: 30,top: 10,bottom: 10),
                  decoration: const BoxDecoration(
                    color: Color(0xFF0C0C0C),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ADINN - CAMPAIGN BRIEF',
                        style: GoogleFonts.inter(
                          color: Colors.grey[400],
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Royal Enfield × $communityName',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        state.startDate != null ? df.format(state.startDate!) : '',
                        style: GoogleFonts.inter(
                          color: Colors.grey[400],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Rows
                _buildRow('BRAND', 'Royal Enfield'),
                _buildRow('OBJECTIVE', state.campaignObjective ?? '-'),
                _buildRow('CAMPAIGN TYPE', state.campaignObjective ?? '-'),
                _buildRow('COMMUNITY', communityName),
                _buildRow('TG RANGE', '28–45 yrs · SEC A'),
                _buildRow('DATES', dateRange.isNotEmpty ? dateRange : '-'),
                _buildRow('DAILY WINDOW', '10:00 AM – 06:00 PM'),
                _buildRow('ACTIVATION SPACE', state.builderSelectedSpace ?? '-'),
                _buildRow('SETUP', setups.isNotEmpty ? setups.join(' + ') : '-'),
                _buildRow('BRANDING', brandings.isNotEmpty ? brandings.join(' + ') : '-'),
                _buildRow('STAGE & AUDIO', stageAudio.isNotEmpty ? stageAudio.join(' + ') : '-'),
                _buildRow('PROMOTERS', promoters),
                _buildRow('ENGAGEMENT', engagements.isNotEmpty ? engagements.join(' + ') : '-'),
                _buildRow('NOTES', state.notes.isNotEmpty ? state.notes : '-', isLast: true),
              ],
            ),
          ),
          
          const SizedBox(height: 24),

          // Preview button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.grey[300]!),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'Preview setup layout →',
                style: GoogleFonts.inter(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),

          const SizedBox(height: 120),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isLast = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isLast ? Colors.transparent : Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
                letterSpacing: 1.0,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
