import 'package:finalproject/core/theme/theme_extination.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/HospitalTrainingGroups/data/hospital_training_group_model.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/HospitalTrainingGroups/presentation/manger/hospital_training_groups_cubit.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/HospitalTrainingGroups/presentation/manger/hospital_training_groups_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HospitalTrainingGroupsList extends StatelessWidget {
  final HospitalTrainingGroupsState state;

  const HospitalTrainingGroupsList({super.key, required this.state});

  String _academicYearName(int id) {
    const names = {
      1: 'الأولى',
      2: 'الثانية',
      3: 'الثالثة',
      4: 'الرابعة',
      5: 'الخامسة',
    };
    return names[id] ?? 'غير محدد';
  }

  @override
  Widget build(BuildContext context) {
    final styles = context.styles;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'الغروبات الحالية',
                  style: styles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                onPressed: () =>
                    context.read<HospitalTrainingGroupsCubit>().loadGroups(),
                icon: const Icon(Icons.refresh_rounded),
                tooltip: 'تحديث',
              ),
            ],
          ),
          const SizedBox(height: 14),
          _filters(context),
          const SizedBox(height: 16),
          if (state.isLoading && state.groups.isNotEmpty)
            const LinearProgressIndicator(),
          if (state.groups.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 70),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.groups_outlined,
                      size: 54,
                      color: styles.textSecondaryColor,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'لا توجد مجموعات تدريب مطابقة',
                      style: TextStyle(color: styles.textSecondaryColor),
                    ),
                  ],
                ),
              ),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth >= 900 ? 2 : 1;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.groups.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: columns == 2 ? 1.8 : 2.5,
                  ),
                  itemBuilder: (context, index) {
                    return _GroupCard(
                      group: state.groups[index],
                      academicYearName: _academicYearName(
                        state.groups[index].academicYearId,
                      ),
                    );
                  },
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _filters(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        SizedBox(
          width: 260,
          child: DropdownButtonFormField<int>(
            initialValue: state.selectedHospitalFilter,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'تصفية حسب المشفى',
              border: OutlineInputBorder(),
            ),
            items: state.hospitals
                .map(
                  (hospital) => DropdownMenuItem(
                    value: hospital.id,
                    child: Text(hospital.name),
                  ),
                )
                .toList(),
            onChanged: (value) => context
                .read<HospitalTrainingGroupsCubit>()
                .loadGroups(hospitalId: value, clearEmployeeFilter: false),
          ),
        ),
        SizedBox(
          width: 260,
          child: DropdownButtonFormField<int>(
            initialValue: state.selectedEmployeeFilter,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'تصفية حسب المشرفة',
              border: OutlineInputBorder(),
            ),
            items: state.employees
                .where(
                  (employee) =>
                      employee.user.role == 'hospital_supervisor' ||
                      employee.jobTitle == 'hospital_supervisor',
                )
                .map(
                  (employee) => DropdownMenuItem(
                    value: employee.id,
                    child: Text(
                      '${employee.user.firstName} ${employee.user.lastName}',
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) => context
                .read<HospitalTrainingGroupsCubit>()
                .loadGroups(employeeId: value, clearHospitalFilter: false),
          ),
        ),
        OutlinedButton.icon(
          onPressed: () => context
              .read<HospitalTrainingGroupsCubit>()
              .loadGroups(clearHospitalFilter: true, clearEmployeeFilter: true),
          icon: const Icon(Icons.filter_alt_off_outlined),
          label: const Text('إزالة الفلاتر'),
        ),
      ],
    );
  }
}

class _GroupCard extends StatelessWidget {
  final HospitalTrainingGroupModel group;
  final String academicYearName;

  const _GroupCard({required this.group, required this.academicYearName});

  @override
  Widget build(BuildContext context) {
    final styles = context.styles;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: styles.primaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.groups_rounded, color: styles.primaryColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  group.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const Spacer(),
          _info(
            Icons.local_hospital_outlined,
            group.hospital?.name ?? 'مشفى #${group.hospitalId}',
          ),
          _info(
            Icons.badge_outlined,
            group.employee?.fullName ??
                'موظف #${group.employeename} ${group.employeenamelast}',
          ),
          _info(Icons.school_outlined, 'السنة $academicYearName'),
          _info(
            Icons.person_outline_rounded,
            '${group.countstundents} طالبة ضمن المجموعة',
          ),
        ],
      ),
    );
  }

  Widget _info(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
