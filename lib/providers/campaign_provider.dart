import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/apartment_field_list.dart';
import '../utils/api_service.dart';

class PromoterRequirement {
  final String id;
  final int maleCount;
  final int femaleCount;
  final List<String> languages; // 'Tamil', 'English', 'Hindi'
  final List<String> appearances; // 'Traditional', 'Professional'
  final List<DateTime> selectedDates;
  final String? notes;

  const PromoterRequirement({
    required this.id,
    this.maleCount = 0,
    this.femaleCount = 0,
    this.languages = const [],
    this.appearances = const [],
    this.selectedDates = const [],
    this.notes,
  });

  PromoterRequirement copyWith({
    String? id,
    int? maleCount,
    int? femaleCount,
    List<String>? languages,
    List<String>? appearances,
    List<DateTime>? selectedDates,
    String? notes,
  }) {
    return PromoterRequirement(
      id: id ?? this.id,
      maleCount: maleCount ?? this.maleCount,
      femaleCount: femaleCount ?? this.femaleCount,
      languages: languages ?? this.languages,
      appearances: appearances ?? this.appearances,
      selectedDates: selectedDates ?? this.selectedDates,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'maleCount': maleCount,
      'femaleCount': femaleCount,
      'languages': languages,
      'appearances': appearances,
      'selectedDates': selectedDates.map((d) => d.toIso8601String()).toList(),
      'notes': notes,
    };
  }

  factory PromoterRequirement.fromJson(Map<String, dynamic> json) {
    return PromoterRequirement(
      id: json['id'] as String? ?? '',
      maleCount: json['maleCount'] as int? ?? 0,
      femaleCount: json['femaleCount'] as int? ?? 0,
      languages: List<String>.from(json['languages'] ?? []),
      appearances: List<String>.from(json['appearances'] ?? []),
      selectedDates: (json['selectedDates'] as List? ?? [])
          .map((d) => DateTime.parse(d as String))
          .toList(),
      notes: json['notes'] as String?,
    );
  }
}

class CampaignScheduleRange {
  DateTime startDate;
  DateTime endDate;

  String fromTime;
  String toTime;

  CampaignScheduleRange({
    required this.startDate,
    required this.endDate,
    required this.fromTime,
    required this.toTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'fromTime': fromTime,
      'toTime': toTime,
    };
  }

  factory CampaignScheduleRange.fromJson(Map<String, dynamic> json) {
    return CampaignScheduleRange(
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      fromTime: json['fromTime'],
      toTime: json['toTime'],
    );
  }
}

class CampaignState {
  final String? apartmentId;

  // Community Details Space Selection (Before builder)
  final String? initialSelectedSpace;

  // Step 1: Space & Schedule
  final String? builderSelectedSpace;

  final DateTime? selectedStart;
  final DateTime? selectedEnd;

  final TimeOfDay? selectedStartTime;
  final TimeOfDay? selectedEndTime;

  //final Map<String, String> selectedTimes;
  final List<CampaignScheduleRange> schedules;

  // Step 2: Basic Setup
  final String? campaignObjective;
  final String brandBriefName;
  final String brandBriefType;

  // Step 3: Branding & Setup
  final Map<String, int> categoryBrandingCounts;
  final Map<String, int> unCategoryBrandingCounts;

  // Step 4: Stage & Audio
  final bool stageSetup;
  final String? stageFootprint;
  final Map<String, int> audioCounts;
  final Map<String, int> stageCounts;

  // Step 5: Promoters
  final bool needPromoters;
  final String? promoterRole;
  final int promoterCount;
  final List<PromoterRequirement> promoterRequirements;

  // Step 6: Gifts & Experiences
  final Map<String, int> giftCounts;
  final Map<String, int> experienceCounts;

  final String notes;

  /// 🔥 FIXED: MUST be nullable (NO EMPTY STRING DEFAULT)
  final String? voiceNotePath;
  final int? voiceNoteDuration; // seconds

  final bool isDraft;
  final int draftStep;

  // Dynamic Prices (API)
  final Map<String, int> dynamicPrices; // Customer Details
  final String? customerBrandName;
  final String? customerContactName;
  final String? customerPhone;
  final String? customerEmail;
  final String? customerGst;
  final String? customerDesignation;
  final String? customerType;
  final String? customerNotes;
  final int? discountType;
  final double discountPercentage;
  final int? apartmentPerDayRent;

  const CampaignState({
    this.apartmentId,
    this.initialSelectedSpace,
    this.builderSelectedSpace,
    this.selectedStart,
    this.selectedEnd,
    this.selectedStartTime,
    this.selectedEndTime,
    this.campaignObjective,
    this.brandBriefName = '',
    this.brandBriefType = '',
    this.categoryBrandingCounts = const {},
    this.stageSetup = false,
    this.stageFootprint,
    this.audioCounts = const {},
    this.needPromoters = false,
    this.promoterRole,
    this.promoterCount = 0,
    this.promoterRequirements = const [],
    this.giftCounts = const {},
    this.experienceCounts = const {},
    this.notes = '',
    this.voiceNotePath,
    this.voiceNoteDuration,
    this.isDraft = false,
    this.draftStep = 0,
    this.unCategoryBrandingCounts = const {},
    this.dynamicPrices = const {},
    this.stageCounts = const {},
    this.customerBrandName,
    this.customerContactName,
    this.customerPhone,
    this.customerEmail,
    this.customerGst,
    this.customerDesignation,
    this.customerType,
    this.customerNotes,
    this.discountType,
    this.discountPercentage = 0,
    this.apartmentPerDayRent,
    this.schedules = const [],
  });

  CampaignState copyWith({
    String? apartmentId,
    String? initialSelectedSpace,
    String? builderSelectedSpace,
    DateTime? selectedStart,
    DateTime? selectedEnd,
    TimeOfDay? selectedStartTime,
    TimeOfDay? selectedEndTime,
    String? campaignObjective,
    String? brandBriefName,
    String? brandBriefType,
    Map<String, int>? brandingCounts,
    Map<String, int>? unCategoryBrandingCount,
    bool? stageSetup,
    String? stageFootprint,
    Map<String, int>? audioCounts,
    List<CampaignScheduleRange>? schedules,
    bool? needPromoters,
    String? promoterRole,
    int? promoterCount,
    List<PromoterRequirement>? promoterRequirements,
    Map<String, int>? giftCounts,
    Map<String, int>? experienceCounts,
    String? notes,
    String? voiceNotePath,
    bool clearVoiceNotePath = false,
    int? voiceNoteDuration,
    bool clearVoiceNoteDuration = false,
    bool clearDates = false,
    bool? isDraft,
    int? draftStep,
    Map<String, int>? dynamicPrices,
    Map<String, int>? stageCounts,
    String? customerBrandName,
    String? customerContactName,
    String? customerPhone,
    String? customerEmail,
    String? customerGst,
    String? customerDesignation,
    String? customerType,
    String? customerNotes,
    int? discountType,
    double? discountPercentage,
    int? apartmentPerDayRent,
  }) {
    return CampaignState(
      apartmentId: apartmentId ?? this.apartmentId,
      initialSelectedSpace: initialSelectedSpace ?? this.initialSelectedSpace,
      builderSelectedSpace: builderSelectedSpace ?? this.builderSelectedSpace,
      selectedStart: clearDates ? null : (selectedStart ?? this.selectedStart),
      selectedEnd: clearDates ? null : (selectedEnd ?? this.selectedEnd),
      selectedStartTime: selectedStartTime ?? this.selectedStartTime,
      selectedEndTime: selectedEndTime ?? this.selectedEndTime,
      campaignObjective: campaignObjective ?? this.campaignObjective,
      brandBriefName: brandBriefName ?? this.brandBriefName,
      brandBriefType: brandBriefType ?? this.brandBriefType,
      categoryBrandingCounts: brandingCounts ?? categoryBrandingCounts,
      schedules: schedules ?? this.schedules,
      unCategoryBrandingCounts:
          unCategoryBrandingCount ?? unCategoryBrandingCounts,
      stageSetup: stageSetup ?? this.stageSetup,
      stageFootprint: stageFootprint ?? this.stageFootprint,
      audioCounts: audioCounts ?? this.audioCounts,
      needPromoters: needPromoters ?? this.needPromoters,
      promoterRole: promoterRole ?? this.promoterRole,
      promoterCount: promoterCount ?? this.promoterCount,
      promoterRequirements: promoterRequirements ?? this.promoterRequirements,
      giftCounts: giftCounts ?? this.giftCounts,
      experienceCounts: experienceCounts ?? this.experienceCounts,
      notes: notes ?? this.notes,
      voiceNotePath: clearVoiceNotePath
          ? null
          : (voiceNotePath ?? this.voiceNotePath),
      voiceNoteDuration: clearVoiceNoteDuration
          ? null
          : (voiceNoteDuration ?? this.voiceNoteDuration),
      isDraft: isDraft ?? this.isDraft,
      draftStep: draftStep ?? this.draftStep,
      dynamicPrices: dynamicPrices ?? this.dynamicPrices,
      stageCounts: stageCounts ?? this.stageCounts,
      customerBrandName: customerBrandName ?? this.customerBrandName,
      customerContactName: customerContactName ?? this.customerContactName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerEmail: customerEmail ?? this.customerEmail,
      customerGst: customerGst ?? this.customerGst,
      customerDesignation: customerDesignation ?? this.customerDesignation,
      customerType: customerType ?? this.customerType,
      customerNotes: customerNotes ?? this.customerNotes,
      discountType: discountType ?? this.discountType,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      apartmentPerDayRent: apartmentPerDayRent ?? this.apartmentPerDayRent,
    );
  }

  /// Computed total promoter count from all requirements
  int get totalPromoterCount {
    if (!needPromoters) return 0;
    int total = 0;
    for (final req in promoterRequirements) {
      total += req.maleCount + req.femaleCount;
    }
    return total;
  }

  Map<String, dynamic> toJson() {
    return {
      'apartmentId': apartmentId,
      'initialSelectedSpace': initialSelectedSpace,
      'builderSelectedSpace': builderSelectedSpace,
      'startDate': selectedStart?.toIso8601String(),
      'endDate': selectedEnd?.toIso8601String(),
      'campaignObjective': campaignObjective,
      'selectedTimes': schedules.map((e) => e.toJson()).toList(),
      'brandBriefName': brandBriefName,
      'brandBriefType': brandBriefType,
      'categoryBrandingCounts': categoryBrandingCounts,
      'unCategoryBrandingCounts': unCategoryBrandingCounts,
      'stageSetup': stageSetup,
      'stageFootprint': stageFootprint,
      'audioCounts': audioCounts,
      'needPromoters': needPromoters,
      'promoterRole': promoterRole,
      'promoterCount': promoterCount,
      'promoterRequirements': promoterRequirements
          .map((r) => r.toJson())
          .toList(),
      'giftCounts': giftCounts,
      'experienceCounts': experienceCounts,
      'notes': notes,
      'voiceNotePath': voiceNotePath,
      'voiceNoteDuration': voiceNoteDuration,
      'isDraft': isDraft,
      'draftStep': draftStep,
      'dynamicPrices': dynamicPrices,
      'stageCounts': stageCounts,
      'customerBrandName': customerBrandName,
      'customerContactName': customerContactName,
      'customerPhone': customerPhone,
      'customerEmail': customerEmail,
      'customerGst': customerGst,
      'customerDesignation': customerDesignation,
      'customerType': customerType,
      'customerNotes': customerNotes,
      'discountType': discountType,
      'discountPercentage': discountPercentage,
      'apartmentPerDayRent': apartmentPerDayRent,
    };
  }

  factory CampaignState.fromJson(Map<String, dynamic> json) {
    return CampaignState(
      apartmentId: json['apartmentId'],
      initialSelectedSpace: json['initialSelectedSpace'],
      builderSelectedSpace: json['builderSelectedSpace'],
      selectedStart: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : null,

      selectedEnd: json['endDate'] != null
          ? DateTime.parse(json['endDate'])
          : null,
      schedules: (json['selectedTimes'] as List? ?? [])
          .map((e) => CampaignScheduleRange.fromJson(e as Map<String, dynamic>))
          .toList(),
      campaignObjective: json['campaignObjective'],
      brandBriefName: json['brandBriefName'] ?? '',
      brandBriefType: json['brandBriefType'] ?? '',
      categoryBrandingCounts: Map<String, int>.from(
        json['categoryBrandingCounts'] ?? {},
      ),
      unCategoryBrandingCounts: Map<String, int>.from(
        json['unCategoryBrandingCounts'] ?? {},
      ),
      stageSetup: json['stageSetup'] ?? false,
      stageFootprint: json['stageFootprint'],
      audioCounts: Map<String, int>.from(json['audioCounts'] ?? {}),
      needPromoters: json['needPromoters'] ?? false,
      promoterRole: json['promoterRole'],
      promoterCount: json['promoterCount'] ?? 0,
      promoterRequirements: (json['promoterRequirements'] as List? ?? [])
          .map((r) => PromoterRequirement.fromJson(r as Map<String, dynamic>))
          .toList(),
      giftCounts: Map<String, int>.from(json['giftCounts'] ?? {}),
      experienceCounts: Map<String, int>.from(json['experienceCounts'] ?? {}),
      notes: json['notes'] ?? '',
      voiceNotePath: json['voiceNotePath'],
      voiceNoteDuration: json['voiceNoteDuration'],
      isDraft: json['isDraft'] ?? false,
      draftStep: json['draftStep'] ?? 0,
      dynamicPrices: Map<String, int>.from(json['dynamicPrices'] ?? {}),
      stageCounts: Map<String, int>.from(json['stageCounts'] ?? {}),
      customerBrandName: json['customerBrandName'],
      customerContactName: json['customerContactName'],
      customerPhone: json['customerPhone'],
      customerEmail: json['customerEmail'],
      customerGst: json['customerGst'],
      customerDesignation: json['customerDesignation'],
      customerType: json['customerType'],
      customerNotes: json['customerNotes'],
      discountType: json['discountType'] as int?,
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble() ?? 0,
      apartmentPerDayRent: json['apartmentPerDayRent'] as int?,
    );
  }

  int get days {
    if (selectedStart == null || selectedEnd == null) {
      return 0;
    }

    return selectedEnd!.difference(selectedStart!).inDays + 1;
  }

  String get dateRangeText {
    if (selectedStart == null || selectedEnd == null) {
      return '';
    }

    final df = DateFormat('E, d MMM yyyy');

    return '${df.format(selectedStart!)} — \n'
            '${df.format(selectedEnd!)}'
        .toUpperCase();
  }
}

class CampaignViewModel extends Notifier<CampaignState> {
  @override
  CampaignState build() {
    return const CampaignState();
  }

  Future<void> loadDraftForApartment(String aptId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString('campaign_draft_$aptId');
      if (jsonStr != null) {
        final Map<String, dynamic> data = jsonDecode(jsonStr);
        state = CampaignState.fromJson(data);
      } else {
        state = CampaignState(apartmentId: aptId);
      }
    } catch (e) {
      debugPrint('Error loading campaign draft for apartment $aptId: $e');
    }
  }

  Future<void> saveDraft(int step) async {
    final aptId = state.apartmentId;
    if (aptId == null) return;
    state = state.copyWith(isDraft: true, draftStep: step);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('campaign_draft_$aptId', jsonEncode(state.toJson()));
      
      final draftIds = prefs.getStringList('campaign_draft_ids') ?? [];
      if (!draftIds.contains(aptId)) {
        draftIds.add(aptId);
        await prefs.setStringList('campaign_draft_ids', draftIds);
      }
      ref.invalidate(allDraftsProvider);
    } catch (e) {
      debugPrint('Error saving campaign draft: $e');
    }
  }

  Future<void> clearCampaign() async {
    final aptId = state.apartmentId;
    state = const CampaignState();
    if (aptId == null) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('campaign_draft_$aptId');
      final draftIds = prefs.getStringList('campaign_draft_ids') ?? [];
      if (draftIds.contains(aptId)) {
        draftIds.remove(aptId);
        await prefs.setStringList('campaign_draft_ids', draftIds);
      }
      ref.invalidate(allDraftsProvider);
    } catch (e) {
      debugPrint('Error clearing campaign draft: $e');
    }
  }

  Future<void> clearDraftForApartment(String aptId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('campaign_draft_$aptId');
      final draftIds = prefs.getStringList('campaign_draft_ids') ?? [];
      if (draftIds.contains(aptId)) {
        draftIds.remove(aptId);
        await prefs.setStringList('campaign_draft_ids', draftIds);
      }
      ref.invalidate(allDraftsProvider);
    } catch (e) {
      debugPrint('Error clearing draft for apartment $aptId: $e');
    }
  }

  void finishCampaign() {
    clearCampaign();
  }

  void setInitialSpace(String space) {
    state = state.copyWith(initialSelectedSpace: space);
  }

  void initializeBuilder(String apartmentId, int perDayRent) {
    state = state.copyWith(
      builderSelectedSpace: state.builderSelectedSpace ?? state.initialSelectedSpace,
      apartmentId: apartmentId,
      apartmentPerDayRent: perDayRent,
    );
  }

  void setBuilderSpace(String space) {
    state = state.copyWith(builderSelectedSpace: space);
  }

  List<PromoterRequirement> _cleanPromoterRequirements(
    List<PromoterRequirement> requirements,
    DateTime? start,
    DateTime? end,
  ) {
    if (start == null || end == null) {
      return requirements.map((r) => r.copyWith(selectedDates: [])).toList();
    }
    final startDay = DateTime(start.year, start.month, start.day);
    final endDay = DateTime(end.year, end.month, end.day);

    return requirements.map((r) {
      final validDates = r.selectedDates.where((date) {
        final d = DateTime(date.year, date.month, date.day);
        return !d.isBefore(startDay) && !d.isAfter(endDay);
      }).toList();
      return r.copyWith(selectedDates: validDates);
    }).toList();
  }

  void addSchedule(CampaignScheduleRange schedule) {
    final updated = [...state.schedules, schedule];
    updated.sort((a, b) => a.startDate.compareTo(b.startDate));
    final minStart = updated.map((e) => e.startDate).reduce((a, b) => a.isBefore(b) ? a : b);
    final maxEnd = updated.map((e) => e.endDate).reduce((a, b) => a.isAfter(b) ? a : b);
    final cleanedPromoters = _cleanPromoterRequirements(
      state.promoterRequirements,
      minStart,
      maxEnd,
    );
    state = state.copyWith(
      schedules: updated,
      selectedStart: minStart,
      selectedEnd: maxEnd,
      promoterRequirements: cleanedPromoters,
    );
  }

  void updateSchedule(int index, CampaignScheduleRange schedule) {
    final updated = [...state.schedules];
    updated[index] = schedule;
    updated.sort((a, b) => a.startDate.compareTo(b.startDate));
    final minStart = updated.map((e) => e.startDate).reduce((a, b) => a.isBefore(b) ? a : b);
    final maxEnd = updated.map((e) => e.endDate).reduce((a, b) => a.isAfter(b) ? a : b);
    final cleanedPromoters = _cleanPromoterRequirements(
      state.promoterRequirements,
      minStart,
      maxEnd,
    );
    state = state.copyWith(
      schedules: updated,
      selectedStart: minStart,
      selectedEnd: maxEnd,
      promoterRequirements: cleanedPromoters,
    );
  }

  void deleteSchedule(int index) {
    final updated = [...state.schedules];
    updated.removeAt(index);
    if (updated.isEmpty) {
      final cleanedPromoters = _cleanPromoterRequirements(
        state.promoterRequirements,
        null,
        null,
      );
      state = state.copyWith(
        schedules: updated,
        clearDates: true,
        promoterRequirements: cleanedPromoters,
      );
    } else {
      final minStart = updated.map((e) => e.startDate).reduce((a, b) => a.isBefore(b) ? a : b);
      final maxEnd = updated.map((e) => e.endDate).reduce((a, b) => a.isAfter(b) ? a : b);
      final cleanedPromoters = _cleanPromoterRequirements(
        state.promoterRequirements,
        minStart,
        maxEnd,
      );
      state = state.copyWith(
        schedules: updated,
        selectedStart: minStart,
        selectedEnd: maxEnd,
        promoterRequirements: cleanedPromoters,
      );
    }
  }

  void clearBrandingItem(String itemName) {
    final currentCounts = Map<String, int>.from(state.categoryBrandingCounts);

    currentCounts.remove(itemName);

    state = state.copyWith(brandingCounts: currentCounts);
  }

  void setVoiceNote(String path, int duration) {
    state = state.copyWith(voiceNotePath: path, voiceNoteDuration: duration);
  }

  void deleteVoiceNote() {
    state = state.copyWith(
      clearVoiceNotePath: true,
      clearVoiceNoteDuration: true,
    );
  }

  void setObjective(String objective) {
    state = state.copyWith(campaignObjective: objective);
  }

  void setDynamicPrices(Map<String, int> prices) {
    final currentPrices = Map<String, int>.from(state.dynamicPrices);
    currentPrices.addAll(prices);
    state = state.copyWith(dynamicPrices: currentPrices);
  }

  void updateBrandingCount(String item, int delta) {
    final currentCounts = Map<String, int>.from(state.categoryBrandingCounts);
    final current = currentCounts[item] ?? 0;
    final newValue = current + delta;
    if (newValue >= 0) {
      currentCounts[item] = newValue;
      state = state.copyWith(brandingCounts: currentCounts);
    }
  }

  void clearBrandingSelection() {
    state = state.copyWith(brandingCounts: {});
  }

  void toggleStageSetup(bool value) {
    state = state.copyWith(stageSetup: value);
    if (!value) {
      state = state.copyWith(stageCounts: {});
    }
  }

  void updateStageCount(String item, int delta) {
    final currentCounts = Map<String, int>.from(state.stageCounts);
    final current = currentCounts[item] ?? 0;
    final newValue = current + delta;
    if (newValue >= 0) {
      currentCounts[item] = newValue;
      state = state.copyWith(stageCounts: currentCounts);
    }
  }

  void updateUnCategoryCount(String item, int delta) {
    final currentCounts = Map<String, int>.from(state.unCategoryBrandingCounts);
    final current = currentCounts[item] ?? 0;
    final newValue = current + delta;
    if (newValue >= 0) {
      currentCounts[item] = newValue;
      state = state.copyWith(unCategoryBrandingCount: currentCounts);
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

  void toggleNeedPromoters(bool value) {
    state = state.copyWith(needPromoters: value);
    if (!value) {
      state = state.copyWith(promoterRequirements: []);
    }
  }

  void addPromoterRequirement() {
    final newList = List<PromoterRequirement>.from(state.promoterRequirements);
    newList.add(
      PromoterRequirement(id: DateTime.now().millisecondsSinceEpoch.toString()),
    );
    state = state.copyWith(promoterRequirements: newList);
  }

  void removePromoterRequirement(String id) {
    final newList = List<PromoterRequirement>.from(state.promoterRequirements)
      ..removeWhere((r) => r.id == id);
    state = state.copyWith(promoterRequirements: newList);
  }

  void updatePromoterRequirement(PromoterRequirement updated) {
    final newList = state.promoterRequirements.map((r) {
      return r.id == updated.id ? updated : r;
    }).toList();
    state = state.copyWith(promoterRequirements: newList);
  }

  void setCustomerDetails({
    String? brandName,
    String? contactName,
    String? phone,
    String? email,
    String? gst,
    String? designation,
    String? type,
    String? notes,
  }) {
    state = state.copyWith(
      customerBrandName: brandName,
      customerContactName: contactName,
      customerPhone: phone,
      customerEmail: email,
      customerGst: gst,
      customerDesignation: designation,
      customerType: type,
      customerNotes: notes,
    );
  }

  void setDiscount(int? type, double percentage) {
    state = state.copyWith(discountType: type, discountPercentage: percentage);
  }

  int get spaceTotal {
    int total = 0;
    int numDays = state.days > 0 ? state.days : 1;
    if (state.builderSelectedSpace != null &&
        state.dynamicPrices.containsKey(state.builderSelectedSpace)) {
      total += state.dynamicPrices[state.builderSelectedSpace!]! * numDays;
    }
    return total;
  }

  int get objectiveTotal {
    int total = 0;
    int numDays = state.days > 0 ? state.days : 1;
    if (state.campaignObjective != null &&
        state.dynamicPrices.containsKey(state.campaignObjective)) {
      total += state.dynamicPrices[state.campaignObjective!]! * numDays;
    }
    return total;
  }

  int get categorizedBrandingTotal {
    int total = 0;
    int numDays = state.days > 0 ? state.days : 1;
    state.categoryBrandingCounts.forEach((item, count) {
      if (count > 0 && state.dynamicPrices.containsKey(item)) {
        if (item.contains('Backdrop') ||
            item.contains('Standee') ||
            item.contains('Flex') ||
            item.contains('Banner')) {
          total += state.dynamicPrices[item]! * count;
        } else {
          total += state.dynamicPrices[item]! * count * numDays;
        }
      }
    });
    return total;
  }

  int get uncategorizedBrandingTotal {
    int total = 0;
    int numDays = state.days > 0 ? state.days : 1;
    state.unCategoryBrandingCounts.forEach((item, count) {
      if (count > 0 && state.dynamicPrices.containsKey(item)) {
        if (item.contains('Backdrop') ||
            item.contains('Standee') ||
            item.contains('Flex') ||
            item.contains('Banner')) {
          total += state.dynamicPrices[item]! * count;
        } else {
          total += state.dynamicPrices[item]! * count * numDays;
        }
      }
    });
    return total;
  }

  int get brandingTotal {
    return categorizedBrandingTotal + uncategorizedBrandingTotal;
  }

  int get setupTotal {
    return 0; // Commented setup steps
  }

  int get promotersTotal {
    if (!state.needPromoters) return 0;
    int total = 0;
    for (final req in state.promoterRequirements) {
      final count = req.maleCount + req.femaleCount;
      total += count * 1500 * req.selectedDates.length;
    }
    return total;
  }

  /*int get apartmentRent {
    final numDays = state.days > 0 ? state.days : 1;
    return (state.apartmentPerDayRent ?? 0) * numDays;
  }*/

  int get giftsExperiencesTotal {
    int total = 0;
    int numDays = state.days > 0 ? state.days : 1;
    state.giftCounts.forEach((item, count) {
      if (count > 0 && state.dynamicPrices.containsKey(item)) {
        total += state.dynamicPrices[item]! * count;
      }
    });
    state.experienceCounts.forEach((item, count) {
      if (count > 0 && state.dynamicPrices.containsKey(item)) {
        total += state.dynamicPrices[item]! * count * numDays;
      }
    });
    return total;
  }

  int get stageTotal {
    if (!state.stageSetup) return 0;
    int total = 0;
    int numDays = state.days > 0 ? state.days : 1;
    state.stageCounts.forEach((item, count) {
      if (count > 0 && state.dynamicPrices.containsKey(item)) {
        if (item.contains('Backdrop') ||
            item.contains('Standee') ||
            item.contains('Flex') ||
            item.contains('Banner')) {
          total += state.dynamicPrices[item]! * count;
        } else {
          total += state.dynamicPrices[item]! * count * numDays;
        }
      }
    });
    return total;
  }

  int get estimatedTotal {
    return spaceTotal +
        objectiveTotal +
        brandingTotal +
        stageTotal +
        setupTotal +
        promotersTotal +
        giftsExperiencesTotal;
  }
}

final apartmentFieldListProvider =
    FutureProvider.family<ApartmentFieldsList, String>((ref, id) async {
      debugPrint('Provider called with id: $id');
      final result = await ApiService().getApartmentFieldList(id);
      debugPrint('API completed');
      return result;
    });

final campaignProvider = NotifierProvider<CampaignViewModel, CampaignState>(
  CampaignViewModel.new,
);

final allDraftsProvider = FutureProvider<List<CampaignState>>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final draftIds = prefs.getStringList('campaign_draft_ids') ?? [];
  final List<CampaignState> drafts = [];
  for (final id in draftIds) {
    final jsonStr = prefs.getString('campaign_draft_$id');
    if (jsonStr != null) {
      try {
        drafts.add(CampaignState.fromJson(jsonDecode(jsonStr)));
      } catch (e) {
        debugPrint('Error parsing draft for apartment $id: $e');
      }
    }
  }
  return drafts;
});
