import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimatedCountText extends StatefulWidget {
  final int count;
  final TextStyle? style;

  const AnimatedCountText({super.key, required this.count, this.style});

  @override
  State<AnimatedCountText> createState() => _AnimatedCountTextState();
}

class _AnimatedCountTextState extends State<AnimatedCountText> {
  late int _previousCount;

  @override
  void initState() {
    super.initState();
    _previousCount = widget.count;
  }

  @override
  void didUpdateWidget(covariant AnimatedCountText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.count != widget.count) {
      _previousCount = oldWidget.count;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isIncreasing = widget.count > _previousCount;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        final offsetAnimation = Tween<Offset>(
          begin: Offset(0.0, isIncreasing ? -0.5 : 0.5),
          end: Offset.zero,
        ).animate(animation);
        
        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      child: Text(
        '${widget.count}',
        key: ValueKey<int>(widget.count),
        style: widget.style ?? GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }
}
