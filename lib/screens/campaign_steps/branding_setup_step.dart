import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/apartment_field_list.dart';
import '../../providers/campaign_provider.dart';
import '../../widgets/countingContainer.dart';

class BrandingSetupStep extends ConsumerStatefulWidget {
  final ApartmentFieldsList apartmentFieldsList;

  const BrandingSetupStep({super.key, required this.apartmentFieldsList});

  @override
  ConsumerState<BrandingSetupStep> createState() => _BrandingSetupStepState();
}

class _BrandingSetupStepState extends ConsumerState<BrandingSetupStep> {
  bool isSelectionExpanded = true;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(campaignProvider);
    final viewModel = ref.read(campaignProvider.notifier);

    final List<ElementsDetails> categorized = [];
    final List<ItemsData> uncategorized = [];

    final elementDetails =
        widget.apartmentFieldsList.data?.elementsDetails ?? <ElementsDetails>[];

    for (final category in elementDetails) {
      if (category.categoryName?.toLowerCase() == 'stage') {
        continue;
      }
      final items = category.itemsData ?? [];

      if (items.any((e) => e.itemType == 2)) {
        categorized.add(category);
      }

      for (final item in items) {
        if (item.itemType == 1) {
          uncategorized.add(item);
        }
      }
    }

    /// Collect selected items
    final List<Map<String, dynamic>> selectedItems = [];
    double grandTotal = 0;

    for (final category in categorized) {
      for (final item in (category.itemsData ?? [])) {
        final qty = state.categoryBrandingCounts[item.itemName] ?? 0;

        if (qty > 0) {
          final itemTotal = ((item.amount ?? 0) * qty).toDouble();

          grandTotal += itemTotal;

          selectedItems.add({
            'category': category.categoryName ?? '',
            'item': item,
            'qty': qty,
            'total': itemTotal,
          });
        }
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ==========================
          /// YOUR SELECTION CARD
          /// ==========================
          if (selectedItems.isNotEmpty) ...[
            GestureDetector(
              onTap: () {
                setState(() {
                  isSelectionExpanded = !isSelectionExpanded;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    /// HEADER
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Text(
                            'YOUR SELECTION',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                              color: Colors.grey[600],
                            ),
                          ),

                          const Spacer(),

                          TextButton(
                            onPressed: () {
                              viewModel.clearBrandingSelection();
                            },
                            child: const Text('Clear all'),
                          ),

                          InkWell(
                            onTap: () {
                              setState(() {
                                isSelectionExpanded = !isSelectionExpanded;
                              });
                            },
                            child: AnimatedRotation(
                              duration: const Duration(milliseconds: 250),
                              turns: isSelectionExpanded ? 0.5 : 0,
                              child: const Icon(Icons.keyboard_arrow_down),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Divider(height: 1, color: Colors.grey.shade300),

                    /// COLLAPSED
                    if (!isSelectionExpanded)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${selectedItems.length} items selected',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                            Text(
                              '₹${grandTotal.toStringAsFixed(0)}',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),

                    /// EXPANDED
                    if (isSelectionExpanded)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            ...categorized.map((category) {
                              final categoryItems = selectedItems
                                  .where(
                                    (e) =>
                                        e['category'] == category.categoryName,
                                  )
                                  .toList();

                              if (categoryItems.isEmpty) {
                                return const SizedBox.shrink();
                              }

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 1),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      category.categoryName ?? '',
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),

                                    const SizedBox(height: 8),

                                    ...categoryItems.map((data) {
                                      final item = data['item'];
                                      final qty = data['qty'];

                                      return Row(
                                        children: [
                                          Expanded(
                                            child: Text(item.itemName ?? ''),
                                          ),
                                          Text('Qty $qty'),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.close,
                                              size: 18,
                                              color: Colors.red,
                                            ),
                                            onPressed: () {
                                              ref
                                                  .read(
                                                    campaignProvider.notifier,
                                                  )
                                                  .clearBrandingItem(
                                                    item.itemName ?? '',
                                                  );
                                            },
                                          ),
                                        ],
                                      );
                                    }),
                                  ],
                                ),
                              );
                            }),

                            Divider(color: Colors.grey.shade300),

                            Row(
                              children: [
                                Text(
                                  'TOTAL',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '₹${grandTotal.toStringAsFixed(0)}',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],

          /// ==========================
          /// HEADER
          /// ==========================
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
            'Add canopies, counters, backdrops and signage — all priced per day, hour, square feet, feet.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),

          const SizedBox(height: 32),

          Text(
            'CATEGORIZED',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
              letterSpacing: 1.0,
            ),
          ),

          const SizedBox(height: 16),

          /// ==========================
          /// CATEGORY LIST
          /// ==========================
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categorized.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final category = categorized[index];

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                  ),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(horizontal: 16),

                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.transparent),
                    ),

                    collapsedShape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.transparent),
                    ),

                    childrenPadding: const EdgeInsets.only(
                      left: 8,
                      right: 8,
                      bottom: 8,
                    ),

                    title: Text(
                      category.categoryName ?? '',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    children: (category.itemsData ?? [])
                        .map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: QuantityItemCard(
                              title: item.itemName ?? '',
                              price: item.amount ?? 0,
                              count:
                                  state.categoryBrandingCounts[item.itemName ??
                                      ''] ??
                                  0,
                              unitLabel: item.amountUnit == 1
                                  ? 'day'
                                  : item.amountUnit == 2
                                  ? 'hour'
                                  : item.amountUnit == 3
                                  ? 'sq.ft'
                                  : 'feet',
                              onChanged: (delta) {
                                viewModel.updateBrandingCount(
                                  item.itemName ?? '',
                                  delta,
                                );
                              },
                              priceFormatter: (price) => '₹$price', stepName: 'brandingCategorized',
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              );
            },
          ),

          /// ==========================
          /// UNCATEGORIZED SECTION
          /// ==========================
          if (uncategorized.isNotEmpty) ...[
            const SizedBox(height: 32),

            Text(
              'UNCATEGORIZED',
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
                letterSpacing: 1.0,
              ),
            ),

            const SizedBox(height: 16),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(5),
              itemCount: uncategorized.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final item = uncategorized[index];
                final count =
                    state.unCategoryBrandingCounts[item.itemName ?? ''] ?? 0;

                return QuantityItemCard(
                  title: item.itemName ?? '',
                  price: item.amount ?? 0,
                  count: count,
                  unitLabel: item.amountUnit == 1
                      ? 'day'
                      : item.amountUnit == 2
                      ? 'hour'
                      : item.amountUnit == 3
                      ? 'sq.ft'
                      : 'feet',
                  onChanged: (delta) {
                    viewModel.updateUnCategoryCount(
                      item.itemName ?? '',
                      delta,
                    );
                  },
                  priceFormatter: (price) => '₹$price',
                  stepName: 'brandingUncategorized',
                );
              },
            ),
          ],

          const SizedBox(height: 120),
        ],
      ),
    );
  }
}
