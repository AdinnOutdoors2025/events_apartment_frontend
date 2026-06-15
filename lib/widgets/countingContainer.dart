import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/campaign_provider.dart';
import 'animated_count_text.dart';
import 'animated_price_text.dart';

class QuantityItemCard extends StatelessWidget {
  final String title;
  final int price;
  final int count;
  final int quantity;
  final ValueChanged<int> onChanged;
  final String unitLabel;
  final String Function(int price)? priceFormatter;
  final String stepName;

  const QuantityItemCard({
    super.key,
    required this.title,
    required this.price,
    required this.count,
    required this.onChanged,
    required this.unitLabel,
    this.priceFormatter,
    required this.stepName,
    this.quantity = 0,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = count > 0;
    final lineTotal = price * count;

    String formattedPrice = priceFormatter != null
        ? priceFormatter!(price)
        : "₹$price";

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
                      Text(
                        (stepName == "unCategorized" || stepName == 'gift') &&
                                quantity != 0
                            ? '$title ($quantity/$unitLabel)'
                            : title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        (stepName == "unCategorized" || stepName == 'gift') && quantity != 0
                            ? formattedPrice
                            : '$formattedPrice / $unitLabel',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),

                _Counter(
                  count: count,
                  isSelected: isSelected,
                  onChanged: onChanged,
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
                    '$count $unitLabel'.toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xFFE5212A),
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

class _Counter extends StatelessWidget {
  final int count;
  final bool isSelected;
  final ValueChanged<int> onChanged;

  const _Counter({
    required this.count,
    required this.isSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            onPressed: count > 0 ? () => onChanged(-1) : null,
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(),
          ),
          SizedBox(
            width: 34,
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
            style: IconButton.styleFrom(
              backgroundColor: isSelected
                  ? const Color(0xFFE5212A)
                  : Colors.black,
              foregroundColor: Colors.white,
              minimumSize: const Size(28, 28),
            ),
            onPressed: () => onChanged(1),
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}
