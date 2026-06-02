import 'package:apartment_client_app/providers/main_navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class SpacesScreen extends ConsumerStatefulWidget {
  const SpacesScreen({super.key});

  @override
  ConsumerState<SpacesScreen> createState() => _SpacesScreenState();
}

class _SpacesScreenState extends ConsumerState<SpacesScreen> {
  String selectedFilter = 'All';

  final List<String> filters = [
    'All',
    'Premium Audience',
    'High Footfall',
    'Family Residents',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            ref.read(bottomNavigationIndex.notifier).state = 0;
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'STEP 1',
              style: GoogleFonts.inter(
                color: Colors.grey[600],
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
            Text(
              'Select your apartment',
              style: GoogleFonts.inter(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              bottom: 16.0,
              right: 16.0,
            ),
            child: SizedBox(
              height: 36,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: filters.length,
                itemBuilder: (context, index) {
                  final filter = filters[index];
                  final isSelected = selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedFilter = filter;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.black : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? Colors.black
                                : Colors.grey[300]!,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            filter,
                            style: GoogleFonts.inter(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.grey[700],
                              fontSize: 13,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildCommunityCard(
            context: context,
            name: 'Prestige Falcon City',
            location: 'Kanakapura Road, Bengaluru',
            footfall: '4,200',
            spacesCount: 3,
            matchPercent: 94,
            tags: ['Premium Audience', 'Automobile Fit'],
          ),
          const SizedBox(height: 16),
          _buildCommunityCard(
            context: context,
            name: 'Sobha Dream Acres',
            location: 'Panathur, Bengaluru',
            footfall: '6,800',
            spacesCount: 2,
            matchPercent: 88,
            tags: ['Family Residents', 'FMCG Fit'],
          ),
          const SizedBox(height: 16),
          _buildCommunityCard(
            context: context,
            name: 'Brigade Meadows',
            location: 'Anekal, Bengaluru',
            footfall: '3,100',
            spacesCount: 2,
            matchPercent: 81,
            tags: ['Premium Audience', 'FMCG Fit'],
          ),
          const SizedBox(height: 16),
          _buildCommunityCard(
            context: context,
            name: 'Purva Palm Beach',
            location: 'Hennur Road, Bengaluru',
            footfall: '5,200',
            spacesCount: 3,
            matchPercent: 90,
            tags: ['Premium Audience', 'Automobile Fit'],
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityCard({
    required BuildContext context,
    required String name,
    required String location,
    required String footfall,
    required int spacesCount,
    required int matchPercent,
    required List<String> tags,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/communityDetails', arguments: name);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            // Dark left placeholder
            Container(
              width: 100,
              height: 140, // fixed height for content alignment
              decoration: const BoxDecoration(
                color: Color(0xFF222222),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  bottomLeft: Radius.circular(24),
                ),
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Icon(
                    Icons.domain,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ),
            ),
            // Right content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: 14,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      location,
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Match percent circle
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFE5212A),
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '$matchPercent',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(
                          footfall,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          ' footfall   ·   $spacesCount spaces',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: tags.map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            tag,
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
