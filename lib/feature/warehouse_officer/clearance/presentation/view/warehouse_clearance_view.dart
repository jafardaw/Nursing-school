import 'package:finalproject/core/di/service_locator.dart';
import 'package:finalproject/core/theme/theme_extination.dart';
import 'package:finalproject/core/widgets/error_widget_view.dart';
import 'package:finalproject/core/widgets/loading_widget.dart';
import 'package:finalproject/core/widgets/pagination_footer.dart';
import 'package:finalproject/core/model/pagination_base_model.dart';
import 'package:finalproject/feature/warehouse_officer/clearance/presentation/manger/warehouse_clearance_cubit.dart';
import 'package:finalproject/feature/warehouse_officer/clearance/presentation/manger/warehouse_clearance_state.dart';
import 'package:finalproject/feature/warehouse_officer/clearance/presentation/view/widget/warehouse_clearance_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

class WarehouseClearanceView extends StatefulWidget {
  const WarehouseClearanceView({super.key});

  @override
  State<WarehouseClearanceView> createState() => _WarehouseClearanceViewState();
}

class _WarehouseClearanceViewState extends State<WarehouseClearanceView> {
  late final WarehouseClearanceCubit _cubit;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _cubit = sl<WarehouseClearanceCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cubit.loadStudents();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _cubit.close();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _cubit.loadStudents(page: 1, query: query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final styles = context.styles;

    return BlocProvider.value(
      value: _cubit,
      child: BlocListener<WarehouseClearanceCubit, WarehouseClearanceState>(
        listener: (context, state) {
          if (state is WarehouseClearanceLoaded &&
              state.warningMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.warningMessage!)));
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          // appBar: AppBar(
          //   backgroundColor: Colors.transparent,
          //   elevation: 0,
          //   title: Text(
          //     'براءة الذمة (السكن الداخلي)',
          //     style: styles.headline3.copyWith(fontWeight: FontWeight.bold),
          //   ),
          //   centerTitle: false,
          // ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSearchBar(),
                const SizedBox(height: 24),
                Expanded(
                  child:
                      BlocBuilder<
                        WarehouseClearanceCubit,
                        WarehouseClearanceState
                      >(
                        builder: (context, state) {
                          if (state is WarehouseClearanceLoading) {
                            return buildLoadingSkeleton();
                          } else if (state is WarehouseClearanceError) {
                            return ShowErrorWidgetView(
                              errorMessage: state.message,
                              onRetry: () => _cubit.refresh(),
                            );
                          } else if (state is WarehouseClearanceLoaded) {
                            final meta = state.meta;
                            return Column(
                              children: [
                                Expanded(
                                  child: WarehouseClearanceTable(
                                    students: state.students,
                                  ),
                                ),
                                if (meta.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: PaginationFooter(
                                      meta: PaginationMeta.fromJson(meta),
                                      onNextPage: () {
                                        final m = PaginationMeta.fromJson(meta);
                                        if (m.currentPage < m.lastPage) {
                                          _cubit.loadStudents(
                                            page: m.currentPage + 1,
                                            query: _searchController.text,
                                          );
                                        }
                                      },
                                      onPreviousPage: () {
                                        final m = PaginationMeta.fromJson(meta);
                                        if (m.currentPage > 1) {
                                          _cubit.loadStudents(
                                            page: m.currentPage - 1,
                                            query: _searchController.text,
                                          );
                                        }
                                      },
                                    ),
                                  ),
                              ],
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          hintText: 'ابحث بالاسم أو الرقم الجامعي...',
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}
