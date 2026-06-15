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
    if (state.selectedStart != null && state.selectedEnd != null) {
      if (state.selectedStart == state.selectedEnd) {
        dateRange = df.format(state.selectedStart!);
      } else {
        dateRange = '${df.format(state.selectedStart!)} → ${df.format(state.selectedEnd!)}';
      }
    }

    // Build lists for summary
    List<String> catBrandings = [];
    state.categoryBrandingCounts.forEach((key, val) {
      if (val > 0) {
        catBrandings.add('$val × $key');
      }
    });
    final catBrandingText = catBrandings.isNotEmpty ? catBrandings.join('\n') : '-';

    List<String> unCatBrandings = [];
    state.unCategoryBrandingCounts.forEach((key, val) {
      if (val > 0) {
        unCatBrandings.add('$val × $key');
      }
    });
    final unCatBrandingText = unCatBrandings.isNotEmpty ? unCatBrandings.join('\n') : '-';

    String stageSetupText = '-';
    if (state.stageSetup) {
      List<String> stageItems = [];
      if (state.stageFootprint != null) {
        stageItems.add('Footprint: ${state.stageFootprint}');
      }
      state.stageCounts.forEach((key, val) {
        if (val > 0) stageItems.add('$val × $key');
      });
      state.audioCounts.forEach((key, val) {
        if (val > 0) stageItems.add('$val × $key');
      });
      stageSetupText = stageItems.isNotEmpty ? stageItems.join('\n') : 'Enabled';
    } else {
      stageSetupText = 'Not Required';
    }

    String promotersText = '-';
    if (state.needPromoters) {
      List<String> promoterDetails = [];
      promoterDetails.add('Total: ${state.totalPromoterCount} promoters');
      for (int i = 0; i < state.promoterRequirements.length; i++) {
        final req = state.promoterRequirements[i];
        final parts = <String>[];
        if (req.maleCount > 0) parts.add('${req.maleCount} Male');
        if (req.femaleCount > 0) parts.add('${req.femaleCount} Female');
        if (req.languages.isNotEmpty) parts.add('Languages: ${req.languages.join(", ")}');
        if (req.appearances.isNotEmpty) parts.add('Appearances: ${req.appearances.join(", ")}');
        if (req.selectedDates.isNotEmpty) parts.add('${req.selectedDates.length} days');
        promoterDetails.add('Req ${i + 1}: ${parts.join(" | ")}');
      }
      promotersText = promoterDetails.join('\n');
    } else {
      promotersText = 'Not Required';
    }

    List<String> giftsList = [];
    state.giftCounts.forEach((key, val) {
      if (val > 0) giftsList.add('$val × $key');
    });
    final giftsText = giftsList.isNotEmpty ? giftsList.join('\n') : '-';

    List<String> experiencesList = [];
    state.experienceCounts.forEach((key, val) {
      if (val > 0) experiencesList.add('$val × $key');
    });
    final experiencesText = experiencesList.isNotEmpty ? experiencesList.join('\n') : '-';

    final List<String> dailyTimesList = [];

    for (final schedule in state.schedules) {
      dailyTimesList.add(
        '${DateFormat('dd MMM yyyy').format(schedule.startDate)}'
            ' → '
            '${DateFormat('dd MMM yyyy').format(schedule.endDate)}'
            ' (${schedule.fromTime} - ${schedule.toTime})',
      );
    }

    final dailyTimesText =
    dailyTimesList.isNotEmpty
        ? dailyTimesList.join('\n')
        : '-';

    final voiceNoteText = state.voiceNotePath != null
        ? 'Recorded (${state.voiceNoteDuration}s)'
        : 'None';

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
                  padding: const EdgeInsets.only(right: 30,left: 30,top: 10,bottom: 10),
                  width: double.infinity,
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
                        '${state.customerBrandName ?? 'Brand'} × $communityName',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        state.selectedStart != null ? df.format(state.selectedStart!) : '',
                        style: GoogleFonts.inter(
                          color: Colors.grey[400],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                // Rows
                _buildRow('BRAND', state.customerBrandName ?? '-'),
                _buildRow('CAMPAIGN TYPE', state.campaignObjective ?? '-'),
                _buildRow('COMMUNITY', communityName),
                _buildRow('DATES', dateRange.isNotEmpty ? dateRange : '-'),
                _buildRow('DAILY TIMESLOTS', dailyTimesText),
                _buildRow('ACTIVATION SPACE', '${state.builderSelectedSpace} sq.ft'),
                _buildRow('CATEGORIZED BRANDING', catBrandingText),
                _buildRow('UNCATEGORIZED BRANDING', unCatBrandingText),
                _buildRow('STAGE SETUP', stageSetupText),
                _buildRow('PROMOTERS', promotersText),
                _buildRow('ENGAGEMENT GIFTS', giftsText),
                _buildRow('ENGAGEMENT EXPERIENCES', experiencesText),
                _buildRow('VOICE INSTRUCTION', voiceNoteText),
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
