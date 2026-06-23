import 'package:finalproject/feature/engineering_office/stock-in/presentation/manger/stock_cubit.dart';
import 'package:finalproject/feature/engineering_office/stock-in/presentation/manger/stock_state.dart';
import 'package:finalproject/feature/engineering_office/stock-in/presentation/view/widget/low_stock_alert.dart';
import 'package:finalproject/feature/engineering_office/stock-in/presentation/view/widget/stock_stats_card.dart';
import 'package:finalproject/feature/engineering_office/stock-in/presentation/view/widget/stock_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finalproject/core/theme/theme_extination.dart';
import 'package:finalproject/core/widgets/error_widget_view.dart';
import 'package:finalproject/core/widgets/loading_widget.dart';
import 'package:finalproject/core/widgets/pagination_footer.dart';

import 'package:responsive_framework/responsive_framework.dart';

class WarehouseDashboard extends StatefulWidget {
  const WarehouseDashboard({super.key});

  @override
  State<WarehouseDashboard> createState() => _WarehouseDashboardState();
}

class _WarehouseDashboardState extends State<WarehouseDashboard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StockCubit>().loadTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final styles = context.styles;
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F9),
      body: SafeArea(
        child: BlocBuilder<StockCubit, StockState>(
          builder: (context, state) {
            if (state is StockLoading) return buildLoadingSkeleton();
            if (state is StockError) {
              return ShowErrorWidgetView(
                errorMessage: state.message,
                onRetry: () => context.read<StockCubit>().refresh(),
              );
            }
            if (state is StockLoaded) {
              return _buildDashboard(state, isDesktop);
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildDashboard(StockLoaded state, bool isDesktop) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isDesktop ? 32 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(isDesktop),
          const SizedBox(height: 24),
          _buildStatsRow(state, isDesktop),
          const SizedBox(height: 24),
          if (state.lowStockCount > 0) ...[
            LowStockAlert(count: state.lowStockCount),
            const SizedBox(height: 24),
          ],
          _buildTableCard(state, isDesktop),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDesktop) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'إدارة المستودع',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF181C32),
              ),
            ),
            SizedBox(height: 4),
            Text(
              'تتبع حركات المخزون والمواد',
              style: TextStyle(color: Color(0xFFA1A5B7), fontSize: 14),
            ),
          ],
        ),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, size: 18),
              label: const Text('دخول مواد'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF50CD89),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.remove, size: 18),
              label: const Text('صرف مواد'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF1416C),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsRow(StockLoaded state, bool isDesktop) {
    return GridView.count(
      crossAxisCount: isDesktop ? 4 : 2,
      shrinkWrap: true,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.4,
      children: [
        StockStatsCard(
          title: 'إجمالي الداخل',
          value: '${state.totalIn}',
          icon: Icons.download,
          color: const Color(0xFF50CD89),
        ),
        StockStatsCard(
          title: 'إجمالي الصادر',
          value: '${state.totalOut}',
          icon: Icons.upload,
          color: const Color(0xFFF1416C),
        ),
        StockStatsCard(
          title: 'الرصيد الحالي',
          value: '${state.totalIn - state.totalOut}',
          icon: Icons.inventory,
          color: const Color(0xFF2196F3),
        ),
        StockStatsCard(
          title: 'مواد منخفضة',
          value: '${state.lowStockCount}',
          icon: Icons.warning_amber,
          color: const Color(0xFFFF9800),
        ),
      ],
    );
  }

  Widget _buildTableCard(StockLoaded state, bool isDesktop) {
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
            padding: const EdgeInsets.all(8.0),
            child: StockTable(transactions: state.transactions),
          ),
          PaginationFooter(
            meta: state.meta,
            onFirstPage: () => context.read<StockCubit>().goToPage(1),
            onPreviousPage: () => context.read<StockCubit>().previousPage(),
            onNextPage: () => context.read<StockCubit>().nextPage(),
            onLastPage: () =>
                context.read<StockCubit>().goToPage(state.meta.lastPage),
          ),
        ],
      ),
    );
  }
}
