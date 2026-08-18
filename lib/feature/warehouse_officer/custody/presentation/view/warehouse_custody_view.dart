import 'package:finalproject/core/widgets/empty_view_list.dart';
import 'package:finalproject/core/widgets/error_widget_view.dart';
import 'package:finalproject/core/widgets/pagination_footer.dart';
import 'package:finalproject/feature/engineering_office/presentation/view/widget/stats_card.dart';
import 'package:finalproject/feature/warehouse_officer/custody/data/model/warehouse_custody_model.dart';
import 'package:finalproject/feature/warehouse_officer/custody/presentation/manger/warehouse_custody_cubit.dart';
import 'package:finalproject/feature/warehouse_officer/custody/presentation/manger/warehouse_custody_state.dart';
import 'package:finalproject/feature/warehouse_officer/custody/presentation/view/widget/warehouse_custody_assign_dialog.dart';
import 'package:finalproject/feature/warehouse_officer/custody/presentation/view/widget/warehouse_custody_details_dialog.dart';
import 'package:finalproject/feature/warehouse_officer/custody/presentation/view/widget/warehouse_custody_loading_view.dart';
import 'package:finalproject/feature/warehouse_officer/custody/presentation/view/widget/warehouse_custody_return_dialog.dart';
import 'package:finalproject/feature/warehouse_officer/custody/presentation/view/widget/warehouse_custody_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

class WarehouseCustodyView extends StatefulWidget {
  const WarehouseCustodyView({super.key});

  @override
  State<WarehouseCustodyView> createState() => _WarehouseCustodyViewState();
}

class _WarehouseCustodyViewState extends State<WarehouseCustodyView> {
  final _studentIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WarehouseCustodyCubit>().loadCustodies();
    });
  }

  @override
  void dispose() {
    _studentIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F9),
      body: SafeArea(
        child: BlocConsumer<WarehouseCustodyCubit, WarehouseCustodyState>(
          listener: (context, state) {
            if (state is WarehouseCustodyLoaded &&
                state.successMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.successMessage!),
                  backgroundColor: const Color(0xFF50CD89),
                ),
              );
              context.read<WarehouseCustodyCubit>().clearSuccessMessage();
            }
          },
          builder: (context, state) {
            if (state is WarehouseCustodyInitial ||
                state is WarehouseCustodyLoading) {
              return const WarehouseCustodyLoadingView();
            }

            if (state is WarehouseCustodyError) {
              return ShowErrorWidgetView(
                errorMessage: state.message,
                onRetry: () =>
                    context.read<WarehouseCustodyCubit>().loadCustodies(),
              );
            }

            if (state is WarehouseCustodyLoaded) {
              return _buildContent(context, state);
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WarehouseCustodyLoaded state) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return RefreshIndicator(
      onRefresh: () => context.read<WarehouseCustodyCubit>().refresh(),
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
                _buildFilterBand(context, state)
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

  Widget _buildHeader(BuildContext context, WarehouseCustodyLoaded state) {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'إدارة العهد',
                style: TextStyle(
                  color: Color(0xFF181C32),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'صرف العهد للطالبات ومتابعة الإرجاع وتحديث المستودع',
                style: TextStyle(color: Color(0xFF7E8299), fontSize: 14),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: state.isSubmitting
              ? null
              : () => _openAssignDialog(context),
          icon: state.isSubmitting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.add_task_outlined, size: 18),
          label: const Text('صرف عهدة'),
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

  Widget _buildStatsGrid(BuildContext context, WarehouseCustodyLoaded state) {
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
          title: 'إجمالي العهد',
          value: '${state.meta.total}',
          icon: Icons.assignment_ind_outlined,
          color: const Color(0xFF0D47A1),
          gradientEndColor: const Color(0xFF42A5F5),
        ),
        StatsCard(
          title: 'عهد نشطة',
          value: '${state.activeCount}',
          icon: Icons.pending_actions_outlined,
          color: const Color(0xFFFF9800),
          gradientEndColor: const Color(0xFFFFB74D),
        ),
        StatsCard(
          title: 'عهد مرجعة',
          value: '${state.returnedCount}',
          icon: Icons.assignment_turned_in_outlined,
          color: const Color(0xFF50CD89),
          gradientEndColor: const Color(0xFF6FDFA0),
        ),
        StatsCard(
          title: 'مواد غير مرجعة',
          value: '${state.pendingItemsCount}',
          icon: Icons.inventory_2_outlined,
          color: const Color(0xFFF1416C),
          gradientEndColor: const Color(0xFFFF6B8A),
        ),
      ],
    );
  }

  Widget _buildFilterBand(BuildContext context, WarehouseCustodyLoaded state) {
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
              Icons.search_outlined,
              color: Color(0xFF0D47A1),
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: _studentIdController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'بحث باسم الطالبة',
                hintText: 'مثال: مروة النجار...',
                prefixIcon: const Icon(Icons.person_search_outlined),
                filled: true,
                fillColor: const Color(0xFFF9FAFB),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFEFF2F5)),
                ),
              ),
              onSubmitted: (_) => _applyStudentFilter(context),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: () => _applyStudentFilter(context),
            icon: const Icon(Icons.search_outlined, size: 18),
            label: const Text('بحث'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0D47A1),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            ),
          ),
          const SizedBox(width: 8),
          TextButton.icon(
            onPressed: () {
              _studentIdController.clear();
              context.read<WarehouseCustodyCubit>().filterByStudentName(null);
            },
            icon: const Icon(Icons.clear_outlined, size: 18),
            label: const Text('مسح'),
          ),
        ],
      ),
    );
  }

  Widget _buildTableSection(
    BuildContext context,
    WarehouseCustodyLoaded state,
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
                  'قائمة العهد',
                  style: TextStyle(
                    color: Color(0xFF181C32),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '${state.meta.total} عهدة',
                  style: const TextStyle(color: Color(0xFF7E8299)),
                ),
              ],
            ),
          ),
          if (state.isRefreshing ||
              state.isSubmitting ||
              state.isLoadingDetails)
            const LinearProgressIndicator(minHeight: 2),
          if (state.custodies.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 48),
              child: EmptyListViews(
                text: 'لا توجد عهد لعرضها حالياً',
                iconData: Icons.assignment_ind_outlined,
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.all(8),
              child: SizedBox(
                height: 560,
                child: WarehouseCustodyTable(
                  custodies: state.custodies,
                  onOpenDetails: (custody) => _showDetails(context, custody),
                  onReturnCustody: (custody) =>
                      _openReturnDialog(context, custody),
                ),
              ),
            ),
          PaginationFooter(
            meta: state.meta,
            onFirstPage: () =>
                context.read<WarehouseCustodyCubit>().goToPage(1),
            onPreviousPage: () =>
                context.read<WarehouseCustodyCubit>().previousPage(),
            onNextPage: () => context.read<WarehouseCustodyCubit>().nextPage(),
            onLastPage: () => context.read<WarehouseCustodyCubit>().goToPage(
              state.meta.lastPage,
            ),
          ),
        ],
      ),
    );
  }

  void _applyStudentFilter(BuildContext context) {
    final text = _studentIdController.text.trim();
    
    if (text.isNotEmpty && text.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى كتابة حرفين على الأقل للبحث باسم الطالبة'),
          backgroundColor: Color(0xFFFF9800),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    context.read<WarehouseCustodyCubit>().filterByStudentName(text);
  }

  Future<void> _openAssignDialog(BuildContext context) async {
    final request = await showDialog<CreateWarehouseCustodyRequest>(
      context: context,
      builder: (_) => const WarehouseCustodyAssignDialog(),
    );

    if (!context.mounted || request == null) return;
    context.read<WarehouseCustodyCubit>().createCustody(request);
  }

  Future<void> _openReturnDialog(
    BuildContext context,
    WarehouseCustodyAssignment custody,
  ) async {
    final latestCustody = await context
        .read<WarehouseCustodyCubit>()
        .loadDetails(custody.id);
    if (!context.mounted || latestCustody == null) return;

    final request = await showDialog<ReturnWarehouseCustodyRequest>(
      context: context,
      builder: (_) => WarehouseCustodyReturnDialog(custody: latestCustody),
    );

    if (!context.mounted || request == null) return;
    context.read<WarehouseCustodyCubit>().returnCustody(
      id: latestCustody.id,
      request: request,
    );
  }

  Future<void> _showDetails(
    BuildContext context,
    WarehouseCustodyAssignment custody,
  ) async {
    final latestCustody = await context
        .read<WarehouseCustodyCubit>()
        .loadDetails(custody.id);
    if (!context.mounted || latestCustody == null) return;

    showDialog(
      context: context,
      builder: (_) => WarehouseCustodyDetailsDialog(custody: latestCustody),
    );
  }
}
