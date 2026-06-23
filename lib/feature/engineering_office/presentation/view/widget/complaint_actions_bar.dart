import 'package:finalproject/core/di/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finalproject/feature/engineering_office/presentation/manger/forward_complaint_cubit.dart';
import 'package:finalproject/feature/engineering_office/presentation/manger/forward_complaint_state.dart';

class ComplaintActionsBar extends StatelessWidget {
  final int complaintId;
  final String currentStage;
  final String status;

  const ComplaintActionsBar({
    super.key,
    required this.complaintId,
    required this.currentStage,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    // لو الشكوى منجزة، ما في إجراءات
    if (status == 'Resolved') {
      return _buildCompletedBadge(context);
    }

    return BlocProvider(
      create: (_) => sl<ForwardComplaintCubit>(),
      child: BlocConsumer<ForwardComplaintCubit, ForwardComplaintState>(
        listener: (context, state) {
          if (state is ForwardComplaintSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('✅ ${state.message} - المرحلة الحالية: ${state.newStage}'),
                backgroundColor: Colors.green,
              ),
            );
            context.read<ForwardComplaintCubit>().reset();
          } else if (state is ForwardComplaintError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('❌ ${state.message}'), backgroundColor: Colors.red),
            );
            context.read<ForwardComplaintCubit>().reset();
          }
        },
        builder: (context, state) {
          final isLoading = state is ForwardComplaintLoading && 
                           state.complaintId == complaintId;

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🟢 المرحلة الحالية
                Row(
                  children: [
                    Icon(Icons.flag, color: _stageColor(currentStage)),
                    const SizedBox(width: 8),
                    Text(
                      'المرحلة الحالية: ${_stageLabel(currentStage)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _stageColor(currentStage),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // 🟢 شريط التقدم
                _buildProgressBar(),
                const SizedBox(height: 16),

                // 🟢 زر التوجيه
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: isLoading
                        ? null
                        : () => _confirmForward(context),
                    icon: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.arrow_forward, size: 20),
                    label: Text(isLoading ? 'جاري التوجيه...' : _nextStageLabel()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _stageColor(currentStage),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCompletedBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF50CD89).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF50CD89).withValues(alpha: 0.3)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, color: Color(0xFF50CD89), size: 24),
          SizedBox(width: 8),
          Text('تم إنجاز الشكوى ✅', style: TextStyle(color: Color(0xFF50CD89), fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    final stages = [
      'dormitory_supervisor',
      'head_supervisor',
      'engineering_office',
      'warehouse_officer',
    ];

    final currentIndex = stages.indexOf(currentStage);

    return Row(
      children: stages.asMap().entries.map((entry) {
        final index = entry.key;
        final stage = entry.value;
        final isCompleted = index < currentIndex;
        final isCurrent = index == currentIndex;

        return Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  if (index > 0)
                    Expanded(
                      child: Container(
                        height: 2,
                        color: isCompleted || isCurrent
                            ? _stageColor(stage)
                            : Colors.grey[300],
                      ),
                    ),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted
                          ? const Color(0xFF50CD89)
                          : isCurrent
                              ? _stageColor(stage)
                              : Colors.grey[300],
                    ),
                  ),
                  if (index < stages.length - 1)
                    Expanded(
                      child: Container(
                        height: 2,
                        color: isCompleted
                            ? _stageColor(stage)
                            : Colors.grey[300],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                _stageLabel(stage),
                style: TextStyle(
                  fontSize: 10,
                  color: isCompleted || isCurrent ? _stageColor(stage) : Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  void _confirmForward(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تأكيد التوجيه'),
        content: Text('هل تريد تحويل الشكوى إلى ${_nextStageLabel()}؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<ForwardComplaintCubit>().forwardComplaint(
                complaintId,
                _nextStage,
              );
            },
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );
  }

  String get _nextStage {
    final stages = [
      'dormitory_supervisor',
      'head_supervisor',
      'engineering_office',
      'warehouse_officer',
    ];
    final currentIndex = stages.indexOf(currentStage);
    if (currentIndex < stages.length - 1) {
      return stages[currentIndex + 1];
    }
    return currentStage;
  }

  String _stageLabel(String stage) {
    switch (stage) {
      case 'dormitory_supervisor': return 'مشرفة السكن';
      case 'head_supervisor': return 'المشرف العام';
      case 'engineering_office': return 'المكتب الهندسي';
      case 'warehouse_officer': return 'أمين المستودع';
      default: return stage;
    }
  }

  String _nextStageLabel() {
    switch (_nextStage) {
      case 'dormitory_supervisor': return 'مشرفة السكن';
      case 'head_supervisor': return 'المشرف العام';
      case 'engineering_office': return 'المكتب الهندسي';
      case 'warehouse_officer': return 'أمين المستودع (إنجاز)';
      default: return _nextStage;
    }
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