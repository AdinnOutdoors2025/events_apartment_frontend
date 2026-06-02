import 'package:apartment_client_app/providers/main_navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home_screen.dart';
import 'spaces_screen.dart';

class MainNavigation extends ConsumerWidget {
  const MainNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavigationIndex);
    final List<Widget> screens = [
      const HomeScreen(),
      const SpacesScreen(),
      const Scaffold(body: Center(child: Text("Campaigns"))),
      const Scaffold(body: Center(child: Text("Insights"))),
      const Scaffold(body: Center(child: Text("Account"))),
    ];

    final List<Map<String, dynamic>> navItems = [
      {'icon': Icons.home_outlined, 'activeIcon': Icons.home, 'label': 'Home'},
      {
        'icon': Icons.business_outlined,
        'activeIcon': Icons.business,
        'label': 'Spaces',
      },
      {
        'icon': Icons.campaign_outlined,
        'activeIcon': Icons.campaign,
        'label': 'Campaigns',
      },
      {
        'icon': Icons.bar_chart_outlined,
        'activeIcon': Icons.bar_chart,
        'label': 'Insights',
      },
      {
        'icon': Icons.person_outline,
        'activeIcon': Icons.person,
        'label': 'Account',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: screens[currentIndex],

      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(navItems.length, (index) {
              final isSelected = currentIndex == index;

              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  ref.read(bottomNavigationIndex.notifier).state = index;
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(color: Colors.transparent),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSelected
                            ? navItems[index]['activeIcon']
                            : navItems[index]['icon'],
                        size: 24,
                        color: isSelected ? Colors.black : Colors.grey.shade600,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        navItems[index]['label'],
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: isSelected
                              ? Colors.black
                              : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
