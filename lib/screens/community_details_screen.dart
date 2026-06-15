import 'package:apartment_client_app/models/apartment_lists.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/constant.dart';
import '../providers/campaign_provider.dart';

class CommunityDetailsScreen extends ConsumerStatefulWidget {
  const CommunityDetailsScreen({super.key});

  @override
  ConsumerState<CommunityDetailsScreen> createState() =>
      _CommunityDetailsScreenState();
}

class _CommunityDetailsScreenState
    extends ConsumerState<CommunityDetailsScreen> {
  String? _loadedApartmentId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final apartmentId = ModalRoute.of(context)?.settings.arguments as String?;
    if (apartmentId != null && apartmentId != _loadedApartmentId) {
      _loadedApartmentId = apartmentId;
      ref.read(campaignProvider.notifier).loadDraftForApartment(apartmentId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final apartmentId = ModalRoute.of(context)?.settings.arguments as String;
    final state = ref.watch(campaignProvider);
    final viewModel = ref.read(campaignProvider.notifier);
    print('apartmentId :$apartmentId');
    print('watching provider');
    final apartmentAsync = ref.watch(apartmentFieldListProvider(apartmentId));

    print(apartmentAsync);

    final apartment = apartmentAsync.value?.data?.apartment;
    final events = apartmentAsync.value?.data?.events;

    final bool isCampaignTypeSelected =
        state.campaignObjective != null && state.campaignObjective!.isNotEmpty;

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
              apartment?.apartmentName ?? '',
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
              child: Stack(
                children: [
                  (apartment?.rating!.isNotEmpty ?? false)
                      ? Positioned(
                          top: 16,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.orange,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  apartment?.rating ?? '',
                                  style: GoogleFonts.inter(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : SizedBox(),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${apartment?.location}, ${apartment?.city}, ${apartment?.state}',
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
                                apartment?.apartmentName ?? '',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ),
                            /*Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE5212A),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '0% match',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),*/
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Stats Row
            Row(
              children: [
                Expanded(
                  child: _buildStatBox(
                    'TG',
                    '${formatCompact((apartment?.fromTGValues ?? 0).toDouble())} - '
                        '${formatCompact((apartment?.toTGValues ?? 0).toDouble())}',
                    Icons.people_outline,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatBox(
                    'FOOTFALL',
                    formatIndianNumber(apartment?.approxPeopleCount ?? 0),
                    Icons.directions_walk,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatBox(
                    'SPACES',
                    formatIndianNumber(apartment?.residencyCount ?? 0),
                    Icons.auto_awesome,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'Define the campaign objective',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'We\'ll suggest a setup template once you choose your campaign type.',
              style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),

            Text(
              'CAMPAIGN TYPE',
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 16),
            ListView.separated(
              padding: const EdgeInsets.all(5),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: events?.length ?? 0,
              separatorBuilder: (_, _) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final event = events![index];

                return _buildObjectiveRadio(
                  event.eventName ?? '',
                  event.amount ?? 0,
                  state,
                  viewModel,
                );
              },
            ),
            const SizedBox(height: 150), // padding for bottom button
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
            onPressed: isCampaignTypeSelected
                ? () {
                    // Populate dynamic prices
                    final events = apartmentAsync.value?.data?.events ?? [];
                    final Map<String, int> prices = {};
                    for (final ev in events) {
                      if (ev.eventName != null && ev.amount != null) {
                        prices[ev.eventName!] = ev.amount!;
                      }
                    }
                    final sqFeet =
                        apartmentAsync.value?.data?.apartment?.sqFeetAmount ??
                        [];
                    for (final feet in sqFeet) {
                      if (feet.size != null && feet.charge != null) {
                        prices[feet.size!] = feet.charge!;
                      }
                    }
                    final elements =
                        apartmentAsync.value?.data?.elementsDetails ?? [];
                    for (final cat in elements) {
                      for (final item in (cat.itemsData ?? [])) {
                        if (item.itemName != null && item.amount != null) {
                          prices[item.itemName!] = item.amount!;
                        }
                      }
                    }
                    final gifts =
                        apartmentAsync.value?.data?.giftsDetails?.normalGifts ??
                        [];
                    for (final gift in gifts) {
                      if (gift.giftName != null && gift.price != null) {
                        prices[gift.giftName!] = gift.price!;
                      }
                    }
                    final liveGifts =
                        apartmentAsync.value?.data?.giftsDetails?.liveCounterGifts ??
                        [];
                    for (final gift in liveGifts) {
                      if (gift.giftName != null && gift.price != null) {
                        prices[gift.giftName!] = gift.price!;
                      }
                    }

                    viewModel.setDynamicPrices(prices);
                    viewModel.initializeBuilder(apartmentId, apartment?.perDayRent ?? 0);
                    final data = apartmentAsync.value;

                    if (data != null) {
                      Navigator.pushNamed(
                        context,
                        '/campaignBuilder',
                        arguments: data,
                      );
                    }
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
              'Select a space',
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

  Widget _buildObjectiveRadio(
    String title,
    int price,
    CampaignState state,
    CampaignViewModel viewModel,
  ) {
    bool isSelected = state.campaignObjective == title;
    return GestureDetector(
      onTap: () => viewModel.setObjective(title),
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
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '₹${formatIndianNumber(price)}',
                    style: GoogleFonts.inter(
                      fontSize: 14,
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


}
