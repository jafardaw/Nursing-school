import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../../core/theme/theme_extination.dart';
import '../../../../core/widgets/show_snak_bar.dart';
import '../../domain/entities/advanced_search_params.dart';
import '../manger/complaints_search_cubit.dart';
import '../manger/complaints_search_state.dart';
import '../widgets/complaint_kanban_view.dart';
import '../widgets/complaint_result_card.dart';
import '../widgets/complaint_table_view.dart';
import '../widgets/search_empty_state.dart';
import '../widgets/search_filter_form.dart';
import '../widgets/search_pagination_bar.dart';

enum ComplaintsDisplayMode { cards, table, kanban }

class ComplaintsAdvancedSearchView extends StatefulWidget {
  const ComplaintsAdvancedSearchView({super.key});

  @override
  State<ComplaintsAdvancedSearchView> createState() => _ComplaintsAdvancedSearchViewState();
}

class _ComplaintsAdvancedSearchViewState extends State<ComplaintsAdvancedSearchView> {
  ComplaintsDisplayMode _displayMode = ComplaintsDisplayMode.cards;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ComplaintsSearchCubit>().search(const AdvancedSearchParams(page: 1, perPage: 15));
    });
  }

  @override
  Widget build(BuildContext context) {
    final styles = context.styles;
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: BlocConsumer<ComplaintsSearchCubit, ComplaintsSearchState>(
          listener: (context, state) {
            if (state is ComplaintsSearchError) {
              showWebBanner(context, state.message, type: BannerType.error);
            }
          },
          builder: (context, state) {
            final cubit = context.read<ComplaintsSearchCubit>();
            final currentParams = cubit.currentParams;

            List<String> history = [];
            if (state is ComplaintsSearchInitial) {
              history = state.searchHistory;
            } else if (state is ComplaintsSearchLoaded) {
              history = state.searchHistory;
            } else if (state is ComplaintsSearchError) {
              history = state.searchHistory;
            }

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // 1. Header Banner
                SliverPadding(
                  padding: EdgeInsets.only(
                    top: isDesktop ? 24 : 16,
                    left: isDesktop ? 24 : 16,
                    right: isDesktop ? 24 : 16,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: _buildHeader(styles, isDesktop),
                  ),
                ),

                // 2. Search & Filter Form
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 24 : 16,
                    vertical: 16,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: SearchFilterForm(
                      initialParams: currentParams,
                      searchHistory: history,
                      onSearch: (params) => cubit.search(params),
                      onReset: () => cubit.reset(),
                    ),
                  ),
                ),

                // 3. Active Filters Bar
                if (currentParams.hasActiveFilters)
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: isDesktop ? 24 : 16),
                    sliver: SliverToBoxAdapter(
                      child: _buildActiveFiltersBar(currentParams, cubit),
                    ),
                  ),

                // 4. View Mode Switcher Header
                if (state is ComplaintsSearchLoaded && state.complaints.isNotEmpty)
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 24 : 16,
                      vertical: 6,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: _buildViewModeSwitcher(state.meta.total),
                    ),
                  ),

                // 5. Main Results Section
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 24 : 16,
                    vertical: 12,
                  ),
                  sliver: _buildResultsSection(state, cubit),
                ),

                // 6. Pagination Bar (if loaded)
                if (state is ComplaintsSearchLoaded && state.meta.total > 0)
                  SliverPadding(
                    padding: EdgeInsets.only(
                      left: isDesktop ? 24 : 16,
                      right: isDesktop ? 24 : 16,
                      bottom: 32,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: SearchPaginationBar(
                        meta: state.meta,
                        onPageChanged: (page) => cubit.changePage(page),
                        onPerPageChanged: (perPage) => cubit.changePerPage(perPage),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(ThemedTextStyles styles, bool isDesktop) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 24 : 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1E293B),
            Color(0xFF0F172A),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF2563EB).withValues(alpha: 0.4)),
            ),
            child: const Icon(
              Icons.travel_explore_rounded,
              color: Color(0xFF60A5FA),
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'البحث المتقدم في الشكاوى',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'تصفية وبحث دقيق بالوصف، التواريخ (الإنشاء، الحل، حركة السجل)، والحالات والمراحل.',
                  style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFiltersBar(AdvancedSearchParams params, ComplaintsSearchCubit cubit) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 6,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Text(
            'الفلاتر النشطة:',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E40AF)),
          ),
          if (params.description != null)
            _buildFilterChip('الوصف: "${params.description}"', () {
              cubit.search(params.copyWith(description: null));
            }),
          if (params.createdAt != null)
            _buildFilterChip('تاريخ الإنشاء: ${params.createdAt}', () {
              cubit.search(params.copyWith(createdAt: null));
            }),
          if (params.dateResolved != null)
            _buildFilterChip('تاريخ الحل: ${params.dateResolved}', () {
              cubit.search(params.copyWith(dateResolved: null));
            }),
          if (params.logCreatedAt != null)
            _buildFilterChip('تاريخ السجل: ${params.logCreatedAt}', () {
              cubit.search(params.copyWith(logCreatedAt: null));
            }),
          if (params.status != null)
            _buildFilterChip('الحالة: ${params.status}', () {
              cubit.search(params.copyWith(status: null));
            }),
          if (params.type != null)
            _buildFilterChip('النوع: ${params.type}', () {
              cubit.search(params.copyWith(type: null));
            }),
          if (params.currentStageRole != null)
            _buildFilterChip('المرحلة: ${params.currentStageRole}', () {
              cubit.search(params.copyWith(currentStageRole: null));
            }),
          if (params.logAction != null)
            _buildFilterChip('حركة السجل: ${params.logAction}', () {
              cubit.search(params.copyWith(logAction: null));
            }),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onRemove) {
    return Chip(
      label: Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF1E40AF))),
      backgroundColor: Colors.white,
      deleteIcon: const Icon(Icons.close_rounded, size: 14, color: Color(0xFF3B82F6)),
      onDeleted: onRemove,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      side: const BorderSide(color: Color(0xFF93C5FD)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  Widget _buildViewModeSwitcher(int totalCount) {
    return Row(
      children: [
        Text(
          'النتائج ($totalCount)',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildViewModeButton(
                icon: Icons.view_agenda_outlined,
                label: 'بطاقات',
                mode: ComplaintsDisplayMode.cards,
              ),
              const SizedBox(width: 4),
              _buildViewModeButton(
                icon: Icons.table_chart_outlined,
                label: 'جدول',
                mode: ComplaintsDisplayMode.table,
              ),
              const SizedBox(width: 4),
              _buildViewModeButton(
                icon: Icons.view_column_outlined,
                label: 'كانبان',
                mode: ComplaintsDisplayMode.kanban,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildViewModeButton({
    required IconData icon,
    required String label,
    required ComplaintsDisplayMode mode,
  }) {
    final isSelected = _displayMode == mode;
    return InkWell(
      onTap: () => setState(() => _displayMode = mode),
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2563EB) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 15,
              color: isSelected ? Colors.white : const Color(0xFF64748B),
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsSection(ComplaintsSearchState state, ComplaintsSearchCubit cubit) {
    if (state is ComplaintsSearchLoading) {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              ),
            ),
          ),
          childCount: 4,
        ),
      );
    }

    if (state is ComplaintsSearchError) {
      return SliverToBoxAdapter(
        child: SearchEmptyState(
          title: 'فشل في جلب نتائج البحث',
          subtitle: state.message,
          icon: Icons.error_outline_rounded,
          onReset: () => cubit.search(const AdvancedSearchParams(page: 1, perPage: 15)),
        ),
      );
    }

    if (state is ComplaintsSearchLoaded) {
      if (state.complaints.isEmpty) {
        return SliverToBoxAdapter(
          child: SearchEmptyState(
            title: 'لا توجد نتائج مطابقة لبحثك',
            subtitle: 'تأكد من صحة الكلمات المفتاحية أو التواريخ المدخلة.',
            onReset: () => cubit.reset(),
          ),
        );
      }

      switch (_displayMode) {
        case ComplaintsDisplayMode.cards:
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final complaint = state.complaints[index];
                return ComplaintResultCard(complaint: complaint);
              },
              childCount: state.complaints.length,
            ),
          );
        case ComplaintsDisplayMode.table:
          return SliverToBoxAdapter(
            child: ComplaintTableView(complaints: state.complaints),
          );
        case ComplaintsDisplayMode.kanban:
          return SliverToBoxAdapter(
            child: ComplaintKanbanView(complaints: state.complaints),
          );
      }
    }

    return const SliverToBoxAdapter(child: SizedBox.shrink());
  }
}
