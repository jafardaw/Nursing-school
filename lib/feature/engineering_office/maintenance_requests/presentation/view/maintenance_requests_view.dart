import 'package:finalproject/core/widgets/error_widget_view.dart';
import 'package:finalproject/core/widgets/pagination_footer.dart';
import 'package:finalproject/feature/engineering_office/maintenance_requests/data/model/maintenance_request_model.dart';
import 'package:finalproject/feature/engineering_office/maintenance_requests/presentation/manger/maintenance_requests_cubit.dart';
import 'package:finalproject/feature/engineering_office/maintenance_requests/presentation/manger/maintenance_requests_state.dart';
import 'package:finalproject/feature/engineering_office/maintenance_requests/presentation/view/widget/maintenance_details_dialog.dart';
import 'package:finalproject/feature/engineering_office/maintenance_requests/presentation/view/widget/maintenance_loading_view.dart';
import 'package:finalproject/feature/engineering_office/maintenance_requests/presentation/view/widget/maintenance_requests_table.dart';
import 'package:finalproject/feature/engineering_office/maintenance_requests/presentation/view/widget/maintenance_search_bar.dart';
import 'package:finalproject/feature/engineering_office/presentation/view/widget/stats_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

class MaintenanceRequestsView extends StatefulWidget {
  const MaintenanceRequestsView({super.key});

  @override
  State<MaintenanceRequestsView> createState() =>
      _MaintenanceRequestsViewState();
}

class _MaintenanceRequestsViewState extends State<MaintenanceRequestsView> {
  final _descriptionController = TextEditingController();
  final _createdAtController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MaintenanceRequestsCubit>().loadRequests();
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _createdAtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F9),
      body: SafeArea(
        child: BlocBuilder<MaintenanceRequestsCubit, MaintenanceRequestsState>(
          builder: (context, state) {
            if (state is MaintenanceRequestsInitial ||
                state is MaintenanceRequestsLoading) {
              return const MaintenanceLoadingView();
            }

            if (state is MaintenanceRequestsError) {
              return ShowErrorWidgetView(
                errorMessage: state.message,
                onRetry: () =>
                    context.read<MaintenanceRequestsCubit>().loadRequests(),
              );
            }

            if (state is MaintenanceRequestsLoaded) {
              return _buildContent(context, state);
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, MaintenanceRequestsLoaded state) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return RefreshIndicator(
      onRefresh: () => context.read<MaintenanceRequestsCubit>().refresh(),
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
                _buildSummaryBand(state)
                    .animate()
                    .fadeIn(duration: 350.ms)
                    .slideY(begin: 0.06, end: 0),
                const SizedBox(height: 24),
                MaintenanceSearchBar(
                      descriptionController: _descriptionController,
                      createdAtController: _createdAtController,
                      onDescriptionChanged: context
                          .read<MaintenanceRequestsCubit>()
                          .searchByDescription,
                      onCreatedAtChanged: context
                          .read<MaintenanceRequestsCubit>()
                          .searchByCreatedAt,
                      onClear: () {
                        _descriptionController.clear();
                        _createdAtController.clear();
                        context.read<MaintenanceRequestsCubit>().clearFilters();
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

  Widget _buildHeader(BuildContext context, MaintenanceRequestsLoaded state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'طلبات الصيانة',
                style: TextStyle(
                  color: Color(0xFF181C32),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'متابعة الطلبات المرتبطة بالشكاوى والمواد المطلوبة للتنفيذ',
                style: TextStyle(color: Color(0xFF7E8299), fontSize: 14),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: state.isRefreshing
              ? null
              : () => context.read<MaintenanceRequestsCubit>().refresh(),
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

  Widget _buildStatsGrid(
    BuildContext context,
    MaintenanceRequestsLoaded state,
  ) {
    final requests = state.requests;
    final pending = requests.where((r) => r.status == 'Pending').length;
    final resolved = requests.where((r) => r.status == 'Resolved').length;
    final itemsCount = requests.fold<int>(0, (sum, r) => sum + r.itemsCount);
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
          title: 'إجمالي الطلبات',
          value: '${state.meta.total}',
          icon: Icons.home_repair_service_outlined,
          color: const Color(0xFF0D47A1),
          gradientEndColor: const Color(0xFF42A5F5),
        ),
        StatsCard(
          title: 'قيد الانتظار',
          value: '$pending',
          icon: Icons.pending_actions_outlined,
          color: const Color(0xFFFF9800),
          gradientEndColor: const Color(0xFFFFB74D),
        ),
        StatsCard(
          title: 'منجزة',
          value: '$resolved',
          icon: Icons.check_circle_outline,
          color: const Color(0xFF50CD89),
          gradientEndColor: const Color(0xFF6FDFA0),
        ),
        StatsCard(
          title: 'مواد مرتبطة',
          value: '$itemsCount',
          icon: Icons.inventory_2_outlined,
          color: const Color(0xFF4ECDC4),
          gradientEndColor: const Color(0xFF7BDDD7),
        ),
      ],
    );
  }

  Widget _buildSummaryBand(MaintenanceRequestsLoaded state) {
    final latestRequest = state.requests.isNotEmpty
        ? state.requests.first
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
              color: const Color(0xFF0D47A1).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.engineering_outlined,
              color: Color(0xFF0D47A1),
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'مركز متابعة الصيانة',
                  style: TextStyle(
                    color: Color(0xFF181C32),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  latestRequest == null
                      ? 'لا توجد طلبات حالياً'
                      : 'آخر طلب: ${latestRequest.description}',
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
    MaintenanceRequestsLoaded state,
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
                  'قائمة طلبات الصيانة',
                  style: TextStyle(
                    color: Color(0xFF181C32),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '${state.meta.total} طلب',
                  style: const TextStyle(color: Color(0xFF7E8299)),
                ),
              ],
            ),
          ),
          if (state.isSearching) const LinearProgressIndicator(minHeight: 2),
          Padding(
            padding: const EdgeInsets.all(8),
            child: MaintenanceRequestsTable(
              requests: state.requests,
              onOpenDetails: (request) => _showDetails(context, request),
            ),
          ),
          PaginationFooter(
            meta: state.meta,
            onFirstPage: () =>
                context.read<MaintenanceRequestsCubit>().goToPage(1),
            onPreviousPage: () =>
                context.read<MaintenanceRequestsCubit>().previousPage(),
            onNextPage: () =>
                context.read<MaintenanceRequestsCubit>().nextPage(),
            onLastPage: () => context.read<MaintenanceRequestsCubit>().goToPage(
              state.meta.lastPage,
            ),
          ),
        ],
      ),
    );
  }

  void _showDetails(BuildContext context, MaintenanceRequestModel request) {
    final cubit = context.read<MaintenanceRequestsCubit>();

    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: MaintenanceDetailsDialog(requestId: request.id),
      ),
    );
  }
}
