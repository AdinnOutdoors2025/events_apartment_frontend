import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../constants/constant.dart';
import '../models/apartment_field_list.dart';
import '../providers/campaign_provider.dart';
import '../utils/api_service.dart';
import '../widgets/animated_price_text.dart';
import 'campaign_steps/branding_setup_step.dart';
import 'campaign_steps/space_schedule_step.dart';
import 'campaign_steps/stage_setup_step.dart';
import 'campaign_steps/promoters_step.dart';
import 'campaign_steps/gifts_experiences_step.dart';
import 'campaign_steps/notes_step.dart';
import 'campaign_steps/customer_details_step.dart';
import 'campaign_steps/brief_step.dart';
import 'campaign_steps/review_step.dart';

class CampaignBuilderScreen extends ConsumerStatefulWidget {
  const CampaignBuilderScreen({super.key});

  @override
  ConsumerState<CampaignBuilderScreen> createState() =>
      _CampaignBuilderScreenState();
}

class _CampaignBuilderScreenState extends ConsumerState<CampaignBuilderScreen> {
  late int _currentStep;
  late int _highestReachedStep;
  final PageController _pageController = PageController();


  @override
  void initState() {
    super.initState();
    final isDraft = ref.read(campaignProvider).isDraft;
    _currentStep = isDraft ? ref.read(campaignProvider).draftStep : 0;
    _highestReachedStep = _currentStep;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_currentStep > 0 && _pageController.hasClients) {
        _pageController.jumpToPage(_currentStep);
      }
    });
  }

  final List<String> _steps = [
    'Space',
    'Branding',
    'Stage',
    'Promoters',
    'Gifts',
    'Notes',
    'Client',
    'Brief',
    'Review',
  ];

  @override
  Widget build(BuildContext context) {
    final apartmentFieldLists =
        ModalRoute.of(context)!.settings.arguments as ApartmentFieldsList;
    final state = ref.watch(campaignProvider);
    final viewModel = ref.read(campaignProvider.notifier);
    final estimatedTotal = viewModel.estimatedTotal;

    final apartment = apartmentFieldLists.data?.apartment;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _showDiscardDialog();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF8F9FA),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 20,
            ),
            onPressed: () {
              _showDiscardDialog();
            },
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CAMPAIGN BUILDER',
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
        body: Column(
          children: [
            // Persistent Top Header section (Dates + Estimate)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 5.0,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.dateRangeText.isNotEmpty
                                ? state.dateRangeText
                                : 'SELECT DATES',
                            style: GoogleFonts.inter(
                              color: Colors.grey[600],
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            apartment?.apartmentName ?? '',
                            style: GoogleFonts.inter(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'ESTIMATE',
                          style: GoogleFonts.inter(
                            color: Colors.grey[600],
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 4),
                        AnimatedPriceText(
                          targetPrice: estimatedTotal,
                          style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(
              height: 35,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _steps.length,
                itemBuilder: (context, index) {
                  bool isPast = index < _currentStep;
                  bool isCurrent = index == _currentStep;
                  bool isCompleted = index <= _highestReachedStep;
                  return GestureDetector(
                    onTap: () {
                      if (isCompleted) {
                        _goToStep(index);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0,top: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 2,
                            width: 40,
                            color: isPast || isCurrent
                                ? const Color(0xFFE5212A)
                                : Colors.grey[300],
                            margin: const EdgeInsets.only(bottom: 6),
                          ),
                          if (isPast)
                            Row(
                              children: [
                                Text(
                                  _steps[index],
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    fontWeight: isPast
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                    color: isPast
                                        ? const Color(0xFFE5212A)
                                        : Colors.grey[500],
                                  ),
                                ),
                                SizedBox(width: 3,),
                                const Icon(
                                  Icons.check,
                                  size: 12,
                                  color: Colors.black,
                                ),
                              ],
                            )
                          else
                            Text(
                              _steps[index],
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: isCurrent
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                color: isCurrent
                                    ? const Color(0xFFE5212A)
                                    : Colors.grey[500],
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const Divider(height: 1, color: Color(0xFFEEEEEE)),

            // Step Content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  SpaceScheduleStep(apartmentFieldsList: apartmentFieldLists),
                  BrandingSetupStep(apartmentFieldsList: apartmentFieldLists),
                  StageSetupStep(apartmentFieldsList: apartmentFieldLists),
                  const PromotersStep(),
                  GiftsExperiencesStep(
                    apartmentFieldsList: apartmentFieldLists,
                  ),
                  const NotesStep(),
                  const CustomerDetailsStep(),
                  BriefStep(communityName: apartment?.apartmentName ?? ''),
                  ReviewStep(onEdit: _goToStep),
                ],
              ),
            ),
            SizedBox(height: 50,)
          ],
        ),
        // Persistent Bottom Bar
        bottomSheet: MediaQuery.of(context).viewInsets.bottom > 0
            ? null
            : Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.only(

              bottom: MediaQuery.of(context).viewPadding.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ESTIMATED TOTAL',
                      style: GoogleFonts.inter(
                        color: Colors.grey[600],
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                    AnimatedPriceText(
                      targetPrice: estimatedTotal,
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                if (_currentStep != _steps.length - 1) const SizedBox(height: 5),

                // Buttons
                if (_currentStep == _steps.length - 1)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            _goToStep(_steps.length - 2); // Brief Step
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            'Brief',
                            style: GoogleFonts.inter(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () async {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => const Center(
                                child: CircularProgressIndicator(color: Color(0xFFE5212A)),
                              ),
                            );

                            try {
                              await ApiService().createCampaign(state, apartmentFieldLists);
                              if (context.mounted) {
                                Navigator.pop(context); // pop loading
                                
                                // Prepare booking summary details before clearing campaign state
                                final apartmentName = apartment?.apartmentName ?? 'Apartment';
                                final location = apartment?.location ?? 'Location';
                                final stayDates = state.selectedStart != null && state.selectedEnd != null
                                    ? "${DateFormat('E, d MMM yyyy').format(state.selectedStart!)} – ${DateFormat('E, d MMM yyyy').format(state.selectedEnd!)}"
                                    : 'Dates';
                                final totalAmount = "₹${estimatedTotal.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}";
                                final bookingId = "BKNG-${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}${DateTime.now().day.toString().padLeft(2, '0')}-${(DateTime.now().millisecondsSinceEpoch % 10000).toString().padLeft(4, '0')}";

                                final bookingItem = {
                                  'bookingId': bookingId,
                                  'apartmentName': apartmentName,
                                  'location': location,
                                  'stayDates': stayDates,
                                  'totalAmount': totalAmount,
                                  'status': 'Confirmed',
                                  'nights': '${state.days} nights',
                                };

                                // Save to SharedPreferences for Campaigns tab
                                final prefs = await SharedPreferences.getInstance();
                                final list = prefs.getStringList('booked_campaigns') ?? [];
                                list.insert(0, jsonEncode(bookingItem));
                                await prefs.setStringList('booked_campaigns', list);

                                viewModel.finishCampaign();
                                
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/bookingSuccess',
                                  arguments: bookingItem,
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                Navigator.pop(context); // pop loading
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      e.toString().replaceAll('Exception: ', ''),
                                      style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                                    ),
                                    backgroundColor: const Color(0xFFE5212A),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            'Request final quote',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                else if (_currentStep == 2)
                  Row(
                    children: [
                     /* Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            _showLayoutPreviewDialog(state);
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: const Color(0xFFF5F5F5),
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            'Layout preview',
                            style: GoogleFonts.inter(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),*/

                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _isContinueEnabled(state)
                              ? () => _handleContinue(state)
                              : null,
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            _getContinueText(),
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isContinueEnabled(state)
                          ? () => _handleContinue(state)
                          : null,
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                      ),
                      child: Text(
                        _getContinueText(),
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isContinueEnabled(CampaignState state) {
    if (_currentStep == 0) {
      return state.builderSelectedSpace != null &&
          state.schedules.isNotEmpty;
    }
    // Stage step validation: if stage is enabled, at least one item count > 0
    if (_currentStep == 2) {
      if (state.stageSetup) {
        final hasCount = state.stageCounts.values.any((c) => c > 0);
        return hasCount;
      }
    }
    return true;
  }

  String _getContinueText() {
    if (_currentStep == 0) return 'Continue';
    if (_currentStep == _steps.length - 2) return 'Review campaign brief';
    if (_currentStep == _steps.length - 1) return 'Continue to estimate';
    return 'Continue';
  }

  void _goToStep(int step) {
    setState(() {
      _currentStep = step;
      if (step > _highestReachedStep) {
        _highestReachedStep = step;
      }
    });
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _handleContinue(CampaignState state) {
    // Promoters step validation (index 3)
    if (_currentStep == 3 && state.needPromoters) {
      for (final req in state.promoterRequirements) {
        if (req.maleCount == 0 && req.femaleCount == 0) {
          _showErrorSnackBar('Please select a gender for all promoter requirements.');
          return;
        }
        if (req.selectedDates.isEmpty) {
          _showErrorSnackBar('Please select at least one day for all promoter requirements.');
          return;
        }
      }
    }

    // Customer details validation (index 6)
    if (_currentStep == 6) {
      if (state.customerType == null || state.customerType!.isEmpty) {
        _showErrorSnackBar('Please select Customer Type (Brand or Agency).');
        return;
      }
      if (state.customerBrandName == null || state.customerBrandName!.trim().isEmpty) {
        _showErrorSnackBar('Please enter Brand / Company Name.');
        return;
      }
      if (state.customerContactName == null || state.customerContactName!.trim().isEmpty) {
        _showErrorSnackBar('Please enter Contact Person Name.');
        return;
      }
      final phone = state.customerPhone?.trim() ?? '';
      if (phone.isEmpty) {
        _showErrorSnackBar('Please enter Contact Phone Number.');
        return;
      }
      if (phone.length < 10) {
        _showErrorSnackBar('Please enter a valid 10-digit Phone Number.');
        return;
      }
      final email = state.customerEmail?.trim() ?? '';
      if (email.isEmpty) {
        _showErrorSnackBar('Please enter Email.');
        return;
      }
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(email)) {
        _showErrorSnackBar('Please enter a valid Email address.');
        return;
      }
      final gst = state.customerGst?.trim() ?? '';
      if (gst.isEmpty) {
        _showErrorSnackBar('Please enter GST Number.');
        return;
      }
      if (gst.length != 15) {
        _showErrorSnackBar('Please enter a valid 15-character GST Number.');
        return;
      }
      if (state.customerDesignation == null || state.customerDesignation!.trim().isEmpty) {
        _showErrorSnackBar('Please enter Designation.');
        return;
      }
    }

    if (_currentStep < _steps.length - 1) {
      _goToStep(_currentStep + 1);
    } else {
      Navigator.pushReplacementNamed(context, '/bottomNav');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.inter(fontWeight: FontWeight.w500),
        ),
        backgroundColor: const Color(0xFFE5212A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showLayoutPreviewDialog(CampaignState state) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          'LAYOUT PREVIEW',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 1.0),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5212A), width: 1.5),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Space Box
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF0EF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE5212A), width: 2, style: BorderStyle.solid),
                    ),
                    alignment: Alignment.topCenter,
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      state.builderSelectedSpace ?? 'Space',
                      style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: const Color(0xFFE5212A), fontSize: 12),
                    ),
                  ),
                  // Render a couple of icons as a visual representation of layout
                  Positioned(
                    top: 60,
                    left: 100,
                    child: Column(
                      children: [
                        const Icon(Icons.table_restaurant, color: Colors.black, size: 24),
                        Text('Table', style: GoogleFonts.inter(fontSize: 8)),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 60,
                    right: 100,
                    child: Column(
                      children: [
                        const Icon(Icons.chair, color: Colors.black, size: 24),
                        Text('Chair', style: GoogleFonts.inter(fontSize: 8)),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 40,
                    child: Column(
                      children: [
                        const Icon(Icons.co_present, color: Colors.black, size: 24),
                        Text('Backdrop', style: GoogleFonts.inter(fontSize: 8)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Interactive 2D schematic of your selected activation footprint (${state.builderSelectedSpace ?? "No space select"}). Items will be arranged in this designated boundary.',
              style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[600], height: 1.4),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _showDiscardDialog() async {
    final viewModel = ref.read(campaignProvider.notifier);
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              'Are you sure you want to go back?',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            content: Text(
              'You can save your progress as a draft or discard it entirely.',
              style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[700]),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                  if (_currentStep > 0) {
                    _goToStep(_currentStep - 1);
                  } else {
                    Navigator.pop(context); // Pops builder
                  }
                },
                child: Text(
                  'Back Step',
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  viewModel.saveDraft(_currentStep);
                  Navigator.pop(context, true);
                  Navigator.pop(context);
                },
                child: Text(
                  'Discard & Save',
                  style: GoogleFonts.inter(
                    color: const Color(0xFFE5212A),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  viewModel.clearCampaign();
                  Navigator.pop(context, true);
                  Navigator.pop(context);
                },
                child: Text(
                  'Discard without save',
                  style: GoogleFonts.inter(
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }
}

