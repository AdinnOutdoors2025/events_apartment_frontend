import 'dart:async';
import 'package:apartment_client_app/constants/color.dart';
import 'package:apartment_client_app/models/apartment_lists.dart';
import 'package:apartment_client_app/providers/main_navigation_provider.dart';
import 'package:apartment_client_app/providers/spaces_filter_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/constant.dart';

class SpacesScreen extends ConsumerStatefulWidget {
  const SpacesScreen({super.key});

  @override
  ConsumerState<SpacesScreen> createState() => _SpacesScreenState();
}

class _SpacesScreenState extends ConsumerState<SpacesScreen> {
  late ScrollController _scrollController;
  late TextEditingController searchController;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    searchController = TextEditingController();
    _scrollController.addListener(_onScroll);

    searchController.addListener(() {
      setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final query = ref.read(spacesFilterProvider).searchQuery;

      searchController.text = query;
    });
  }

  void _onScroll() {
    final state = ref.read(spacesListProvider);

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!state.isLoading &&
          !state.isLoadingMore &&
          state.pageNumber < state.totalPages) {
        ref
            .read(spacesListProvider.notifier)
            .fetchPage(page: state.pageNumber + 1);
      }
    }
    print("====== PAGINATION ======");
    print("Current Page: ${state.pageNumber}");
    print("Total Pages: ${state.totalPages}");
    print("Loading: ${state.isLoading}");
    print("Loading More: ${state.isLoadingMore}");
  }

  @override
  void dispose() {
    _scrollController.dispose();
    searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _openBottomSheet(
    BuildContext context,
    WidgetRef ref,
    ApartmentData data,
    SpacesFilterState filterState,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: false,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final bottomInset = MediaQuery.of(context).viewPadding.bottom;

        return Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: _FilterBottomSheet(
            data: data,
            initialFilter: filterState,
            onApply: (newFilter) {
              ref.read(spacesFilterProvider.notifier).setFilters(newFilter);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final spacesState = ref.watch(spacesListProvider);
    final showBackButton = ref.watch(showSpacesBackButtonProvider);

    final mockData = ApartmentData(
      pageNumber: spacesState.pageNumber,
      count: spacesState.count,
      totalCount: spacesState.totalCount,
      totalPages: spacesState.totalPages,
      locationFilter: spacesState.locationFilter,
      cityFilter: spacesState.cityFilter,
      stateFilter: spacesState.stateFilter,
      priceRange: spacesState.priceRange,
      apartments: spacesState.apartments,
      apartmentGroupNameFilter: spacesState.apartmentGroupNameFilter,
    );
    final currentSearch = ref.watch(spacesFilterProvider).searchQuery;

    if (searchController.text != currentSearch) {
      searchController.text = currentSearch;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        leading: showBackButton
            ? IconButton(
                onPressed: () {
                  ref.read(bottomNavigationIndex.notifier).state = 0;
                },
                icon: const Icon(Icons.arrow_back),
              )
            : null,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            showBackButton
                ? Text(
                    'STEP 1',
                    style: GoogleFonts.inter(
                      color: Colors.grey[600],
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  )
                : const SizedBox(),
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
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchAndFilterHeader(context, ref, mockData),
          _buildActiveFiltersRow(
            context,
            ref,
            ref.watch(spacesFilterProvider),
            mockData,
          ),
          if (!spacesState.isLoading)
            Padding(
              padding: const EdgeInsets.only(left: 22.0),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Showing ',
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: formatIndianNumber(spacesState.totalCount),
                      style: const TextStyle(
                        color: AppColors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text: searchController.text.trim().isNotEmpty
                          ? ' Matching Apartments for "${searchController.text}"'
                          : ' Apartments',
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Expanded(
            child: Stack(
              children: [
                _buildList(context, ref),

                if (spacesState.isLoading)
                  const Center(
                    child: CircularProgressIndicator(color: Color(0xFFE5212A)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, WidgetRef ref) {
    final spacesState = ref.watch(spacesListProvider);

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(spacesListProvider.notifier).fetchPage(page: 1);
      },
      child: spacesState.apartments.isEmpty && spacesState.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFE5212A)),
            )
          : spacesState.apartments.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                Center(
                  child: Text(
                    'No apartments match search/filters',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            )
          : ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount:
                  spacesState.apartments.length +
                  (spacesState.isLoadingMore ? 1 : 0),
              separatorBuilder: (context, index) {
                if (index < spacesState.apartments.length - 1) {
                  return const SizedBox(height: 16);
                }
                return const SizedBox.shrink();
              },
              itemBuilder: (context, index) {
                if (index < spacesState.apartments.length) {
                  final apartment = spacesState.apartments[index];
                  return _buildCommunityCard(
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
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFFE5212A),
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
    );
  }

  Widget _buildSearchAndFilterHeader(
    BuildContext context,
    WidgetRef ref,
    ApartmentData data,
  ) {
    final filterState = ref.watch(spacesFilterProvider);

    int activeFiltersCount = 0;
    if (filterState.selectedLocation != null) activeFiltersCount++;
    if (filterState.selectedCity != null) activeFiltersCount++;
    if (filterState.selectedState != null) activeFiltersCount++;
    if (filterState.selectedApartmentGroup != null) activeFiltersCount++;
    if (filterState.minTG != null || filterState.maxTG != null) {
      activeFiltersCount++;
    }
    if (filterState.minRent != null || filterState.maxRent != null) {
      activeFiltersCount++;
    }

    final bool hasActiveFilters = activeFiltersCount > 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: searchController,
                onChanged: (val) {
                  if (_debounce?.isActive ?? false) {
                    _debounce!.cancel();
                  }

                  _debounce = Timer(
                    const Duration(milliseconds: 500),
                    () async {
                      print('User typing: "$val"');
                      final query = val.trim();

                      final currentQuery = ref
                          .read(spacesFilterProvider)
                          .searchQuery;

                      if (query == currentQuery) return;

                      ref
                          .read(spacesFilterProvider.notifier)
                          .setSearchQuery(query);

                      print(query);
                      await ref
                          .read(spacesListProvider.notifier)
                          .fetchPage(page: 1, overrideSearch: query);
                    },
                  );
                },
                decoration: InputDecoration(
                  hintText: 'Search apartments, city, state, TG, rent...',
                  hintStyle: GoogleFonts.inter(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey[600],
                    size: 20,
                  ),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () async {
                            searchController.clear();

                            ref
                                .read(spacesFilterProvider.notifier)
                                .setSearchQuery('');

                            await ref
                                .read(spacesListProvider.notifier)
                                .fetchPage(page: 1, overrideSearch: '');

                            setState(() {});
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Stack(
            clipBehavior: Clip.none,
            children: [
              GestureDetector(
                onTap: () => _openBottomSheet(context, ref, data, filterState),
                child: Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: hasActiveFilters
                        ? const Color(0xFFE5212A)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: hasActiveFilters
                          ? const Color(0xFFE5212A)
                          : Colors.grey[200]!,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.tune,
                    color: hasActiveFilters ? Colors.white : Colors.black,
                    size: 20,
                  ),
                ),
              ),
              if (hasActiveFilters)
                Positioned(
                  right: -4,
                  top: -4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Center(
                      child: Text(
                        '$activeFiltersCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFiltersRow(
    BuildContext context,
    WidgetRef ref,
    SpacesFilterState filterState,
    ApartmentData data,
  ) {
    final filterNotifier = ref.read(spacesFilterProvider.notifier);
    final List<Widget> chips = [];

    if (filterState.selectedLocation != null) {
      chips.add(
        _buildFilterChip(
          context,
          'Location: ${filterState.selectedLocation?.toLowerCase()}',
          () {
            filterNotifier.clearLocation();
          },
        ),
      );
    }
    if (filterState.selectedCity != null) {
      chips.add(
        _buildFilterChip(
          context,
          'City: ${filterState.selectedCity?.toLowerCase()}',
          () {
            filterNotifier.clearCity();
          },
        ),
      );
    }
    if (filterState.selectedState != null) {
      chips.add(
        _buildFilterChip(
          context,
          'State: ${filterState.selectedState?.toLowerCase()}',
          () {
            filterNotifier.clearStateFilter();
          },
        ),
      );
    }
    if (filterState.selectedApartmentGroup != null) {
      chips.add(
        _buildFilterChip(
          context,
          'Group: ${filterState.selectedApartmentGroup?.toLowerCase()}',
          () {
            filterNotifier.clearApartmentGroup();
          },
        ),
      );
    }
    if (filterState.minTG != null || filterState.maxTG != null) {
      final min = filterState.minTG?.round() ?? (data.priceRange?.minTG ?? 0);
      final max =
          filterState.maxTG?.round() ?? (data.priceRange?.maxTG ?? 1000);
      chips.add(
        _buildFilterChip(
          context,
          'TG: ${formatCompact(min)} - ${formatCompact(max)}',
          () {
            filterNotifier.clearTGRange();
          },
        ),
      );
    }
    if (filterState.minRent != null || filterState.maxRent != null) {
      final min =
          filterState.minRent?.round() ?? (data.priceRange?.minRent ?? 0);
      final max =
          filterState.maxRent?.round() ?? (data.priceRange?.maxRent ?? 10000);
      chips.add(
        _buildFilterChip(
          context,
          'Rent: ₹${formatCompact(min)} - ${formatCompact(max)}',
          () {
            filterNotifier.clearRentRange();
          },
        ),
      );
    }

    if (chips.isEmpty) return const SizedBox();

    return Container(
      height: 40,
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          GestureDetector(
            onTap: () {
              filterNotifier.resetFilters();
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8.0, top: 4.0, bottom: 4.0),
              padding: const EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0EF),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFFBBFBC)),
              ),
              child: const Icon(
                Icons.close,
                color: Color(0xFFE5212A),
                size: 16,
              ),
            ),
          ),
          ...chips,
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    String label,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Icon(Icons.close, color: Color(0xFFE5212A), size: 13),
            SizedBox(width: 5),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommunityCard({
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
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 140, // fixed height for content alignment
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppImages.apartmentPortrait),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  bottomLeft: Radius.circular(24),
                ),
              ),
              /*child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Icon(
                    Icons.domain,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ),*/
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
                        matchPercent != 0
                            ? Container(
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
                              )
                            : SizedBox(),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(
                          footfall.toString(),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          ' footfall',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          '  ·  $spacesCount',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '  spaces',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        Spacer(),
                        apartment.rating.isNotEmpty
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF3E0),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.orange,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 3),
                                    Text(
                                      apartment.rating,
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox(),
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

class _FilterBottomSheet extends StatefulWidget {
  final ApartmentData data;
  final SpacesFilterState initialFilter;
  final ValueChanged<SpacesFilterState> onApply;

  const _FilterBottomSheet({
    required this.data,
    required this.initialFilter,
    required this.onApply,
  });

  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  String? _selectedLocation;
  String? _selectedCity;
  String? _selectedState;
  String? _selectedApartmentGroup;

  double _minTG = 0;
  double _maxTG = 1000;
  double _minRent = 0;
  double _maxRent = 10000;

  double? _currentMinTG;
  double? _currentMaxTG;
  double? _currentMinRent;
  double? _currentMaxRent;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialFilter.selectedLocation;
    _selectedCity = widget.initialFilter.selectedCity;
    _selectedState = widget.initialFilter.selectedState;
    _selectedApartmentGroup = widget.initialFilter.selectedApartmentGroup;

    _minTG = (widget.data.priceRange?.minTG ?? 0).toDouble();
    _maxTG = (widget.data.priceRange?.maxTG ?? 1000).toDouble();
    _minRent = (widget.data.priceRange?.minRent ?? 0).toDouble();
    _maxRent = (widget.data.priceRange?.maxRent ?? 10000).toDouble();

    if (_maxTG <= _minTG) _maxTG = _minTG + 100;
    if (_maxRent <= _minRent) _maxRent = _minRent + 1000;

    _currentMinTG = widget.initialFilter.minTG ?? _minTG;
    _currentMaxTG = widget.initialFilter.maxTG ?? _maxTG;
    _currentMinRent = widget.initialFilter.minRent ?? _minRent;
    _currentMaxRent = widget.initialFilter.maxRent ?? _maxRent;

    _currentMinTG = _currentMinTG!.clamp(_minTG, _maxTG);
    _currentMaxTG = _currentMaxTG!.clamp(_minTG, _maxTG);
    _currentMinRent = _currentMinRent!.clamp(_minRent, _maxRent);
    _currentMaxRent = _currentMaxRent!.clamp(_minRent, _maxRent);
  }

  @override
  Widget build(BuildContext context) {
    final apartmentGroups = widget.data.apartmentGroupNameFilter
        .map((a) => a.toString())
        .where((g) => g.isNotEmpty)
        .toSet()
        .toList();

    final locations = widget.data.locationFilter
        .map((e) => e.toString())
        .where((e) => e.isNotEmpty)
        .toList();
    final cities = widget.data.cityFilter
        .map((e) => e.toString())
        .where((e) => e.isNotEmpty)
        .toList();
    final states = widget.data.stateFilter
        .map((e) => e.toString())
        .where((e) => e.isNotEmpty)
        .toList();

    print(_selectedApartmentGroup);
    print(apartmentGroups);
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        top: 8,
        left: 20,
        right: 20,
        bottom: 20 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filters',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedLocation = null;
                    _selectedCity = null;
                    _selectedState = null;
                    _selectedApartmentGroup = null;
                    _currentMinTG = _minTG;
                    _currentMaxTG = _maxTG;
                    _currentMinRent = _minRent;
                    _currentMaxRent = _maxRent;
                  });
                },
                child: Text(
                  'Clear All',
                  style: GoogleFonts.inter(
                    color: const Color(0xFFE5212A),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 12),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location Filter
                  if (locations.isNotEmpty) ...[
                    _buildSectionTitle('LOCATION'),
                    _buildDropdown(
                      value: _selectedLocation,
                      hint: 'Select Location',
                      items: locations,
                      onChanged: (val) =>
                          setState(() => _selectedLocation = val),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // City Filter
                  if (cities.isNotEmpty) ...[
                    _buildSectionTitle('CITY'),
                    _buildDropdown(
                      value: _selectedCity,
                      hint: 'Select City',
                      items: cities,
                      onChanged: (val) => setState(() => _selectedCity = val),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // State Filter
                  if (states.isNotEmpty) ...[
                    _buildSectionTitle('STATE'),
                    _buildDropdown(
                      value: _selectedState,
                      hint: 'Select State',
                      items: states,
                      onChanged: (val) => setState(() => _selectedState = val),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Apartment Group Filter
                  if (apartmentGroups.isNotEmpty) ...[
                    _buildSectionTitle('APARTMENT GROUP'),
                    _buildDropdown(
                      value: _selectedApartmentGroup,
                      hint: 'Select Group',
                      items: apartmentGroups,
                      onChanged: (val) =>
                          setState(() => _selectedApartmentGroup = val),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // TG Range Filter
                  if (!(_minTG == 0 && _maxTG == 0)) ...[
                    _buildSectionTitle('TG RANGE'),

                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          formatCompact(_currentMinTG!),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          formatCompact(_currentMaxTG!),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    RangeSlider(
                      values: RangeValues(_currentMinTG!, _currentMaxTG!),
                      min: _minTG,
                      max: _maxTG,
                      divisions: getSliderDivisions(_minTG, _maxTG),
                      labels: RangeLabels(
                        formatCompact(_currentMinTG!),
                        formatCompact(_currentMaxTG!),
                      ),
                      activeColor: const Color(0xFFE5212A),
                      inactiveColor: Colors.grey[200],
                      onChanged: (values) {
                        setState(() {
                          _currentMinTG = values.start;
                          _currentMaxTG = values.end;
                        });
                      },
                    ),

                    const SizedBox(height: 16),
                  ],

                  // Rent Range Filter
                  if (!(_minRent == 0 && _maxRent == 0)) ...[
                    _buildSectionTitle('RENT RANGE'),

                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '₹${formatCompact(_currentMinRent!)}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '₹${formatCompact(_currentMaxRent!)}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    RangeSlider(
                      values: RangeValues(_currentMinRent!, _currentMaxRent!),
                      min: _minRent,
                      max: _maxRent,
                      divisions: getSliderDivisions(_minRent, _maxRent),
                      labels: RangeLabels(
                        formatCompact(_currentMinRent!),
                        formatCompact(_currentMaxRent!),
                      ),
                      activeColor: const Color(0xFFE5212A),
                      inactiveColor: Colors.grey[200],
                      onChanged: (values) {
                        setState(() {
                          _currentMinRent = values.start;
                          _currentMaxRent = values.end;
                        });
                      },
                    ),

                    const SizedBox(height: 16),
                  ],
                ],
              ),
            ),
          ),

          const Divider(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: Colors.grey[300]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onApply(
                      SpacesFilterState(
                        searchQuery: widget.initialFilter.searchQuery,
                        selectedLocation: _selectedLocation,
                        selectedCity: _selectedCity,
                        selectedState: _selectedState,
                        selectedApartmentGroup: _selectedApartmentGroup,
                        minTG: _currentMinTG == _minTG ? null : _currentMinTG,
                        maxTG: _currentMaxTG == _maxTG ? null : _currentMaxTG,
                        minRent: _currentMinRent == _minRent
                            ? null
                            : _currentMinRent,
                        maxRent: _currentMaxRent == _maxRent
                            ? null
                            : _currentMaxRent,
                      ),
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Apply',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
      child: Text(
        title,
        style: GoogleFonts.inter(
          color: Colors.grey[600],
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(
            hint,
            style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 14),
          ),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          onChanged: onChanged,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: GoogleFonts.inter(color: Colors.black, fontSize: 14),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  int getSliderDivisions(double min, double max) {
    final range = max - min;

    double step;

    if (max < 100) {
      step = 10;
    } else if (max < 1000) {
      step = 100;
    } else {
      step = 1000;
    }

    return (range / step).round().clamp(1, 10000);
  }
}
