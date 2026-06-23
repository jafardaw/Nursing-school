import 'package:finalproject/core/widgets/empty_view_list.dart';
import 'package:finalproject/core/widgets/error_widget_view.dart';
import 'package:finalproject/core/widgets/pagination_footer.dart';
import 'package:finalproject/feature/engineering_office/presentation/view/widget/stats_card.dart';
import 'package:finalproject/feature/warehouse_officer/stock_in_warehouse/data/model/warehouse_stock_in_model.dart';
import 'package:finalproject/feature/warehouse_officer/stock_in_warehouse/presentation/manger/warehouse_stock_in_cubit.dart';
import 'package:finalproject/feature/warehouse_officer/stock_in_warehouse/presentation/manger/warehouse_stock_in_state.dart';
import 'package:finalproject/feature/warehouse_officer/stock_in_warehouse/presentation/view/widget/warehouse_stock_in_details_dialog.dart';
import 'package:finalproject/feature/warehouse_officer/stock_in_warehouse/presentation/view/widget/warehouse_stock_in_form_dialog.dart';
import 'package:finalproject/feature/warehouse_officer/stock_in_warehouse/presentation/view/widget/warehouse_stock_in_loading_view.dart';
import 'package:finalproject/feature/warehouse_officer/stock_in_warehouse/presentation/view/widget/warehouse_stock_in_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

class WarehouseStockInView extends StatefulWidget {
  const WarehouseStockInView({super.key});

  @override
  State<WarehouseStockInView> createState() => _WarehouseStockInViewState();
}

class _WarehouseStockInViewState extends State<WarehouseStockInView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WarehouseStockInCubit>().loadTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F9),
      body: SafeArea(
        child: BlocConsumer<WarehouseStockInCubit, WarehouseStockInState>(
          listener: (context, state) {
            if (state is WarehouseStockInLoaded &&
                state.lastCreatedTransaction != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم تسجيل حركة دخول المواد بنجاح'),
                  backgroundColor: Color(0xFF50CD89),
                ),
              );
              context.read<WarehouseStockInCubit>().clearCreatedTransaction();
            }
          },
          builder: (context, state) {
            if (state is WarehouseStockInInitial ||
                state is WarehouseStockInLoading) {
              return const WarehouseStockInLoadingView();
            }

            if (state is WarehouseStockInError) {
              return ShowErrorWidgetView(
                errorMessage: state.message,
                onRetry: () =>
                    context.read<WarehouseStockInCubit>().loadTransactions(),
              );
            }

            if (state is WarehouseStockInLoaded) {
              return _buildContent(context, state);
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WarehouseStockInLoaded state) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return RefreshIndicator(
      onRefresh: () => context.read<WarehouseStockInCubit>().refresh(),
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
                  state,
                ).animate().fadeIn(duration: 400.ms, delay: 80.ms),
                const SizedBox(height: 24),
                _buildFocusBand(state)
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

  Widget _buildHeader(BuildContext context, WarehouseStockInLoaded state) {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'إدخال مواد المستودع',
                style: TextStyle(
                  color: Color(0xFF181C32),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'تسجيل المواد الداخلة ومتابعة تفاصيل الرصيد من نفس الحركة',
                style: TextStyle(color: Color(0xFF7E8299), fontSize: 14),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: state.isSubmitting
              ? null
              : () => _openCreateDialog(context),
          icon: state.isSubmitting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.add_box_outlined, size: 18),
          label: const Text('دخول مواد'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF50CD89),
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

  Widget _buildStatsGrid(BuildContext context, WarehouseStockInLoaded state) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width >= 1100
        ? 4
        : width >= 800
        ? 2
        : 1;

    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: crossAxisCount == 1 ? 2.6 : 1.55,
      children: [
        StatsCard(
          title: 'إجمالي الحركات',
          value: '${state.meta.total}',
          icon: Icons.receipt_long_outlined,
          color: const Color(0xFF0D47A1),
          gradientEndColor: const Color(0xFF42A5F5),
        ),
        StatsCard(
          title: 'كمية الصفحة الحالية',
          value: '${state.totalQty}',
          icon: Icons.add_box_outlined,
          color: const Color(0xFF50CD89),
          gradientEndColor: const Color(0xFF6FDFA0),
        ),
        StatsCard(
          title: 'مصادر مختلفة',
          value: '${state.uniqueSourcesCount}',
          icon: Icons.account_balance_outlined,
          color: const Color(0xFF2196F3),
          gradientEndColor: const Color(0xFF64B5F6),
        ),
        StatsCard(
          title: 'تحتاج متابعة',
          value: '${state.lowStockCount}',
          icon: Icons.warning_amber_outlined,
          color: const Color(0xFFFF9800),
          gradientEndColor: const Color(0xFFFFB74D),
        ),
      ],
    );
  }

  Widget _buildFocusBand(WarehouseStockInLoaded state) {
    final latest = state.transactions.isNotEmpty
        ? state.transactions.first
        : null;

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
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: const Color(0xFF50CD89).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.warehouse_outlined,
              color: Color(0xFF50CD89),
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'مركز دخول المواد',
                  style: TextStyle(
                    color: Color(0xFF181C32),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  latest == null
                      ? 'لا توجد حركات إدخال حالياً'
                      : 'آخر حركة: ${latest.item?.name ?? 'مادة #${latest.itemId}'} - ${latest.qty} ${latest.item?.unit ?? ''}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Color(0xFF7E8299)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableSection(
    BuildContext context,
    WarehouseStockInLoaded state,
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
                  'حركات دخول المواد',
                  style: TextStyle(
                    color: Color(0xFF181C32),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '${state.meta.total} حركة',
                  style: const TextStyle(color: Color(0xFF7E8299)),
                ),
              ],
            ),
          ),
          if (state.isRefreshing || state.isSubmitting)
            const LinearProgressIndicator(minHeight: 2),
          if (state.transactions.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 48),
              child: EmptyListViews(
                text: 'لا توجد حركات دخول مواد حتى الآن',
                iconData: Icons.inventory_2_outlined,
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.all(8),
              child: SizedBox(
                height: 560,
                child: WarehouseStockInTable(
                  transactions: state.transactions,
                  onOpenDetails: (transaction) =>
                      _showDetails(context, transaction),
                ),
              ),
            ),
          PaginationFooter(
            meta: state.meta,
            onFirstPage: () =>
                context.read<WarehouseStockInCubit>().goToPage(1),
            onPreviousPage: () =>
                context.read<WarehouseStockInCubit>().previousPage(),
            onNextPage: () => context.read<WarehouseStockInCubit>().nextPage(),
            onLastPage: () => context.read<WarehouseStockInCubit>().goToPage(
              state.meta.lastPage,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openCreateDialog(BuildContext context) async {
    final request = await showDialog<WarehouseStockInRequest>(
      context: context,
      builder: (_) => const WarehouseStockInFormDialog(),
    );

    if (!context.mounted || request == null) return;
    context.read<WarehouseStockInCubit>().createStockIn(request);
  }

  void _showDetails(
    BuildContext context,
    WarehouseStockInTransaction transaction,
  ) {
    showDialog(
      context: context,
      builder: (_) => WarehouseStockInDetailsDialog(transaction: transaction),
    );
  }
}
