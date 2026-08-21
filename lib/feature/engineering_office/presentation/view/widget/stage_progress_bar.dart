import 'package:flutter/material.dart';

class StageProgressBar extends StatelessWidget {
  final String currentStage;
  final String status;
  final bool isDark;

  const StageProgressBar({
    super.key,
    required this.currentStage,
    required this.status,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final stages = [
      _StageInfo(
        'housing_unit_supervisor',
        'مشرفة\nالسكن',
        Icons.person,
        const Color(0xFFFF9800),
      ),
      _StageInfo(
        'head_supervisor',
        'المشرف\nالعام',
        Icons.admin_panel_settings,
        const Color(0xFF2196F3),
      ),
      _StageInfo(
        'engineering_office',
        'المكتب\nالهندسي',
        Icons.engineering,
        const Color(0xFF9C27B0),
      ),
      _StageInfo(
        'warehouse_officer',
        'أمين\nالمستودع',
        Icons.inventory,
        const Color(0xFF4CAF50),
      ),
    ];

    final currentIndex = stages.indexWhere((s) => s.key == currentStage);
    final isResolved = status == 'Resolved';

    return Column(
      children: [
        Row(
          children: stages.asMap().entries.map((entry) {
            final index = entry.key;
            final stage = entry.value;
            final isCompleted = isResolved || index < currentIndex;
            final isCurrent = index == currentIndex && !isResolved;

            return Expanded(
              child: Column(
                children: [
                  // الخط + الدائرة
                  SizedBox(
                    height: 32,
                    child: Row(
                      children: [
                        if (index > 0)
                          Expanded(
                            child: Container(
                              height: 3,
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              decoration: BoxDecoration(
                                color: isCompleted
                                    ? stage.color
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: isCompleted || isCurrent
                                ? LinearGradient(
                                    colors: [
                                      stage.color,
                                      stage.color.withValues(alpha: 0.7),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : null,
                            color: (!isCompleted && !isCurrent)
                                ? Colors.grey[300]
                                : null,
                            boxShadow: isCurrent
                                ? [
                                    BoxShadow(
                                      color: stage.color.withValues(alpha: 0.4),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Icon(
                            isCompleted ? Icons.check : stage.icon,
                            size: 16,
                            color: (isCompleted || isCurrent)
                                ? Colors.white
                                : Colors.grey[500],
                          ),
                        ),
                        if (index < stages.length - 1)
                          Expanded(
                            child: Container(
                              height: 3,
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              decoration: BoxDecoration(
                                color: isCompleted
                                    ? stage.color
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    stage.label,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                      color: isCompleted || isCurrent
                          ? stage.color
                          : Colors.grey,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _StageInfo {
  final String key;
  final String label;
  final IconData icon;
  final Color color;

  _StageInfo(this.key, this.label, this.icon, this.color);
}
