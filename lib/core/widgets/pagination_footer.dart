import 'package:finalproject/core/model/pagination_base_model.dart';
import 'package:finalproject/core/widgets/p.dart';
import 'package:flutter/material.dart';

/// 🟢 ويدجت عام للـ Pagination - يستخدم في أي صفحة
class PaginationFooter extends StatelessWidget {
  final PaginationMeta meta;
  final VoidCallback? onFirstPage;
  final VoidCallback? onPreviousPage;
  final VoidCallback? onNextPage;
  final VoidCallback? onLastPage;

  const PaginationFooter({
    super.key,
    required this.meta,
    this.onFirstPage,
    this.onPreviousPage,
    this.onNextPage,
    this.onLastPage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFEFF2F5))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 🟢 عرض النطاق
          Text(
            'عرض ${meta.from} - ${meta.to} من أصل ${meta.total}',
            style: const TextStyle(color: Color(0xFF7E8299)),
          ),
          Row(
            children: [
              // الأولى
              PageButton(
                icon: Icons.first_page,
                onPressed: meta.currentPage > 1 ? onFirstPage : null,
              ),
              const SizedBox(width: 4),
              // السابقة
              PageButton(
                icon: Icons.chevron_right,
                onPressed: meta.currentPage > 1 ? onPreviousPage : null,
              ),
              const SizedBox(width: 10),
              // رقم الصفحة
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D47A1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${meta.currentPage} من ${meta.lastPage}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // التالية
              PageButton(
                icon: Icons.chevron_left,
                onPressed: meta.hasMore ? onNextPage : null,
              ),
              // الأخيرة
              PageButton(
                icon: Icons.last_page,
                onPressed: meta.currentPage < meta.lastPage ? onLastPage : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
