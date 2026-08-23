import 'package:finalproject/feature/warehouse_officer/clearance/data/model/clearance_student_model.dart';
import 'package:finalproject/feature/warehouse_officer/clearance/presentation/manger/warehouse_clearance_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

class WarehouseClearanceTable extends StatelessWidget {
  final List<ClearanceStudentModel> students;

  const WarehouseClearanceTable({super.key, required this.students});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE);

    if (students.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(48.0),
          child: Column(
            children: [
              Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              Text(
                'لا يوجد طلاب مطابقين للبحث',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    if (isMobile) {
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: students.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final student = students[index];
          return _MobileStudentCard(student: student);
        },
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(minWidth: constraints.maxWidth),
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: DataTable(
                  horizontalMargin: 24,
                  columnSpacing: 32,
                  headingRowHeight: 56,
                  dataRowMaxHeight: 64,
                  dataRowMinHeight: 64,
                  headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
                  columns: const [
                    DataColumn(
                        label: Text('الرقم الجامعي',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('اسم الطالب',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('السنة الدراسية',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('براءة الذمة',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: students.map((student) {
                    return DataRow(
                      cells: [
                        DataCell(Text(student.nationalNumber,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF334155)))),
                        DataCell(Text(student.fullName,
                            style: const TextStyle(fontWeight: FontWeight.bold))),
                        DataCell(Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            student.academicYear,
                            style: const TextStyle(
                              color: Color(0xFF2563EB),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )),
                        DataCell(
                          _ClearanceToggle(student: student),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}

class _ClearanceToggle extends StatelessWidget {
  final ClearanceStudentModel student;

  const _ClearanceToggle({required this.student});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Switch(
          value: student.clearanceStatus,
          activeThumbColor: const Color(0xFF10B981),
          onChanged: (val) {
            context
                .read<WarehouseClearanceCubit>()
                .toggleClearance(student.id, val);
          },
        ),
        const SizedBox(width: 8),
        Text(
          student.clearanceStatus ? 'بريء ذمة' : 'غير بريء',
          style: TextStyle(
            color: student.clearanceStatus
                ? const Color(0xFF10B981)
                : const Color(0xFFEF4444),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _MobileStudentCard extends StatelessWidget {
  final ClearanceStudentModel student;

  const _MobileStudentCard({required this.student});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    student.fullName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    student.academicYear,
                    style: const TextStyle(
                      color: Color(0xFF2563EB),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'الرقم الجامعي: ${student.nationalNumber}',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'حالة براءة الذمة:',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                _ClearanceToggle(student: student),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
