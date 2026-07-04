import 'dart:async';

import 'package:finalproject/core/constants/app_constants.dart';
import 'package:finalproject/core/theme/theme_extination.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/HospitalTrainingGroups/data/hospital_training_group_model.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/HospitalTrainingGroups/presentation/manger/hospital_training_groups_cubit.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/HospitalTrainingGroups/presentation/manger/hospital_training_groups_state.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/data/model/student_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HospitalTrainingGroupForm extends StatefulWidget {
  final HospitalTrainingGroupsState state;

  const HospitalTrainingGroupForm({super.key, required this.state});

  @override
  State<HospitalTrainingGroupForm> createState() =>
      _HospitalTrainingGroupFormState();
}

class _HospitalTrainingGroupFormState extends State<HospitalTrainingGroupForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _studentSearchController = TextEditingController();
  Timer? _debounce;
  int? _hospitalId;
  int? _employeeId;
  int _academicYearId = AppConstants.academicYears.first.id;
  final List<StudentModeljd> _selectedStudents = [];

  @override
  void dispose() {
    _debounce?.cancel();
    _nameController.dispose();
    _studentSearchController.dispose();
    super.dispose();
  }

  String _studentName(StudentModeljd student) {
    final first = student.user?.firstName ?? '';
    final last = student.user?.lastName ?? '';
    return [
      first,
      student.fatherName,
      last,
    ].where((part) => part.trim().isNotEmpty).join(' ');
  }

  void _onStudentSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 450), () {
      context.read<HospitalTrainingGroupsCubit>().searchStudents(value);
    });
  }

  void _toggleStudent(StudentModeljd student) {
    setState(() {
      final exists = _selectedStudents.any((item) => item.id == student.id);
      if (exists) {
        _selectedStudents.removeWhere((item) => item.id == student.id);
      } else {
        _selectedStudents.add(student);
      }
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedStudents.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('اختر طالبة واحدة على الأقل')),
      );
      return;
    }

    final success = await context
        .read<HospitalTrainingGroupsCubit>()
        .createGroup(
          CreateHospitalTrainingGroupRequest(
            name: _nameController.text.trim(),
            hospitalId: _hospitalId!,
            academicYearId: _academicYearId,
            employeeId: _employeeId!,
            studentIds: _selectedStudents.map((student) => student.id).toList(),
          ),
        );

    if (success && mounted) {
      _formKey.currentState!.reset();
      _nameController.clear();
      _studentSearchController.clear();
      setState(() {
        _hospitalId = null;
        _employeeId = null;
        _academicYearId = AppConstants.academicYears.first.id;
        _selectedStudents.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final styles = context.styles;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final supervisors = widget.state.employees
        .where(
          (employee) =>
              employee.user.role == 'hospital_supervisor' ||
              employee.jobTitle == 'hospital_supervisor',
        )
        .toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xFFE5E7EB),
        ),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.groups_2_rounded, color: styles.primaryColor),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'إنشاء مجموعة تدريب',
                    style: styles.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            _textField(
              controller: _nameController,
              label: 'اسم المجموعة',
              icon: Icons.drive_file_rename_outline_rounded,
              validator: (value) =>
                  value == null || value.trim().isEmpty ? 'مطلوب' : null,
            ),
            const SizedBox(height: 14),
            _dropdown<int>(
              value: _hospitalId,
              label: 'المشفى',
              icon: Icons.local_hospital_outlined,
              hintText: widget.state.hospitals.isEmpty
                  ? 'لا توجد مشافي محملة'
                  : 'اختر المشفى',
              items: widget.state.hospitals
                  .map(
                    (hospital) => DropdownMenuItem(
                      value: hospital.id,
                      child: Text(hospital.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _hospitalId = value),
              validator: (value) => value == null ? 'اختر المشفى' : null,
            ),
            const SizedBox(height: 14),
            _dropdown<int>(
              value: _employeeId,
              label: 'مشرفة مشفى',
              icon: Icons.badge_outlined,
              hintText: supervisors.isEmpty
                  ? 'لا يوجد موظفون بدور مشرفة مشفى'
                  : 'اختر مشرفة المشفى',
              items: supervisors
                  .map(
                    (employee) => DropdownMenuItem(
                      value: employee.id,
                      child: Text(
                        '${employee.user.firstName} ${employee.user.lastName}',
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _employeeId = value),
              validator: (value) => value == null ? 'اختر المشرفة' : null,
            ),
            const SizedBox(height: 14),
            _dropdown<int>(
              value: _academicYearId,
              label: 'السنة الدراسية',
              icon: Icons.school_outlined,
              items: AppConstants.academicYears
                  .map(
                    (year) => DropdownMenuItem(
                      value: year.id,
                      child: Text(year.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _academicYearId = value);
                }
              },
            ),
            const SizedBox(height: 18),
            _textField(
              controller: _studentSearchController,
              label: 'بحث عن طالبة',
              icon: Icons.search_rounded,
              onChanged: _onStudentSearchChanged,
            ),
            const SizedBox(height: 10),
            _selectedStudentsWrap(styles),
            const SizedBox(height: 10),
            _studentsPicker(styles, isDark),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: widget.state.isSubmitting ? null : _submit,
                icon: widget.state.isSubmitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.add_rounded),
                label: const Text('إنشاء المجموعة'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _selectedStudentsWrap(dynamic styles) {
    if (_selectedStudents.isEmpty) {
      return Text(
        'لم يتم اختيار طالبات بعد',
        style: TextStyle(color: styles.textSecondaryColor, fontSize: 12),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _selectedStudents.map((student) {
        return InputChip(
          label: Text(_studentName(student)),
          onDeleted: () => _toggleStudent(student),
        );
      }).toList(),
    );
  }

  Widget _studentsPicker(dynamic styles, bool isDark) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 250),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xFFE5E7EB),
        ),
      ),
      child: widget.state.students.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'لا توجد نتائج للطالبات',
                  style: TextStyle(color: styles.textSecondaryColor),
                ),
              ),
            )
          : ListView.separated(
              shrinkWrap: true,
              itemCount: widget.state.students.length,
              separatorBuilder: (_, index) => Divider(
                height: 1,
                color: isDark ? Colors.white10 : const Color(0xFFE5E7EB),
              ),
              itemBuilder: (context, index) {
                final student = widget.state.students[index];
                final selected = _selectedStudents.any(
                  (item) => item.id == student.id,
                );
                return CheckboxListTile(
                  value: selected,
                  onChanged: (_) => _toggleStudent(student),
                  title: Text(
                    _studentName(student).isEmpty
                        ? 'طالبة #${student.id}'
                        : _studentName(student),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    student.nationalNumber,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                );
              },
            ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  Widget _dropdown<T>({
    required T? value,
    required String label,
    required IconData icon,
    required List<DropdownMenuItem<T>> items,
    required void Function(T?) onChanged,
    String? hintText,
    String? Function(T?)? validator,
  }) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      items: items,
      onChanged: onChanged,
      validator: validator,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
