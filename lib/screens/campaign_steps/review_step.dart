import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../providers/campaign_provider.dart';
import '../../widgets/animated_price_text.dart';
import '../../constants/constant.dart';

class ReviewStep extends ConsumerWidget {
  final Function(int) onEdit;

  const ReviewStep({super.key, required this.onEdit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(campaignProvider.notifier);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'QUOTATION PREVIEW',
            style: GoogleFonts.inter(
              color: const Color(0xFFE5212A),
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your estimated investment',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'A working estimate. ADINN will verify availability and share the final quote.',
            style: GoogleFonts.inter(
              color: Colors.grey[600],
              fontSize: 12,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          
          // Total Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ESTIMATED TOTAL',
                  style: GoogleFonts.inter(
                    color: Colors.grey[400],
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                AnimatedPriceText(
                  targetPrice: viewModel.estimatedTotal,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Inclusive of setup, manpower & taxes',
                  style: GoogleFonts.inter(
                    color: Colors.grey[400],
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Breakdowns
          _buildBreakdownItem('SPACE BOOKING', viewModel.spaceTotal, () => onEdit(0)),
          const SizedBox(height: 12),
          _buildBreakdownItem('CAMPAIGN TYPE', viewModel.objectiveTotal, () => onEdit(1)),
          const SizedBox(height: 12),
          _buildBreakdownItem('SETUP', viewModel.setupTotal, () => onEdit(3)), // Stage is step 3
          const SizedBox(height: 12),
          _buildBreakdownItem('BRANDING', viewModel.brandingTotal, () => onEdit(2)),
          const SizedBox(height: 12),
          _buildBreakdownItem('PROMOTERS', viewModel.promotersTotal, () => onEdit(4)),
          const SizedBox(height: 12),
          _buildBreakdownItem('ENGAGEMENT GIFTS', viewModel.giftsExperiencesTotal, () => onEdit(5)),
          
          const SizedBox(height: 24),
          
          // Bottom Note
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Text(
              'ADINN will verify apartment availability and share the final quote within 24 hours. Payment is offline, post quote confirmation.',
              style: GoogleFonts.inter(
                color: Colors.grey[600],
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ),
          
          const SizedBox(height: 100), // Space for bottom bar
        ],
      ),
    );
  }

  Widget _buildBreakdownItem(String title, int amount, VoidCallback onEdit) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  color: Colors.grey[600],
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                formatIndianNumber(amount, isCurrency: true),
                style: GoogleFonts.inter(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          OutlinedButton.icon(
            onPressed: onEdit,
            icon: const Icon(Icons.edit, size: 12, color: Colors.black),
            label: Text(
              'Edit',
              style: GoogleFonts.inter(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              side: BorderSide(color: Colors.grey[300]!),
              minimumSize: const Size(0, 32),
            ),
          ),
        ],
      ),
    );
  }
}
