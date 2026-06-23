import 'package:finalproject/core/widgets/error_widget_view.dart';
import 'package:finalproject/core/widgets/pagination_footer.dart';
import 'package:finalproject/feature/engineering_office/presentation/view/widget/stats_card.dart';
import 'package:finalproject/feature/warehouse_officer/maintenance_warehouse_officer/data/model/warehouse_maintenance_model.dart';
import 'package:finalproject/feature/warehouse_officer/maintenance_warehouse_officer/presentation/manger/warehouse_maintenance_cubit.dart';
import 'package:finalproject/feature/warehouse_officer/maintenance_warehouse_officer/presentation/manger/warehouse_maintenance_state.dart';
import 'package:finalproject/feature/warehouse_officer/maintenance_warehouse_officer/presentation/view/widget/warehouse_maintenance_details_dialog.dart';
import 'package:finalproject/feature/warehouse_officer/maintenance_warehouse_officer/presentation/view/widget/warehouse_maintenance_form_dialog.dart';
import 'package:finalproject/feature/warehouse_officer/maintenance_warehouse_officer/presentation/view/widget/warehouse_maintenance_loading_view.dart';
import 'package:finalproject/feature/warehouse_officer/maintenance_warehouse_officer/presentation/view/widget/warehouse_maintenance_search_bar.dart';
import 'package:finalproject/feature/warehouse_officer/maintenance_warehouse_officer/presentation/view/widget/warehouse_maintenance_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

class WarehouseMaintenanceView extends StatefulWidget {
  const WarehouseMaintenanceView({super.key});

  @override
  State<WarehouseMaintenanceView> createState() =>
      _WarehouseMaintenanceViewState();
}

class _WarehouseMaintenanceViewState extends State<WarehouseMaintenanceView> {
  final _descriptionController = TextEditingController();
  final _createdAtController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WarehouseMaintenanceCubit>().loadRequests();
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
        child:
            BlocConsumer<WarehouseMaintenanceCubit, WarehouseMaintenanceState>(
              listener: (context, state) {
                if (state is WarehouseMaintenanceLoaded &&
                    state.successMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.successMessage!),
                      backgroundColor: const Color(0xFF50CD89),
                    ),
                  );
                  context
                      .read<WarehouseMaintenanceCubit>()
                      .clearSuccessMessage();
                }
              },
              builder: (context, state) {
                if (state is WarehouseMaintenanceInitial ||
                    state is WarehouseMaintenanceLoading) {
                  return const WarehouseMaintenanceLoadingView();
                }

                if (state is WarehouseMaintenanceError) {
                  return ShowErrorWidgetView(
                    errorMessage: state.message,
                    onRetry: () => context
                        .read<WarehouseMaintenanceCubit>()
                        .loadRequests(),
                  );
                }

                if (state is WarehouseMaintenanceLoaded) {
                  return _buildContent(context, state);
                }

                return const SizedBox();
              },
            ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WarehouseMaintenanceLoaded state) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return RefreshIndicator(
      onRefresh: () => context.read<WarehouseMaintenanceCubit>().refresh(),
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
                WarehouseMaintenanceSearchBar(
                      descriptionController: _descriptionController,
                      createdAtController: _createdAtController,
                      onDescriptionChanged: context
                          .read<WarehouseMaintenanceCubit>()
                          .searchByDescription,
                      onCreatedAtChanged: context
                          .read<WarehouseMaintenanceCubit>()
                          .searchByCreatedAt,
                      onClear: () {
                        _descriptionController.clear();
                        _createdAtController.clear();
                        context
                            .read<WarehouseMaintenanceCubit>()
                            .clearFilters();
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

  Widget _buildHeader(BuildContext context, WarehouseMaintenanceLoaded state) {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'طلبات صيانة المستودع',
                style: TextStyle(
                  color: Color(0xFF181C32),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'إنشاء ومتابعة طلبات الصيانة المرتبطة بالشكاوى والمواد',
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
              : const Icon(Icons.add_task_outlined, size: 18),
          label: const Text('طلب جديد'),
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
    WarehouseMaintenanceLoaded state,
  ) {
    final pending = state.requests.where((request) => request.isPending).length;
    final resolved = state.requests
        .where((request) => request.isResolved)
        .length;
    final totalItems = state.requests.fold(
      0,
      (sum, request) => sum + request.itemsCount,
    );
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
          value: '$totalItems',
          icon: Icons.inventory_2_outlined,
          color: const Color(0xFF2196F3),
          gradientEndColor: const Color(0xFF64B5F6),
        ),
      ],
    );
  }

  Widget _buildTableSection(
    BuildContext context,
    WarehouseMaintenanceLoaded state,
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
          if (state.isRefreshing || state.isSubmitting)
            const LinearProgressIndicator(minHeight: 2),
          Padding(
            padding: const EdgeInsets.all(8),
            child: WarehouseMaintenanceTable(
              requests: state.requests,
              deletingRequestId: state.deletingRequestId,
              onOpenDetails: (request) => _showDetails(context, request),
              onDelete: (request) => _confirmDelete(context, request),
            ),
          ),
          PaginationFooter(
            meta: state.meta,
            onFirstPage: () =>
                context.read<WarehouseMaintenanceCubit>().goToPage(1),
            onPreviousPage: () =>
                context.read<WarehouseMaintenanceCubit>().previousPage(),
            onNextPage: () =>
                context.read<WarehouseMaintenanceCubit>().nextPage(),
            onLastPage: () => context
                .read<WarehouseMaintenanceCubit>()
                .goToPage(state.meta.lastPage),
          ),
        ],
      ),
    );
  }

  Future<void> _openCreateDialog(BuildContext context) async {
    final request = await showDialog<CreateWarehouseMaintenanceRequest>(
      context: context,
      builder: (_) => const WarehouseMaintenanceFormDialog(),
    );

    if (!context.mounted || request == null) return;
    context.read<WarehouseMaintenanceCubit>().createRequest(request);
  }

  void _showDetails(BuildContext context, WarehouseMaintenanceRequest request) {
    showDialog(
      context: context,
      builder: (_) => WarehouseMaintenanceDetailsDialog(request: request),
    );
  }

  void _confirmDelete(
    BuildContext context,
    WarehouseMaintenanceRequest request,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('تأكيد الحذف'),
        content: Text('هل تريد حذف طلب الصيانة #${request.id}؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<WarehouseMaintenanceCubit>().deleteRequest(
                request.id,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF1416C),
              foregroundColor: Colors.white,
            ),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}
