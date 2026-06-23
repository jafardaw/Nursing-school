import 'package:finalproject/core/widgets/error_widget_view.dart';
import 'package:finalproject/core/widgets/pagination_footer.dart';
import 'package:finalproject/feature/engineering_office/presentation/view/widget/stats_card.dart';
import 'package:finalproject/feature/warehouse_officer/complaint/data/model/warehouse_complaint_model.dart';
import 'package:finalproject/feature/warehouse_officer/complaint/presentation/manger/warehouse_complaints_cubit.dart';
import 'package:finalproject/feature/warehouse_officer/complaint/presentation/manger/warehouse_complaints_state.dart';
import 'package:finalproject/feature/warehouse_officer/complaint/presentation/view/widget/warehouse_complaint_details_dialog.dart';
import 'package:finalproject/feature/warehouse_officer/complaint/presentation/view/widget/warehouse_complaint_filter_bar.dart';
import 'package:finalproject/feature/warehouse_officer/complaint/presentation/view/widget/warehouse_complaints_loading_view.dart';
import 'package:finalproject/feature/warehouse_officer/complaint/presentation/view/widget/warehouse_complaints_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

class WarehouseComplaintsView extends StatefulWidget {
  const WarehouseComplaintsView({super.key});

  @override
  State<WarehouseComplaintsView> createState() =>
      _WarehouseComplaintsViewState();
}

class _WarehouseComplaintsViewState extends State<WarehouseComplaintsView> {
  final _createdAtController = TextEditingController();
  String _statusValue = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WarehouseComplaintsCubit>().loadComplaints();
    });
  }

  @override
  void dispose() {
    _createdAtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F9),
      body: SafeArea(
        child: BlocBuilder<WarehouseComplaintsCubit, WarehouseComplaintsState>(
          builder: (context, state) {
            if (state is WarehouseComplaintsInitial ||
                state is WarehouseComplaintsLoading) {
              return const WarehouseComplaintsLoadingView();
            }

            if (state is WarehouseComplaintsError) {
              return ShowErrorWidgetView(
                errorMessage: state.message,
                onRetry: () =>
                    context.read<WarehouseComplaintsCubit>().loadComplaints(),
              );
            }

            if (state is WarehouseComplaintsLoaded) {
              return _buildContent(context, state);
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WarehouseComplaintsLoaded state) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return RefreshIndicator(
      onRefresh: () => context.read<WarehouseComplaintsCubit>().refresh(),
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
                WarehouseComplaintFilterBar(
                      createdAtController: _createdAtController,
                      statusValue: _statusValue,
                      onStatusChanged: (value) {
                        setState(() => _statusValue = value);
                        context.read<WarehouseComplaintsCubit>().searchByStatus(
                          value,
                        );
                      },
                      onCreatedAtChanged: context
                          .read<WarehouseComplaintsCubit>()
                          .searchByCreatedAt,
                      onClear: () {
                        setState(() => _statusValue = '');
                        _createdAtController.clear();
                        context.read<WarehouseComplaintsCubit>().clearFilters();
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

  Widget _buildHeader(BuildContext context, WarehouseComplaintsLoaded state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'شكاوى مسؤول المستودع',
                style: TextStyle(
                  color: Color(0xFF181C32),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'متابعة الشكاوى المحولة للمستودع واعتماد إنهاء مرحلة المستودع',
                style: TextStyle(color: Color(0xFF7E8299), fontSize: 14),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: state.isRefreshing
              ? null
              : () => context.read<WarehouseComplaintsCubit>().refresh(),
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
    WarehouseComplaintsLoaded state,
  ) {
    final pending = state.complaints.where((c) => c.status == 'Pending').length;
    final inProgress = state.complaints.where((c) => c.isInProgress).length;
    final resolved = state.complaints.where((c) => c.isResolved).length;
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
          title: 'إجمالي الشكاوى',
          value: '${state.meta.total}',
          icon: Icons.report_problem_outlined,
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
          title: 'قيد التنفيذ',
          value: '$inProgress',
          icon: Icons.inventory_2_outlined,
          color: const Color(0xFF2196F3),
          gradientEndColor: const Color(0xFF64B5F6),
        ),
        StatsCard(
          title: 'منجزة',
          value: '$resolved',
          icon: Icons.check_circle_outline,
          color: const Color(0xFF50CD89),
          gradientEndColor: const Color(0xFF6FDFA0),
        ),
      ],
    );
  }

  Widget _buildFocusBand(WarehouseComplaintsLoaded state) {
    final latestComplaint = state.complaints.isNotEmpty
        ? state.complaints.first
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
              Icons.warehouse_outlined,
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
                  'مركز اعتماد شكاوى المستودع',
                  style: TextStyle(
                    color: Color(0xFF181C32),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  latestComplaint == null
                      ? 'لا توجد شكاوى حالياً'
                      : 'آخر شكوى: ${latestComplaint.description}',
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
    WarehouseComplaintsLoaded state,
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
                  'قائمة الشكاوى',
                  style: TextStyle(
                    color: Color(0xFF181C32),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '${state.meta.total} شكوى',
                  style: const TextStyle(color: Color(0xFF7E8299)),
                ),
              ],
            ),
          ),
          if (state.isSearching) const LinearProgressIndicator(minHeight: 2),
          Padding(
            padding: const EdgeInsets.all(8),
            child: WarehouseComplaintsTable(
              complaints: state.complaints,
              approvingComplaintId: state.approvingComplaintId,
              onApprove: (complaint) => _confirmApprove(context, complaint),
              onOpenDetails: (complaint) => _showDetails(context, complaint),
            ),
          ),
          PaginationFooter(
            meta: state.meta,
            onFirstPage: () =>
                context.read<WarehouseComplaintsCubit>().goToPage(1),
            onPreviousPage: () =>
                context.read<WarehouseComplaintsCubit>().previousPage(),
            onNextPage: () =>
                context.read<WarehouseComplaintsCubit>().nextPage(),
            onLastPage: () => context.read<WarehouseComplaintsCubit>().goToPage(
              state.meta.lastPage,
            ),
          ),
        ],
      ),
    );
  }

  void _showDetails(BuildContext context, WarehouseComplaintModel complaint) {
    showDialog(
      context: context,
      builder: (_) => WarehouseComplaintDetailsDialog(complaint: complaint),
    );
  }

  void _confirmApprove(
    BuildContext context,
    WarehouseComplaintModel complaint,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('تأكيد الاعتماد'),
        content: Text('هل تريد اعتماد الشكوى #${complaint.id}؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<WarehouseComplaintsCubit>().approveComplaint(
                complaint.id,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF50CD89),
              foregroundColor: Colors.white,
            ),
            child: const Text('اعتماد'),
          ),
        ],
      ),
    );
  }
}
