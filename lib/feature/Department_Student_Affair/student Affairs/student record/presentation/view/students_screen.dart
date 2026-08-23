import 'package:finalproject/core/constants/app_routes.dart';
import 'package:finalproject/core/di/service_locator.dart';
import 'package:finalproject/core/services/navigation_service.dart';
import 'package:finalproject/core/theme/app_colors.dart';
import 'package:finalproject/core/theme/theme_extination.dart';
import 'package:finalproject/core/widgets/circle_name.dart';
import 'package:finalproject/core/widgets/custom_confirm_dialog.dart';
import 'package:finalproject/core/widgets/empty_view_list.dart';
import 'package:finalproject/core/widgets/error_widget_view.dart';
import 'package:finalproject/core/widgets/loading_widget.dart';
import 'package:finalproject/core/widgets/pagination_footer.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/presentation/manger/cubit/delete_student_cubit.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/presentation/manger/cubit/delete_student_state.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/presentation/view/widget/show_dailog.dart';
import 'package:finalproject/core/widgets/show_snak_bar.dart';
import 'package:finalproject/core/widgets/small_button.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/data/model/student_model.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/presentation/manger/cubit/export_pdf_cubit.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/presentation/manger/cubit/export_pdf_state.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/presentation/manger/students_cubit.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/presentation/manger/students_state.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/presentation/view/documents/show_student_documents_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:responsive_framework/responsive_framework.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  void _exportPdf(BuildContext context) {
    final exportCubit = sl<ExportPdfCubit>();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 12),
            Text('جاري تحميل الملف...'),
          ],
        ),
        duration: Duration(seconds: 30),
      ),
    );

    exportCubit.exportPdf();

    exportCubit.stream.listen((state) {
      if (!mounted) return;
      if (state is ExportPdfSuccess) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message), backgroundColor: Colors.green),
        );
      } else if (state is ExportPdfError) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message), backgroundColor: Colors.red),
        );
      }
    });
  }

  Widget _buildHeaderSection(ThemedTextStyles styles, bool isDesktop) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D47A1), Color(0xFF1976D2), Color(0xFF42A5F5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D47A1).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.people_alt_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "سجل الطالبات",
                  style: styles.headline2.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "عرض وإدارة سجل الطالبات الملتحقات بالكلية وتصدير البيانات",
                  style: styles.bodyMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Container(
                width: 220,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                    });
                  },
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: "بحث عن طالبة...",
                    hintStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 13,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.white.withValues(alpha: 0.7),
                      size: 20,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              smallButton(
                styles,
                () => _exportPdf(context),
                Icons.file_upload_outlined,
                'تصدير PDF',
                styles.errorColor,
                styles.whiteColor,
              ),
              const SizedBox(width: 12),
              smallButton(
                styles,
                () {
                  NavigationService.pushTo(context, AppRoutes.addStudentRoute);
                },
                Icons.person_add,
                'تسجيل طالبة',
                styles.primaryColor,
                styles.whiteColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final styles = context.styles;
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F9),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.only(
                top: isDesktop ? 25 : 12,
                left: isDesktop ? 25 : 12,
                right: isDesktop ? 25 : 12,
              ),
              sliver: SliverToBoxAdapter(
                child: _buildHeaderSection(styles, isDesktop),
              ),
            ),
            BlocBuilder<StudentsCubit, StudentsState>(
              builder: (context, state) {
                if (state is StudentsLoading) {
                  return SliverFillRemaining(
                    child: Padding(
                      padding: EdgeInsets.all(isDesktop ? 25 : 12),
                      child: buildLoadingSkeleton(),
                    ),
                  );
                }
                if (state is StudentsError) {
                  return SliverFillRemaining(
                    child: ShowErrorWidgetView(
                      errorMessage: state.message,
                      onRetry: () =>
                          context.read<StudentsCubit>().loadStudents(),
                    ),
                  );
                }
                if (state is StudentsLoaded) {
                  final filtered = state.students.where((student) {
                    final fullName = student.user != null
                        ? '${student.user!.firstName} ${student.user!.lastName}'
                              .toLowerCase()
                        : '';
                    return fullName.contains(_searchQuery.toLowerCase()) ||
                        student.nationalNumber.contains(_searchQuery) ||
                        student.fingerprintId.contains(_searchQuery);
                  }).toList();

                  if (filtered.isEmpty && state.students.isNotEmpty) {
                    return const SliverFillRemaining(
                      child: EmptyListViews(text: 'لا توجد نتائج مطابقة للبحث'),
                    );
                  }
                  if (filtered.isEmpty) {
                    return SliverFillRemaining(
                      child: EmptyListViews(text: 'لا يوجد بيانات'),
                    );
                  }

                  return SliverPadding(
                    padding: EdgeInsets.only(
                      left: isDesktop ? 25 : 12,
                      right: isDesktop ? 25 : 12,
                      top: 20,
                      bottom: 25,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        Container(
                          height: 600,
                          decoration: BoxDecoration(
                            color: styles.cardColor,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: _buildDataTable(filtered),
                          ),
                        ),
                        const SizedBox(height: 20),
                        PaginationFooter(
                          meta: state.meta,
                          onFirstPage: () =>
                              context.read<StudentsCubit>().goToPage(1),
                          onPreviousPage: () =>
                              context.read<StudentsCubit>().previousPage(),
                          onNextPage: () =>
                              context.read<StudentsCubit>().nextPage(),
                          onLastPage: () => context
                              .read<StudentsCubit>()
                              .goToPage(state.meta.lastPage),
                        ),
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
    );
  }

  // ====== 4. الجدول ======
  Widget _buildDataTable(List<StudentModeljd> students) {
    return DataTable2(
      columnSpacing: 20,
      horizontalMargin: 12,
      minWidth: 900,
      smRatio: 0.5,
      lmRatio: 1.5,
      headingRowHeight: 60,
      headingTextStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Color(0xFF5E6278),
        fontSize: 15,
      ),
      headingRowColor: WidgetStateProperty.all(const Color(0xFFF9FAFB)),
      columns: const [
        DataColumn2(label: Text('الرقم الجامعي'), size: ColumnSize.M),
        DataColumn2(label: Text('الاسم'), size: ColumnSize.L),
        DataColumn2(label: Text('السنة'), size: ColumnSize.S),
        DataColumn2(label: Text('رقم الهوية'), size: ColumnSize.M),
        DataColumn2(
          label: Text('حالة الطالب'),
          size: ColumnSize.S,
          numeric: true,
        ),
        DataColumn2(label: Text('الحالة'), size: ColumnSize.S),
        DataColumn2(label: Text('إجراءات'), size: ColumnSize.S),
      ],
      rows: students.map((student) => _buildDataRow(student)).toList(),
    );
  }

  // ====== 5. صف البيانات ======
  DataRow _buildDataRow(StudentModeljd student) {
    final isActive = !student.clearanceStatus;

    return DataRow(
      cells: [
        DataCell(
          // الرقم الجامعي
          Text(
            student.userId.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF3F4254),
            ),
          ),
        ),

        // الاسم مع Avatar
        DataCell(
          Row(
            children: [
              circleName(
                firstNameFirstchar: student.user?.firstName[0] ?? '?',
                radius: 20,
                backgroundColor: const Color(0xFF0D47A1).withValues(alpha: 0.1),
                textStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D47A1),
                ),
              ),
              const SizedBox(width: 40),
              Text(
                student.user != null
                    ? '${student.user!.firstName} ${student.user!.lastName}'
                    : 'غير معروف',
                style: const TextStyle(
                  color: Color(0xFF0D47A1),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        // السنة
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF0D47A1).withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              student.academicYear?.name ?? '-',
              style: const TextStyle(
                color: Color(0xFF0D47A1),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        // رقم الهوية
        DataCell(
          Text(
            student.nationalNumber,
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ),

        // المعدل
        DataCell(
          Text(
            student.studyType,
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ),

        // الحالة
        DataCell(buildStatusBadge(isActive)),

        // إجراءات
        DataCell(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.visibility_outlined,
                  size: 18,
                  color: Color(0xFF009EF7),
                ),
                tooltip: 'عرض',
                onPressed: () => showStudentDetails(
                  context: context,
                  isActives: isActive,
                  student: student,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(
                  Icons.description_outlined,
                  size: 18,
                  color: Color(0xFF009EF7),
                ),
                tooltip: 'ملف',
                onPressed: () => showStudentDocumentsDialog(
                  context: context,
                  student: student,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 8),
              BlocConsumer<DeleteStudentCubit, DeleteStudentState>(
                listener: (context, state) {
                  if (state is DeleteStudentSuccess) {
                    showCustomSnackBar(
                      context,
                      'تم حذف الطالب بنجاح',
                      type: ToastType.success,
                    );
                  } else if (state is DeleteStudentError) {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    showCustomSnackBar(
                      context,
                      state.message,
                      type: ToastType.error,
                    );
                  }
                },
                builder: (context, state) {
                  final isLoading =
                      state is DeleteStudentLoading &&
                      state.studentId == student.id;
                  return isLoading
                      ? const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.error,
                            ),
                          ),
                        )
                      : IconButton(
                          icon: const Icon(
                            Icons.delete,
                            size: 18,
                            color: AppColors.error,
                          ),
                          tooltip: 'حذف',
                          onPressed: () {
                            // إغلاق أي حوار مفتوح
                            confirmDelete(context, () {
                              NavigationService.goBack(context);
                              context.read<DeleteStudentCubit>().deleteStudent(
                                student.id,
                              );
                            });
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ====== 6. Badge الحالة ======
  Widget buildStatusBadge(bool isActive) {
    final Color baseColor = isActive
        ? const Color(0xFF50CD89)
        : const Color(0xFFF1416C);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: baseColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        isActive ? 'بريئة الذمة' : 'غير بريئة الذمة',
        style: TextStyle(
          color: baseColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StudentsCubit>().loadStudents();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
