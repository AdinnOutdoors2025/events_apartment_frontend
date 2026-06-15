import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/apartment_field_list.dart';
import '../models/apartment_lists.dart';
import '../utils/api_service.dart';

class SpacesFilterState {
  static const _unset = Object();

  final String searchQuery;
  final String? selectedLocation;
  final String? selectedCity;
  final String? selectedState;
  final String? selectedApartmentGroup;
  final double? minTG;
  final double? maxTG;
  final double? minRent;
  final double? maxRent;

  const SpacesFilterState({
    this.searchQuery = '',
    this.selectedLocation,
    this.selectedCity,
    this.selectedState,
    this.selectedApartmentGroup,
    this.minTG,
    this.maxTG,
    this.minRent,
    this.maxRent,
  });

  SpacesFilterState copyWith({
    String? searchQuery,
    String? selectedLocation,
    String? selectedCity,
    String? selectedState,
    String? selectedApartmentGroup,
    Object? minTG = _unset,
    Object? maxTG = _unset,
    Object? minRent = _unset,
    Object? maxRent = _unset,
  }) {
    return SpacesFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedLocation: selectedLocation == ''
          ? null
          : (selectedLocation ?? this.selectedLocation),
      selectedCity: selectedCity == ''
          ? null
          : (selectedCity ?? this.selectedCity),
      selectedState: selectedState == ''
          ? null
          : (selectedState ?? this.selectedState),
      selectedApartmentGroup: selectedApartmentGroup == ''
          ? null
          : (selectedApartmentGroup ?? this.selectedApartmentGroup),
      minTG: minTG == _unset ? this.minTG : minTG as double?,
      maxTG: maxTG == _unset ? this.maxTG : maxTG as double?,
      minRent: minRent == _unset ? this.minRent : minRent as double?,
      maxRent: maxRent == _unset ? this.maxRent : maxRent as double?,
    );
  }

  SpacesFilterState clear() {
    return const SpacesFilterState();
  }
}

class SpacesFilterNotifier extends StateNotifier<SpacesFilterState> {
  SpacesFilterNotifier() : super(const SpacesFilterState());

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setLocation(String? location) {
    state = state.copyWith(selectedLocation: location ?? '');
  }

  void setCity(String? city) {
    state = state.copyWith(selectedCity: city ?? '');
  }

  void setState(String? stateName) {
    state = state.copyWith(selectedState: stateName ?? '');
  }

  void setApartmentGroup(String? groupName) {
    state = state.copyWith(selectedApartmentGroup: groupName ?? '');
  }

  void setTGRange(double min, double max) {
    state = state.copyWith(minTG: min, maxTG: max);
  }

  void setRentRange(double min, double max) {
    state = state.copyWith(minRent: min, maxRent: max);
  }

  void resetFilters() {
    state = const SpacesFilterState();
  }

  void setFilters(SpacesFilterState filters) {
    state = filters;
  }

  void clearLocation() {
    state = state.copyWith(selectedLocation: '');
  }

  void clearCity() {
    state = state.copyWith(selectedCity: '');
  }

  void clearStateFilter() {
    state = state.copyWith(selectedState: '');
  }

  void clearApartmentGroup() {
    state = state.copyWith(selectedApartmentGroup: '');
  }

  void clearTGRange() {
    state = state.copyWith(minTG: null, maxTG: null);
  }

  void clearRentRange() {
    state = state.copyWith(minRent: null, maxRent: null);
  }
}

final spacesFilterProvider =
    StateNotifierProvider<SpacesFilterNotifier, SpacesFilterState>((ref) {
      return SpacesFilterNotifier();
    });

class SpacesState {
  final List<Apartment> apartments;
  final int pageNumber;
  final int count;
  final int totalCount;
  final int totalPages;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final List<dynamic> locationFilter;
  final List<dynamic> cityFilter;
  final List<dynamic> stateFilter;
  final List<dynamic> apartmentGroupNameFilter;
  final PriceRange? priceRange;

  const SpacesState({
    this.apartments = const [],
    this.pageNumber = 1,
    this.count = 10,
    this.totalCount = 0,
    this.totalPages = 0,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.locationFilter = const [],
    this.cityFilter = const [],
    this.stateFilter = const [],
    this.apartmentGroupNameFilter = const [],
    this.priceRange,
  });

  SpacesState copyWith({
    List<Apartment>? apartments,
    int? pageNumber,
    int? count,
    int? totalCount,
    int? totalPages,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    List<dynamic>? locationFilter,
    List<dynamic>? cityFilter,
    List<dynamic>? stateFilter,
    List<dynamic>? apartmentGroupNameFilter,
    PriceRange? priceRange,
  }) {
    return SpacesState(
      apartments: apartments ?? this.apartments,
      pageNumber: pageNumber ?? this.pageNumber,
      count: count ?? this.count,
      totalCount: totalCount ?? this.totalCount,
      totalPages: totalPages ?? this.totalPages,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      locationFilter: locationFilter ?? this.locationFilter,
      cityFilter: cityFilter ?? this.cityFilter,
      stateFilter: stateFilter ?? this.stateFilter,
      apartmentGroupNameFilter:
          apartmentGroupNameFilter ?? this.apartmentGroupNameFilter,
      priceRange: priceRange ?? this.priceRange,
    );
  }
}

class SpacesListNotifier extends StateNotifier<SpacesState> {
  final Ref _ref;

  List<Apartment> _unfilteredApartments = [];
  int _unfilteredPageNumber = 1;
  int _unfilteredCount = 10;
  int _unfilteredTotalCount = 0;
  int _unfilteredTotalPages = 0;

  SpacesListNotifier(this._ref) : super(const SpacesState()) {
    fetchPage(page: 1);
  }

  Future<void> fetchPage({required int page, String? overrideSearch}) async {
    final filter = _ref.read(spacesFilterProvider);
    final searchVal = overrideSearch ?? filter.searchQuery;

    print('====================');
    print('FETCH PAGE');
    print('Page: $page');
    print('Search: "$searchVal"');
    print('Location: ${filter.selectedLocation}');
    print('City: ${filter.selectedCity}');
    print('State: ${filter.selectedState}');
    print('Apartment Group: ${filter.selectedApartmentGroup}');
    print('Min TG: ${filter.minTG}');
    print('Max TG: ${filter.maxTG}');
    print('Min Rent: ${filter.minRent}');
    print('Max Rent: ${filter.maxRent}');
    print('====================');

    if (page == 1) {
      state = state.copyWith(isLoading: true, apartments: [], error: null);
    } else {
      state = state.copyWith(isLoadingMore: true, error: null);
    }

    try {
      final response = await ApiService().apartmentList(
        pageNumber: page,
        count: 10,
        search: searchVal,
        location: filter.selectedLocation,
        city: filter.selectedCity,
        state: filter.selectedState,
        apartmentGroupName: filter.selectedApartmentGroup,
        minTG: filter.minTG,
        maxTG: filter.maxTG,
        minRent: filter.minRent,
        maxRent: filter.maxRent,
      );

      if (response.success == true && response.data != null) {
        final data = response.data!;

        print('====================');
        print('FETCH SUCCESS');
        print('Search: "$searchVal"');
        print('Received: ${data.apartments.length} apartments');
        print('Total Count: ${data.totalCount}');
        print('Current Page: ${data.pageNumber}');
        print('Total Pages: ${data.totalPages}');
        print('====================');

        final newApartments = page == 1
            ? data.apartments
            : [...state.apartments, ...data.apartments];

        state = state.copyWith(
          isLoading: false,
          isLoadingMore: false,
          pageNumber: data.pageNumber,
          count: data.count,
          totalPages: data.totalPages,
          totalCount: data.totalCount,
          locationFilter: data.locationFilter,
          cityFilter: data.cityFilter,
          stateFilter: data.stateFilter,
          apartmentGroupNameFilter: data.apartmentGroupNameFilter,
          priceRange: data.priceRange,
          apartments: newApartments,
        );

        if (searchVal.isEmpty) {
          _unfilteredApartments = newApartments;
          _unfilteredPageNumber = data.pageNumber;
          _unfilteredCount = data.count;
          _unfilteredTotalCount = data.totalCount;
          _unfilteredTotalPages = data.totalPages;
        }
      } else {
        state = state.copyWith(
          isLoading: false,
          isLoadingMore: false,
          error: response.message.isNotEmpty
              ? response.message
              : 'Failed to fetch apartments',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        error: e.toString(),
      );
    }
  }

  void onFilterChanged(SpacesFilterState? previous, SpacesFilterState next) {
    final searchChanged = (previous?.searchQuery != next.searchQuery);
    final filtersChanged =
        (previous?.selectedLocation != next.selectedLocation) ||
        (previous?.selectedCity != next.selectedCity) ||
        (previous?.selectedState != next.selectedState) ||
        (previous?.selectedApartmentGroup != next.selectedApartmentGroup) ||
        (previous?.minTG != next.minTG) ||
        (previous?.maxTG != next.maxTG) ||
        (previous?.minRent != next.minRent) ||
        (previous?.maxRent != next.maxRent);

    if (filtersChanged) {
      _unfilteredApartments = [];
      _unfilteredPageNumber = 1;
      _unfilteredTotalPages = 0;
      _unfilteredTotalCount = 0;
      fetchPage(page: 1);
      return;
    }

    if (searchChanged) {
      final query = next.searchQuery.trim();
      if (query.isEmpty) {
        state = state.copyWith(
          apartments: _unfilteredApartments,
          pageNumber: _unfilteredPageNumber,
          count: _unfilteredCount,
          totalCount: _unfilteredTotalCount,
          totalPages: _unfilteredTotalPages,
          error: null,
        );
      } else {
        final localMatches = _unfilteredApartments
            .where(
              (a) =>
                  a.apartmentName.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();

        if (localMatches.isNotEmpty) {
          state = state.copyWith(
            apartments: localMatches,
            pageNumber: 1,
            totalPages: 1,
            totalCount: localMatches.length,
            error: null,
          );
        } else {
          fetchPage(page: 1, overrideSearch: query);
        }
      }
    }
  }

  Future<void> loadMore() async {
    final filter = _ref.read(spacesFilterProvider);
    if (filter.searchQuery.isNotEmpty) {
      return;
    }
    if (state.isLoading ||
        state.isLoadingMore ||
        state.pageNumber >= state.totalPages) {
      return;
    }
    await fetchPage(page: state.pageNumber + 1);
  }
}

final spacesListProvider =
    StateNotifierProvider<SpacesListNotifier, SpacesState>((ref) {
      final notifier = SpacesListNotifier(ref);
      ref.listen<SpacesFilterState>(spacesFilterProvider, (previous, next) {
        notifier.onFilterChanged(previous, next);
      });
      return notifier;
    });
