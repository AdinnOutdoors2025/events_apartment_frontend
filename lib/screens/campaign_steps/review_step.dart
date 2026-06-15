import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../providers/campaign_provider.dart';
import '../../constants/constant.dart';

class ReviewStep extends ConsumerStatefulWidget {
  final Function(int) onEdit;

  const ReviewStep({super.key, required this.onEdit});

  @override
  ConsumerState<ReviewStep> createState() => _ReviewStepState();
}

class _ReviewStepState extends ConsumerState<ReviewStep> {
  final _discountCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final state = ref.read(campaignProvider);
    if (state.discountType != null) {
      _discountCtrl.text = state.discountPercentage.toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    _discountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(campaignProvider);
    final viewModel = ref.read(campaignProvider.notifier);

    final double subtotal = viewModel.estimatedTotal.toDouble();
    final int? discountType = state.discountType;
    final double discountValue = double.tryParse(_discountCtrl.text) ?? 0.0;

    double discountAmount = 0.0;
    if (discountType == 1) {
      discountAmount = subtotal * (discountValue / 100.0);
    } else if (discountType == 2) {
      discountAmount = discountValue;
    }

    final double discountedSubtotal = (subtotal - discountAmount).clamp(
      0.0,
      double.infinity,
    );
    final double gstAmount = discountedSubtotal * 0.18;
    final double finalTotal = discountedSubtotal + gstAmount;

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
                  'FINAL ESTIMATE (INCL. GST)',
                  style: GoogleFonts.inter(
                    color: Colors.grey[400],
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  formatIndianNumber(finalTotal.round(), isCurrency: true),
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Includes applied discount and 18% GST',
                  style: GoogleFonts.inter(
                    color: Colors.grey[400],
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Discount Section
         /* Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'APPLY DISCOUNT',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _discountCtrl.clear();
                          viewModel.setDiscount(1, 0.0);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: discountType == 1
                                ? const Color(0xFFE5212A)
                                : Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: discountType == 1
                                  ? const Color(0xFFE5212A)
                                  : Colors.grey.shade200,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Percentage (%)',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: discountType == 1
                                  ? Colors.white
                                  : Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _discountCtrl.clear();
                          viewModel.setDiscount(2, 0.0);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: discountType == 2
                                ? const Color(0xFFE5212A)
                                : Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: discountType == 2
                                  ? const Color(0xFFE5212A)
                                  : Colors.grey.shade200,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Amount (₹)',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: discountType == 2
                                  ? Colors.white
                                  : Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (discountType != null) ...[
                  const SizedBox(height: 16),
                  TextField(
                    controller: _discountCtrl,
                    keyboardType: TextInputType.number,
                    onChanged: (val) {
                      final parsed = double.tryParse(val) ?? 0.0;
                      viewModel.setDiscount(discountType, parsed);
                    },
                    decoration: InputDecoration(
                      hintText: discountType == 1
                          ? 'Enter discount percentage (e.g. 10)'
                          : 'Enter discount amount (e.g. 1500)',
                      hintStyle: GoogleFonts.inter(
                        color: Colors.grey[400],
                        fontSize: 13,
                      ),
                      prefixIcon: Icon(
                        discountType == 1
                            ? Icons.percent
                            : Icons.currency_rupee,
                        size: 16,
                        color: Colors.grey[500],
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.grey[200]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.grey[200]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),*/

          // Price Summary breakdown card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'INVESTMENT SUMMARY',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 16),
                /*_buildSummaryRow(
                  'Apartment Rent',
                  formatIndianNumber(viewModel.apartmentRent, isCurrency: true),
                  subtitle: state.days >= 2
                      ? '₹${formatIndianNumber(state.apartmentPerDayRent ?? 0)} × ${state.days} days'
                      : null,
                ),*/
                const SizedBox(height: 8),
                _buildSummaryRow(
                  'Space Booking',
                  formatIndianNumber(viewModel.spaceTotal, isCurrency: true),
                  /*subtitle: state.days >= 2
                      ? '₹${formatIndianNumber(state.dynamicPrices[state.builderSelectedSpace] ?? 0)} × ${state.days} days'
                      : null,*/
                ),
                const SizedBox(height: 8),
                _buildSummaryRow(
                  'Campaign Type / Objective',
                  formatIndianNumber(
                    viewModel.objectiveTotal,
                    isCurrency: true,
                  ),
                 /* subtitle: state.days >= 2
                      ? '₹${formatIndianNumber(state.dynamicPrices[state.campaignObjective] ?? 0)} × ${state.days} days'
                      : null,*/
                ),
                const SizedBox(height: 8),
                viewModel.categorizedBrandingTotal == 0
                    ? SizedBox()
                    : Column(
                        children: [
                          _buildSummaryRow(
                            'Branding (Categorized)',
                            formatIndianNumber(
                              viewModel.categorizedBrandingTotal,
                              isCurrency: true,
                            ),
                            /*subtitle: () {
                              if (state.days < 2) return null;
                              List<String> items = [];
                              state.categoryBrandingCounts.forEach((
                                item,
                                count,
                              ) {
                                if (count > 0 &&
                                    state.dynamicPrices.containsKey(item)) {
                                  final isFlat =
                                      item.contains('Backdrop') ||
                                      item.contains('Standee') ||
                                      item.contains('Flex') ||
                                      item.contains('Banner');
                                  final price = state.dynamicPrices[item]!;
                                  if (isFlat) {
                                    items.add(
                                      '$item: ₹${formatIndianNumber(price)} × $count (Flat)',
                                    );
                                  } else {
                                    items.add(
                                      '$item: ₹${formatIndianNumber(price)} × $count × ${state.days} days',
                                    );
                                  }
                                }
                              });
                              return items.isNotEmpty ? items.join('\n') : null;
                            }(),*/
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                viewModel.uncategorizedBrandingTotal == 0
                    ? SizedBox()
                    : Column(
                        children: [
                          _buildSummaryRow(
                            'Branding (Essentials)',
                            formatIndianNumber(
                              viewModel.uncategorizedBrandingTotal,
                              isCurrency: true,
                            ),
                            /*subtitle: () {
                              if (state.days < 2) return null;
                              List<String> items = [];
                              state.unCategoryBrandingCounts.forEach((
                                item,
                                count,
                              ) {
                                if (count > 0 &&
                                    state.dynamicPrices.containsKey(item)) {
                                  final isFlat =
                                      item.contains('Backdrop') ||
                                      item.contains('Standee') ||
                                      item.contains('Flex') ||
                                      item.contains('Banner');
                                  final price = state.dynamicPrices[item]!;
                                  if (isFlat) {
                                    items.add(
                                      '$item: ₹${formatIndianNumber(price)} × $count',
                                    );
                                  } else {
                                    items.add(
                                      '$item: ₹${formatIndianNumber(price)} × $count × ${state.days} days',
                                    );
                                  }
                                }
                              });
                              return items.isNotEmpty ? items.join('\n') : null;
                            }(),*/
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                viewModel.stageTotal == 0
                    ? SizedBox()
                    : Column(
                        children: [
                          _buildSummaryRow(
                            'Stage Setup',
                            formatIndianNumber(
                              viewModel.stageTotal,
                              isCurrency: true,
                            ),
                            /*subtitle: () {
                              if (state.days < 2) return null;
                              List<String> items = [];
                              state.stageCounts.forEach((item, count) {
                                if (count > 0 &&
                                    state.dynamicPrices.containsKey(item)) {
                                  final price = state.dynamicPrices[item]!;
                                  *//*final isFlat =
                                      item.contains('Backdrop') ||
                                      item.contains('Standee') ||
                                      item.contains('Flex') ||
                                      item.contains('Banner');

                                  if (isFlat) {
                                    items.add(
                                      '$item: ₹${formatIndianNumber(price)} × $count (Flat)',
                                    );
                                  } else {*//*
                                    items.add(
                                      '$item: ₹${formatIndianNumber(price)} × $count × ${state.days} days',
                                    );
                                  *//*}*//*
                                }
                              });
                              return items.isNotEmpty ? items.join('\n') : null;
                            }(),*/
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                viewModel.promotersTotal == 0
                    ? SizedBox()
                    : Column(
                        children: [
                          _buildSummaryRow(
                            'Promoters Setup',
                            formatIndianNumber(
                              viewModel.promotersTotal,
                              isCurrency: true,
                            ),
                            /*subtitle: () {
                              if (state.days < 2) return null;
                              List<String> promoterLines = [];
                              for (
                                int i = 0;
                                i < state.promoterRequirements.length;
                                i++
                              ) {
                                final req = state.promoterRequirements[i];
                                final count = req.maleCount + req.femaleCount;
                                if (count > 0) {
                                  promoterLines.add(
                                    'Req ${i + 1}: ₹1,500 × $count promoters × ${req.selectedDates.length} days',
                                  );
                                }
                              }
                              return promoterLines.isNotEmpty
                                  ? promoterLines.join('\n')
                                  : null;
                            }(),*/
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                viewModel.giftsExperiencesTotal == 0
                    ? SizedBox()
                    : _buildSummaryRow(
                        'Engagement Gifts & Experiences',
                        formatIndianNumber(
                          viewModel.giftsExperiencesTotal,
                          isCurrency: true,
                        ),
                        /*subtitle: () {
                          if (state.days < 2) return null;
                          List<String> items = [];
                          state.giftCounts.forEach((item, count) {
                            if (count > 0 &&
                                state.dynamicPrices.containsKey(item)) {
                              final price = state.dynamicPrices[item]!;
                              items.add(
                                '$item: ₹${formatIndianNumber(price)} × $count (Flat)',
                              );
                            }
                          });
                          state.experienceCounts.forEach((item, count) {
                            if (count > 0 &&
                                state.dynamicPrices.containsKey(item)) {
                              final price = state.dynamicPrices[item]!;
                              items.add(
                                '$item: ₹${formatIndianNumber(price)} × $count × ${state.days} days',
                              );
                            }
                          });
                          return items.isNotEmpty ? items.join('\n') : null;
                        }(),*/
                      ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Divider(height: 1),
                ),
                _buildSummaryRow(
                  'Subtotal',
                  formatIndianNumber(subtotal.round(), isCurrency: true),
                ),
                if (discountType != null) ...[
                  const SizedBox(height: 10),
                  _buildSummaryRow(
                    discountType == 1
                        ? 'Discount Applied (${discountValue.toStringAsFixed(0)}%)'
                        : 'Discount Applied (₹${formatIndianNumber(discountValue.round())})',
                    '- ${formatIndianNumber(discountAmount.round(), isCurrency: true)}',
                    valueColor: const Color(0xFFE5212A),
                  ),
                ],
                const SizedBox(height: 10),
                _buildSummaryRow(
                  'GST (18%)',
                  formatIndianNumber(gstAmount.round(), isCurrency: true),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Divider(height: 1),
                ),
                _buildSummaryRow(
                  'Final Amount',
                  formatIndianNumber(finalTotal.round(), isCurrency: true),
                  isBold: true,
                  subtitle: discountType != null
                      ? 'Note: Final amount is not a final price.'
                      : null,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'SCHEDULE & SPACE',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                        letterSpacing: 1.0,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => widget.onEdit(0),
                      child: Text(
                        'Change',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFE5212A),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.square_foot, size: 20, color: Color(0xFFE5212A)),
                    const SizedBox(width: 8),
                    Text(
                      'Selected Space: ',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      '${state.builderSelectedSpace ?? "-"} sq.ft',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),
                Text(
                  'Added Schedule Blocks:',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                if (state.schedules.isEmpty)
                  Text(
                    'No schedule ranges added yet.',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  )
                else
                  ...state.schedules.map((schedule) {
                    final sd = DateFormat('dd MMM yyyy').format(schedule.startDate);
                    final ed = DateFormat('dd MMM yyyy').format(schedule.endDate);
                    return Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF0EF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 14, color: Color(0xFFE5212A)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '$sd → $ed',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Text(
                            '${schedule.fromTime} - ${schedule.toTime}',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              ],
            ),
          ),


          // Breakdowns
          /*_buildBreakdownItem(
            'SPACE BOOKING',
            viewModel.spaceTotal,
            () => widget.onEdit(0),
          ),*/
          const SizedBox(height: 12),
          _buildBreakdownItem(
            'BRANDING (CATEGORIZED)',
            viewModel.categorizedBrandingTotal,
            () => widget.onEdit(1),
          ),
          const SizedBox(height: 12),
          _buildBreakdownItem(
            'BRANDING (ESSENTIALS)',
            viewModel.uncategorizedBrandingTotal,
            () => widget.onEdit(1),
          ),
          const SizedBox(height: 12),
          _buildBreakdownItem(
            'STAGE SETUP',
            viewModel.stageTotal,
            () => widget.onEdit(2),
          ),
          const SizedBox(height: 12),
          _buildBreakdownItem(
            'PROMOTERS SETUP',
            viewModel.promotersTotal,
            () => widget.onEdit(3),
          ),
          const SizedBox(height: 12),
          _buildBreakdownItem(
            'ENGAGEMENT GIFTS',
            viewModel.giftsExperiencesTotal,
            () => widget.onEdit(4),
          ),
          const SizedBox(height: 12),
          _buildBreakdownItem(
            'CUSTOMER DETAILS',
            0,
            () => widget.onEdit(6),
            hideAmount: true,
          ),

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

          const SizedBox(height: 120), // Space for bottom bar
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isBold = false,
    Color? valueColor,
    String? subtitle,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: isBold ? 14 : 13,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
                  color: isBold ? Colors.black : Colors.grey[700],
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: isBold ? const Color(0xFFE5212A) : Colors.grey[500],
                    fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ],
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: isBold ? 16 : 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: valueColor ?? (isBold ? Colors.black : Colors.grey[800]),
          ),
        ),
      ],
    );
  }

  Widget _buildBreakdownItem(
    String title,
    int amount,
    VoidCallback onEdit, {
    bool hideAmount = false,
  }) {
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
              if (!hideAmount) ...[
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
