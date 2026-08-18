import 'dart:async';

import 'package:finalproject/core/constants/api_endpoints.dart';
import 'package:finalproject/core/constants/app_constants.dart';
import 'package:finalproject/core/network/api_service.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/HospitalTrainingGroups/data/hospital_training_group_model.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/HospitalTrainingGroups/presentation/manger/hospital_training_groups_cubit.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/HospitalTrainingGroups/presentation/manger/hospital_training_groups_state.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/data/model/student_model.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/data/model/students_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class CreateTrainingGroupPage extends StatefulWidget {
  const CreateTrainingGroupPage({super.key});

  @override
  State<CreateTrainingGroupPage> createState() =>
      _CreateTrainingGroupPageState();
}

class _CreateTrainingGroupPageState extends State<CreateTrainingGroupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  int? _hospitalId;
  int? _employeeId;
  int _academicYearId = AppConstants.academicYears.first.id;
  final List<StudentModeljd> _selectedStudents = [];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _removeStudent(StudentModeljd student) {
    setState(() {
      _selectedStudents.removeWhere((s) => s.id == student.id);
    });
  }

  Future<void> _openSearchDialog() async {
    final returnedStudents = await showDialog<List<StudentModeljd>>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _AddStudentsDialog(
        academicYearId: _academicYearId,
        alreadySelected: _selectedStudents,
      ),
    );

    if (returnedStudents != null) {
      setState(() {
        // Replace the selected students with the ones returned from the dialog
        _selectedStudents.clear();
        _selectedStudents.addAll(returnedStudents);
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedStudents.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء اختيار طالبة واحدة على الأقل'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (_hospitalId == null || _employeeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء تعبئة جميع الحقول الأساسية'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final req = CreateHospitalTrainingGroupRequest(
      name: _nameController.text.trim(),
      hospitalId: _hospitalId!,
      academicYearId: _academicYearId,
      employeeId: _employeeId!,
      studentIds: _selectedStudents.map((s) => s.id).toList(),
    );

    final success = await context
        .read<HospitalTrainingGroupsCubit>()
        .createGroup(req);
    if (success && mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F6F9),
        appBar: AppBar(
          title: const Text('إنشاء مجموعة تدريب جديدة'),
          elevation: 0,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: BlocBuilder<HospitalTrainingGroupsCubit, HospitalTrainingGroupsState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Group Details Card ──
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF0D47A1,
                                  ).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.info_outline,
                                  color: Color(0xFF0D47A1),
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'البيانات الأساسية للمجموعة',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                    labelText: 'اسم المجموعة',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    prefixIcon: const Icon(Icons.groups),
                                  ),
                                  validator: (v) => v!.trim().isEmpty
                                      ? 'مطلوب إدخال اسم المجموعة'
                                      : null,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: DropdownButtonFormField<int>(
                                  value: _academicYearId,
                                  decoration: InputDecoration(
                                    labelText: 'السنة الدراسية',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    prefixIcon: const Icon(Icons.school),
                                  ),
                                  items: AppConstants.academicYears.map((year) {
                                    return DropdownMenuItem(
                                      value: year.id,
                                      child: Text(year.name),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    if (val != null) {
                                      setState(() {
                                        if (_academicYearId != val) {
                                          _academicYearId = val;
                                          _selectedStudents
                                              .clear(); // Clear basket on year change
                                        }
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<int>(
                                  value: _hospitalId,
                                  decoration: InputDecoration(
                                    labelText: 'المشفى المخصص',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.local_hospital,
                                    ),
                                  ),
                                  items: state.hospitals.map((h) {
                                    return DropdownMenuItem(
                                      value: h.id,
                                      child: Text(h.name),
                                    );
                                  }).toList(),
                                  validator: (v) => v == null ? 'مطلوب' : null,
                                  onChanged: (val) =>
                                      setState(() => _hospitalId = val),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: DropdownButtonFormField<int>(
                                  value: _employeeId,
                                  decoration: InputDecoration(
                                    labelText: 'المشرفة المسؤولة',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    prefixIcon: const Icon(Icons.person),
                                  ),
                                  items: state.employees.map((e) {
                                    return DropdownMenuItem(
                                      value: e.id,
                                      child: Text(e.user.firstName),
                                    );
                                  }).toList(),
                                  validator: (v) => v == null ? 'مطلوب' : null,
                                  onChanged: (val) =>
                                      setState(() => _employeeId = val),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Selected Students Basket ──
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.people_alt,
                                    color: Colors.orange,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'قائمة الطالبات المضافات للمجموعة',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'العدد: ${_selectedStudents.length}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton.icon(
                              onPressed: _openSearchDialog,
                              icon: const Icon(Icons.person_add),
                              label: const Text('إضافة طالبات'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0D47A1),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        if (_selectedStudents.isEmpty)
                          Container(
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.grey.shade300,
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'السلة فارغة. قم بالضغط على "إضافة طالبات" للبدء.',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          )
                        else
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade200),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _selectedStudents.length,
                              separatorBuilder: (_, __) =>
                                  const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final student = _selectedStudents[index];
                                final studentName = [
                                  student.user?.firstName ?? '',
                                  student.fatherName,
                                  student.user?.lastName ?? '',
                                ].where((s) => s.trim().isNotEmpty).join(' ');
                                final specializationName =
                                    student.specialization?.name ?? 'عام';
                                final yearName =
                                    student.academicYear?.name ??
                                    AppConstants.academicYears
                                        .firstWhere(
                                          (y) => y.id == student.academicYearId,
                                          orElse: () =>
                                              AppConstants.academicYears.first,
                                        )
                                        .name;

                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: const Color(0xFFE8EAF6),
                                    child: Text(
                                      '${index + 1}',
                                      style: const TextStyle(
                                        color: Color(0xFF3F51B5),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    studentName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'السنة: $yearName | الاختصاص: $specializationName | الرقم: ${student.nationalNumber}',
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                    ),
                                    onPressed: () => _removeStudent(student),
                                    tooltip: 'إزالة من السلة',
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ── Save Button ──
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: state.isSubmitting ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: state.isSubmitting
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'حفظ وإنشاء المجموعة',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// The Fast Search Dialog
// ─────────────────────────────────────────────────────────────────────────────
class _AddStudentsDialog extends StatefulWidget {
  final int academicYearId;
  final List<StudentModeljd> alreadySelected;

  const _AddStudentsDialog({
    required this.academicYearId,
    required this.alreadySelected,
  });

  @override
  State<_AddStudentsDialog> createState() => _AddStudentsDialogState();
}

class _AddStudentsDialogState extends State<_AddStudentsDialog> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  bool _isLoading = false;
  List<StudentModeljd> _searchResults = [];
  final List<StudentModeljd> _tempSelected = [];
  String _error = '';

  @override
  void initState() {
    super.initState();
    // Copy initially selected to temp list so checkboxes reflect current state
    _tempSelected.addAll(widget.alreadySelected);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _performSearch(query);
    });
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _isLoading = false;
        _error = '';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = '';
    });
    try {
      final apiService = GetIt.I<ApiService>();

      final endpoint = ApiEndpoints.studentsSearch;

      final queryParameters = <String, dynamic>{
        'page': 1,
        'per_page': 50,
        'filters[academic_year_id]': widget.academicYearId,
        'filters[first_name]': query.trim(),
      };

      final response = await apiService.get(
        endpoint,
        queryParameters: queryParameters,
      );

      var students = StudentsResponse.fromJson(response.data).students;

      if (mounted) {
        setState(() {
          _searchResults = students;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'حدث خطأ أثناء جلب البيانات.';
          _isLoading = false;
        });
      }
    }
  }

  void _toggleStudent(StudentModeljd student) {
    setState(() {
      if (_tempSelected.any((s) => s.id == student.id)) {
        _tempSelected.removeWhere((s) => s.id == student.id);
      } else {
        _tempSelected.add(student);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final yearName = AppConstants.academicYears
        .firstWhere((y) => y.id == widget.academicYearId)
        .name;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 600,
          height: 700,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'البحث عن طالبات',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'عرض نتائج: $yearName',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'ابحث بالاسم...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: _onSearchChanged,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _error.isNotEmpty
                    ? Center(
                        child: Text(
                          _error,
                          style: const TextStyle(color: Colors.red),
                        ),
                      )
                    : _searchController.text.trim().isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search,
                              size: 48,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'اكتب اسم الطالبة للبحث عنها...',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    : _searchResults.isEmpty
                    ? const Center(
                        child: Text(
                          'لا يوجد نتائج مطابقة.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.separated(
                        itemCount: _searchResults.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final student = _searchResults[index];
                          final isSelected = _tempSelected.any(
                            (s) => s.id == student.id,
                          );
                          final studentName = [
                            student.user?.firstName ?? '',
                            student.fatherName,
                            student.user?.lastName ?? '',
                          ].where((s) => s.trim().isNotEmpty).join(' ');

                          final specializationName =
                              student.specialization?.name ?? 'عام';
                          final studentYearName =
                              student.academicYear?.name ?? yearName;

                          return ListTile(
                            onTap: () => _toggleStudent(student),
                            leading: CircleAvatar(
                              backgroundColor: isSelected
                                  ? const Color(0xFF0D47A1)
                                  : Colors.grey.shade200,
                              child: Icon(
                                Icons.person,
                                color: isSelected ? Colors.white : Colors.grey,
                              ),
                            ),
                            title: Text(
                              studentName,
                              style: TextStyle(
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            subtitle: Text(
                              'السنة: $studentYearName | الاختصاص: $specializationName\nالرقم: ${student.nationalNumber ?? '-'}',
                            ),
                            isThreeLine: true,
                            trailing: Checkbox(
                              value: isSelected,
                              onChanged: (val) => _toggleStudent(student),
                              activeColor: const Color(0xFF0D47A1),
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'تم تحديد ${_tempSelected.length} طالبة',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0D47A1),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(_tempSelected);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D47A1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('تأكيد الإضافة'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
