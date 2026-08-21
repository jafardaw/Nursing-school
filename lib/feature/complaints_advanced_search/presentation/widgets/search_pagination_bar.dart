import 'package:flutter/material.dart';
import '../../domain/entities/paginated_complaints_entity.dart';

class SearchPaginationBar extends StatelessWidget {
  final PaginationMetaEntity meta;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<int> onPerPageChanged;

  const SearchPaginationBar({
    super.key,
    required this.meta,
    required this.onPageChanged,
    required this.onPerPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (meta.total <= 0) return const SizedBox.shrink();

    final canPrev = meta.currentPage > 1;
    final canNext = meta.currentPage < meta.lastPage;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Items info
          Text(
            'عرض ${meta.from ?? 1} إلى ${meta.to ?? meta.total} من إجمالي ${meta.total} نتيجة',
            style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
          ),

          // Controls
          Row(
            children: [
              // Per page dropdown
              const Text('لكل صفحة: ', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
              DropdownButton<int>(
                value: meta.perPage,
                underline: const SizedBox.shrink(),
                items: [10, 15, 25, 50].map((count) {
                  return DropdownMenuItem<int>(
                    value: count,
                    child: Text('$count', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) onPerPageChanged(val);
                },
              ),
              const SizedBox(width: 16),

              // Prev Button
              IconButton(
                icon: const Icon(Icons.chevron_right_rounded),
                onPressed: canPrev ? () => onPageChanged(meta.currentPage - 1) : null,
                tooltip: 'الصفحة السابقة',
              ),

              // Page indicator
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${meta.currentPage} / ${meta.lastPage}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2563EB),
                  ),
                ),
              ),

              // Next Button
              IconButton(
                icon: const Icon(Icons.chevron_left_rounded),
                onPressed: canNext ? () => onPageChanged(meta.currentPage + 1) : null,
                tooltip: 'الصفحة التالية',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
