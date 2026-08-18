import 'package:data_table_2/data_table_2.dart';
import 'package:finalproject/core/di/service_locator.dart';
import 'package:finalproject/core/widgets/empty_view_list.dart';
import 'package:finalproject/core/widgets/error_widget_view.dart';
import 'package:finalproject/core/widgets/pagination_footer.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/attendance_monitoring/dormitory_attendance/data/model/dormitory_night_check_model.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/attendance_monitoring/dormitory_attendance/presentation/manger/dormitory_attendance_cubit.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/attendance_monitoring/dormitory_attendance/presentation/manger/dormitory_attendance_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DormitoryAttendanceTab extends StatefulWidget {
  const DormitoryAttendanceTab({super.key});

  @override
  State<DormitoryAttendanceTab> createState() => _DormitoryAttendanceTabState();
}

class _DormitoryAttendanceTabState extends State<DormitoryAttendanceTab>
    with AutomaticKeepAliveClientMixin {
  final _studentNameCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();

  late final DormitoryAttendanceCubit _cubit;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _cubit = sl<DormitoryAttendanceCubit>();
    _cubit.load();
  }

  @override
  void dispose() {
    _studentNameCtrl.dispose();
    _dateCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<DormitoryAttendanceCubit, DormitoryAttendanceState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildFilters(context),
              const SizedBox(height: 16),
              if (state is DormitoryAttendanceLoaded) ...[
                _buildStats(state),
                const SizedBox(height: 16),
              ],
              _buildBody(context, state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilters(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _studentNameCtrl,
              decoration: _inputDec(
                label: 'اسم الطالبة',
                icon: Icons.person_search_outlined,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _dateCtrl,
              readOnly: true,
              onTap: () => _pickDate(context),
              decoration: _inputDec(
                label: 'التاريخ',
                icon: Icons.calendar_today_outlined,
                suffix: _dateCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () => setState(() => _dateCtrl.clear()),
                      )
                    : null,
              ),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: () => _applyFilters(context),
            icon: const Icon(Icons.search_outlined, size: 18),
            label: const Text('بحث'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0D47A1),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
          const SizedBox(width: 8),
          TextButton.icon(
            onPressed: () => _clearFilters(context),
            icon: const Icon(Icons.clear_all_outlined, size: 18),
            label: const Text('مسح'),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(DormitoryAttendanceLoaded state) {
    return Row(
      children: [
        _StatChip(
          label: 'إجمالي',
          value: state.meta.total,
          color: const Color(0xFF0D47A1),
          icon: Icons.list_alt_outlined,
        ),
        const SizedBox(width: 12),
        _StatChip(
          label: 'حاضر',
          value: state.presentCount,
          color: const Color(0xFF50CD89),
          icon: Icons.check_circle_outline,
        ),
        const SizedBox(width: 12),
        _StatChip(
          label: 'غائب',
          value: state.absentCount,
          color: const Color(0xFFF1416C),
          icon: Icons.cancel_outlined,
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, DormitoryAttendanceState state) {
    if (state is DormitoryAttendanceLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is DormitoryAttendanceError) {
      return ShowErrorWidgetView(
        errorMessage: state.message,
        onRetry: () => context.read<DormitoryAttendanceCubit>().load(),
      );
    }

    if (state is DormitoryAttendanceLoaded) {
      if (state.records.isEmpty) {
        return const EmptyListViews(
          text: 'لا توجد سجلات تفقد سكن حالياً',
          iconData: Icons.hotel_outlined,
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (state.isRefreshing) const LinearProgressIndicator(minHeight: 2),
          _buildTable(state.records),
          const SizedBox(height: 16),
          PaginationFooter(
            meta: state.meta,
            onFirstPage: () =>
                context.read<DormitoryAttendanceCubit>().goToPage(1),
            onPreviousPage: () =>
                context.read<DormitoryAttendanceCubit>().previousPage(),
            onNextPage: () =>
                context.read<DormitoryAttendanceCubit>().nextPage(),
            onLastPage: () => context.read<DormitoryAttendanceCubit>().goToPage(
              state.meta.lastPage,
            ),
          ),
        ],
      );
    }

    return const SizedBox();
  }

  Widget _buildTable(List<DormitoryNightCheckModel> records) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(const Color(0xFFF3F6F9)),
                columnSpacing: 24,
                columns: const [
                  DataColumn(
                    label: Text('#', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  DataColumn(
                    label: Text(
                      'الطالبة',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'الرقم الوطني',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'الغرفة',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'المبنى',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'التاريخ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'الحالة',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'ملاحظة',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
            rows: records.map((record) {
              return DataRow(
                cells: [
                  DataCell(Text('${record.id}')),
                  DataCell(Text(record.student.fullName)),
                  DataCell(Text(record.student.nationalNumber)),
                  DataCell(Text(record.student.room?.roomNumber ?? '-')),
                  DataCell(Text(record.student.room?.buildingName ?? '-')),
                  DataCell(Text(record.date)),
                  DataCell(_StatusBadge(status: record.status)),
                  DataCell(Text(record.note ?? '-')),
                ],
              );
            }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _dateCtrl.text =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  void _applyFilters(BuildContext context) {
    context.read<DormitoryAttendanceCubit>().applyFilters(
      studentName: _studentNameCtrl.text,
      date: _dateCtrl.text,
    );
  }

  void _clearFilters(BuildContext context) {
    _studentNameCtrl.clear();
    _dateCtrl.clear();
    context.read<DormitoryAttendanceCubit>().clearFilters();
  }

  InputDecoration _inputDec({
    required String label,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 20),
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color(0xFFF9FAFB),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFEFF2F5)),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  final IconData icon;

  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 6),
          Text(
            '$value',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final isPresent = status == 'Present';
    final color = isPresent ? const Color(0xFF50CD89) : const Color(0xFFF1416C);
    final label = isPresent ? 'حاضر' : 'غائب';
    final icon = isPresent ? Icons.check_circle_outline : Icons.cancel_outlined;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
