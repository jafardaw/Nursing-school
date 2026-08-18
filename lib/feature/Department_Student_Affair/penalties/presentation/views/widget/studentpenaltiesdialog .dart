import 'package:finalproject/feature/Department_Student_Affair/penalties/data/penalties_model.dart';
import 'package:finalproject/feature/Department_Student_Affair/penalties/presentation/manger/cubit_delete/delete_penalties_cubit.dart';
import 'package:finalproject/feature/Department_Student_Affair/penalties/presentation/manger/cubit_delete/delete_penalties_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentPenaltiesDialog extends StatefulWidget {
  final StudentPenaltiesModel studentData;
  final ValueChanged<PenaltyModel> onEdit; // نمرر الـ ID
  final Function(int penaltyId) onDelete;
  final List<int> loadingIds; // 👈 هاد المتغير الجديد

  const StudentPenaltiesDialog({
    super.key,
    required this.studentData,
    required this.onEdit,
    required this.onDelete,
    required this.loadingIds,
  });

  @override
  State<StudentPenaltiesDialog> createState() => _StudentPenaltiesDialogState();
}

class _StudentPenaltiesDialogState extends State<StudentPenaltiesDialog> {
  late List<PenaltyModel> localPenalties;

  @override
  void initState() {
    super.initState();
    // نأخذ نسخة من البيانات الممرة عند التشغيل لأول مرة
    localPenalties = List.from(widget.studentData.penalties);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeletePenaltyCubit, DeletePenaltyState>(
      listener: (context, state) {
        if (state is DeletePenaltySuccess) {
          // 2. عندما تنجح العملية، نقوم بتحديث القائمة المحلية فقط
          setState(() {
            // نستخدم الـ penaltyId الذي يأتي غالباً من حالة النجاح أو الذي تم طلبه
            // إذا كان الكيوبيت لا يرجع الـ ID، سنعتمد على أن العملية نجحت لآخر طلب
            localPenalties.removeWhere(
              (item) => widget.loadingIds.contains(item.id),
            );

            // ملاحظة: إذا كان الـ state يحتوي على الـ id المحذوف يكون أفضل:
            // localPenalties.removeWhere((item) => item.id == state.deletedId);
          });
        }
      },
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Column(
          children: [
            Text("سجل غيابات: ${widget.studentData.student.fullName}"),
            const Divider(),
          ],
        ),
        content: SizedBox(
          width: 500,
          child: widget.studentData.penalties.isEmpty
              ? const Center(child: Text("لا توجد سجلات حالياً"))
              : ListView.separated(
                  shrinkWrap: true,
                  itemCount: localPenalties.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final penalty = localPenalties[index];
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
      ),
    );
  }

  Widget _buildPenaltyItem(BuildContext context, PenaltyModel penalty) {
    bool isLoading = widget.loadingIds.contains(penalty.id);
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
                  "الرقم الوطني:${widget.studentData.student.nationalnumber}",
                  style: const TextStyle(fontSize: 13),
                ),
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
              widget.onEdit(penalty);
            },
            icon: const Icon(Icons.edit_outlined, color: Colors.green),
            tooltip: 'تعديل',
          ),
          isLoading
              ? const CircularProgressIndicator()
              : IconButton(
                  onPressed: () {
                    widget.onDelete(penalty.id);
                  },
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
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
            ? Colors.red.withValues(alpha: 0.1)
            : Colors.orange.withValues(alpha: 0.1),
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
