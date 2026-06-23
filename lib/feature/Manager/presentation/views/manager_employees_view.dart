import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:finalproject/core/theme/theme_extination.dart';
import 'package:finalproject/core/widgets/pagination_footer.dart';
import '../../data/models/employee_model.dart';
import '../manger/employees_cubit.dart';
import '../manger/employees_state.dart';
import 'widget/employee_action_dialog.dart';
import 'package:finalproject/core/widgets/custom_confirm_dialog.dart';

/// واجهة إدارة الموظفين الرئيسية (ManagerEmployeesView)
///
/// الوظيفة:
/// عرض قائمة الموظفين في جدول فاخر، ودعم التصفح بالصفحات وعمليات الإضافة والتعديل والحذف للكادر.
class ManagerEmployeesView extends StatefulWidget {
  const ManagerEmployeesView({super.key});

  @override
  State<ManagerEmployeesView> createState() => _ManagerEmployeesViewState();
}

class _ManagerEmployeesViewState extends State<ManagerEmployeesView> {
  final Map<String, String> _roleTranslations = {
    'student_affairs': 'شؤون الطلاب',
    'examinations_officer': 'المسؤول الامتحاني',
    'housing_unit_supervisor': 'مشرف السكن',
    'hospital_supervisor': 'مشرف المشفى',
    'warehouse_officer': 'أمين المستودع',
    'entry_exit_supervisor': 'مراقب البوابة',
    'manager': 'المدير العام',
    'engineering_office': 'المكتب الهندسي',
    'head_supervisor': 'المشرف العام',
  };

  String _translateRole(String roleKey) {
    return _roleTranslations[roleKey] ?? roleKey;
  }

  String _formatDate(String isoString) {
    if (isoString.isEmpty) return 'غير محدد';
    try {
      final date = DateTime.parse(isoString);
      return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    } catch (_) {
      return isoString.split('T').first;
    }
  }

  void _showActionDialog(BuildContext context, {EmployeeItem? employee}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => EmployeeActionDialog(
        employee: employee,
        employeesCubit: context.read<EmployeesCubit>(),
      ),
    );
  }

  void _confirmDelete(BuildContext context, EmployeeItem employee) {
    confirmDelete(context, () async {
      Navigator.of(context, rootNavigator: true).pop();
      final success = await context.read<EmployeesCubit>().deleteEmployee(employee.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success ? 'تم حذف الموظف بنجاح' : 'فشل عملية الحذف، حاول لاحقاً',
              style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
            ),
            backgroundColor: success ? Colors.green[600] : Colors.red[600],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final styles = context.styles;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: styles.backgroundColor,
        appBar: AppBar(
          backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          elevation: 0.5,
          title: Text(
            MediaQuery.of(context).size.width < 600 ? 'إدارة الموظفين' : 'إدارة الكادر الإداري والموظفين',
            style: styles.headline6.copyWith(fontWeight: FontWeight.bold),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: MediaQuery.of(context).size.width < 500
                  ? Container(
                      decoration: BoxDecoration(
                        color: styles.primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        onPressed: () => _showActionDialog(context),
                        icon: const Icon(Icons.add_rounded, color: Colors.white),
                        tooltip: 'إضافة موظف جديد',
                      ),
                    )
                  : ElevatedButton.icon(
                      onPressed: () => _showActionDialog(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: styles.primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      icon: const Icon(Icons.add_rounded, color: Colors.white),
                      label: const Text(
                        'إضافة موظف جديد',
                        style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
            ),
          ],
        ),
        body: BlocBuilder<EmployeesCubit, EmployeesState>(
          builder: (context, state) {
            if (state is EmployeesLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is EmployeesError) {
              return _buildErrorState(state.message, styles);
            }

            if (state is EmployeesSuccess) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  final isMobile = constraints.maxWidth < 750;
                  return Column(
                    children: [
                      // القائمة أو الجدول
                      Expanded(
                        child: state.employees.isEmpty
                            ? Center(
                                child: Text(
                                  'لا يوجد موظفين مسجلين حالياً.',
                                  style: styles.bodyLarge.copyWith(color: styles.textSecondaryColor),
                                ),
                              )
                            : (isMobile
                                ? _buildMobileList(state.employees)
                                : _buildDesktopTable(state.employees, isDark)),
                      ),
                      
                      // الفوتر مع أزرار التحكم بالصفحات
                      if (state.meta != null)
                        PaginationFooter(
                          meta: state.meta!,
                          onFirstPage: () => context.read<EmployeesCubit>().loadEmployees(page: 1),
                          onPreviousPage: () => context.read<EmployeesCubit>().loadEmployees(page: state.meta!.currentPage - 1),
                          onNextPage: () => context.read<EmployeesCubit>().loadEmployees(page: state.meta!.currentPage + 1),
                          onLastPage: () => context.read<EmployeesCubit>().loadEmployees(page: state.meta!.lastPage),
                        ),
                    ],
                  );
                },
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildDesktopTable(List<EmployeeItem> list, bool isDark) {
    final styles = context.styles;
    final screenWidth = MediaQuery.of(context).size.width;
    final showAllColumns = screenWidth >= 1100;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFE2E8F0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: showAllColumns
                ? const <int, TableColumnWidth>{
                    0: FlexColumnWidth(2.8),
                    1: FlexColumnWidth(3.2),
                    2: FlexColumnWidth(2.2),
                    3: FlexColumnWidth(2.5),
                    4: FlexColumnWidth(2.2),
                    5: FixedColumnWidth(110),
                  }
                : const <int, TableColumnWidth>{
                    0: FlexColumnWidth(3.5),
                    1: FlexColumnWidth(2.8),
                    2: FlexColumnWidth(3.2),
                    3: FixedColumnWidth(110),
                  },
            children: [
              // Header Row
              TableRow(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                  border: Border(
                    bottom: BorderSide(
                      color: isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFE2E8F0),
                      width: 1,
                    ),
                  ),
                ),
                children: [
                  _buildHeaderCell('الموظف'),
                  if (showAllColumns) _buildHeaderCell('البريد الإلكتروني'),
                  _buildHeaderCell('القسم'),
                  _buildHeaderCell('الدور الوظيفي'),
                  if (showAllColumns) _buildHeaderCell('تاريخ التعيين'),
                  _buildHeaderCell('العمليات'),
                ],
              ),
              // Data Rows
              ...list.map((item) {
                return TableRow(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFE2E8F0),
                        width: 1,
                      ),
                    ),
                  ),
                  children: [
                    // الموظف
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: styles.primaryColor.withValues(alpha: 0.1),
                            radius: 18,
                            child: Text(
                              item.user.firstName.isNotEmpty ? item.user.firstName[0] : 'U',
                              style: TextStyle(color: styles.primaryColor, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "${item.user.firstName} ${item.user.lastName}",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // البريد الإلكتروني
                    if (showAllColumns)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Text(
                          item.user.email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    // القسم
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Text(
                        item.department,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // الدور الوظيفي
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: styles.primaryColor.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _translateRole(item.user.role),
                              style: TextStyle(
                                color: styles.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // تاريخ التعيين
                    if (showAllColumns)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Text(
                          _formatDate(item.hireDate),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    // العمليات
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => _showActionDialog(context, employee: item),
                            icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                            tooltip: 'تعديل',
                            constraints: const BoxConstraints(),
                            padding: EdgeInsets.zero,
                          ),
                          const SizedBox(width: 12),
                          IconButton(
                            onPressed: () => _confirmDelete(context, item),
                            icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                            tooltip: 'حذف',
                            constraints: const BoxConstraints(),
                            padding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    ).animate().fade(duration: 400.ms).slideY(begin: 0.05);
  }

  Widget _buildHeaderCell(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Cairo',
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

Widget _buildMobileList(List<EmployeeItem> list) {
  final styles = context.styles;
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: list.length,
    itemBuilder: (context, index) {
      final item = list[index];
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFE2E8F0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: styles.primaryColor.withValues(alpha: 0.1),
                  radius: 20,
                  child: Text(
                    item.user.firstName.isNotEmpty ? item.user.firstName[0] : 'U',
                    style: TextStyle(color: styles.primaryColor, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${item.user.firstName} ${item.user.lastName}",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        item.user.email,
                        style: TextStyle(color: styles.textSecondaryColor, fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: styles.primaryColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _translateRole(item.user.role),
                    style: TextStyle(color: styles.primaryColor, fontWeight: FontWeight.bold, fontSize: 11),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'القسم: ${item.department}',
                        style: const TextStyle(fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'تاريخ التعيين: ${_formatDate(item.hireDate)}',
                        style: TextStyle(color: styles.textSecondaryColor, fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => _showActionDialog(context, employee: item),
                      icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                      tooltip: 'تعديل',
                    ),
                    IconButton(
                      onPressed: () => _confirmDelete(context, item),
                      icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                      tooltip: 'حذف',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ).animate().fade(delay: (index * 50).ms, duration: 300.ms).slideX(begin: 0.05);
    },
  );
}

  Widget _buildErrorState(String error, dynamic styles) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline_rounded, color: Colors.red[600], size: 60),
          const SizedBox(height: 16),
          Text(
            'حدث خطأ أثناء تحميل البيانات',
            style: styles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              error,
              style: styles.bodyMedium.copyWith(color: styles.textSecondaryColor),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              context.read<EmployeesCubit>().loadEmployees();
            },
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }
}
