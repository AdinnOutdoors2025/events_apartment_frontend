import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/constant.dart';
import '../providers/campaign_provider.dart';
import '../widgets/animated_price_text.dart';
import 'campaign_steps/basic_setup_step.dart';
import 'campaign_steps/branding_setup_step.dart';
import 'campaign_steps/space_schedule_step.dart';
import 'campaign_steps/stage_audio_step.dart';
import 'campaign_steps/promoters_step.dart';
import 'campaign_steps/gifts_experiences_step.dart';
import 'campaign_steps/notes_step.dart';
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
    // Assuming if it's draft, we initialize with draftStep
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
    'Basic',
    'Branding',
    'Stage',
    'Promoters',
    'Gifts',
    'Notes',
    'Brief',
    'Review',
  ];

  @override
  Widget build(BuildContext context) {
    final communityName =
        ModalRoute.of(context)?.settings.arguments as String? ??
        'Community Name';
    final state = ref.watch(campaignProvider);
    final viewModel = ref.read(campaignProvider.notifier);
    final estimatedTotal = viewModel.estimatedTotal;

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
        body: Column(
          children: [
            // Persistent Top Header section (Dates + Estimate)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 12.0,
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
                            communityName,
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
              height: 40,
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
                      padding: const EdgeInsets.only(right: 16.0),
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
                            const Icon(
                              Icons.check,
                              size: 12,
                              color: Colors.black,
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
                // Disable swipe to force using Continue button
                children: [
                  const SpaceScheduleStep(),
                  const BasicSetupStep(),
                  const BrandingSetupStep(),
                  const StageAudioStep(),
                  const PromotersStep(),
                  const GiftsExperiencesStep(),
                  const NotesStep(),
                  BriefStep(communityName: communityName),
                  ReviewStep(onEdit: _goToStep),
                ],
              ),
            ),
          ],
        ),
        // Persistent Bottom Bar
        bottomSheet: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
          child: SafeArea(
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

                if (_currentStep != _steps.length - 1) SizedBox(height: 16),

                // Buttons
                if (_currentStep == _steps.length - 1)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            _goToStep(7); // Brief Step
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
                          onPressed: () {
                            viewModel.finishCampaign();
                            Navigator.pop(context);
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
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
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

                      const SizedBox(width: 12),

                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _isContinueEnabled(state)
                              ? () {
                                  if (_currentStep < _steps.length - 1) {
                                    _goToStep(_currentStep + 1);
                                  } else {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      '/bottomNav',
                                    );
                                  }
                                }
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
                          ? () {
                              if (_currentStep < _steps.length - 1) {
                                _goToStep(_currentStep + 1);
                              } else {
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/bottomNav',
                                );
                              }
                            }
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
          state.startDate != null &&
          state.endDate != null;
    }
    // For other steps, just return true for now to allow navigating through the flow
    return true;
  }

  String _getContinueText() {
    if (_currentStep == 0) return 'Continue';
    if (_currentStep == 1) return 'Continue to branding';
    if (_currentStep == _steps.length - 3) return 'Review campaign brief';
    if (_currentStep == _steps.length - 2) return 'Continue to estimate';
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
