import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimatedPriceText extends StatelessWidget {
  final int targetPrice;
  final TextStyle? style;

  const AnimatedPriceText({super.key, required this.targetPrice, this.style});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      tween: Tween<double>(begin: 0, end: targetPrice.toDouble()),
      builder: (context, value, child) {
        final currentPrice = value.round();
        final formattedValue = _formatIndianNumber(currentPrice);
        return Text(
          formattedValue,
          style: style ?? GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        );
      },
    );
  }

  String _formatIndianNumber(int number) {
    String numStr = number.toString();
    if (numStr.length <= 3) return '₹$numStr';

    String result = "";
    int count = 0;
    for (int i = numStr.length - 1; i >= 0; i--) {
      result = numStr[i] + result;
      count++;
      if (count == 3 && i != 0) {
        result = ',$result';
      } else if (count > 3 && (count - 3) % 2 == 0 && i != 0) {
        result = ',$result';
      }
    }
    return '₹$result';
  }
}
