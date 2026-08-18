import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:finalproject/core/di/service_locator.dart';
import 'package:finalproject/feature/Department_Exam/Exam_Schedule/data/model/exam_schedule_model.dart';
import 'package:finalproject/feature/Department_Exam/Exam_Schedule/presentation/manger/seat_allocation/exam_seat_allocation_cubit.dart';
import 'package:finalproject/feature/Department_Exam/Exam_Schedule/presentation/manger/seat_allocation/exam_seat_allocation_state.dart';
import 'package:finalproject/feature/Department_Exam/Halls/data/hall_model.dart';

class ExamSeatAllocationPage extends StatelessWidget {
  final ExamScheduleModel schedule;
  final List<ExamScheduleModel> sessionSchedules;

  const ExamSeatAllocationPage({
    super.key,
    required this.schedule,
    required this.sessionSchedules,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ExamSeatAllocationCubit>()..load(schedule.id ?? 0),
      child: _ExamSeatAllocationView(
        schedule: schedule,
        sessionSchedules: sessionSchedules,
      ),
    );
  }
}

class _ExamSeatAllocationView extends StatefulWidget {
  final ExamScheduleModel schedule;
  final List<ExamScheduleModel> sessionSchedules;

  const _ExamSeatAllocationView({
    required this.schedule,
    required this.sessionSchedules,
  });

  @override
  State<_ExamSeatAllocationView> createState() =>
      _ExamSeatAllocationViewState();
}

class _ExamSeatAllocationViewState extends State<_ExamSeatAllocationView> {
  final Set<int> _selectedHallIds = <int>{};
  final TextEditingController _hallSearchController = TextEditingController();
  final TextEditingController _studentSearchController =
      TextEditingController();

  String _hallSearch = '';
  String _studentSearch = '';
  int? _selectedResultHallId;
  bool _forceAllocation = false;

  int get _scheduleId => widget.schedule.id ?? 0;
  int get _requiredStudents => widget.schedule.eligibleStudentsCount;

  @override
  void dispose() {
    _hallSearchController.dispose();
    _studentSearchController.dispose();
    super.dispose();
  }

  int _minutes(String value) {
    final parts = value.split(':');
    final hour = int.tryParse(parts.isNotEmpty ? parts.first : '') ?? -1;
    final minute = int.tryParse(parts.length > 1 ? parts[1] : '') ?? -1;
    return hour < 0 || minute < 0 ? -1 : (hour * 60) + minute;
  }

  bool _overlaps(ExamScheduleModel other) {
    if (other.id == widget.schedule.id ||
        other.examDate != widget.schedule.examDate) {
      return false;
    }
    final start = _minutes(widget.schedule.startTime);
    final end = _minutes(widget.schedule.endTime);
    final otherStart = _minutes(other.startTime);
    final otherEnd = _minutes(other.endTime);
    return start >= 0 &&
        end > start &&
        otherStart >= 0 &&
        otherEnd > otherStart &&
        start < otherEnd &&
        otherStart < end;
  }

  Set<int> _unavailableHallIds(List<HallModel> halls) {
    final busyNames = widget.sessionSchedules
        .where(_overlaps)
        .expand((schedule) => schedule.halls)
        .map((name) => name.trim())
        .where((name) => name.isNotEmpty)
        .toSet();
    return halls
        .where((hall) => busyNames.contains(hall.name.trim()))
        .map((hall) => hall.id)
        .toSet();
  }

  int _selectedCapacity(List<HallModel> halls) => halls
      .where((hall) => _selectedHallIds.contains(hall.id))
      .fold(0, (total, hall) => total + hall.capacity);

  String _dateLabel(String value) {
    final parts = value.split('-');
    if (parts.length != 3) return value;
    return '${parts[2]}/${parts[1]}/${parts[0]}';
  }

  String _timeLabel(String value) =>
      value.length >= 5 ? value.substring(0, 5) : value;

  Future<void> _confirmAllocation(ExamSeatAllocationState state) async {
    final capacity = _selectedCapacity(state.halls);
    if (_selectedHallIds.isEmpty) {
      _showMessage('اختر قاعة واحدة على الأقل.', isError: true);
      return;
    }
    if (capacity < _requiredStudents) {
      _showMessage(
        'السعة المختارة غير كافية. العجز: ${_requiredStudents - capacity} مقعد.',
        isError: true,
      );
      return;
    }

    final hasPrevious = state.seatingSheet.hasSeatings;
    if (hasPrevious) {
      final accepted = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('تأكيد إعادة التوزيع'),
          content: const Text(
            'يوجد توزيع سابق لهذه المادة. سيتم إرسال القاعات الجديدة إلى الخادم لإعادة التوزيع.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('إلغاء'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('متابعة'),
            ),
          ],
        ),
      );
      if (accepted != true || !mounted) return;
    }

    final success = await context.read<ExamSeatAllocationCubit>().allocate(
      scheduleId: _scheduleId,
      hallIds: _selectedHallIds.toList(),
    );
    if (success && mounted) {
      setState(() => _forceAllocation = false);
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError
              ? const Color(0xFFB3261E)
              : const Color(0xFF146C43),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('تخصيص القاعات والمقاعد'),
          centerTitle: false,
          actions: [
            IconButton(
              tooltip: 'تحديث النتائج',
              onPressed: _scheduleId == 0
                  ? null
                  : () => context
                        .read<ExamSeatAllocationCubit>()
                        .refreshSeatings(_scheduleId),
              icon: const Icon(Icons.refresh_rounded),
            ),
            const SizedBox(width: 10),
          ],
        ),
        body: BlocConsumer<ExamSeatAllocationCubit, ExamSeatAllocationState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              _showMessage(state.errorMessage!, isError: true);
            }
            if (state.successMessage != null) {
              _showMessage(state.successMessage!);
            }
          },
          builder: (context, state) {
            if (state.loading && state.halls.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            if (_scheduleId == 0) {
              return const Center(
                child: Text('تعذر تحديد معرف المادة الامتحانية.'),
              );
            }

            final showResults =
                state.seatingSheet.hasSeatings && !_forceAllocation;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHero(state, showResults),
                  const SizedBox(height: 20),
                  if (showResults)
                    _buildResults(state)
                  else
                    _buildAllocationSetup(state),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHero(ExamSeatAllocationState state, bool showResults) {
    final seated = state.seatingSheet.totalSeated;
    final status = seated == 0
        ? 'غير موزعة'
        : seated >= _requiredStudents
        ? 'موزعة بالكامل'
        : 'توزيع جزئي';
    final statusColor = seated == 0
        ? const Color(0xFF6C757D)
        : seated >= _requiredStudents
        ? const Color(0xFF146C43)
        : const Color(0xFFB26A00);

    return Card(
      elevation: 0,
      color: const Color(0xFFF5F8FC),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 14,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundColor: Color(0xFF153E75),
                  child: Icon(Icons.event_seat_outlined, color: Colors.white),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.schedule.subjectName,
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      [
                        widget.schedule.academicYear,
                        if (widget.schedule.specialization.isNotEmpty)
                          widget.schedule.specialization,
                      ].where((item) => item.isNotEmpty).join(' • '),
                      style: TextStyle(color: Colors.blueGrey.shade700),
                    ),
                  ],
                ),
                Chip(
                  avatar: Icon(
                    seated == 0
                        ? Icons.pending_outlined
                        : seated >= _requiredStudents
                        ? Icons.check_circle_outline
                        : Icons.warning_amber_rounded,
                    color: statusColor,
                    size: 18,
                  ),
                  label: Text(status),
                  side: BorderSide(color: statusColor.withOpacity(.35)),
                  labelStyle: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (showResults)
                  OutlinedButton.icon(
                    onPressed: () => setState(() => _forceAllocation = true),
                    icon: const Icon(Icons.restart_alt_rounded),
                    label: const Text('إعادة اختيار القاعات'),
                  ),
              ],
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 12,
              runSpacing: 10,
              children: [
                _detailPill(
                  Icons.calendar_month_outlined,
                  _dateLabel(widget.schedule.examDate),
                ),
                _detailPill(
                  Icons.schedule_outlined,
                  '${_timeLabel(widget.schedule.startTime)} — ${_timeLabel(widget.schedule.endTime)}',
                ),
                _detailPill(
                  Icons.groups_2_outlined,
                  '$_requiredStudents طالباً مؤهلاً',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailPill(IconData icon, String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFD8E2F0)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 17, color: const Color(0xFF315B91)),
        const SizedBox(width: 7),
        Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    ),
  );

  Widget _buildAllocationSetup(ExamSeatAllocationState state) {
    final unavailable = _unavailableHallIds(state.halls);
    final selectedCapacity = _selectedCapacity(state.halls);
    final difference = selectedCapacity - _requiredStudents;
    final filteredHalls = state.halls.where((hall) {
      return hall.name.toLowerCase().contains(_hallSearch.toLowerCase());
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSummaryCards(
          seated: 0,
          usedHalls: _selectedHallIds.length,
          capacity: selectedCapacity,
        ),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 1050;
            final selector = _buildHallSelector(
              state: state,
              halls: filteredHalls,
              unavailableHallIds: unavailable,
            );
            final summary = _buildAllocationSummary(
              state: state,
              unavailableHallIds: unavailable,
              selectedCapacity: selectedCapacity,
              difference: difference,
            );
            if (!wide) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [summary, const SizedBox(height: 18), selector],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 7, child: selector),
                const SizedBox(width: 20),
                Expanded(flex: 4, child: summary),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildSummaryCards({
    required int seated,
    required int usedHalls,
    required int capacity,
  }) {
    final remaining = (_requiredStudents - seated).clamp(0, _requiredStudents);
    return Wrap(
      spacing: 14,
      runSpacing: 14,
      children: [
        _summaryCard(
          'الطلاب المطلوبون',
          '$_requiredStudents',
          Icons.groups_rounded,
          const Color(0xFF315B91),
        ),
        _summaryCard(
          'المقاعد الموزعة',
          '$seated',
          Icons.event_seat_rounded,
          const Color(0xFF146C43),
        ),
        _summaryCard(
          'المقاعد المتبقية',
          '$remaining',
          Icons.pending_actions_rounded,
          const Color(0xFFB26A00),
        ),
        _summaryCard(
          'سعة القاعات المختارة',
          '$capacity',
          Icons.domain_rounded,
          const Color(0xFF6A4C93),
        ),
        _summaryCard(
          'القاعات المستخدمة',
          '$usedHalls',
          Icons.meeting_room_rounded,
          const Color(0xFF0F6B78),
        ),
      ],
    );
  }

  Widget _summaryCard(String title, String value, IconData icon, Color color) {
    return SizedBox(
      width: 200,
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(.12),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blueGrey.shade700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHallSelector({
    required ExamSeatAllocationState state,
    required List<HallModel> halls,
    required Set<int> unavailableHallIds,
  }) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.domain_add_outlined, color: Color(0xFF153E75)),
                const SizedBox(width: 9),
                const Expanded(
                  child: Text(
                    'اختيار القاعات الامتحانية',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                  ),
                ),
                Text(
                  '${halls.length} قاعة',
                  style: TextStyle(color: Colors.blueGrey.shade700),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _hallSearchController,
              onChanged: (value) => setState(() => _hallSearch = value),
              decoration: const InputDecoration(
                labelText: 'بحث عن قاعة',
                prefixIcon: Icon(Icons.search_rounded),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            if (halls.isEmpty)
              const Padding(
                padding: EdgeInsets.all(28),
                child: Center(child: Text('لا توجد قاعات مطابقة للبحث.')),
              )
            else
              LayoutBuilder(
                builder: (context, constraints) {
                  final count = constraints.maxWidth > 850
                      ? 3
                      : constraints.maxWidth > 520
                      ? 2
                      : 1;
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: halls.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: count,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: count == 1 ? 4.1 : 2.15,
                    ),
                    itemBuilder: (context, index) {
                      final hall = halls[index];
                      final unavailable = unavailableHallIds.contains(hall.id);
                      final selected = _selectedHallIds.contains(hall.id);
                      return _hallCard(hall, selected, unavailable);
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _hallCard(HallModel hall, bool selected, bool unavailable) {
    final color = unavailable
        ? Colors.grey
        : selected
        ? const Color(0xFF315B91)
        : const Color(0xFF6A4C93);
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: unavailable
          ? null
          : () => setState(() {
              if (selected) {
                _selectedHallIds.remove(hall.id);
              } else {
                _selectedHallIds.add(hall.id);
              }
            }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(.10) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: unavailable
                ? Colors.grey.shade300
                : selected
                ? color
                : const Color(0xFFD9E2EC),
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Checkbox(
              value: selected,
              onChanged: unavailable
                  ? null
                  : (_) => setState(() {
                      if (selected) {
                        _selectedHallIds.remove(hall.id);
                      } else {
                        _selectedHallIds.add(hall.id);
                      }
                    }),
              activeColor: color,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hall.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${hall.capacity} مقعداً • ${hall.type}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blueGrey.shade700,
                    ),
                  ),
                  if (unavailable) ...[
                    const SizedBox(height: 5),
                    const Text(
                      'غير متاحة في هذا الوقت',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFFB3261E),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllocationSummary({
    required ExamSeatAllocationState state,
    required Set<int> unavailableHallIds,
    required int selectedCapacity,
    required int difference,
  }) {
    final enough = selectedCapacity >= _requiredStudents;
    final selectedHalls = state.halls
        .where((hall) => _selectedHallIds.contains(hall.id))
        .toList();
    return Card(
      elevation: 0,
      color: const Color(0xFFFBFCFE),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'ملخص التخصيص',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 20),
            _metricRow('الطلاب المطلوبون', '$_requiredStudents'),
            _metricRow('السعة المختارة', '$selectedCapacity'),
            _metricRow(
              enough ? 'المقاعد المتبقية' : 'العجز في المقاعد',
              '${difference.abs()}',
              valueColor: enough
                  ? const Color(0xFF146C43)
                  : const Color(0xFFB3261E),
            ),
            const Divider(height: 30),
            Text(
              'القاعات المختارة',
              style: TextStyle(
                color: Colors.blueGrey.shade700,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            if (selectedHalls.isEmpty)
              Text(
                'لم يتم اختيار قاعات بعد.',
                style: TextStyle(color: Colors.blueGrey.shade600),
              )
            else
              Wrap(
                spacing: 7,
                runSpacing: 7,
                children: selectedHalls
                    .map(
                      (hall) =>
                          Chip(label: Text('${hall.name} (${hall.capacity})')),
                    )
                    .toList(),
              ),
            const SizedBox(height: 22),
            FilledButton.tonalIcon(
              onPressed: () {
                final suggested = context
                    .read<ExamSeatAllocationCubit>()
                    .suggestHallIds(
                      requiredCapacity: _requiredStudents,
                      unavailableHallIds: unavailableHallIds,
                    );
                if (suggested.isEmpty) {
                  _showMessage(
                    'لا توجد سعة متاحة كافية في القاعات المتوفرة.',
                    isError: true,
                  );
                  return;
                }
                setState(() {
                  _selectedHallIds
                    ..clear()
                    ..addAll(suggested);
                });
              },
              icon: const Icon(Icons.auto_awesome_outlined),
              label: const Text('اقتراح القاعات تلقائياً'),
            ),
            const SizedBox(height: 10),
            FilledButton.icon(
              onPressed: state.allocating || !enough
                  ? null
                  : () => _confirmAllocation(state),
              icon: state.allocating
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.playlist_add_check_circle_outlined),
              label: Text(
                state.allocating
                    ? 'جارٍ تنفيذ التوزيع...'
                    : 'تنفيذ التوزيع التلقائي',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _metricRow(String label, String value, {Color? valueColor}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 7),
    child: Row(
      children: [
        Expanded(
          child: Text(label, style: TextStyle(color: Colors.blueGrey.shade700)),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: valueColor,
          ),
        ),
      ],
    ),
  );

  Widget _buildResults(ExamSeatAllocationState state) {
    final sheet = state.seatingSheet;
    final filtered = sheet.seatings.where((seating) {
      final matchesName = seating.studentName.toLowerCase().contains(
        _studentSearch.toLowerCase(),
      );
      final matchesHall =
          _selectedResultHallId == null ||
          seating.hallId == _selectedResultHallId;
      return matchesName && matchesHall;
    }).toList()..sort((a, b) => a.seatNumber.compareTo(b.seatNumber));
    final halls = sheet.byHall.values
        .where((items) => items.isNotEmpty)
        .map((items) => items.first)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSummaryCards(
          seated: sheet.totalSeated,
          usedHalls: halls.length,
          capacity: halls.fold(0, (total, hall) => total + hall.hallCapacity),
        ),
        const SizedBox(height: 20),
        Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.fact_check_outlined,
                      color: Color(0xFF146C43),
                    ),
                    const SizedBox(width: 9),
                    const Expanded(
                      child: Text(
                        'نتائج توزيع الطلاب',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Text(
                      '${sheet.totalSeated} طالباً',
                      style: TextStyle(color: Colors.blueGrey.shade700),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    ChoiceChip(
                      label: const Text('كل القاعات'),
                      selected: _selectedResultHallId == null,
                      onSelected: (_) =>
                          setState(() => _selectedResultHallId = null),
                    ),
                    ...halls.map((hall) {
                      final count = sheet.byHall[hall.hallId]?.length ?? 0;
                      return ChoiceChip(
                        label: Text(
                          '${hall.hallName} ($count/${hall.hallCapacity})',
                        ),
                        selected: _selectedResultHallId == hall.hallId,
                        onSelected: (_) =>
                            setState(() => _selectedResultHallId = hall.hallId),
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _studentSearchController,
                  onChanged: (value) => setState(() => _studentSearch = value),
                  decoration: const InputDecoration(
                    labelText: 'بحث باسم الطالب',
                    prefixIcon: Icon(Icons.search_rounded),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                if (filtered.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(30),
                    child: Center(child: Text('لا توجد نتائج مطابقة.')),
                  )
                else
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: WidgetStatePropertyAll(
                        const Color(0xFFF0F5FA),
                      ),
                      columns: const [
                        DataColumn(label: Text('رقم المقعد'), numeric: true),
                        DataColumn(label: Text('اسم الطالب')),
                        DataColumn(label: Text('القاعة')),
                        DataColumn(label: Text('سعة القاعة'), numeric: true),
                      ],
                      rows: filtered
                          .map(
                            (seating) => DataRow(
                              cells: [
                                DataCell(Text('${seating.seatNumber}')),
                                DataCell(Text(seating.studentName)),
                                DataCell(Text(seating.hallName)),
                                DataCell(Text('${seating.hallCapacity}')),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
