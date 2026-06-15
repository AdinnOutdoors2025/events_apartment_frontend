import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../providers/campaign_provider.dart';

class PromotersStep extends ConsumerWidget {
  const PromotersStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(campaignProvider);
    final viewModel = ref.read(campaignProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ========================
          /// HEADER
          /// ========================
          Text(
            'STEP · PROMOTERS',
            style: GoogleFonts.inter(
              color: const Color(0xFFE5212A),
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Promoter Requirements',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Configure the promoters you need for your campaign.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 32),

          /// ========================
          /// ARE YOU NEED PROMOTER? TOGGLE
          /// ========================
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: state.needPromoters
                    ? const Color(0xFFE5212A).withValues(alpha: 0.5)
                    : Colors.grey.shade200,
                width: state.needPromoters ? 1.5 : 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Are you need promoter?',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Enable to configure your promoter requirements.',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Switch.adaptive(
                  value: state.needPromoters,
                  activeThumbColor: const Color(0xFFE5212A),
                  onChanged: (val) {
                    viewModel.toggleNeedPromoters(val);
                    if (val && state.promoterRequirements.isEmpty) {
                      viewModel.addPromoterRequirement();
                    }
                  },
                ),
              ],
            ),
          ),

          /// ========================
          /// PROMOTER REQUIREMENT CARDS
          /// ========================
          if (state.needPromoters) ...[
            const SizedBox(height: 24),
            Text(
              'PROMOTER DETAILS',
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 16),
            ...state.promoterRequirements.asMap().entries.map((entry) {
              final index = entry.key;
              final req = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _PromoterCard(
                  index: index,
                  requirement: req,
                  startDate: state.selectedStart,
                  endDate: state.selectedEnd,
                  onUpdate: (updated) =>
                      viewModel.updatePromoterRequirement(updated),
                  onRemove: state.promoterRequirements.length > 1
                      ? () => viewModel.removePromoterRequirement(req.id)
                      : null,
                ),
              );
            }),

            /// ADD MORE BUTTON
            GestureDetector(
              onTap: () => viewModel.addPromoterRequirement(),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0EF),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFE5212A).withValues(alpha: 0.4),
                    width: 1.5,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE5212A),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Add Another Promoter Requirement',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFE5212A),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          const SizedBox(height: 120),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// PROMOTER CARD WIDGET
// ─────────────────────────────────────────────────────
class _PromoterCard extends StatelessWidget {
  final int index;
  final PromoterRequirement requirement;
  final DateTime? startDate;
  final DateTime? endDate;
  final ValueChanged<PromoterRequirement> onUpdate;
  final VoidCallback? onRemove;

  const _PromoterCard({
    required this.index,
    required this.requirement,
    required this.startDate,
    required this.endDate,
    required this.onUpdate,
    this.onRemove,
  });

  List<DateTime> get _campaignDates {
    if (startDate == null || endDate == null) return [];
    final days = endDate!.difference(startDate!).inDays + 1;
    return List.generate(days, (i) => startDate!.add(Duration(days: i)));
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('d MMM');
    final campaignDates = _campaignDates;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0EF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Requirement ${index + 1}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFE5212A),
                  ),
                ),
              ),
              if (onRemove != null)
                GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.delete_outline,
                      size: 18,
                      color: Colors.red.shade400,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 20),
          const _Divider(),
          const SizedBox(height: 20),

          /// ── GENDER SELECTION ──
          Text(
            'GENDER',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey[500],
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Select gender(s) and set the required count.',
            style: GoogleFonts.inter(fontSize: 11, color: Colors.grey[500]),
          ),
          const SizedBox(height: 12),
          // Gender selector chips
          Row(
            children: [
              _GenderChip(
                label: 'Male',
                icon: Icons.male_rounded,
                selected: requirement.maleCount > 0,
                onTap: () {
                  if (requirement.maleCount > 0) {
                    // Deselect Male
                    onUpdate(requirement.copyWith(maleCount: 0));
                  } else {
                    // Select Male, clear Female
                    onUpdate(requirement.copyWith(maleCount: 1, femaleCount: 0));
                  }
                },
              ),
              const SizedBox(width: 12),
              _GenderChip(
                label: 'Female',
                icon: Icons.female_rounded,
                selected: requirement.femaleCount > 0,
                onTap: () {
                  if (requirement.femaleCount > 0) {
                    // Deselect Female
                    onUpdate(requirement.copyWith(femaleCount: 0));
                  } else {
                    // Select Female, clear Male
                    onUpdate(requirement.copyWith(femaleCount: 1, maleCount: 0));
                  }
                },
              ),
            ],
          ),
          // Counter rows for selected genders
          if (requirement.maleCount > 0) ...[
            const SizedBox(height: 14),
            _GenderCounterRow(
              label: 'Male',
              icon: Icons.male_rounded,
              count: requirement.maleCount,
              onDecrement: requirement.maleCount > 1
                  ? () => onUpdate(requirement.copyWith(maleCount: requirement.maleCount - 1))
                  : null,
              onIncrement: () => onUpdate(requirement.copyWith(maleCount: requirement.maleCount + 1)),
            ),
          ],
          if (requirement.femaleCount > 0) ...[
            const SizedBox(height: 14),
            _GenderCounterRow(
              label: 'Female',
              icon: Icons.female_rounded,
              count: requirement.femaleCount,
              onDecrement: requirement.femaleCount > 1
                  ? () => onUpdate(requirement.copyWith(femaleCount: requirement.femaleCount - 1))
                  : null,
              onIncrement: () => onUpdate(requirement.copyWith(femaleCount: requirement.femaleCount + 1)),
            ),
          ],

          const SizedBox(height: 20),
          const _Divider(),
          const SizedBox(height: 20),

          /// ── LANGUAGE SELECTION ──
          Text(
            'LANGUAGE',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey[500],
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: ['Tamil', 'English', 'Hindi', 'Malayalam'].map((lang) {
              final selected = requirement.languages.contains(lang);
              return _SelectChip(
                label: lang,
                selected: selected,
                onTap: () {
                  final langs = List<String>.from(requirement.languages);
                  selected ? langs.remove(lang) : langs.add(lang);
                  onUpdate(requirement.copyWith(languages: langs));
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 20),
          const _Divider(),
          const SizedBox(height: 20),

          /// ── APPEARANCE SELECTION ──
          Text(
            'APPEARANCE',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey[500],
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: ['Traditional', 'Professional','Elegant', 'Modern'].map((style) {
              final selected = requirement.appearances.contains(style);
              return _SelectChip(
                label: style,
                selected: selected,
                onTap: () {
                  final apps = List<String>.from(requirement.appearances);
                  selected ? apps.remove(style) : apps.add(style);
                  onUpdate(requirement.copyWith(appearances: apps));
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 20),
          const _Divider(),
          const SizedBox(height: 20),

          /// ── DATE SELECTION ──
          Text(
            'SELECT DAYS',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey[500],
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            campaignDates.isEmpty
                ? 'No campaign dates set. Please select dates in the Space & Schedule step.'
                : 'Select the days this requirement applies to.',
            style: GoogleFonts.inter(fontSize: 11, color: Colors.grey[500]),
          ),
          if (campaignDates.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: campaignDates.map((date) {
                final selected = requirement.selectedDates
                    .any((d) => _isSameDay(d, date));
                return _DateChip(
                  label: dateFormat.format(date),
                  selected: selected,
                  onTap: () {
                    final dates =
                        List<DateTime>.from(requirement.selectedDates);
                    if (selected) {
                      dates.removeWhere((d) => _isSameDay(d, date));
                    } else {
                      dates.add(date);
                    }
                    onUpdate(requirement.copyWith(selectedDates: dates));
                  },
                );
              }).toList(),
            ),
          ],

          const SizedBox(height: 20),
          const _Divider(),
          const SizedBox(height: 20),

          /// ── NOTES (optional) ──
          Text(
            'NOTES (OPTIONAL)',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey[500],
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            maxLines: 3,
            controller: TextEditingController.fromValue(
              TextEditingValue(
                text: requirement.notes ?? '',
                selection: TextSelection.collapsed(
                  offset: (requirement.notes ?? '').length,
                ),
              ),
            ),
            onChanged: (val) {
              onUpdate(requirement.copyWith(notes: val));
            },
            decoration: InputDecoration(
              hintText: 'Any special notes for this requirement...',
              hintStyle: GoogleFonts.inter(
                color: Colors.grey[400],
                fontSize: 13,
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
              contentPadding: const EdgeInsets.all(16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

// ─────────────────────────────────────────────────────
// GENDER CHIP (select step)
// ─────────────────────────────────────────────────────
class _GenderChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _GenderChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFE5212A) : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected
                  ? const Color(0xFFE5212A)
                  : Colors.grey.shade200,
              width: selected ? 1.5 : 1.0,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20,
                color: selected ? Colors.white : Colors.grey[500],
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : Colors.grey[600],
                ),
              ),
              if (selected) ...[
                const SizedBox(width: 6),
                const Icon(Icons.check_circle, size: 14, color: Colors.white),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// GENDER COUNTER ROW (count step, shown after selection)
// ─────────────────────────────────────────────────────
class _GenderCounterRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final int count;
  final VoidCallback? onDecrement;
  final VoidCallback onIncrement;

  const _GenderCounterRow({
    required this.label,
    required this.icon,
    required this.count,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0EF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE5212A).withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFFE5212A)),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFE5212A),
            ),
          ),
          const Spacer(),
          _CounterBtn(
            icon: Icons.remove,
            onTap: onDecrement,
          ),
          const SizedBox(width: 16),
          Text(
            '$count',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 16),
          _CounterBtn(
            icon: Icons.add,
            onTap: onIncrement,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// COUNTER BUTTON
// ─────────────────────────────────────────────────────
class _CounterBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _CounterBtn({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: enabled ? Colors.black : Colors.grey.shade200,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 14,
          color: enabled ? Colors.white : Colors.grey.shade400,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// SELECT CHIP (language / appearance)
// ─────────────────────────────────────────────────────
class _SelectChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SelectChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE5212A) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: selected
                ? const Color(0xFFE5212A)
                : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : Colors.grey[700],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// DATE CHIP
// ─────────────────────────────────────────────────────
class _DateChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _DateChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE5212A) : Colors.white,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: selected
                ? const Color(0xFFE5212A)
                : Colors.grey.shade300,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: const Color(0xFFE5212A).withValues(alpha: 0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selected)
              const Padding(
                padding: EdgeInsets.only(right: 4),
                child: Icon(Icons.check, size: 12, color: Colors.white),
              ),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// DIVIDER HELPER
// ─────────────────────────────────────────────────────
class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Divider(height: 1, color: Colors.grey.shade100);
  }
}
