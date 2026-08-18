import 'package:finalproject/core/di/service_locator.dart';
import 'package:finalproject/core/theme/theme_extination.dart';
import 'package:finalproject/core/widgets/custom_confirm_dialog.dart';
import 'package:finalproject/core/widgets/empty_view_list.dart';
import 'package:finalproject/core/widgets/error_widget_view.dart';
import 'package:finalproject/core/widgets/show_snak_bar.dart';
import 'package:finalproject/core/widgets/small_button.dart';
import 'package:finalproject/feature/warehouse_officer/items/data/model/warehouse_item_model.dart';
import 'package:finalproject/feature/warehouse_officer/items/presentation/manger/warehouse_items_cubit.dart';
import 'package:finalproject/feature/warehouse_officer/items/presentation/manger/warehouse_items_state.dart';
import 'package:finalproject/feature/warehouse_officer/items/presentation/view/widget/warehouse_item_form_dialog.dart';
import 'package:finalproject/feature/warehouse_officer/items/presentation/view/widget/warehouse_items_search_bar.dart';
import 'package:finalproject/feature/warehouse_officer/items/presentation/view/widget/warehouse_items_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

class WarehouseItemsView extends StatefulWidget {
  const WarehouseItemsView({super.key});

  @override
  State<WarehouseItemsView> createState() => _WarehouseItemsViewState();
}

class _WarehouseItemsViewState extends State<WarehouseItemsView> {
  late final WarehouseItemsCubit _cubit;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _cubit = sl<WarehouseItemsCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cubit.fetchItems(page: _currentPage);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _unitController.dispose();
    _cubit.close();
    super.dispose();
  }

  void _onSearch() {
    _currentPage = 1;
    final name = _nameController.text.trim();
    final unit = _unitController.text.trim();
    if (name.isEmpty && unit.isEmpty) {
      _cubit.fetchItems(page: _currentPage);
    } else {
      _cubit.searchItems(name: name, unit: unit, page: _currentPage);
    }
  }

  void _onReset() {
    _nameController.clear();
    _unitController.clear();
    _currentPage = 1;
    _cubit.fetchItems(page: _currentPage);
  }

  void _openAddEditDialog({WarehouseItemModel? item}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: _cubit,
          child: BlocConsumer<WarehouseItemsCubit, WarehouseItemsState>(
            listener: (context, state) {
              if (state is WarehouseItemActionSuccess) {
                Navigator.of(dialogContext).pop();
              }
            },
            builder: (context, state) {
              final isLoading = state is WarehouseItemActionLoading;
              return WarehouseItemFormDialog(
                item: item,
                isLoading: isLoading,
                onSave: (request) {
                  if (item == null) {
                    _cubit.createItem(request);
                  } else {
                    _cubit.updateItem(id: item.id, request: request);
                  }
                },
              );
            },
          ),
        );
      },
    );
  }

  void _onDelete(WarehouseItemModel item) {
    confirmDelete(context, () {
      _cubit.deleteItem(item.id);
      Navigator.of(context, rootNavigator: true).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final styles = context.styles;
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return BlocProvider.value(
      value: _cubit,
      child: BlocListener<WarehouseItemsCubit, WarehouseItemsState>(
        listener: (context, state) {
          if (state is WarehouseItemActionSuccess) {
            showWebBanner(context, state.message, type: BannerType.success);
          } else if (state is WarehouseItemsError) {
            showWebBanner(context, state.message, type: BannerType.error);
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF8F9FD),
          body: SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.only(
                    top: isDesktop ? 24 : 12,
                    left: isDesktop ? 24 : 12,
                    right: isDesktop ? 24 : 12,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: _buildHeaderSection(styles, isDesktop),
                  ),
                ),
                BlocBuilder<WarehouseItemsCubit, WarehouseItemsState>(
                  builder: (context, state) {
                    final items = _cubit.items;
                    final meta = _cubit.meta;

                    if (state is WarehouseItemsLoading && items.isEmpty) {
                      return const SliverFillRemaining(
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (state is WarehouseItemsError && items.isEmpty) {
                      return SliverFillRemaining(
                        child: ShowErrorWidgetView(
                          errorMessage: state.message,
                          showImage: false,
                          onRetry: () => _cubit.fetchItems(page: _currentPage),
                        ),
                      );
                    }

                    return SliverMainAxisGroup(
                      slivers: [
                        SliverPadding(
                          padding: EdgeInsets.only(
                            left: isDesktop ? 24 : 12,
                            right: isDesktop ? 24 : 12,
                            top: 16,
                          ),
                          sliver: SliverToBoxAdapter(
                            child: Column(
                              children: [
                                _buildSummaryKPIs(items),
                                const SizedBox(height: 16),
                                WarehouseItemsSearchBar(
                                  nameController: _nameController,
                                  unitController: _unitController,
                                  onSearch: _onSearch,
                                  onReset: _onReset,
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (items.isEmpty)
                          const SliverFillRemaining(
                            child: EmptyListViews(
                              text: 'لا توجد مواد مخزنية مطابقة',
                            ),
                          )
                        else
                          SliverPadding(
                            padding: EdgeInsets.only(
                              left: isDesktop ? 24 : 12,
                              right: isDesktop ? 24 : 12,
                              top: 20,
                              bottom: 24,
                            ),
                            sliver: SliverToBoxAdapter(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.02),
                                      blurRadius: 15,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                  border: Border.all(
                                    color: const Color(0xFFF1F5F9),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 520,
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: WarehouseItemsTable(
                                          items: items,
                                          onEdit: (item) =>
                                              _openAddEditDialog(item: item),
                                          onDelete: _onDelete,
                                        ),
                                      ),
                                    ),
                                    if (meta != null && meta.lastPage > 1)
                                      _buildPaginationFooter(meta),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(ThemedTextStyles styles, bool isDesktop) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "إدارة المواد والمستلزمات المخزنية",
              style: styles.headline2.copyWith(
                color: const Color(0xFF1E293B),
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "إضافة وتعديل المواد المخزنية وضبط حدود الإنذار والكميات",
              style: styles.bodyMedium.copyWith(color: const Color(0xFF64748B)),
            ),
          ],
        ),
        smallButton(
          styles,
          () => _openAddEditDialog(),
          Icons.add_box_rounded,
          'مادة جديدة',
          styles.primaryColor,
          Colors.white,
        ),
      ],
    );
  }

  Widget _buildSummaryKPIs(List<WarehouseItemModel> items) {
    final lowStockCount =
        items.where((i) => i.totalQuantity <= i.minStockAlert).length;
    final totalQtySum = items.fold<int>(0, (sum, i) => sum + i.totalQuantity);

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _buildKpiTile(
          title: 'إجمالي المواد المسجلة',
          value: '${items.length}',
          icon: Icons.inventory_2_rounded,
          color: const Color(0xFF2563EB),
        ),
        _buildKpiTile(
          title: 'مواد ينقصها المخزون',
          value: '$lowStockCount',
          subtitle: 'تتطلب تزويد فوري',
          icon: Icons.warning_amber_rounded,
          color: lowStockCount > 0 ? const Color(0xFFDC2626) : const Color(0xFF10B981),
        ),
        _buildKpiTile(
          title: 'إجمالي القطع المتوفرة',
          value: '$totalQtySum',
          subtitle: 'قطعة بالمستودع',
          icon: Icons.pie_chart_rounded,
          color: const Color(0xFF0D9488),
        ),
      ],
    );
  }

  Widget _buildKpiTile({
    required String title,
    required String value,
    String? subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: 240,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationFooter(WarehouseItemsMeta meta) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'عرض صفحة ${meta.currentPage} من ${meta.lastPage} (إجمالي ${meta.total} مادة)',
            style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
          ),
          Row(
            children: [
              IconButton(
                onPressed: meta.currentPage > 1
                    ? () {
                        setState(() {
                          _currentPage--;
                        });
                        _cubit.fetchItems(page: _currentPage);
                      }
                    : null,
                icon: const Icon(Icons.arrow_back_ios_rounded, size: 18),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: meta.hasMore
                    ? () {
                        setState(() {
                          _currentPage++;
                        });
                        _cubit.fetchItems(page: _currentPage);
                      }
                    : null,
                icon: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
