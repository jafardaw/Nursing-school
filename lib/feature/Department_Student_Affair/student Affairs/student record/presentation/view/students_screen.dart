import 'package:finalproject/core/constants/app_routes.dart';
import 'package:finalproject/core/di/service_locator.dart';
import 'package:finalproject/core/services/navigation_service.dart';
import 'package:finalproject/core/theme/theme_extination.dart';
import 'package:finalproject/core/widgets/circle_name.dart';
import 'package:finalproject/core/widgets/empty_view_list.dart';
import 'package:finalproject/core/widgets/error_widget_view.dart';
import 'package:finalproject/core/widgets/loading_widget.dart';
import 'package:finalproject/core/widgets/pagination_footer.dart';
import 'package:finalproject/core/widgets/show_dailog.dart';
import 'package:finalproject/core/widgets/small_button.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/data/model/student_model.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/presentation/manger/cubit/export_pdf_cubit.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/presentation/manger/cubit/export_pdf_state.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/presentation/manger/students_cubit.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/presentation/manger/students_state.dart';
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

  @override
  Widget build(BuildContext context) {
    final styles = context.styles;
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F9),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(isDesktop ? 25 : 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🟢 3. شريط البحث والتصفية والأزرار
              const SizedBox(height: 20),

              // 🟢 4. الجدول الرئيسي
              Expanded(
                child: Container(
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
                  child: BlocBuilder<StudentsCubit, StudentsState>(
                    builder: (context, state) {
                      if (state is StudentsLoading) {
                        return buildLoadingSkeleton();
                      }
                      if (state is StudentsError) {
                        return ShowErrorWidgetView(
                          errorMessage: state.message,
                          onRetry: () =>
                              context.read<StudentsCubit>().loadStudents(),
                        );
                      }
                      if (state is StudentsLoaded) {
                        if (state.students.isEmpty) {
                          return EmptyListViews(text: 'لا يوجد بيانات');
                        }
                        return Column(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: _buildDataTable(state),
                              ),
                            ),
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
                          ],
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              ),
              SizedBox(height: 40),
              buildSearchBar(context, isDesktop),
            ],
          ),
        ),
      ),
    );
  }

  // ====== 3. شريط البحث والتصفية ======
  Widget buildSearchBar(BuildContext context, bool isDesktop) {
    final styles = context.styles;

    return Row(
      children: [
        if (isDesktop) ...[
          smallButton(
            styles,
            () {
              // 🟢 إنشاء Cubit مؤقت للتصدير
              final exportCubit = sl<ExportPdfCubit>();

              // 🟢 عرض Snackbar للتحميل
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

              // 🟢 استمع للنتيجة
              exportCubit.stream.listen((state) {
                if (state is ExportPdfSuccess) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else if (state is ExportPdfError) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              });
            },
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
              // الكود ده مش هيتنفذ غير لما المستخدم يرجع من صفحة التسجيل
            },
            Icons.person_add,
            'تسجيل طالبة جديدة',
            styles.primaryColor,
            styles.whiteColor,
          ),
          const SizedBox(width: 8),
        ],
      ],
    );
  }

  // ====== 4. الجدول ======
  Widget _buildDataTable(StudentsLoaded state) {
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
      rows: state.students.map((student) => _buildDataRow(student)).toList(),
    );
  }

  // ====== 5. صف البيانات ======
  DataRow _buildDataRow(StudentModel student) {
    final isActive = !student.clearanceStatus;

    return DataRow(
      cells: [
        // الرقم الجامعي
        DataCell(
          Text(
            student.nationalNumber,
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
            student.fingerprintId,
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
                  titleText: student.user?.firstName ?? '',
                  labiltext: student.user?.lastName ?? '',
                  ntext: student.nationalNumber,
                  fintext: student.fingerprintId,
                  mobileText: student.mobileNum,
                  emtext: student.user?.email ?? '',
                  academicYearText: student.academicYear?.name ?? '',
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
                tooltip: 'طلب',
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
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
        isActive ? 'نشطة' : 'موقفة',
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
