import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../providers/campaign_provider.dart';

class NotesStep extends ConsumerWidget {
  const NotesStep({super.key});

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
            'STEP · SPECIAL INSTRUCTIONS',
            style: GoogleFonts.inter(
              color: const Color(0xFFE5212A),
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Anything we should know?',
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
            'Add notes on brand guidelines, setup constraints, or apartment-specific requests.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 32),

          Text(
            'NOTES FOR THE ADINN TEAM',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 16),

          TextField(
            maxLines: 8,
            onChanged: viewModel.updateNotes,
            controller: TextEditingController.fromValue(
              TextEditingValue(
                text: state.notes,
                selection: TextSelection.collapsed(offset: state.notes.length),
              ),
            ),
            decoration: InputDecoration(
              hintText: 'E.g. brand colour palette is matte black & red, no music after 7 PM, vegetarian giveaways only.',
              hintStyle: GoogleFonts.inter(color: Colors.grey[400], fontSize: 14, fontWeight: FontWeight.w400),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(20),
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
          ),

          const SizedBox(height: 120),
        ],
      ),
    );
  }
}
