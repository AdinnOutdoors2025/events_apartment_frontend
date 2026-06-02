import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../providers/campaign_provider.dart';

class SpaceScheduleStep extends ConsumerWidget {
  const SpaceScheduleStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(campaignProvider);
    final viewModel = ref.read(campaignProvider.notifier);
    
    final dateFormat = DateFormat('E, d MMM yyyy');

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'STEP · SPACE & SCHEDULE',
            style: GoogleFonts.inter(
              color: const Color(0xFFE5212A),
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose your campaign space',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pick a footprint and lock the activation window.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),

          Text(
            'ACTIVATION SPACE',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 16),
          
          _buildSpaceRadio('10 × 10 ft', 3150, state, viewModel),
          const SizedBox(height: 12),
          _buildSpaceRadio('10 × 20 ft', 5500, state, viewModel),
          const SizedBox(height: 12),
          _buildSpaceRadio('10 × 30 ft', 8000, state, viewModel),

          const SizedBox(height: 32),

          Text(
            'SCHEDULE',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 16),

          _buildDateRow('Start date', state.startDate != null ? dateFormat.format(state.startDate!) : 'Select Date', () async {
            final date = await showDatePicker(
              context: context,
              initialDate: state.startDate ?? DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (date != null) {
              // Auto-set end date to start date if it's null or before start date
              DateTime end = state.endDate ?? date;
              if (end.isBefore(date)) end = date;
              viewModel.setDates(date, end);
            }
          }),
          const SizedBox(height: 12),
          _buildDateRow('End date', state.endDate != null ? dateFormat.format(state.endDate!) : 'Select Date', () async {
            if (state.startDate == null) {
               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select start date first.')));
               return;
            }
            final date = await showDatePicker(
              context: context,
              initialDate: state.endDate ?? state.startDate!,
              firstDate: state.startDate!,
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (date != null) {
              viewModel.setDates(state.startDate!, date);
            }
          }),
          const SizedBox(height: 12),
          _buildDateRow('Daily window', '10:00 AM – 06:00 PM', () {
             // Optional: Time picker implementation
          }, isDropdown: true),
          
          const SizedBox(height: 120), // Bottom padding
        ],
      ),
    );
  }

  Widget _buildSpaceRadio(String title, int price, CampaignState state, CampaignViewModel viewModel) {
    bool isSelected = state.builderSelectedSpace == title;
    return GestureDetector(
      onTap: () => viewModel.setBuilderSpace(title),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? const Color(0xFFE5212A) : Colors.grey[300]!,
            width: isSelected ? 1.5 : 1.0,
          ),
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
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '₹${price.toString().replaceAllMapped(RegExp(r'(\\d{1,3})(?=(\\d{3})+(?!\\d))'), (Match m) => '${m[1]},')}/day',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFFE5212A) : Colors.grey[300]!,
                  width: isSelected ? 6.0 : 1.0, // thick border acts like filled radio
                ),
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateRow(String label, String value, VoidCallback onTap, {bool isDropdown = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            Row(
              children: [
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                if (isDropdown) ...[
                  const SizedBox(width: 8),
                  Icon(Icons.keyboard_arrow_down, color: Colors.grey[600], size: 18),
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }
}
