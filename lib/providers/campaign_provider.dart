import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class CampaignState {
  // Community Details Space Selection (Before builder)
  final String? initialSelectedSpace;

  // Step 1: Space & Schedule
  final String? builderSelectedSpace;
  final DateTime? startDate;
  final DateTime? endDate;

  // Step 2: Basic Setup
  final String? campaignObjective;
  final String brandBriefName;
  final String brandBriefType;

  // Step 3: Branding & Setup
  final Map<String, int> brandingCounts;

  // Step 4: Stage & Audio
  final bool stageSetup;
  final String? stageFootprint;
  final Map<String, int> audioCounts; // per hour total

  // Step 5: Promoters
  final bool needPromoters;
  final String? promoterRole;
  final int promoterCount;

  // Step 6: Gifts & Experiences
  final Map<String, int> giftCounts; // per unit
  final Map<String, int> experienceCounts;
  final String notes;
  final bool isDraft;
  final int draftStep;

  const CampaignState({
    this.initialSelectedSpace,
    this.builderSelectedSpace,
    this.startDate,
    this.endDate,
    this.campaignObjective,
    this.brandBriefName = '',
    this.brandBriefType = '',
    this.brandingCounts = const {},
    this.stageSetup = false,
    this.stageFootprint,
    this.audioCounts = const {},
    this.needPromoters = false,
    this.promoterRole,
    this.promoterCount = 0,
    this.giftCounts = const {},
    this.experienceCounts = const {},
    this.notes = '',
    this.isDraft = false,
    this.draftStep = 0,
  });

  CampaignState copyWith({
    String? initialSelectedSpace,
    String? builderSelectedSpace,
    DateTime? startDate,
    DateTime? endDate,
    String? campaignObjective,
    String? brandBriefName,
    String? brandBriefType,
    Map<String, int>? brandingCounts,
    bool? stageSetup,
    String? stageFootprint,
    Map<String, int>? audioCounts,
    bool? needPromoters,
    String? promoterRole,
    int? promoterCount,
    Map<String, int>? giftCounts,
    Map<String, int>? experienceCounts,
    String? notes,
    bool? isDraft,
    int? draftStep,
  }) {
    return CampaignState(
      initialSelectedSpace: initialSelectedSpace ?? this.initialSelectedSpace,
      builderSelectedSpace: builderSelectedSpace ?? this.builderSelectedSpace,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      campaignObjective: campaignObjective ?? this.campaignObjective,
      brandBriefName: brandBriefName ?? this.brandBriefName,
      brandBriefType: brandBriefType ?? this.brandBriefType,
      brandingCounts: brandingCounts ?? this.brandingCounts,
      stageSetup: stageSetup ?? this.stageSetup,
      stageFootprint: stageFootprint ?? this.stageFootprint,
      audioCounts: audioCounts ?? this.audioCounts,
      needPromoters: needPromoters ?? this.needPromoters,
      promoterRole: promoterRole ?? this.promoterRole,
      promoterCount: promoterCount ?? this.promoterCount,
      giftCounts: giftCounts ?? this.giftCounts,
      experienceCounts: experienceCounts ?? this.experienceCounts,
      notes: notes ?? this.notes,
      isDraft: isDraft ?? this.isDraft,
      draftStep: draftStep ?? this.draftStep,
    );
  }

  int get days {
    if (startDate == null || endDate == null) return 0;
    // Inclusive days e.g., 14th to 15th is 2 days.
    return endDate!.difference(startDate!).inDays + 1;
  }

  String get dateRangeText {
    if (startDate == null || endDate == null) return '';
    final df = DateFormat('E, d MMM yyyy');
    return '${df.format(startDate!)} — ${df.format(endDate!)}'.toUpperCase();
  }
}

class CampaignViewModel extends Notifier<CampaignState> {
  // Prices mappings
  final Map<String, int> spacePrices = {
    '10 × 10 ft': 3150,
    '10 × 20 ft': 5500,
    '10 × 30 ft': 8000,
  };

  final Map<String, int> objectivePrices = {
    'Promotion Only': 2000,
    'Promotion + Lead Generation': 4000,
    'Sales Only': 3000,
  };

  final Map<String, int> brandingPrices = {
    'Canopy': 800,
    'Arabian Tent': 1200,
    'Table': 250,
    'Chair': 75,
    'Product Display Counter': 700,
    'Backdrop 6 × 4 ft': 2000,
    'Backdrop 8 × 6 ft': 3500,
    'Standee': 1200,
    'Flex / Banner': 1500,
  };

  final List<String> perPieceItems = [
    'Backdrop 6 × 4 ft',
    'Backdrop 8 × 6 ft',
    'Standee',
    'Flex / Banner',
  ];

  final Map<String, int> stagePrices = {
    'Small': 11000,
    'Medium': 15000,
  };

  final Map<String, int> audioPrices = {
    'MIC Host': 500,
    'Sound System': 1500,
    'DJ Setup': 2000,
    'LED Screen': 3000,
  };

  final Map<String, int> giftPrices = {
    'Cap': 100,
    'Key Chain': 50,
    'Water Can': 30,
  };

  final Map<String, int> experiencePrices = {
    'Nail Artist': 4000,
    'Tattoo Activity': 3500,
  };

  @override
  CampaignState build() {
    return const CampaignState();
  }

  void saveDraft(int step) {
    state = state.copyWith(isDraft: true, draftStep: step);
  }

  void clearCampaign() {
    state = const CampaignState();
  }

  void finishCampaign() {
    state = state.copyWith(isDraft: false);
  }

  void setInitialSpace(String space) {
    state = state.copyWith(initialSelectedSpace: space);
  }

  void initializeBuilder() {
    state = state.copyWith(builderSelectedSpace: state.initialSelectedSpace);
  }

  void setBuilderSpace(String space) {
    state = state.copyWith(builderSelectedSpace: space);
  }

  void setDates(DateTime start, DateTime end) {
    state = state.copyWith(startDate: start, endDate: end);
  }

  void setObjective(String objective) {
    state = state.copyWith(campaignObjective: objective);
  }

  void updateBrandingCount(String item, int delta) {
    final currentCounts = Map<String, int>.from(state.brandingCounts);
    final current = currentCounts[item] ?? 0;
    final newValue = current + delta;
    if (newValue >= 0) {
      currentCounts[item] = newValue;
      state = state.copyWith(brandingCounts: currentCounts);
    }
  }

  void toggleStageSetup(bool value) {
    state = state.copyWith(stageSetup: value);
  }

  void setStageFootprint(String footprint) {
    state = state.copyWith(stageFootprint: footprint);
  }

  void updateAudioCount(String item, int delta) {
    final currentCounts = Map<String, int>.from(state.audioCounts);
    final current = currentCounts[item] ?? 0;
    final newValue = current + delta;
    if (newValue >= 0) {
      currentCounts[item] = newValue;
      state = state.copyWith(audioCounts: currentCounts);
    }
  }

  void togglePromoters(bool value) {
    state = state.copyWith(needPromoters: value);
  }

  void setPromoterRole(String role) {
    state = state.copyWith(promoterRole: role);
  }

  void updatePromoterCount(int delta) {
    final newValue = state.promoterCount + delta;
    if (newValue >= 0) {
      state = state.copyWith(promoterCount: newValue);
    }
  }

  void updateGiftCount(String item, int delta) {
    final currentCounts = Map<String, int>.from(state.giftCounts);
    final current = currentCounts[item] ?? 0;
    final newValue = current + delta;
    if (newValue >= 0) {
      currentCounts[item] = newValue;
      state = state.copyWith(giftCounts: currentCounts);
    }
  }

  void updateExperienceCount(String item, int delta) {
    final currentCounts = Map<String, int>.from(state.experienceCounts);
    final current = currentCounts[item] ?? 0;
    final newValue = current + delta;
    if (newValue >= 0) {
      currentCounts[item] = newValue;
      state = state.copyWith(experienceCounts: currentCounts);
    }
  }

  void updateNotes(String text) {
    state = state.copyWith(notes: text);
  }

  int get spaceTotal {
    int total = 0;
    int numDays = state.days > 0 ? state.days : 1;
    if (state.builderSelectedSpace != null && spacePrices.containsKey(state.builderSelectedSpace)) {
      total += spacePrices[state.builderSelectedSpace!]! * numDays;
    }
    return total;
  }

  int get objectiveTotal {
    int total = 0;
    int numDays = state.days > 0 ? state.days : 1;
    if (state.campaignObjective != null && objectivePrices.containsKey(state.campaignObjective)) {
      total += objectivePrices[state.campaignObjective!]! * numDays;
    }
    return total;
  }

  int get brandingTotal {
    int total = 0;
    int numDays = state.days > 0 ? state.days : 1;
    state.brandingCounts.forEach((item, count) {
      if (count > 0 && brandingPrices.containsKey(item)) {
        if (perPieceItems.contains(item)) {
           total += brandingPrices[item]! * count;
        } else {
           total += brandingPrices[item]! * count * numDays;
        }
      }
    });
    return total;
  }

  int get setupTotal {
    int total = 0;
    int numDays = state.days > 0 ? state.days : 1;
    
    // Stage
    if (state.stageSetup && state.stageFootprint != null && stagePrices.containsKey(state.stageFootprint)) {
      total += stagePrices[state.stageFootprint!]! * numDays;
    }
    
    // Audio
    state.audioCounts.forEach((item, count) {
      if (count > 0 && audioPrices.containsKey(item)) {
        total += audioPrices[item]! * count;
      }
    });
    return total;
  }

  int get promotersTotal {
    int total = 0;
    int numDays = state.days > 0 ? state.days : 1;
    if (state.needPromoters && state.promoterCount > 0) {
      total += 1500 * state.promoterCount * numDays;
    }
    return total;
  }

  int get giftsExperiencesTotal {
    int total = 0;
    int numDays = state.days > 0 ? state.days : 1;
    state.giftCounts.forEach((item, count) {
      if (count > 0 && giftPrices.containsKey(item)) {
        total += giftPrices[item]! * count;
      }
    });
    state.experienceCounts.forEach((item, count) {
      if (count > 0 && experiencePrices.containsKey(item)) {
        total += experiencePrices[item]! * count * numDays;
      }
    });
    return total;
  }

  int get estimatedTotal {
    return spaceTotal + objectiveTotal + brandingTotal + setupTotal + promotersTotal + giftsExperiencesTotal;
  }
}

final campaignProvider = NotifierProvider<CampaignViewModel, CampaignState>(
  CampaignViewModel.new,
);
