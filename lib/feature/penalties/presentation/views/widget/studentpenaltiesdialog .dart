import 'package:finalproject/feature/penalties/data/penalties_model.dart';
import 'package:flutter/material.dart';

class StudentPenaltiesDialog extends StatelessWidget {
  final StudentPenaltiesModel studentData;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const StudentPenaltiesDialog({
    super.key,
    required this.studentData,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Column(
        children: [
          Text("سجل غيابات: ${studentData.student.fullName}"),
          const Divider(),
        ],
      ),
      content: SizedBox(
        width: 500,
        child: studentData.penalties.isEmpty
            ? const Center(child: Text("لا توجد سجلات حالياً"))
            : ListView.separated(
                shrinkWrap: true,
                itemCount: studentData.penalties.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final penalty = studentData.penalties[index];
                  return _buildPenaltyItem(context, penalty);
                },
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("إغلاق"),
        ),
      ],
    );
  }

  Widget _buildPenaltyItem(BuildContext context, PenaltyModel penalty) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          _buildStatusBadge(penalty.type),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(penalty.body, style: const TextStyle(fontSize: 13)),
                const SizedBox(height: 4),
                Text(
                  penalty.date,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          // أزرار التعديل والحذف موجودة لكن بدون أي منطق مرتبط
          IconButton(
            onPressed: () {
              Navigator.pop(context);
              onEdit();
            },
            icon: const Icon(Icons.edit_outlined, color: Colors.green),
            tooltip: 'تعديل',
          ),
          IconButton(
            onPressed: () {
              onDelete();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            tooltip: 'حذف',
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String type) {
    final isAbsence = type == 'غياب';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isAbsence
            ? Colors.red.withOpacity(0.1)
            : Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        type,
        style: TextStyle(
          color: isAbsence ? Colors.red : Colors.orange,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
