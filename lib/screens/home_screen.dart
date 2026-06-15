import 'package:apartment_client_app/constants/constant.dart';
import 'package:apartment_client_app/providers/main_navigation_provider.dart';
import 'package:apartment_client_app/widgets/animated_counter.dart';
import 'package:apartment_client_app/providers/campaign_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/color.dart';
import '../models/apartment_lists.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final campaignState = ref.watch(campaignProvider);
    final apartmentAsync = ref.watch(apartmentListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getGreeting(),
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      /*Text(
                        'Royal Enfield',
                        style: GoogleFonts.inter(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                          color: Colors.black,
                        ),
                      ),*/
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey[300]!),
                      color: Colors.white,
                    ),
                    child: const Stack(
                      children: [
                        Icon(Icons.notifications_none, size: 24),
                        Positioned(
                          right: 2,
                          top: 2,
                          child: CircleAvatar(
                            radius: 4,
                            backgroundColor: Color(0xFFE5212A),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0A0A0A), Color(0xFF0A0A0A)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PLAN YOUR NEXT CAMPAIGN',
                      style: GoogleFonts.inter(
                        color: Colors.grey[400],
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Premium apartment\nactivations,\nbuilt in minutes.',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Select a community, design the setup, request your quote. ADINN handles permissions and on-ground delivery.',
                      style: GoogleFonts.inter(
                        color: Colors.grey[400],
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        ref.read(campaignProvider.notifier).clearCampaign();
                        ref.read(showSpacesBackButtonProvider.notifier).state =
                            true;
                        ref.read(bottomNavigationIndex.notifier).state = 1;
                      },
                      icon: const Icon(Icons.add, size: 20),
                      label: Text(
                        'Create new campaign',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE5212A),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: buildStatCard('CAMPAIGNS', 12, _animation, false),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: buildStatCard('LEADS', 1840, _animation, true),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: buildStatCard(
                      'SPEND',
                      28500,
                      _animation,
                      true,
                      isCurrency: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Horizontal Scrollable list of drafts
              ref.watch(allDraftsProvider).when(
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: CircularProgressIndicator(color: Color(0xFFE5212A)),
                  ),
                ),
                error: (err, stack) => const SizedBox(height: 12),
                data: (draftList) {
                  if (draftList.isEmpty) return const SizedBox(height: 12);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Text(
                          'CONTINUE DRAFTS',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 105,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: draftList.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final draft = draftList[index];
                            final estVal = draft.builderSelectedSpace != null && draft.dynamicPrices.containsKey(draft.builderSelectedSpace)
                                ? (draft.dynamicPrices[draft.builderSelectedSpace]! * (draft.days > 0 ? draft.days : 1))
                                : 0;
                            // Calculate total estimated price for this draft
                            int estTotal = estVal;
                            if (draft.campaignObjective != null && draft.dynamicPrices.containsKey(draft.campaignObjective)) {
                              estTotal += draft.dynamicPrices[draft.campaignObjective]! * (draft.days > 0 ? draft.days : 1);
                            }
                            draft.categoryBrandingCounts.forEach((item, count) {
                              if (count > 0 && draft.dynamicPrices.containsKey(item)) {
                                if (item.contains('Backdrop') || item.contains('Standee') || item.contains('Flex') || item.contains('Banner')) {
                                  estTotal += draft.dynamicPrices[item]! * count;
                                } else {
                                  estTotal += draft.dynamicPrices[item]! * count * (draft.days > 0 ? draft.days : 1);
                                }
                              }
                            });
                            draft.unCategoryBrandingCounts.forEach((item, count) {
                              if (count > 0 && draft.dynamicPrices.containsKey(item)) {
                                if (item.contains('Backdrop') || item.contains('Standee') || item.contains('Flex') || item.contains('Banner')) {
                                  estTotal += draft.dynamicPrices[item]! * count;
                                } else {
                                  estTotal += draft.dynamicPrices[item]! * count * (draft.days > 0 ? draft.days : 1);
                                }
                              }
                            });
                            draft.stageCounts.forEach((item, count) {
                              if (count > 0 && draft.dynamicPrices.containsKey(item)) {
                                if (item.contains('Backdrop') || item.contains('Standee') || item.contains('Flex') || item.contains('Banner')) {
                                  estTotal += draft.dynamicPrices[item]! * count;
                                } else {
                                  estTotal += draft.dynamicPrices[item]! * count * (draft.days > 0 ? draft.days : 1);
                                }
                              }
                            });
                            if (draft.needPromoters) {
                              for (final req in draft.promoterRequirements) {
                                estTotal += (req.maleCount + req.femaleCount) * 1500 * req.selectedDates.length;
                              }
                            }
                            draft.giftCounts.forEach((item, count) {
                              if (count > 0 && draft.dynamicPrices.containsKey(item)) {
                                estTotal += draft.dynamicPrices[item]! * count;
                              }
                            });
                            draft.experienceCounts.forEach((item, count) {
                              if (count > 0 && draft.dynamicPrices.containsKey(item)) {
                                estTotal += draft.dynamicPrices[item]! * count * (draft.days > 0 ? draft.days : 1);
                              }
                            });

                            return GestureDetector(
                              onTap: () async {
                                final aptId = draft.apartmentId;
                                if (aptId != null) {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) => const Center(
                                      child: CircularProgressIndicator(color: Color(0xFFE5212A)),
                                    ),
                                  );
                                  try {
                                    await ref.read(campaignProvider.notifier).loadDraftForApartment(aptId);
                                    final fieldsList = await ref.read(
                                      apartmentFieldListProvider(aptId).future,
                                    );
                                    if (context.mounted) {
                                      Navigator.pop(context); // close loader
                                      Navigator.pushNamed(
                                        context,
                                        '/campaignBuilder',
                                        arguments: fieldsList,
                                      );
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      Navigator.pop(context); // close loader
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Failed to load draft: $e')),
                                      );
                                    }
                                  }
                                }
                              },
                              child: Container(
                                width: 280,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(color: const Color(0xFFFBBFBC), width: 1.5),
                                  color: const Color(0xFFFFF0EF),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFE5212A),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.auto_awesome,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            draft.customerBrandName?.isNotEmpty == true
                                                ? draft.customerBrandName!.toUpperCase()
                                                : 'CAMPAIGN SETUP',
                                            style: GoogleFonts.inter(
                                              color: const Color(0xFFE5212A),
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.0,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            draft.builderSelectedSpace != null
                                                ? '${draft.builderSelectedSpace} sq.ft · ${draft.schedules.length} blocks'
                                                : 'Continue campaign setup',
                                            style: GoogleFonts.inter(
                                              color: Colors.black,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'Est: ${formatIndianNumber(estTotal, isCurrency: true)}',
                                            style: GoogleFonts.inter(
                                              color: Colors.grey[700],
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_outward,
                                      color: Colors.black,
                                      size: 18,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recommended communities',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                      color: Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      ref.read(bottomNavigationIndex.notifier).state = 1;
                    },
                    child: Text(
                      'See all',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 300,
                child: apartmentAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),

                  error: (error, stack) =>
                      Center(child: Text(error.toString())),

                  data: (response) {
                    final apartments = response.data?.apartments ?? [];

                    if (apartments.isEmpty) {
                      return const Center(
                        child: Text(
                          'No apartments available',
                          style: TextStyle(fontSize: 16),
                        ),
                      );
                    }

                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 1),
                      itemCount: apartments.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        final apartment = apartments[index];

                        return SizedBox(
                          width: 230,
                          child: buildCommunityCard(
                            context: context,
                            name: apartment.apartmentName,
                            location:
                                '${apartment.location}, ${apartment.city}, ${apartment.state}',
                            footfall: apartment.approxPeopleCount,
                            spacesCount: apartment.residencyCount,
                            matchPercent: (int.tryParse("0") ?? 0) * 20,
                            tags: [
                              apartment.isActive,
                              '₹${formatIndianNumber(apartment.perDayRent)}/day',
                            ].where((e) => e.isNotEmpty).toList(),
                            apartment: apartment,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildStatCard(
    String label,
    int targetValue,
    Animation<double> animation,
    bool isLarge, {
    bool isCurrency = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              color: Colors.grey[600],
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 8),
          AnimatedCounter(
            value: targetValue,
            formatter: (value) {
              return formatIndianNumber(value, isCurrency: isCurrency);
            },
            style: GoogleFonts.inter(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCommunityCard({
    required BuildContext context,
    required Apartment apartment,
    required String name,
    required String location,
    required int footfall,
    required int spacesCount,
    required int matchPercent,
    required List<String> tags,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/communityDetails',
          arguments: apartment.id,
        );
      },
      child: SizedBox(
        width: 300,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Container(
                  width: double.infinity,
                  height: 130,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(AppImages.apartmentLandscape),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Match Badge
                      /*                    Positioned(
                        top: 14,
                        right: 14,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                          child: Text(
                            '$matchPercent%',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )*/

                      // Building Icon
                      /*                    Positioned(
                        bottom: 16,
                        left: 16,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.domain,
                            color: Colors.white.withOpacity(0.9),
                            size: 22,
                          ),
                        ),
                      )*/
                    ],
                  ),
                ),

                // Content Section
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Location
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                color: Colors.grey.shade600,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Apartment Name
                      Text(
                        name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Stats
                      Row(
                        children: [
                          Icon(
                            Icons.people_alt_outlined,
                            size: 15,
                            color: Colors.grey.shade700,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$footfall',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            ' footfall',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),

                          const SizedBox(width: 12),

                          Icon(
                            Icons.home_work_outlined,
                            size: 15,
                            color: Colors.grey.shade700,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$spacesCount',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            ' spaces',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),

                      if (tags.isNotEmpty) ...[
                        const SizedBox(height: 14),

                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: tags.map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                tag,
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
