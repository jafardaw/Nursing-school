import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:finalproject/core/theme/theme_extination.dart';
import '../../../data/models/employee_model.dart';
import '../../manger/employees_cubit.dart';

/// حوار إضافة أو تعديل موظف (EmployeeActionDialog)
///
/// الوظيفة:
/// توفير نموذج تفاعلي متكامل لإضافة موظف جديد أو تعديل بيانات موظف قائم مع التحقق من صحة المدخلات.
class EmployeeActionDialog extends StatefulWidget {
  final EmployeeItem? employee;
  final EmployeesCubit employeesCubit;

  const EmployeeActionDialog({
    super.key,
    this.employee,
    required this.employeesCubit,
  });

  @override
  State<EmployeeActionDialog> createState() => _EmployeeActionDialogState();
}

class _EmployeeActionDialogState extends State<EmployeeActionDialog> {
  final _formKey = GlobalKey<FormState>();
  
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _departmentController;
  late final TextEditingController _hireDateController;

  String _selectedRole = 'examinations_officer';
  DateTime? _selectedDate;
  bool _isLoading = false;

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

  @override
  void initState() {
    super.initState();
    final emp = widget.employee;
    _firstNameController = TextEditingController(text: emp?.user.firstName ?? '');
    _lastNameController = TextEditingController(text: emp?.user.lastName ?? '');
    _emailController = TextEditingController(text: emp?.user.email ?? '');
    _passwordController = TextEditingController();
    _departmentController = TextEditingController(text: emp?.department ?? '');
    
    String formattedDate = '';
    if (emp != null && emp.hireDate.isNotEmpty) {
      try {
        final parsed = DateTime.parse(emp.hireDate);
        _selectedDate = parsed;
        formattedDate = "${parsed.year}-${parsed.month.toString().padLeft(2, '0')}-${parsed.day.toString().padLeft(2, '0')}";
      } catch (_) {
        formattedDate = emp.hireDate.split('T').first;
      }
    } else {
      _selectedDate = DateTime.now();
      formattedDate = "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}";
    }
    _hireDateController = TextEditingController(text: formattedDate);

    if (emp != null && _roleTranslations.containsKey(emp.user.role)) {
      _selectedRole = emp.user.role;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _departmentController.dispose();
    _hireDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale('ar'),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _hireDateController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final request = CreateEmployeeRequest(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.isNotEmpty ? _passwordController.text : null,
      role: _selectedRole,
      department: _departmentController.text.trim(),
      hireDate: _hireDateController.text.trim(),
    );

    bool success = false;
    if (widget.employee == null) {
      success = await widget.employeesCubit.createEmployee(request);
    } else {
      success = await widget.employeesCubit.updateEmployee(widget.employee!.id, request);
    }

    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.employee == null ? 'تم إضافة الموظف بنجاح' : 'تم تعديل بيانات الموظف بنجاح',
              style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.green[600],
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'حدث خطأ، يرجى المحاولة لاحقاً',
              style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.red[600],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final styles = context.styles;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEdit = widget.employee != null;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 650;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
        elevation: 10,
        shadowColor: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 580),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // --- HEADER ---
                  _buildHeader(isDark, isEdit),
                  
                  // --- FORM CONTENT ---
                  Flexible(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Section 1: البيانات الشخصية
                          _buildSectionTitle('البيانات الشخصية', Icons.person_rounded, styles),
                          const SizedBox(height: 16),
                          
                          // الاسم الأول واسم العائلة
                          if (isMobile) ...[
                            _buildFieldWrapper(
                              label: 'الاسم الأول',
                              child: _buildTextField(
                                controller: _firstNameController,
                                icon: Icons.person_outline_rounded,
                                hintText: 'أدخل الاسم الأول',
                                validator: (v) => v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
                                styles: styles,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildFieldWrapper(
                              label: 'الكنية / اسم العائلة',
                              child: _buildTextField(
                                controller: _lastNameController,
                                icon: Icons.person_outline_rounded,
                                hintText: 'أدخل اسم العائلة',
                                validator: (v) => v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
                                styles: styles,
                              ),
                            ),
                          ] else ...[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: _buildFieldWrapper(
                                    label: 'الاسم الأول',
                                    child: _buildTextField(
                                      controller: _firstNameController,
                                      icon: Icons.person_outline_rounded,
                                      hintText: 'أدخل الاسم الأول',
                                      validator: (v) => v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
                                      styles: styles,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildFieldWrapper(
                                    label: 'الكنية / اسم العائلة',
                                    child: _buildTextField(
                                      controller: _lastNameController,
                                      icon: Icons.person_outline_rounded,
                                      hintText: 'أدخل اسم العائلة',
                                      validator: (v) => v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
                                      styles: styles,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          const SizedBox(height: 16),

                          // البريد الإلكتروني
                          _buildFieldWrapper(
                            label: 'البريد الإلكتروني',
                            child: _buildTextField(
                              controller: _emailController,
                              icon: Icons.email_outlined,
                              hintText: 'name@example.com',
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) {
                                if (v == null || v.isEmpty) return 'هذا الحقل مطلوب';
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) {
                                  return 'يرجى إدخال بريد إلكتروني صالح';
                                }
                                return null;
                              },
                              styles: styles,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // كلمة المرور
                          _buildFieldWrapper(
                            label: isEdit ? 'كلمة المرور الجديدة (اتركها فارغة للمحافظة عليها)' : 'كلمة المرور',
                            child: _buildTextField(
                              controller: _passwordController,
                              icon: Icons.lock_outline_rounded,
                              hintText: isEdit ? '••••••' : 'أدخل كلمة مرور قوية',
                              obscureText: true,
                              validator: (v) {
                                if (!isEdit && (v == null || v.isEmpty)) return 'هذا الحقل مطلوب';
                                if (v != null && v.isNotEmpty && v.length < 6) {
                                  return 'يجب ألا تقل كلمة المرور عن 6 أحرف';
                                }
                                return null;
                              },
                              styles: styles,
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // Section 2: البيانات الوظيفية
                          _buildSectionTitle('البيانات الوظيفية', Icons.work_rounded, styles),
                          const SizedBox(height: 16),

                          // القسم
                          _buildFieldWrapper(
                            label: 'القسم التابع له',
                            child: _buildTextField(
                              controller: _departmentController,
                              icon: Icons.business_outlined,
                              hintText: 'مثال: شؤون الطلاب، الهيئة التدريسية',
                              validator: (v) => v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
                              styles: styles,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // الدور وتاريخ التعيين
                          if (isMobile) ...[
                            _buildFieldWrapper(
                              label: 'الدور الوظيفي والصلاحية',
                              child: _buildDropdownField(isDark, styles),
                            ),
                            const SizedBox(height: 16),
                            _buildFieldWrapper(
                              label: 'تاريخ التعيين',
                              child: _buildDatePickerField(context, styles),
                            ),
                          ] else ...[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: _buildFieldWrapper(
                                    label: 'الدور الوظيفي والصلاحية',
                                    child: _buildDropdownField(isDark, styles),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildFieldWrapper(
                                    label: 'تاريخ التعيين',
                                    child: _buildDatePickerField(context, styles),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  // --- ACTIONS ---
                  _buildActions(isDark, styles, isMobile),
                ],
              ),
            ),
          ),
        ),
      ).animate().fade(duration: 300.ms).scale(
            begin: const Offset(0.95, 0.95),
            end: const Offset(1, 1),
            curve: Curves.easeOutBack,
          ),
    );
  }

  Widget _buildHeader(bool isDark, bool isEdit) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 24, 20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: context.styles.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isEdit ? Icons.edit_note_rounded : Icons.person_add_alt_1_rounded,
              color: context.styles.primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEdit ? 'تعديل بيانات الموظف' : 'إضافة موظف جديد',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isEdit ? 'قم بتحديث معلومات الموظف والصلاحيات' : 'أدخل البيانات الأساسية لإنشاء حساب موظف جديد',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close_rounded),
            style: IconButton.styleFrom(
              backgroundColor: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
              iconSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, ThemedTextStyles styles) {
    return Row(
      children: [
        Icon(icon, size: 18, color: styles.primaryColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: styles.primaryColor,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Divider(
            color: styles.primaryColor.withValues(alpha: 0.15),
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildFieldWrapper({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4, bottom: 8),
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        child,
      ],
    );
  }

  InputDecoration _getInputDecoration({
    required IconData prefixIcon,
    required String hintText,
    required bool isDark,
    required ThemedTextStyles styles,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        fontFamily: 'Cairo',
        fontSize: 13,
        color: isDark ? Colors.white38 : Colors.black38,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      filled: true,
      fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
      prefixIcon: Icon(
        prefixIcon,
        size: 20,
        color: styles.primaryColor.withValues(alpha: 0.7),
      ),
      suffixIcon: suffixIcon,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: styles.primaryColor,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: styles.errorColor,
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: styles.errorColor,
          width: 1.5,
        ),
      ),
      errorStyle: const TextStyle(
        fontFamily: 'Cairo',
        fontSize: 11,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    required ThemedTextStyles styles,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(fontFamily: 'Cairo', fontSize: 14),
      decoration: _getInputDecoration(
        prefixIcon: icon,
        hintText: hintText,
        isDark: isDark,
        styles: styles,
      ),
    );
  }

  Widget _buildDropdownField(bool isDark, ThemedTextStyles styles) {
    return DropdownButtonFormField<String>(
      initialValue: _selectedRole,
      onChanged: (val) {
        if (val != null) {
          setState(() => _selectedRole = val);
        }
      },
      dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      style: TextStyle(
        fontFamily: 'Cairo',
        fontSize: 14,
        color: isDark ? Colors.white : Colors.black87,
      ),
      decoration: _getInputDecoration(
        prefixIcon: Icons.shield_outlined,
        hintText: '',
        isDark: isDark,
        styles: styles,
      ),
      items: _roleTranslations.entries.map((e) {
        return DropdownMenuItem(
          value: e.key,
          child: Text(
            e.value,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 14,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDatePickerField(BuildContext context, ThemedTextStyles styles) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextFormField(
      controller: _hireDateController,
      readOnly: true,
      onTap: () => _selectDate(context),
      style: const TextStyle(fontFamily: 'Cairo', fontSize: 14),
      decoration: _getInputDecoration(
        prefixIcon: Icons.calendar_today_rounded,
        hintText: 'اختر تاريخ التعيين',
        isDark: isDark,
        styles: styles,
        suffixIcon: Icon(
          Icons.arrow_drop_down_rounded,
          color: styles.primaryColor.withValues(alpha: 0.7),
        ),
      ),
      validator: (v) => v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
    );
  }

  Widget _buildActions(bool isDark, ThemedTextStyles styles, bool isMobile) {
    final cancelBtn = OutlinedButton(
      onPressed: _isLoading ? null : () => Navigator.pop(context),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        side: BorderSide(
          color: isDark ? Colors.white10 : const Color(0xFFE2E8F0),
        ),
      ),
      child: Text(
        'إلغاء',
        style: TextStyle(
          fontFamily: 'Cairo',
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white70 : Colors.black87,
        ),
      ),
    );

    final submitBtn = ElevatedButton(
      onPressed: _isLoading ? null : _submit,
      style: ElevatedButton.styleFrom(
        backgroundColor: styles.primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 0,
      ),
      child: _isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Colors.white,
              ),
            )
          : Text(
              widget.employee == null ? 'إضافة الموظف' : 'حفظ التعديلات',
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: submitBtn,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: cancelBtn,
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                cancelBtn,
                const SizedBox(width: 12),
                submitBtn,
              ],
            ),
    );
  }
}
