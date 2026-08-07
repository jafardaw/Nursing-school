import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finalproject/core/di/service_locator.dart';
import 'package:finalproject/feature/engineering_office/presentation/manger/forward_complaint_cubit.dart';
import 'package:finalproject/feature/engineering_office/presentation/manger/forward_complaint_state.dart';

class ForwardActionsBar extends StatefulWidget {
  final int complaintId;
  final String currentStage;
  final String status;
  final String complaintType;
  final String roomNumber;
  final String buildingName;

  const ForwardActionsBar({
    super.key,
    required this.complaintId,
    required this.currentStage,
    required this.status,
    required this.complaintType,
    required this.roomNumber,
    required this.buildingName,
  });

  @override
  State<ForwardActionsBar> createState() => _ForwardActionsBarState();
}

class _ForwardActionsBarState extends State<ForwardActionsBar> {
  late ForwardComplaintCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<ForwardComplaintCubit>();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.status == 'Resolved') {
      return _buildCompletedCard();
    }

    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<ForwardComplaintCubit, ForwardComplaintState>(
        listener: (context, state) {
          if (state is ForwardComplaintSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(child: Text('✅ تم تحويل الشكوى إلى ')),
                  ],
                ),
                backgroundColor: const Color(0xFF50CD89),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
            Navigator.pop(context, true); // إغلاق الـ Dialog وتحديث الـ Dashboard
          } else if (state is ForwardComplaintError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(child: Text('❌ ${state.message}')),
                  ],
                ),
                backgroundColor: const Color(0xFFF1416C),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is ForwardComplaintLoading && 
                           state.complaintId == widget.complaintId;

          return _buildActionCard(isLoading);
        },
      ),
    );
  }

  Widget _buildCompletedCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF50CD89), Color(0xFF6FDFA0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF50CD89).withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, color: Colors.white, size: 28),
          SizedBox(width: 12),
          Text(
            'تم إنجاز الشكوى بنجاح ✅',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(bool isLoading) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E7FF)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // معلومات سريعة
          Row(
            children: [
              _infoChip(Icons.build, widget.complaintType, const Color(0xFFFF9800)),
              const SizedBox(width: 8),
              _infoChip(Icons.meeting_room, 'غرفة ${widget.roomNumber}', const Color(0xFF2196F3)),
              const SizedBox(width: 8),
              _infoChip(Icons.business, widget.buildingName, const Color(0xFF9C27B0)),
            ],
          ),
          const SizedBox(height: 16),

          // زر التوجيه
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: isLoading ? null : () => _confirmForward(),
              icon: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                    )
                  : const Icon(Icons.arrow_forward_rounded, size: 22),
              label: Text(
                isLoading ? 'جاري التوجيه...' : 'موافقة وتحويل إلى ',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _stageColor(widget.currentStage),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }

  void _confirmForward() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.help_outline, color: _stageColor(widget.currentStage)),
            const SizedBox(width: 8),
            const Text('تأكيد التوجيه'),
          ],
        ),
        content: Text(
          'هل أنت متأكد من تحويل الشكوى إلى؟',
          style: const TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _cubit.forwardComplaint(widget.complaintId );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _stageColor(widget.currentStage),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );
  }



  Color _stageColor(String stage) {
    switch (stage) {
      case 'dormitory_supervisor': return const Color(0xFFFF9800);
      case 'head_supervisor': return const Color(0xFF2196F3);
      case 'engineering_office': return const Color(0xFF9C27B0);
      case 'warehouse_officer': return const Color(0xFF4CAF50);
      default: return Colors.grey;
    }
  }
}