import 'package:data_table_2/data_table_2.dart';
import 'package:finalproject/core/constants/app_routes.dart';
import 'package:finalproject/core/di/service_locator.dart';
import 'package:finalproject/core/services/navigation_service.dart';
import 'package:finalproject/core/widgets/custom_confirm_dialog.dart';
import 'package:finalproject/core/widgets/customfilterbar.dart';
import 'package:finalproject/core/widgets/show_snak_bar.dart';
import 'package:finalproject/feature/Department_Student_Affair/penalties/data/penalties_model.dart';
import 'package:finalproject/feature/Department_Student_Affair/penalties/presentation/views/edit_penalty_dialog.dart';
import 'package:finalproject/feature/Department_Student_Affair/penalties/presentation/manger/cubit_delete/delete_penalties_cubit.dart';
import 'package:finalproject/feature/Department_Student_Affair/penalties/presentation/manger/cubit_delete/delete_penalties_state.dart';
import 'package:finalproject/feature/Department_Student_Affair/penalties/presentation/manger/cubit_get/get_all_penalties_cubit.dart';
import 'package:finalproject/feature/Department_Student_Affair/penalties/presentation/manger/cubit_get/get_all_penalties_state.dart';
import 'package:finalproject/feature/Department_Student_Affair/penalties/presentation/views/widget/studentpenaltiesdialog%20.dart';
import 'package:finalproject/feature/Department_Student_Affair/penalties/repo/penalties_repo.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// تأكد من استيراد الملفات الخاصة بك
// import 'package:finalproject/feature/penalties/presentation/widgets/custom_filter_bar.dart';

class AbsencePage extends StatefulWidget {
  const AbsencePage({super.key});

  @override
  State<AbsencePage> createState() => _AbsencePageState();
}

class _AbsencePageState extends State<AbsencePage> {
  // تعريف المتحكمات والمتغيرات الخاصة بالفلترة
  final TextEditingController _searchController = TextEditingController();
  String? selectedYear = 'الكل';

  late final AbsenceCubit absenceCubit;

  @override
  void initState() {
    super.initState();
    absenceCubit = AbsenceCubit(sl<AbsenceRepository>())..fetchAbsences();
  }

  void _triggerSearch(BuildContext context) {
    final name = _searchController.text.trim();
    final year = selectedYear;
    context.read<AbsenceCubit>().fetchAbsencesSearch(
      name: name.isEmpty ? null : name,
      yearId: year == 'الكل' ? null : year,
      page: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => absenceCubit),
        BlocProvider(
          create: (context) =>
              sl<DeletePenaltyCubit>(), // تسجيل الـ Delete Cubit
        ),
      ],

      child: Builder(
        builder: (innerContext) {
          return BlocListener<DeletePenaltyCubit, DeletePenaltyState>(
            listener: (context, state) {
              if (state is DeletePenaltyLoading) {}
              if (state is DeletePenaltySuccess) {
                // 1. إظهار رسالة نجاح
                showCustomSnackBar(
                  context,
                  state.message,
                  type: ToastType.success,
                );

                // 2. تحديث القائمة فوراً عشان يختفي السجل المحذوف
                context.read<AbsenceCubit>().fetchAbsences();
              }
              if (state is DeletePenaltyError) {
                showCustomSnackBar(
                  context,
                  state.message,
                  type: ToastType.error,
                );
              }
            },
            child: Scaffold(
              backgroundColor: const Color(0xFFF3F6F9),
              body: SafeArea(
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.all(25.0),
                      sliver: SliverToBoxAdapter(
                        child: CustomFilterBar(
                          buttonTooltip: 'بحث عن سجل غياب/إنذار',
                          searchHint: "ابحث عن طالب بالاسم...",
                          searchController: _searchController,
                          onSearchSubmitted: (val) => _triggerSearch(innerContext),
                          label1: "السنة الدراسية",
                          value1: selectedYear,
                          items1: const ['الكل', '1', '2', '3', '4'],
                          onChanged1: (val) {
                            setState(() => selectedYear = val);
                            _triggerSearch(innerContext);
                          },
                          onFilterPressedsearch: () => _triggerSearch(innerContext),
                          icon2: const Icon(Icons.search),
                          onChanged3: (val) => _triggerSearch(innerContext),
                        ),
                      ),
                    ),
                    BlocBuilder<AbsenceCubit, AbsenceState>(
                      builder: (context, state) {
                        if (state is AbsenceLoading) {
                          return const SliverFillRemaining(
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        if (state is AbsenceError) {
                          return SliverFillRemaining(
                            child: Center(child: Text(state.message)),
                          );
                        }
                        if (state is AbsenceSuccess) {
                          if (state.absences.isEmpty) {
                            return const SliverFillRemaining(
                              child: Center(
                                child: Text(
                                  'لا توجد سجلات غيابات أو عقوبات حالياً',
                                ),
                              ),
                            );
                          }
                          return SliverPadding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25.0,
                            ),
                            sliver: SliverList(
                              delegate: SliverChildListDelegate([
                                Container(
                                  height: 600,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.04,
                                        ),
                                        blurRadius: 20,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                    ),
                                    child: DataTable2(
                                      columnSpacing: 20,
                                      horizontalMargin: 12,
                                      minWidth: 900,
                                      headingRowHeight: 60,
                                      headingRowColor: WidgetStateProperty.all(
                                        const Color(0xFFF9FAFB),
                                      ),
                                      columns: const [
                                        DataColumn2(
                                          label: Text('الطالب'),
                                          size: ColumnSize.L,
                                        ),
                                        DataColumn2(
                                          label: Text('السنة'),
                                          size: ColumnSize.L,
                                        ),
                                        DataColumn2(
                                          label: Text('نوع المخالفة'),
                                          size: ColumnSize.M,
                                        ),
                                        DataColumn2(
                                          label: Text('التاريخ'),
                                          size: ColumnSize.M,
                                        ),
                                        DataColumn2(
                                          label: Text('ملاحظات'),
                                          size: ColumnSize.L,
                                        ),
                                      ],
                                      rows: state.absences
                                          .map(
                                            (studentGroup) => _buildRow(
                                              innerContext,
                                              studentGroup,
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                _buildPaginationFooter(context, state),
                                const SizedBox(height: 25.0),
                              ]),
                            ),
                          );
                        }
                        return const SliverToBoxAdapter(child: SizedBox());
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleFilterLogic(BuildContext context) {
    NavigationService.pushTo(context, AppRoutes.addpenalites, extra: 1);
  }

  DataRow _buildRow(BuildContext innerContext, StudentPenaltiesModel item) {
    return DataRow(
      cells: [
        DataCell(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.student.fullName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "إجمالي السجلات: ${item.penalties.length}",
                style: const TextStyle(fontSize: 10, color: Colors.blueGrey),
              ),
            ],
          ),
        ),
        DataCell(
          _buildStatusBadge(
            item.student.academicYear!.fullName.isNotEmpty
                ? item.student.academicYear!.fullName
                : "لا يوجد",
          ),
        ),
        // نعرض نوع آخر عقوبة مسجلة له كمثال في الجدول الرئيسي
        DataCell(
          _buildStatusBadge(
            item.penalties.isNotEmpty ? item.penalties.first.type : "لا يوجد",
          ),
        ),
        DataCell(
          Text(item.penalties.isNotEmpty ? item.penalties.first.date : "-"),
        ),

        DataCell(
          IconButton(
            onPressed: () {
              // الآن innerContext أصبح متاحاً هنا ولن يعطيك Undefined
              final deleteCubit = innerContext.read<DeletePenaltyCubit>();

              showDialog(
                context: innerContext, // يفضل استخدام innerContext أيضاً هنا
                builder: (dialogContext) => BlocProvider.value(
                  value: deleteCubit,
                  child: BlocBuilder<DeletePenaltyCubit, DeletePenaltyState>(
                    builder: (context, state) {
                      int? currentLoadingId;
                      if (state is DeletePenaltyLoading) {
                        currentLoadingId = state.penaltyId;
                      }

                      return StudentPenaltiesDialog(
                        studentData: item,
                        loadingIds: currentLoadingId != null
                            ? [currentLoadingId]
                            : [],
                        onEdit: (penalty) async {
                          await showEditPenaltyDialog(
                            context: context,
                            penalty: penalty,
                          );
                        },
                        onDelete: (penaltyId) {
                          confirmDelete(context, () {
                            deleteCubit.deletePenalty(penaltyId);
                            Navigator.pop(context);
                          });
                        },
                      );
                    },
                  ),
                ),
              );
            },
            icon: const Icon(Icons.visibility_outlined, color: Colors.blue),
          ),
        ),

        // أزرار التحكم (التعديل والحذف لأول سجل أو للسجل الرئيسي)
        // DataCell(
        //   IconButton(
        //     onPressed: () {},
        //     icon: const Icon(Icons.edit_outlined, color: Colors.green),
        //   ),
        // ),
        // DataCell(
        //   IconButton(
        //     onPressed: () {},
        //     icon: const Icon(Icons.delete_outline, color: Colors.red),
        //   ),
        // ),
      ],
    );
  }

  Widget _buildStatusBadge(String type) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        type,
        style: const TextStyle(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPaginationFooter(BuildContext context, AbsenceSuccess state) {
    final cubit = context.read<AbsenceCubit>();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFEFF2F5))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "إجمالي السجلات: ${state.total}",
            style: const TextStyle(color: Colors.grey),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: cubit.currentPage > 1
                    ? () => cubit.fetchAbsences(page: cubit.currentPage - 1)
                    : null,
              ),
              Text(
                "صفحة ${cubit.currentPage}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: (cubit.currentPage * 15) < state.total
                    ? () => cubit.fetchAbsences(page: cubit.currentPage + 1)
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
