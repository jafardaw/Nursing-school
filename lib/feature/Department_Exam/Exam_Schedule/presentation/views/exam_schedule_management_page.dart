import 'exam_seat_allocation_page.dart';
import 'package:finalproject/core/di/service_locator.dart';
import 'package:finalproject/feature/Department_Exam/Exam_Schedule/data/model/exam_schedule_model.dart';
import 'package:finalproject/feature/Department_Exam/Exam_Schedule/presentation/manger/management/exam_schedule_management_cubit.dart';
import 'package:finalproject/feature/Department_Exam/Exam_Schedule/presentation/manger/management/exam_schedule_management_state.dart';
import 'package:finalproject/feature/Department_Exam/Exam_Session/data/exam_session_model.dart';
import 'package:finalproject/feature/Department_Exam/Exam_Session/presentation/manger/exam_session_cubit.dart';
import 'package:finalproject/feature/Department_Exam/Exam_Session/presentation/manger/exam_session_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'widget/exam_time_picker_field.dart';

class ExamScheduleManagementPage extends StatelessWidget {
  const ExamScheduleManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<ExamSessionCubit>()..fetchSessions()),
        BlocProvider(create: (_) => sl<ExamScheduleManagementCubit>()),
      ],
      child: const _ExamScheduleManagementView(),
    );
  }
}

class _ExamScheduleManagementView extends StatefulWidget {
  const _ExamScheduleManagementView();

  @override
  State<_ExamScheduleManagementView> createState() =>
      _ExamScheduleManagementViewState();
}

class _ExamScheduleManagementViewState
    extends State<_ExamScheduleManagementView> {
  final TextEditingController _searchController = TextEditingController();
  final Set<int> _selectedIds = <int>{};
  final Map<int, ExamScheduleModel> _drafts = <int, ExamScheduleModel>{};
  ExamSessionModel? _selectedSession;
  bool _editing = false;
  String _search = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _selectSession(ExamSessionModel? session) {
    if (session == null) return;
    setState(() {
      _selectedSession = session;
      _selectedIds.clear();
      _drafts.clear();
      _editing = false;
    });
    context.read<ExamScheduleManagementCubit>().loadSchedule(session.id);
  }

  ExamScheduleModel _current(ExamScheduleModel schedule) {
    return _drafts[schedule.id] ?? schedule;
  }

  void _updateDraft(ExamScheduleModel schedule) {
    if (schedule.id == null) return;
    setState(() => _drafts[schedule.id!] = schedule);
  }

  String _dateLabel(String value) {
    final parts = value.split('-');
    if (parts.length != 3) return value;
    return '${parts[2]}/${parts[1]}/${parts[0]}';
  }

  String _timeLabel(String value) =>
      value.length >= 5 ? value.substring(0, 5) : value;

  TimeOfDay _asTime(String value) {
    final parts = value.split(':');
    return TimeOfDay(
      hour: int.tryParse(parts.isNotEmpty ? parts[0] : '') ?? 8,
      minute: int.tryParse(parts.length > 1 ? parts[1] : '') ?? 0,
    );
  }

  Future<void> _changeDate(ExamScheduleModel source) async {
    final current = _current(source);
    final date = DateTime.tryParse(current.examDate) ?? DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (selected == null || !mounted) return;
    _updateDraft(
      current.copyWith(
        examDate:
            '${selected.year}-${selected.month.toString().padLeft(2, '0')}-${selected.day.toString().padLeft(2, '0')}',
      ),
    );
  }

  Future<void> _changeTime(
    ExamScheduleModel source, {
    required bool start,
  }) async {
    final current = _current(source);
    final selected = await showExamTimePicker(
      context,
      initialTime: parseExamTime(start ? current.startTime : current.endTime),
    );
    if (selected == null || !mounted) return;
    _updateDraft(
      start
          ? current.copyWith(startTime: formatExamTime(selected))
          : current.copyWith(endTime: formatExamTime(selected)),
    );
  }

  int _minutes(String value) {
    final time = _asTime(value);
    return time.hour * 60 + time.minute;
  }

  int _minutesFromTime(String value) {
    final parts = value.split(':');
    final hour = int.tryParse(parts.isNotEmpty ? parts.first : '') ?? -1;
    final minute = int.tryParse(parts.length > 1 ? parts[1] : '') ?? -1;
    return hour < 0 || minute < 0 ? -1 : (hour * 60) + minute;
  }

  String _extractSpecialization(String subjectName) {
    final match = RegExp(r'\(([^)]+)\)').firstMatch(subjectName);
    return match?.group(1)?.trim().toLowerCase() ?? '';
  }

  String _specializationLabel(String value) {
    return value.isEmpty ? 'العام' : value;
  }

  String? _validateScheduleRules(List<ExamScheduleModel> schedules) {
    for (var i = 0; i < schedules.length; i++) {
      final current = schedules[i];
      final currentStart = _minutesFromTime(current.startTime);
      final currentEnd = _minutesFromTime(current.endTime);
      if (current.examDate.isEmpty ||
          currentStart < 0 ||
          currentEnd <= currentStart) {
        return 'تحقق من تاريخ ووقت بداية ونهاية كل مادة قبل الحفظ.';
      }

      for (var j = i + 1; j < schedules.length; j++) {
        final other = schedules[j];
        if (current.examDate != other.examDate) continue;

        final sameAcademicYear =
            current.academicYear.trim().isNotEmpty &&
            current.academicYear.trim() == other.academicYear.trim();
        final currentSpecialization = current.specialization
            .trim()
            .toLowerCase();
        final otherSpecialization = other.specialization.trim().toLowerCase();
        final sameSpecialization = currentSpecialization == otherSpecialization;

        if (sameAcademicYear && sameSpecialization) {
          final specializationLabel = current.specialization.trim().isEmpty
              ? 'العام'
              : current.specialization.trim();
          return 'لا يمكن جدولة مادتين من السنة ${current.academicYear} والاختصاص $specializationLabel في اليوم نفسه (${_dateLabel(current.examDate)}).';
        }

        final otherStart = _minutesFromTime(other.startTime);
        final otherEnd = _minutesFromTime(other.endTime);
        if (otherStart < 0 || otherEnd <= otherStart) {
          return 'تحقق من تاريخ ووقت بداية ونهاية كل مادة قبل الحفظ.';
        }

        final timeOverlaps = currentStart < otherEnd && otherStart < currentEnd;
        if (timeOverlaps) {
          return 'يوجد تعارض زمني بين «${current.subjectName}» و«${other.subjectName}» في ${_dateLabel(current.examDate)}.';
        }
      }
    }
    return null;
  }

  Future<void> _saveUpdates() async {
    final schedules = _schedulesFromState(
      context.read<ExamScheduleManagementCubit>().state,
    );
    final effectiveSchedules = schedules.map(_current).toList();
    final validationMessage = _validateScheduleRules(effectiveSchedules);
    if (validationMessage != null) {
      _showMessage(validationMessage, isError: true);
      return;
    }

    final updates = _drafts.entries
        .where((entry) => _selectedIds.contains(entry.key))
        .map((entry) => entry.value)
        .toList();

    if (updates.isEmpty) {
      _showMessage('لم تُجرَ تعديلات على المواد المحددة.', isError: true);
      return;
    }
    if (updates.any(
      (schedule) => _minutes(schedule.endTime) <= _minutes(schedule.startTime),
    )) {
      _showMessage('يجب أن يكون وقت النهاية بعد وقت البداية.', isError: true);
      return;
    }

    final saved = await context.read<ExamScheduleManagementCubit>().saveUpdates(
      updates,
    );
    if (!mounted) return;
    if (saved) {
      setState(() {
        _drafts.clear();
        _selectedIds.clear();
        _editing = false;
      });
      _showMessage('تم حفظ تعديلات ${updates.length} مادة بنجاح.');
    } else {
      _showMessage('تعذر حفظ التعديلات. حاول مرة أخرى.', isError: true);
    }
  }

  Future<void> _deleteSchedule(List<ExamScheduleModel> schedules) async {
    final session = _selectedSession;
    if (session == null || schedules.isEmpty) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(
          Icons.warning_amber_rounded,
          color: Color(0xFFB42318),
          size: 36,
        ),
        title: const Text('حذف البرنامج الامتحاني بالكامل'),
        content: Text(
          'سيتم حذف ${schedules.length} مادة من برنامج دورة «${session.name}» نهائياً. لا يمكن التراجع عن هذه العملية.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('إلغاء'),
          ),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFB42318),
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            icon: const Icon(Icons.delete_forever_outlined),
            label: const Text('حذف البرنامج'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;
    final deleted = await context
        .read<ExamScheduleManagementCubit>()
        .deleteCurrentSchedule();
    if (!mounted) return;
    if (deleted) {
      setState(() {
        _drafts.clear();
        _selectedIds.clear();
        _editing = false;
      });
      _showMessage('تم حذف برنامج الدورة بالكامل.');
    } else {
      _showMessage('تعذر حذف برنامج الدورة. حاول مرة أخرى.', isError: true);
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: isError
              ? const Color(0xFFB42318)
              : const Color(0xFF067647),
          content: Text(message),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      body: SafeArea(
        child: BlocBuilder<ExamSessionCubit, ExamSessionState>(
          builder: (context, sessionState) {
            final sessions = sessionState is ExamSessionLoaded
                ? sessionState.sessions
                : context.read<ExamSessionCubit>().sessions;

            if (_selectedSession == null && sessions.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted &&
                    _selectedSession == null &&
                    sessions.isNotEmpty) {
                  _selectSession(sessions.first);
                }
              });
            }

            return BlocBuilder<
              ExamScheduleManagementCubit,
              ExamScheduleManagementState
            >(
              builder: (context, state) {
                final schedules = _schedulesFromState(state);
                final busy =
                    state is ExamScheduleManagementSaving ||
                    state is ExamScheduleManagementDeleting;
                final filtered = schedules.where(_matchesSearch).toList();

                return Directionality(
                  textDirection: TextDirection.rtl,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildHero(schedules),
                        const SizedBox(height: 20),
                        _buildSessionBar(sessions, sessionState, busy),
                        const SizedBox(height: 20),
                        if (_selectedSession != null) ...[
                          _buildSummary(schedules),
                          const SizedBox(height: 20),
                          _buildToolbar(schedules, busy),
                          const SizedBox(height: 14),
                        ],
                        _buildContent(state, filtered, busy),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  List<ExamScheduleModel> _schedulesFromState(
    ExamScheduleManagementState state,
  ) {
    if (state is ExamScheduleManagementLoaded) return state.schedules;
    if (state is ExamScheduleManagementSaving) return state.schedules;
    if (state is ExamScheduleManagementDeleting) return state.schedules;
    if (state is ExamScheduleManagementError) return state.schedules;
    return const [];
  }

  bool _matchesSearch(ExamScheduleModel schedule) {
    final value = _search.trim().toLowerCase();
    if (value.isEmpty) return true;
    return schedule.subjectName.toLowerCase().contains(value) ||
        schedule.academicYear.toLowerCase().contains(value) ||
        schedule.examDate.contains(value);
  }

  Widget _buildHero(List<ExamScheduleModel> schedules) {
    final session = _selectedSession;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF12355B), Color(0xFF1F5F8B)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.calendar_month_outlined,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'إدارة البرنامج الامتحاني',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  session == null
                      ? 'اختر دورة امتحانية لعرض برنامجها وإدارته.'
                      : '${session.name} • ${session.academicYear} • ${schedules.length} مادة',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.84),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          if (session != null)
            _HeroBadge(
              label:
                  '${schedules.fold<int>(0, (sum, item) => sum + item.eligibleStudentsCount)} طالب مؤهل',
            ),
        ],
      ),
    );
  }

  Widget _buildSessionBar(
    List<ExamSessionModel> sessions,
    ExamSessionState sessionState,
    bool busy,
  ) {
    final loading = sessionState is ExamSessionLoading;
    return Card(
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            const Icon(Icons.account_tree_outlined, color: Color(0xFF1F5F8B)),
            const SizedBox(width: 12),
            const Text(
              'الدورة الامتحانية',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: DropdownButtonFormField<ExamSessionModel>(
                value: _selectedSession,
                isExpanded: true,
                decoration: const InputDecoration(
                  hintText: 'اختر دورة لعرض برنامجها',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                ),
                items: sessions
                    .map(
                      (session) => DropdownMenuItem(
                        value: session,
                        child: Text(
                          '${session.name} — ${session.academicYear}',
                        ),
                      ),
                    )
                    .toList(),
                onChanged: loading || busy ? null : _selectSession,
              ),
            ),
            if (loading) ...[
              const SizedBox(width: 14),
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSummary(List<ExamScheduleModel> schedules) {
    final dates = schedules.map((item) => item.examDate).toSet().length;
    final students = schedules.fold<int>(
      0,
      (sum, item) => sum + item.eligibleStudentsCount,
    );
    return Row(
      children: [
        Expanded(
          child: _MetricCard(
            icon: Icons.menu_book_outlined,
            value: '${schedules.length}',
            label: 'المواد المجدولة',
            color: const Color(0xFF1F5F8B),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _MetricCard(
            icon: Icons.groups_2_outlined,
            value: '$students',
            label: 'الطلاب المؤهلون',
            color: const Color(0xFF8D4C00),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _MetricCard(
            icon: Icons.event_available_outlined,
            value: '$dates',
            label: 'أيام الامتحان',
            color: const Color(0xFF067647),
          ),
        ),
      ],
    );
  }

  Widget _buildToolbar(List<ExamScheduleModel> schedules, bool busy) {
    final hasSelection = _selectedIds.isNotEmpty;
    return Card(
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            SizedBox(
              width: 300,
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _search = value),
                decoration: InputDecoration(
                  hintText: 'ابحث عن مادة أو سنة دراسية أو تاريخ',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _search.isEmpty
                      ? null
                      : IconButton(
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _search = '');
                          },
                          icon: const Icon(Icons.close),
                        ),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const Spacer(),
            if (_editing) ...[
              OutlinedButton(
                onPressed: busy
                    ? null
                    : () => setState(() {
                        _editing = false;
                        _drafts.clear();
                      }),
                child: const Text('إلغاء التعديل'),
              ),
              const SizedBox(width: 10),
              FilledButton.icon(
                onPressed: busy ? null : _saveUpdates,
                icon: const Icon(Icons.save_outlined),
                label: Text('حفظ تعديلات ${_selectedIds.length} مادة'),
              ),
            ] else ...[
              FilledButton.tonalIcon(
                onPressed: hasSelection && !busy
                    ? () => setState(() => _editing = true)
                    : null,
                icon: const Icon(Icons.edit_calendar_outlined),
                label: Text(
                  hasSelection
                      ? 'تعديل المحدد (${_selectedIds.length})'
                      : 'حدد مواداً للتعديل',
                ),
              ),
              const SizedBox(width: 10),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFB42318),
                ),
                onPressed: schedules.isEmpty || busy
                    ? null
                    : () => _deleteSchedule(schedules),
                icon: const Icon(Icons.delete_sweep_outlined),
                label: const Text('حذف برنامج الدورة'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
    ExamScheduleManagementState state,
    List<ExamScheduleModel> schedules,
    bool busy,
  ) {
    if (_selectedSession == null) {
      return const _EmptyPanel(
        icon: Icons.touch_app_outlined,
        title: 'اختر دورة امتحانية',
        subtitle: 'ستظهر مواد برنامج الدورة وتفاصيل الطلاب المؤهلين هنا.',
      );
    }
    if (state is ExamScheduleManagementLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is ExamScheduleManagementError && schedules.isEmpty) {
      return _EmptyPanel(
        icon: Icons.error_outline,
        title: 'تعذر تحميل البرنامج',
        subtitle: state.message,
        isError: true,
      );
    }
    if (schedules.isEmpty) {
      return const _EmptyPanel(
        icon: Icons.event_busy_outlined,
        title: 'لا يوجد برنامج امتحاني لهذه الدورة',
        subtitle: 'يمكنك إنشاء برنامج جديد من صفحة إضافة البرنامج الامتحاني.',
      );
    }

    return Card(
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Stack(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 16,
              horizontalMargin: 16,
              headingRowHeight: 52,
              dataRowHeight: 72,
              headingRowColor: WidgetStateProperty.all(const Color(0xFFF0F5FA)),
              columns: [
                DataColumn(
                  label: Checkbox(
                    value:
                        schedules.isNotEmpty &&
                        _selectedIds.length == schedules.length,
                    tristate: true,
                    onChanged: busy
                        ? null
                        : (selected) => setState(() {
                            _selectedIds
                              ..clear()
                              ..addAll(
                                selected == true
                                    ? schedules
                                          .map((item) => item.id)
                                          .whereType<int>()
                                    : const <int>[],
                              );
                          }),
                  ),
                ),
                const DataColumn(label: Text('المادة')),
                const DataColumn(
                  label: Tooltip(message: 'السنة الدراسية', child: Text('السنة')),
                ),
                const DataColumn(label: Text('التاريخ')),
                const DataColumn(label: Text('البداية')),
                const DataColumn(label: Text('النهاية')),
                const DataColumn(label: Text('الطلاب المؤهلون'), numeric: true),
                const DataColumn(label: Text('المقاعد')),
                const DataColumn(label: Text('القاعات')),
                const DataColumn(label: Text('الحالة')),
              ],
              rows: schedules.map(_buildRow).toList(),
            ),
          ),
          if (busy)
            Positioned.fill(
              child: ColoredBox(
                color: Colors.white70,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 10),
                      Text(
                        state is ExamScheduleManagementDeleting
                            ? 'جارٍ حذف البرنامج...'
                            : 'جارٍ حفظ التعديلات...',
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  DataRow _buildRow(ExamScheduleModel source) {
    final schedule = _current(source);
    final id = source.id;
    final selected = id != null && _selectedIds.contains(id);
    final editable = _editing && selected;

    Widget allocationCell() {
      return IconButton.filledTonal(
        tooltip: 'تخصيص القاعات والمقاعد',
        onPressed: id == null
            ? null
            : () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ExamSeatAllocationPage(
                      schedule: source,
                      sessionSchedules: _schedulesFromState(
                        context.read<ExamScheduleManagementCubit>().state,
                      ),
                    ),
                  ),
                );
                if (mounted && _selectedSession != null) {
                  context.read<ExamScheduleManagementCubit>().loadSchedule(
                    _selectedSession!.id,
                  );
                }
              },
        icon: const Icon(Icons.event_seat_outlined, size: 19),
      );
    }

    Widget timeCell(String label, VoidCallback onTap) {
      return editable
          ? TextButton.icon(
              onPressed: onTap,
              icon: const Icon(Icons.schedule, size: 17),
              label: Text(label),
            )
          : Text(label);
    }

    return DataRow(
      selected: selected,
      cells: [
        DataCell(
          Checkbox(
            value: selected,
            onChanged: id == null
                ? null
                : (value) => setState(() {
                    if (value == true) {
                      _selectedIds.add(id);
                    } else {
                      _selectedIds.remove(id);
                    }
                  }),
          ),
        ),
        DataCell(
          SizedBox(
            width: 200,
            child: Text(
              schedule.specialization.isEmpty
                  ? schedule.subjectName
                  : '${schedule.subjectName} — ${schedule.specialization}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ),
        DataCell(
          Text(schedule.academicYear.isEmpty ? '—' : schedule.academicYear),
        ),
        DataCell(
          editable
              ? TextButton.icon(
                  onPressed: () => _changeDate(source),
                  icon: const Icon(Icons.edit_calendar_outlined, size: 17),
                  label: Text(_dateLabel(schedule.examDate)),
                )
              : Text(_dateLabel(schedule.examDate)),
        ),
        DataCell(
          timeCell(
            _timeLabel(schedule.startTime),
            () => _changeTime(source, start: true),
          ),
        ),
        DataCell(
          timeCell(
            _timeLabel(schedule.endTime),
            () => _changeTime(source, start: false),
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF4E5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${schedule.eligibleStudentsCount}',
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: Color(0xFF8D4C00),
              ),
            ),
          ),
        ),
        DataCell(allocationCell()),
        DataCell(
          SizedBox(
            width: 130,
            child: Text(
              schedule.halls.isEmpty ? 'غير محددة' : schedule.halls.join('، '),
            ),
          ),
        ),
        DataCell(_StatusChip(status: schedule.status)),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF667085),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroBadge extends StatelessWidget {
  const _HeroBadge({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final normalized = status.toLowerCase();
    final isPending = normalized == 'pending';
    final color = isPending ? const Color(0xFF8D4C00) : const Color(0xFF067647);
    final label = isPending ? 'بانتظار التنفيذ' : status;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _EmptyPanel extends StatelessWidget {
  const _EmptyPanel({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isError = false,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final color = isError ? const Color(0xFFB42318) : const Color(0xFF1F5F8B);
    return Card(
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(46),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 44, color: color),
              const SizedBox(height: 14),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF667085)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
