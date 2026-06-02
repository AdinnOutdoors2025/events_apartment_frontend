import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/campaign_provider.dart';

class CommunityDetailsScreen extends ConsumerStatefulWidget {
  const CommunityDetailsScreen({super.key});

  @override
  ConsumerState<CommunityDetailsScreen> createState() => _CommunityDetailsScreenState();
}

class _CommunityDetailsScreenState extends ConsumerState<CommunityDetailsScreen> {
  @override
  void initState() {
    super.initState();
    // Reset initial space selection when opening this screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(campaignProvider.notifier).setInitialSpace('');
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get community name from arguments if passed, otherwise default
    final communityName = ModalRoute.of(context)?.settings.arguments as String? ?? 'Prestige Falcon City';
    final state = ref.watch(campaignProvider);
    final viewModel = ref.read(campaignProvider.notifier);

    final bool isSpaceSelected = state.initialSelectedSpace != null && state.initialSelectedSpace!.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'COMMUNITY',
              style: GoogleFonts.inter(
                color: Colors.grey[600],
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
            Text(
              communityName,
              style: GoogleFonts.inter(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image Card
            Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [Color(0xFF2B2B2B), Color(0xFF1A1A1A)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'KANAKAPURA ROAD, BENGALURU',
                      style: GoogleFonts.inter(
                        color: Colors.grey[400],
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            communityName,
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE5212A),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '94% match',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Stats Row
            Row(
              children: [
                Expanded(child: _buildStatBox('TG', '28–45 yrs', Icons.people_outline)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatBox('FOOTFALL', '4,200', Icons.directions_walk)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatBox('SPACES', '3', Icons.auto_awesome)),
              ],
            ),
            const SizedBox(height: 16),

            // Tags
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildTag('Premium Audience'),
                _buildTag('Automobile Fit'),
                _buildTag('High Footfall'),
              ],
            ),
            const SizedBox(height: 32),

            Text(
              'Available activation spaces',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Tap a space to start your campaign.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),

            // Spaces List
            _buildSpaceItem(
              '10 × 10 ft',
              3150,
              state.initialSelectedSpace == '10 × 10 ft',
              () => viewModel.setInitialSpace('10 × 10 ft'),
            ),
            const SizedBox(height: 12),
            _buildSpaceItem(
              '10 × 20 ft',
              5500,
              state.initialSelectedSpace == '10 × 20 ft',
              () => viewModel.setInitialSpace('10 × 20 ft'),
            ),
            const SizedBox(height: 12),
            _buildSpaceItem(
              '10 × 30 ft',
              8000,
              state.initialSelectedSpace == '10 × 30 ft',
              () => viewModel.setInitialSpace('10 × 30 ft'),
            ),
            const SizedBox(height: 100), // padding for bottom button
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: isSpaceSelected
                ? () {
                    viewModel.initializeBuilder();
                    Navigator.pushNamed(context, '/campaignBuilder', arguments: communityName);
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              disabledBackgroundColor: Colors.grey[300],
              foregroundColor: Colors.white,
              disabledForegroundColor: Colors.grey[600],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28.0),
              ),
            ),
            child: Text(
              isSpaceSelected ? 'Continue' : 'Select a space',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatBox(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(height: 12),
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
            value,
            style: GoogleFonts.inter(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0EF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFBBFBC)),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: const Color(0xFFE5212A),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildSpaceItem(String size, int price, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF0EF) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? const Color(0xFFE5212A) : Colors.grey[200]!,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFE5212A) : Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.domain,
                color: isSelected ? Colors.white : Colors.grey[600],
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    size,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Per day · all-inclusive booking',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '₹${price.toString().replaceAllMapped(RegExp(r'(\\d{1,3})(?=(\\d{3})+(?!\\d))'), (Match m) => '${m[1]},')}',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: '/day',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
