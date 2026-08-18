import 'package:data_table_2/data_table_2.dart';
import 'package:finalproject/core/di/service_locator.dart';
import 'package:finalproject/core/widgets/empty_view_list.dart';
import 'package:finalproject/core/widgets/error_widget_view.dart';
import 'package:finalproject/core/widgets/pagination_footer.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/attendance_monitoring/gate_attendance/data/model/gate_log_model.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/attendance_monitoring/gate_attendance/presentation/manger/gate_attendance_cubit.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/attendance_monitoring/gate_attendance/presentation/manger/gate_attendance_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GateAttendanceTab extends StatefulWidget {
  const GateAttendanceTab({super.key});

  @override
  State<GateAttendanceTab> createState() => _GateAttendanceTabState();
}

class _GateAttendanceTabState extends State<GateAttendanceTab>
    with AutomaticKeepAliveClientMixin {
  final _studentNameCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  String? _selectedDirection;

  late final GateAttendanceCubit _cubit;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _cubit = sl<GateAttendanceCubit>();
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
      child: BlocBuilder<GateAttendanceCubit, GateAttendanceState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildFilters(context),
              const SizedBox(height: 16),
              if (state is GateAttendanceLoaded) ...[
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
          Expanded(
            child: DropdownButtonFormField<String?>(
              value: _selectedDirection,
              decoration: _inputDec(
                label: 'الاتجاه',
                icon: Icons.swap_horiz_outlined,
              ),
              items: const [
                DropdownMenuItem(value: null, child: Text('الكل')),
                DropdownMenuItem(value: 'In', child: Text('دخول')),
                DropdownMenuItem(value: 'Out', child: Text('خروج')),
              ],
              onChanged: (val) => setState(() => _selectedDirection = val),
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

  Widget _buildStats(GateAttendanceLoaded state) {
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
          label: 'دخول',
          value: state.inCount,
          color: const Color(0xFF50CD89),
          icon: Icons.login_outlined,
        ),
        const SizedBox(width: 12),
        _StatChip(
          label: 'خروج',
          value: state.outCount,
          color: const Color(0xFFFF9800),
          icon: Icons.logout_outlined,
        ),
        const SizedBox(width: 12),
        _StatChip(
          label: 'متأخرة',
          value: state.lateCount,
          color: const Color(0xFFF1416C),
          icon: Icons.timer_off_outlined,
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, GateAttendanceState state) {
    if (state is GateAttendanceLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is GateAttendanceError) {
      return ShowErrorWidgetView(
        errorMessage: state.message,
        onRetry: () => context.read<GateAttendanceCubit>().load(),
      );
    }

    if (state is GateAttendanceLoaded) {
      if (state.logs.isEmpty) {
        return const EmptyListViews(
          text: 'لا توجد سجلات بوابة حالياً',
          iconData: Icons.sensor_door_outlined,
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (state.isRefreshing) const LinearProgressIndicator(minHeight: 2),
          _buildTable(state.logs),
          const SizedBox(height: 16),
          PaginationFooter(
            meta: state.meta,
            onFirstPage: () => context.read<GateAttendanceCubit>().goToPage(1),
            onPreviousPage: () =>
                context.read<GateAttendanceCubit>().previousPage(),
            onNextPage: () => context.read<GateAttendanceCubit>().nextPage(),
            onLastPage: () => context.read<GateAttendanceCubit>().goToPage(
              state.meta.lastPage,
            ),
          ),
        ],
      );
    }

    return const SizedBox();
  }

  Widget _buildTable(List<GateLogModel> logs) {
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
                      'الوقت',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'الاتجاه',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'الطريقة',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'متأخرة',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
        rows: logs.map((log) {
          return DataRow(
            cells: [
              DataCell(Text('${log.id}')),
              DataCell(Text(log.student.fullName)),
              DataCell(Text(log.timestamp)),
              DataCell(_DirectionBadge(direction: log.direction)),
              DataCell(Text(log.method)),
              DataCell(
                log.isLate
                    ? const Icon(
                        Icons.timer_off_outlined,
                        color: Color(0xFFF1416C),
                        size: 20,
                      )
                    : const Icon(
                        Icons.check_circle_outline,
                        color: Color(0xFF50CD89),
                        size: 20,
                      ),
              ),
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
    context.read<GateAttendanceCubit>().applyFilters(
      direction: _selectedDirection,
      studentName: _studentNameCtrl.text,
      date: _dateCtrl.text,
    );
  }

  void _clearFilters(BuildContext context) {
    _studentNameCtrl.clear();
    _dateCtrl.clear();
    setState(() => _selectedDirection = null);
    context.read<GateAttendanceCubit>().clearFilters();
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

class _DirectionBadge extends StatelessWidget {
  final String direction;
  const _DirectionBadge({required this.direction});

  @override
  Widget build(BuildContext context) {
    final isIn = direction == 'In';
    final color = isIn ? const Color(0xFF50CD89) : const Color(0xFFFF9800);
    final label = isIn ? 'دخول' : 'خروج';
    final icon = isIn ? Icons.login_outlined : Icons.logout_outlined;

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
