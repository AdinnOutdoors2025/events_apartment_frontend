import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../models/apartment_field_list.dart';
import '../../providers/campaign_provider.dart';

class SpaceScheduleStep extends ConsumerStatefulWidget {
  final ApartmentFieldsList apartmentFieldsList;

  const SpaceScheduleStep({super.key, required this.apartmentFieldsList});

  @override
  ConsumerState<SpaceScheduleStep> createState() => _SpaceScheduleStepState();
}

class _SpaceScheduleStepState extends ConsumerState<SpaceScheduleStep> {
  DateTime? fromDate;
  DateTime? toDate;

  TimeOfDay startTime = const TimeOfDay(hour: 9, minute: 0);

  TimeOfDay endTime = const TimeOfDay(hour: 18, minute: 0);

  int? editingIndex;

  late final DateRangePickerController pickerController;
  String currentMonthName = '';

  @override
  void initState() {
    super.initState();

    pickerController = DateRangePickerController();
    currentMonthName = DateFormat('MMMM yyyy').format(DateTime.now());
  }

  @override
  void dispose() {
    pickerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(campaignProvider);
    final viewModel = ref.read(campaignProvider.notifier);
    final apartment = widget.apartmentFieldsList.data?.apartment;
    final sqFeet = apartment?.sqFeetAmount ?? [];

    List<DateTime> getBookedDates() {
      final List<DateTime> dates = [];

      for (int i = 0; i < state.schedules.length; i++) {
        if (editingIndex == i) continue;

        final schedule = state.schedules[i];

        DateTime current = schedule.startDate;

        while (!current.isAfter(schedule.endDate)) {
          dates.add(current);
          current = current.add(const Duration(days: 1));
        }
      }

      return dates;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'STEP · SPACE & SCHEDULE',
            style: GoogleFonts.inter(
              color: const Color(0xFFE5212A),
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose your campaign space',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pick a footprint and lock the activation window.',
            style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 32),

          Text(
            'ACTIVATION SPACE',
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
            itemCount: sqFeet.length,
            separatorBuilder: (_, _) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final feet = sqFeet[index];

              return _buildSpaceRadio(
                feet.size ?? '',
                feet.charge ?? 0,
                state,
                viewModel,
              );
            },
          ),

          const SizedBox(height: 32),

          Text(
            'SCHEDULE',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
              letterSpacing: 1,
            ),
          ),

          const SizedBox(height: 16),

          // Campaign Duration
/*          if (state.schedules.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_month, color: Color(0xFFE5212A)),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Selected Campaign Dates",
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          "${DateFormat('dd MMM yyyy').format(state.schedules.first.startDate)}"
                          " → "
                          "${DateFormat('dd MMM yyyy').format(state.schedules.last.endDate)}",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFE5212A),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )*/

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.shade200, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  editingIndex == null
                      ? "Custom Schedule Range"
                      : "Edit Schedule Range",
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 16),

                // Grey bordered calendar container
                Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      // Custom Header Row
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 8.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.chevron_left,
                                color: Colors.black,
                                size: 24,
                              ),
                              onPressed: () {
                                pickerController.backward?.call();
                              },
                            ),
                            Text(
                              currentMonthName,
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.chevron_right,
                                color: Colors.black,
                                size: 24,
                              ),
                              onPressed: () {
                                pickerController.forward?.call();
                              },
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: Color(0xFFEEEEEE)),

                      // Calendar View Wrapped to Propagate Scroll
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onVerticalDragUpdate: (details) {
                          final scrollPosition = Scrollable.of(
                            context,
                          ).position;
                          scrollPosition.jumpTo(
                            (scrollPosition.pixels - details.delta.dy).clamp(
                              scrollPosition.minScrollExtent,
                              scrollPosition.maxScrollExtent,
                            ),
                          );
                        },
                        child: SfDateRangePicker(
                          key: ValueKey(
                            '${state.schedules.length}_$editingIndex',
                          ),
                          controller: pickerController,
                          backgroundColor: Colors.transparent,
                          headerHeight: 0,
                          selectionShape: DateRangePickerSelectionShape.circle,
                          selectionRadius: 18,

                          minDate: DateTime(
                            DateTime.now().year,
                            DateTime.now().month,
                            DateTime.now().day,
                          ),
                          enablePastDates: false,
                          selectionMode: DateRangePickerSelectionMode.range,
                          navigationDirection:
                              DateRangePickerNavigationDirection.horizontal,
                          navigationMode: DateRangePickerNavigationMode.snap,
                          startRangeSelectionColor: const Color(0xFFE5212A),
                          endRangeSelectionColor: const Color(0xFFE5212A),
                          rangeSelectionColor: const Color(
                            0xFFE5212A,
                          ).withOpacity(0.12),
                          selectionTextStyle: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                          monthCellStyle: DateRangePickerMonthCellStyle(
                            textStyle: GoogleFonts.inter(
                              color: Colors.black,
                              fontSize: 13,
                            ),
                            blackoutDateTextStyle: GoogleFonts.inter(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none,

                            ),
                            todayTextStyle: GoogleFonts.inter(
                              color:  Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          monthViewSettings: DateRangePickerMonthViewSettings(
                            blackoutDates: getBookedDates(),
                          ),
                          yearCellStyle: DateRangePickerYearCellStyle(
                            textStyle: GoogleFonts.inter(color: Colors.black),
                            todayTextStyle: GoogleFonts.inter(
                              color: const Color(0xFFE5212A),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onSelectionChanged: (args) {
                            final value = args.value;

                            if (value is PickerDateRange) {
                              setState(() {
                                fromDate = value.startDate;
                                toDate = value.endDate;
                              });
                            } else {
                              setState(() {
                                fromDate = null;
                                toDate = null;
                              });
                            }
                          },
                          onViewChanged: (DateRangePickerViewChangedArgs args) {
                            if (args.visibleDateRange.startDate != null) {
                              final middleDate = args
                                  .visibleDateRange
                                  .startDate!
                                  .add(const Duration(days: 15));
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (mounted) {
                                  setState(() {
                                    currentMonthName = DateFormat(
                                      'MMMM yyyy',
                                    ).format(middleDate);
                                  });
                                }
                              });
                            }
                          },

                          selectableDayPredicate: (DateTime date) {
                            final today = DateTime(
                              DateTime.now().year,
                              DateTime.now().month,
                              DateTime.now().day,
                            );
                            if (date.isBefore(today)) {
                              return false;
                            }
                            for (int i = 0; i < state.schedules.length; i++) {
                              if (editingIndex == i) {
                                continue;
                              }
                              final schedule = state.schedules[i];
                              if (!date.isBefore(schedule.startDate) &&
                                  !date.isAfter(schedule.endDate)) {
                                return false;
                              }
                            }
                            return true;
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(child: _dateField("From", fromDate)),
                    const SizedBox(width: 10),
                    Expanded(child: _dateField("To", toDate)),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: _timeField(context, "Start Time", startTime, (
                        time,
                      ) {
                        setState(() {
                          startTime = time;
                        });
                      }),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _timeField(context, "End Time", endTime, (time) {
                        setState(() {
                          endTime = time;
                        });
                      }),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                if (editingIndex != null) ...[
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              editingIndex = null;
                              fromDate = null;
                              toDate = null;
                              startTime = const TimeOfDay(hour: 9, minute: 0);
                              endTime = const TimeOfDay(hour: 18, minute: 0);
                            });
                            pickerController.selectedRange = null;
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text(
                            "Cancel Edit",
                            style: GoogleFonts.inter(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: fromDate == null || toDate == null
                              ? null
                              : () {
                                  _saveOrUpdateSchedule(state, viewModel);
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE5212A),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text(
                            "Update",
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  /*                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: fromDate == null || toDate == null
                          ? null
                          : () {
                              _saveOrUpdateSchedule(
                                state,
                                viewModel,
                                forceNew: true,
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        "Add as New Date Range",
                        style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                      ),
                    ),
                  )*/
                ] else ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: fromDate == null || toDate == null
                          ? null
                          : () {
                              _saveOrUpdateSchedule(state, viewModel);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE5212A),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        "Add This Date Range",
                        style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 16),

          Text(
            "Added Schedule Blocks",
            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 10),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.schedules.length,
            itemBuilder: (_, index) {
              final item = state.schedules[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 18,
                      color: Color(0xFFE5212A),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${DateFormat('dd MMM').format(item.startDate)} → ${DateFormat('dd MMM').format(item.endDate)}",
                          ),

                          const SizedBox(height: 4),

                          Text("${item.fromTime} - ${item.toTime}"),
                        ],
                      ),
                    ),

                    PopupMenuButton(
                      color: Colors.white,
                      position: PopupMenuPosition.under,
                      // show below icon
                      offset: const Offset(0, 8),
                      // little gap below icon
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      onSelected: (value) {
                        if (value == 'edit') {
                          setState(() {
                            editingIndex = index;

                            fromDate = item.startDate;

                            toDate = item.endDate;

                            startTime = parseTime(item.fromTime);

                            endTime = parseTime(item.toTime);
                          });

                          pickerController.selectedRange = PickerDateRange(
                            item.startDate,
                            item.endDate,
                          );
                          pickerController.displayDate = item.startDate;
                        }

                        if (value == 'delete') {
                          viewModel.deleteSchedule(index);
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 'edit', child: Text('Edit')),
                        PopupMenuItem(value: 'delete', child: Text('Delete')),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 120), // Bottom padding
        ],
      ),
    );
  }

  Widget _buildSpaceRadio(
    String title,
    int price,
    CampaignState state,
    CampaignViewModel viewModel,
  ) {
    bool isSelected = state.builderSelectedSpace == title;
    return GestureDetector(
      onTap: () => viewModel.setBuilderSpace(title),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$title sq.ft',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '₹${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}/day',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFE5212A)
                      : Colors.grey[300]!,
                  width: isSelected ? 6.0 : 1.0,
                ),
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveOrUpdateSchedule(
    CampaignState state,
    CampaignViewModel viewModel, {
    bool forceNew = false,
  }) {
    final startMinutes = startTime.hour * 60 + startTime.minute;
    final endMinutes = endTime.hour * 60 + endTime.minute;

    if (endMinutes <= startMinutes) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("End time must be after start time")),
      );
      return;
    }

    bool overlap = state.schedules.any((e) {
      if (!forceNew &&
          editingIndex != null &&
          state.schedules.indexOf(e) == editingIndex) {
        return false;
      }
      return !(toDate!.isBefore(e.startDate) || fromDate!.isAfter(e.endDate));
    });

    if (overlap) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selected dates already exist")),
      );
      return;
    }

    final schedule = CampaignScheduleRange(
      startDate: fromDate!,
      endDate: toDate!,
      fromTime: format12Hour(context, startTime),
      toTime: format12Hour(context, endTime),
    );

    if (editingIndex == null || forceNew) {
      viewModel.addSchedule(schedule);
    } else {
      viewModel.updateSchedule(editingIndex!, schedule);
    }

    setState(() {
      editingIndex = null;
      fromDate = null;
      toDate = null;
      startTime = const TimeOfDay(hour: 9, minute: 0);
      endTime = const TimeOfDay(hour: 18, minute: 0);
    });

    pickerController.selectedRange = null;
  }

  Widget _dateField(String label, DateTime? value) {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border.all(
          color: /*value != null ? const Color(0xFFE5212A) :*/
              Colors.grey.shade300,
          width: /*value != null ? 1.5 :*/ 1.0,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today,
            size: 18,
            color: /*value != null ? const Color(0xFFE5212A) :*/
                Colors.grey.shade600,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade500,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value == null
                      ? "Select Date"
                      : DateFormat("dd MMM yyyy").format(value),
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: value == null ? Colors.grey.shade400 : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _timeField(
    BuildContext context,
    String label,
    TimeOfDay selectedTime,
    ValueChanged<TimeOfDay> onChanged,
  ) {
    return InkWell(
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: selectedTime,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(alwaysUse24HourFormat: false),
              child: Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: Color(0xFFE5212A),
                    onPrimary: Colors.white,
                    onSurface: Colors.black,
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFFE5212A),
                    ),
                  ),
                ),
                child: child!,
              ),
            );
          },
        );

        if (picked != null) {
          onChanged(picked);
        }
      },
      child: Container(
        height: 54,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.access_time, size: 18, color: Colors.grey.shade600),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label.toUpperCase(),
                    style: GoogleFonts.inter(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade500,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    format12Hour(context, selectedTime),
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, size: 18),
          ],
        ),
      ),
    );
  }

  String format12Hour(BuildContext context, TimeOfDay time) {
    return MaterialLocalizations.of(
      context,
    ).formatTimeOfDay(time, alwaysUse24HourFormat: false);
  }

  TimeOfDay parseTime(String value) {
    final dateTime = DateFormat('hh:mm a').parse(value);
    return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
  }

  TimeOfDay _parseTime(String timeString) {
    try {
      final dateTime = DateFormat('hh:mm a').parse(timeString);
      return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
    } catch (_) {
      return const TimeOfDay(hour: 9, minute: 0);
    }
  }
}
