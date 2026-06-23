import 'package:finalproject/core/widgets/empty_view_list.dart';
import 'package:finalproject/core/widgets/error_widget_view.dart';
import 'package:finalproject/core/widgets/pagination_footer.dart';
import 'package:finalproject/feature/engineering_office/presentation/view/widget/stats_card.dart';
import 'package:finalproject/feature/warehouse_officer/statistics/data/model/warehouse_statistics_model.dart';
import 'package:finalproject/feature/warehouse_officer/statistics/presentation/manger/warehouse_statistics_cubit.dart';
import 'package:finalproject/feature/warehouse_officer/statistics/presentation/manger/warehouse_statistics_state.dart';
import 'package:finalproject/feature/warehouse_officer/statistics/presentation/view/widget/warehouse_inventory_table.dart';
import 'package:finalproject/feature/warehouse_officer/statistics/presentation/view/widget/warehouse_statistics_loading_view.dart';
import 'package:finalproject/feature/warehouse_officer/statistics/presentation/view/widget/warehouse_statistics_search_bar.dart';
import 'package:finalproject/feature/warehouse_officer/statistics/presentation/view/widget/warehouse_top_stocked_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

class WarehouseStatisticsView extends StatefulWidget {
  const WarehouseStatisticsView({super.key});

  @override
  State<WarehouseStatisticsView> createState() =>
      _WarehouseStatisticsViewState();
}

class _WarehouseStatisticsViewState extends State<WarehouseStatisticsView> {
  final _nameController = TextEditingController();
  final _createdAtController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WarehouseStatisticsCubit>().loadDashboard();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _createdAtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F9),
      body: SafeArea(
        child: BlocBuilder<WarehouseStatisticsCubit, WarehouseStatisticsState>(
          builder: (context, state) {
            if (state is WarehouseStatisticsInitial ||
                state is WarehouseStatisticsLoading) {
              return const WarehouseStatisticsLoadingView();
            }

            if (state is WarehouseStatisticsError) {
              return ShowErrorWidgetView(
                errorMessage: state.message,
                onRetry: () =>
                    context.read<WarehouseStatisticsCubit>().loadDashboard(),
              );
            }

            if (state is WarehouseStatisticsLoaded) {
              return _buildContent(context, state);
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WarehouseStatisticsLoaded state) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return RefreshIndicator(
      onRefresh: () =>
          context.read<WarehouseStatisticsCubit>().refreshDashboard(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(isDesktop ? 32 : 16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1440),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, state)
                    .animate()
                    .fadeIn(duration: 350.ms)
                    .slideY(begin: -0.08, end: 0),
                const SizedBox(height: 24),
                _buildStatsGrid(
                  context,
                  state.statistics,
                ).animate().fadeIn(duration: 400.ms, delay: 80.ms),
                const SizedBox(height: 24),
                _buildMiddleSection(state, isDesktop)
                    .animate()
                    .fadeIn(duration: 350.ms)
                    .slideY(begin: 0.06, end: 0),
                const SizedBox(height: 24),
                WarehouseStatisticsSearchBar(
                      nameController: _nameController,
                      createdAtController: _createdAtController,
                      onNameChanged: context
                          .read<WarehouseStatisticsCubit>()
                          .searchByName,
                      onCreatedAtChanged: context
                          .read<WarehouseStatisticsCubit>()
                          .searchByCreatedAt,
                      onClear: () {
                        _nameController.clear();
                        _createdAtController.clear();
                        context.read<WarehouseStatisticsCubit>().clearFilters();
                      },
                      isSearching: state.isSearching,
                    )
                    .animate()
                    .fadeIn(duration: 350.ms)
                    .slideY(begin: 0.06, end: 0),
                const SizedBox(height: 24),
                _buildTableSection(context, state)
                    .animate()
                    .fadeIn(duration: 350.ms)
                    .slideY(begin: 0.06, end: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WarehouseStatisticsLoaded state) {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'إحصائيات المستودع',
                style: TextStyle(
                  color: Color(0xFF181C32),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'نظرة تشغيلية على الأصناف والكميات وتنبيهات المخزون',
                style: TextStyle(color: Color(0xFF7E8299), fontSize: 14),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: state.isRefreshing
              ? null
              : () =>
                    context.read<WarehouseStatisticsCubit>().refreshDashboard(),
          icon: state.isRefreshing
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.refresh, size: 18),
          label: const Text('تحديث'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0D47A1),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(BuildContext context, WarehouseStatistics statistics) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width >= 1200
        ? 5
        : width >= 850
        ? 3
        : width >= 520
        ? 2
        : 1;

    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: crossAxisCount == 1 ? 2.7 : 1.35,
      children: [
        StatsCard(
          title: 'إجمالي الأصناف',
          value: '${statistics.totalItems}',
          icon: Icons.inventory_2_outlined,
          color: const Color(0xFF0D47A1),
          gradientEndColor: const Color(0xFF42A5F5),
        ),
        StatsCard(
          title: 'إجمالي الكمية',
          value: '${statistics.totalStockQuantity}',
          icon: Icons.warehouse_outlined,
          color: const Color(0xFF4ECDC4),
          gradientEndColor: const Color(0xFF7BDDD7),
        ),
        StatsCard(
          title: 'الأصناف المتوفرة',
          value: '${statistics.availableItems}',
          icon: Icons.check_circle_outline,
          color: const Color(0xFF50CD89),
          gradientEndColor: const Color(0xFF6FDFA0),
        ),
        StatsCard(
          title: 'الأصناف المنتهية',
          value: '${statistics.outOfStockItems}',
          icon: Icons.remove_shopping_cart_outlined,
          color: const Color(0xFFF1416C),
          gradientEndColor: const Color(0xFFFF6B8A),
        ),
        StatsCard(
          title: 'مخزون منخفض',
          value: '${statistics.lowStockItems}',
          icon: Icons.warning_amber_rounded,
          color: const Color(0xFFFF9800),
          gradientEndColor: const Color(0xFFFFB74D),
        ),
      ],
    );
  }

  Widget _buildMiddleSection(WarehouseStatisticsLoaded state, bool isDesktop) {
    final summary = _WarehouseStockSummary(statistics: state.statistics);
    final topItems = WarehouseTopStockedList(
      items: state.statistics.topStockedItems,
    );

    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 3, child: summary),
          const SizedBox(width: 16),
          Expanded(flex: 2, child: topItems),
        ],
      );
    }

    return Column(children: [summary, const SizedBox(height: 16), topItems]);
  }

  Widget _buildTableSection(
    BuildContext context,
    WarehouseStatisticsLoaded state,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Row(
              children: [
                const Icon(
                  Icons.table_chart_outlined,
                  color: Color(0xFF0D47A1),
                ),
                const SizedBox(width: 8),
                const Text(
                  'قائمة الأصناف',
                  style: TextStyle(
                    color: Color(0xFF181C32),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '${state.meta.total} صنف',
                  style: const TextStyle(color: Color(0xFF7E8299)),
                ),
              ],
            ),
          ),
          if (state.items.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 48),
              child: EmptyListViews(
                text: 'لا توجد أصناف مطابقة للبحث',
                iconData: Icons.inventory_2_outlined,
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.all(8),
              child: SizedBox(
                height: 560,
                child: WarehouseInventoryTable(items: state.items),
              ),
            ),
          PaginationFooter(
            meta: state.meta,
            onFirstPage: () =>
                context.read<WarehouseStatisticsCubit>().goToPage(1),
            onPreviousPage: () =>
                context.read<WarehouseStatisticsCubit>().previousPage(),
            onNextPage: () =>
                context.read<WarehouseStatisticsCubit>().nextPage(),
            onLastPage: () => context.read<WarehouseStatisticsCubit>().goToPage(
              state.meta.lastPage,
            ),
          ),
        ],
      ),
    );
  }
}

class _WarehouseStockSummary extends StatelessWidget {
  final WarehouseStatistics statistics;

  const _WarehouseStockSummary({required this.statistics});

  @override
  Widget build(BuildContext context) {
    final total = statistics.totalItems == 0 ? 1 : statistics.totalItems;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.analytics_outlined, color: Color(0xFF0D47A1)),
              SizedBox(width: 8),
              Text(
                'توزيع حالة المخزون',
                style: TextStyle(
                  color: Color(0xFF181C32),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          _ProgressLine(
            title: 'متوفر',
            value: statistics.availableItems,
            percent: statistics.availableItems / total,
            color: const Color(0xFF50CD89),
          ),
          const SizedBox(height: 16),
          _ProgressLine(
            title: 'منخفض',
            value: statistics.lowStockItems,
            percent: statistics.lowStockItems / total,
            color: const Color(0xFFFF9800),
          ),
          const SizedBox(height: 16),
          _ProgressLine(
            title: 'منتهي',
            value: statistics.outOfStockItems,
            percent: statistics.outOfStockItems / total,
            color: const Color(0xFFF1416C),
          ),
        ],
      ),
    );
  }
}

class _ProgressLine extends StatelessWidget {
  final String title;
  final int value;
  final double percent;
  final Color color;

  const _ProgressLine({
    required this.title,
    required this.value,
    required this.percent,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF5E6278),
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text(
              '$value',
              style: const TextStyle(
                color: Color(0xFF181C32),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: percent.clamp(0, 1),
            minHeight: 8,
            backgroundColor: color.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
