import 'package:finalproject/core/di/service_locator.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/matching/data/matching_campaign_model.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/matching/presentation/manger/matching_results_cubit.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/matching/presentation/manger/matching_results_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finalproject/core/widgets/pagination_footer.dart';

class MatchingResultsView extends StatelessWidget {
  final MatchingCampaignModel campaign;

  const MatchingResultsView({super.key, required this.campaign});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MatchingResultsCubit>(param1: campaign.id)..fetchResults(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          title: Text(
            'نتائج الفرز - ${campaign.title}',
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 18,
              color: Color(0xFF1E293B),
            ),
          ),
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF1E293B),
          elevation: 0,
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(color: const Color(0xFFE2E8F0), height: 1),
          ),
        ),
        body: _MatchingResultsBody(campaign: campaign),
      ),
    );
  }
}

class _MatchingResultsBody extends StatelessWidget {
  final MatchingCampaignModel campaign;

  const _MatchingResultsBody({required this.campaign});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MatchingResultsCubit, MatchingResultsState>(
      builder: (context, state) {
        if (state is MatchingResultsInitial || (state is MatchingResultsLoading && !state.isPagination)) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF2563EB)),
          );
        } else if (state is MatchingResultsError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline_rounded, color: Color(0xFFEF4444), size: 48),
                const SizedBox(height: 16),
                Text(
                  state.message,
                  style: const TextStyle(color: Color(0xFF1E293B), fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => context.read<MatchingResultsCubit>().fetchResults(),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        } else if (state is MatchingResultsLoaded || (state is MatchingResultsLoading && state.isPagination)) {
          final results = state is MatchingResultsLoaded ? state.results : (context.read<MatchingResultsCubit>().state as MatchingResultsLoaded).results;
          final meta = state is MatchingResultsLoaded ? state.meta : (context.read<MatchingResultsCubit>().state as MatchingResultsLoaded).meta;
          final isLoading = state is MatchingResultsLoading;

          if (results.isEmpty) {
            return const Center(
              child: Text(
                'لا توجد نتائج فرز متاحة.',
                style: TextStyle(color: Color(0xFF64748B), fontSize: 16),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeaderStats(context, meta.total),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  physics: const BouncingScrollPhysics(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(minWidth: constraints.maxWidth),
                              child: DataTable(
                                headingRowColor: WidgetStateProperty.all(const Color(0xFFF1F5F9)),
                          dataRowMinHeight: 64,
                          dataRowMaxHeight: 64,
                          dividerThickness: 1,
                          columnSpacing: 48,
                          columns: const [
                            DataColumn(label: Text('#', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF475569), fontSize: 16))),
                            DataColumn(label: Text('اسم الطالب', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF475569), fontSize: 16))),
                            DataColumn(label: Text('المعدل', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF475569), fontSize: 16))),
                            DataColumn(label: Text('الحالة', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF475569), fontSize: 16))),
                            DataColumn(label: Text('المقعد المفروز', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF475569), fontSize: 16))),
                            DataColumn(label: Text('تاريخ التقديم', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF475569), fontSize: 16))),
                          ],
                          rows: results.asMap().entries.map((entry) {
                            final index = entry.key + 1 + (meta.currentPage - 1) * meta.perPage;
                            final result = entry.value;

                            return DataRow(
                              color: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
                                return result.isMatched ? const Color(0xFFECFDF5) : Colors.white; // الأخضر الفاتح للمقبولين
                              }),
                              cells: [
                                DataCell(Text('$index', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15))),
                                DataCell(
                                  Row(
                                    children: [
                                      const CircleAvatar(
                                        radius: 16,
                                        backgroundColor: Color(0xFFE2E8F0),
                                        child: Icon(Icons.person_rounded, size: 18, color: Color(0xFF64748B)),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        result.student?.fullName ?? 'غير معروف',
                                        style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1E293B), fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF1F5F9),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      result.gpaScore ?? '---',
                                      style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF334155), fontSize: 15),
                                    ),
                                  ),
                                ),
                                DataCell(_buildStatusChip(result.status)),
                                DataCell(Text(
                                  result.matchedSeat?.displayName ?? '---',
                                  style: const TextStyle(color: Color(0xFF475569), fontSize: 15),
                                )),
                                DataCell(Text(
                                  _formatDate(result.submissionDate),
                                  style: const TextStyle(color: Color(0xFF64748B), fontSize: 15),
                                )),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
              if (meta.lastPage > 1)
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PaginationFooter(
                        meta: meta,
                        onNextPage: () => context.read<MatchingResultsCubit>().fetchResults(page: meta.currentPage + 1),
                        onPreviousPage: () => context.read<MatchingResultsCubit>().fetchResults(page: meta.currentPage - 1),
                        onFirstPage: () => context.read<MatchingResultsCubit>().fetchResults(page: 1),
                        onLastPage: () => context.read<MatchingResultsCubit>().fetchResults(page: meta.lastPage),
                      ),
                      if (isLoading)
                        const Positioned(
                          right: 16,
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildStatusChip(String status) {
    Color bgColor;
    Color textColor;
    String label;

    if (status == 'Matched') {
      bgColor = const Color(0xFFD1FAE5);
      textColor = const Color(0xFF059669);
      label = 'مقبول';
    } else {
      bgColor = const Color(0xFFFEE2E2);
      textColor = const Color(0xFFDC2626);
      label = 'مرفوض';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }

  String _formatDate(String isoString) {
    if (isoString.isEmpty) return '---';
    try {
      final date = DateTime.parse(isoString);
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return isoString;
    }
  }

  Widget _buildHeaderStats(BuildContext context, int totalStudents) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Row(
        children: [
          Expanded(
            child: _statCard(
              title: 'إجمالي المتقدمين',
              value: '$totalStudents',
              icon: Icons.groups_rounded,
              color: const Color(0xFF6366F1),
              bgColor: const Color(0xFFEEF2FF),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _statCard(
              title: 'السعة الكلية',
              value: '${campaign.totalCapacity}',
              icon: Icons.account_balance_rounded,
              color: const Color(0xFF0EA5E9),
              bgColor: const Color(0xFFE0F2FE),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _statCard(
              title: 'المقاعد المشغولة',
              value: '${campaign.totalMatched}',
              icon: Icons.check_circle_rounded,
              color: const Color(0xFF10B981),
              bgColor: const Color(0xFFD1FAE5),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _statCard(
              title: 'المقاعد الشاغرة',
              value: '${campaign.totalRemaining}',
              icon: Icons.hourglass_empty_rounded,
              color: const Color(0xFFF59E0B),
              bgColor: const Color(0xFFFEF3C7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Color(0xFF1E293B),
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
