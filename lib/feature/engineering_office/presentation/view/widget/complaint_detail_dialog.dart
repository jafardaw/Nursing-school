import 'package:finalproject/feature/engineering_office/data/model/complaint_model.dart';
import 'package:finalproject/feature/engineering_office/presentation/view/widget/forward_actions_bar.dart';
import 'package:finalproject/feature/engineering_office/presentation/view/widget/stage_progress_bar.dart';
import 'package:flutter/material.dart';

class ComplaintDetailDialog extends StatelessWidget {
  final ComplaintModel complaint;

  const ComplaintDetailDialog({super.key, required this.complaint});

  static Future<void> show(BuildContext context, ComplaintModel complaint) {
    return showDialog(
      context: context,
      builder: (context) => ComplaintDetailDialog(complaint: complaint),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFFF8FAFC),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: EdgeInsets.zero,
      content: SizedBox(
        width: 600,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🟢 Header
              _buildHeader(),
              
              // 🟢 المحتوى
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // شريط التقدم
                    StageProgressBar(
                      currentStage: complaint.currentStageRole,
                      status: complaint.status,
                    ),
                    const SizedBox(height: 24),

                    // الوصف
                    _buildDescriptionCard(),
                    const SizedBox(height: 16),

                    // معلومات الغرفة
                    _buildRoomInfoCard(),
                    const SizedBox(height: 24),

                    // أزرار الإجراءات
                    ForwardActionsBar(
                      complaintId: complaint.id,
                      currentStage: complaint.currentStageRole,
                      status: complaint.status,
                      complaintType: complaint.type,
                      roomNumber: complaint.room?.roomNumber ?? '?',
                      buildingName: complaint.room?.building?.name ?? '?',
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

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1E293B), Color(0xFF334155)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.engineering, color: Colors.white, size: 32),
          ),
          const SizedBox(height: 12),
          Text(
            'شكوى #${complaint.id}',
            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: _statusColor(complaint.status).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _statusLabel(complaint.status),
              style: TextStyle(color: _statusColor(complaint.status), fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.description, color: Color(0xFF64748B), size: 20),
              const SizedBox(width: 8),
              const Text('وصف الشكوى', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF334155), fontSize: 16)),
            ],
          ),
          const SizedBox(height: 12),
          Text(complaint.description, style: const TextStyle(color: Color(0xFF64748B), fontSize: 14, height: 1.6)),
        ],
      ),
    );
  }

  Widget _buildRoomInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          _roomInfoItem(Icons.meeting_room, 'الغرفة', complaint.room?.roomNumber ?? '?'),
          const SizedBox(width: 24),
          _roomInfoItem(Icons.layers, 'الطابق', '${complaint.room?.floorNumber ?? '?'}'),
          const SizedBox(width: 24),
          _roomInfoItem(Icons.business, 'المبنى', complaint.room?.building?.name ?? '?'),
        ],
      ),
    );
  }

  Widget _roomInfoItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF64748B), size: 20),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF334155), fontSize: 14)),
      ],
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Pending': return const Color(0xFFFF9800);
      case 'In_Progress': return const Color(0xFF2196F3);
      case 'Resolved': return const Color(0xFF50CD89);
      default: return Colors.grey;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'Pending': return 'قيد الانتظار';
      case 'In_Progress': return 'قيد التنفيذ';
      case 'Resolved': return 'منجزة';
      default: return status;
    }
  }
}