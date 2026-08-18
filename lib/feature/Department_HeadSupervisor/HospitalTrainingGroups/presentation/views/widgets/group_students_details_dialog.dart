import 'package:finalproject/feature/Department_HeadSupervisor/HospitalTrainingGroups/data/hospital_training_group_model.dart';
import 'package:flutter/material.dart';

class GroupStudentsDetailsDialog extends StatelessWidget {
  final HospitalTrainingGroupModel group;

  const GroupStudentsDetailsDialog({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 500,
          constraints: const BoxConstraints(maxHeight: 600),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'طالبات مجموعة: ${group.name}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 8),
              if (group.students.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Text(
                      'لا توجد طالبات في هذه المجموعة.',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                )
              else
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: group.students.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final student = group.students[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFFE8EAF6),
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(color: Color(0xFF3F51B5)),
                          ),
                        ),
                        title: Text(
                          [
                            student.user?.firstName ?? '',
                            student.fatherName,
                            student.user?.lastName ?? '',
                          ].where((s) => s.trim().isNotEmpty).join(' '),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('السنة: ${student.academicYearId}'),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
