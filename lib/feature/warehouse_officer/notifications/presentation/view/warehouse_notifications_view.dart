import 'package:finalproject/core/widgets/error_widget_view.dart';
import 'package:finalproject/core/widgets/pagination_footer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../manger/warehouse_notifications_cubit.dart';
import '../manger/warehouse_notifications_state.dart';
import '../widgets/notification_card_widget.dart';
import '../widgets/notifications_empty_state.dart';
import '../widgets/notifications_loading_view.dart';

class WarehouseNotificationsView extends StatefulWidget {
  const WarehouseNotificationsView({super.key});

  @override
  State<WarehouseNotificationsView> createState() =>
      _WarehouseNotificationsViewState();
}

class _WarehouseNotificationsViewState
    extends State<WarehouseNotificationsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WarehouseNotificationsCubit>().loadNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F9),
      body: SafeArea(
        child: BlocConsumer<WarehouseNotificationsCubit,
            WarehouseNotificationsState>(
          listener: (context, state) {
            if (state is WarehouseNotificationsLoaded &&
                state.successMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.successMessage!),
                  backgroundColor: const Color(0xFF50CD89),
                ),
              );
              context
                  .read<WarehouseNotificationsCubit>()
                  .clearSuccessMessage();
            }
          },
          builder: (context, state) {
            if (state is WarehouseNotificationsInitial ||
                state is WarehouseNotificationsLoading) {
              return const NotificationsLoadingView();
            }

            if (state is WarehouseNotificationsError) {
              return ShowErrorWidgetView(
                errorMessage: state.message,
                onRetry: () => context
                    .read<WarehouseNotificationsCubit>()
                    .loadNotifications(),
              );
            }

            if (state is WarehouseNotificationsLoaded) {
              return _buildContent(context, state, isDesktop);
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WarehouseNotificationsLoaded state,
    bool isDesktop,
  ) {
    final cubit = context.read<WarehouseNotificationsCubit>();
    final items = state.filteredNotifications;

    return RefreshIndicator(
      onRefresh: () => cubit.refresh(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(isDesktop ? 32 : 16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header
                _buildHeader(context, state, isDesktop)
                    .animate()
                    .fadeIn(duration: 350.ms)
                    .slideY(begin: -0.08, end: 0),
                const SizedBox(height: 24),

                // 2. Filter Tabs
                _buildFilterTabs(context, state)
                    .animate()
                    .fadeIn(duration: 350.ms, delay: 50.ms),
                const SizedBox(height: 20),

                // 3. Notifications List or Empty State
                if (items.isEmpty)
                  NotificationsEmptyState(
                    title: state.activeFilterTab ==
                            NotificationFilterTab.stockAlerts
                        ? 'لا توجد تنبيهات مخزون'
                        : 'لا توجد إشعارات في هذا القسم',
                    subtitle: state.activeFilterTab ==
                            NotificationFilterTab.stockAlerts
                        ? 'جميع المواد المخزنية بحالة جيدة وفوق الحد الأدنى.'
                        : 'لم يتم العثور على إشعارات مطابقة للفلتر المحدد.',
                    onRefresh: () => cubit.refresh(),
                  ).animate().fadeIn(duration: 350.ms)
                else ...[
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return NotificationCardWidget(
                        notification: items[index],
                      )
                          .animate()
                          .fadeIn(
                            duration: 250.ms,
                            delay: Duration(milliseconds: 30 * index),
                          )
                          .slideY(begin: 0.04, end: 0);
                    },
                  ),
                  const SizedBox(height: 16),

                  // 4. Pagination Footer
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: PaginationFooter(
                      meta: state.meta.toPaginationMeta(),
                      onFirstPage: () => cubit.goToPage(1),
                      onPreviousPage: () => cubit.previousPage(),
                      onNextPage: () => cubit.nextPage(),
                      onLastPage: () => cubit.goToPage(state.meta.lastPage),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    WarehouseNotificationsLoaded state,
    bool isDesktop,
  ) {
    final cubit = context.read<WarehouseNotificationsCubit>();

    return Container(
      padding: EdgeInsets.all(isDesktop ? 24 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF0D47A1).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.notifications_active_outlined,
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
                  'إشعارات وتنبيهات المستودع',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF181C32),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'متابعة تنبيهات وصول الأصناف للحد الأدنى والإشعارات التشغيلية (${state.meta.total} إشعار)',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF7E8299),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: state.isRefreshing ? null : () => cubit.refresh(),
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs(
    BuildContext context,
    WarehouseNotificationsLoaded state,
  ) {
    final cubit = context.read<WarehouseNotificationsCubit>();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildTabChip(
            label: 'جميع الإشعارات',
            count: state.notifications.length,
            isSelected: state.activeFilterTab == NotificationFilterTab.all,
            onTap: () => cubit.setFilterTab(NotificationFilterTab.all),
          ),
          const SizedBox(width: 8),
          _buildTabChip(
            label: 'تنبيهات المخزون',
            count: state.stockAlertsCount,
            isSelected:
                state.activeFilterTab == NotificationFilterTab.stockAlerts,
            onTap: () => cubit.setFilterTab(NotificationFilterTab.stockAlerts),
            color: const Color(0xFFD97706),
          ),
          const SizedBox(width: 8),
          _buildTabChip(
            label: 'غير مقروءة',
            count: state.unreadCount,
            isSelected: state.activeFilterTab == NotificationFilterTab.unread,
            onTap: () => cubit.setFilterTab(NotificationFilterTab.unread),
            color: const Color(0xFF4338CA),
          ),
          const SizedBox(width: 8),
          _buildTabChip(
            label: 'مقروءة',
            count: state.notifications.length - state.unreadCount,
            isSelected: state.activeFilterTab == NotificationFilterTab.read,
            onTap: () => cubit.setFilterTab(NotificationFilterTab.read),
          ),
        ],
      ),
    );
  }

  Widget _buildTabChip({
    required String label,
    required int count,
    required bool isSelected,
    required VoidCallback onTap,
    Color color = const Color(0xFF0D47A1),
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : const Color(0xFFE2E8F0),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF475569),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.25)
                    : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : const Color(0xFF64748B),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
