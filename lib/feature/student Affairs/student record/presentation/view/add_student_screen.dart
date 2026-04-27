import 'package:finalproject/core/services/navigation_service.dart';
import 'package:finalproject/core/theme/theme_extination.dart';
import 'package:finalproject/feature/student%20Affairs/student%20record/data/model/create_student_request.dart';
import 'package:finalproject/feature/student%20Affairs/student%20record/presentation/manger/cubit/add_student_cubit.dart';
import 'package:finalproject/feature/student%20Affairs/student%20record/presentation/manger/cubit/add_student_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finalproject/core/constants/app_constants.dart';
import 'package:finalproject/core/utils/validators.dart';

import 'package:responsive_framework/responsive_framework.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _nationalNumberCtrl = TextEditingController();
  final _fingerprintCtrl = TextEditingController();
  final _fatherNameCtrl = TextEditingController();
  final _motherNameCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();
  final _placeOfBirthCtrl = TextEditingController();
  final _registryCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();

  // Dropdown values
  String _selectedGovernorate = AppConstants.governorates[0];
  String _selectedNationality = AppConstants.nationalities[0];
  String _selectedYear = AppConstants.academicYears[0];
  String _selectedStudyType = AppConstants.studyTypes[0];
  String _selectedHousingType = AppConstants.housingTypes[0];

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _nationalNumberCtrl.dispose();
    _fingerprintCtrl.dispose();
    _fatherNameCtrl.dispose();
    _motherNameCtrl.dispose();
    _dobCtrl.dispose();
    _placeOfBirthCtrl.dispose();
    _registryCtrl.dispose();
    _addressCtrl.dispose();
    _mobileCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final request = CreateStudentRequest(
        firstName: _firstNameCtrl.text,
        lastName: _lastNameCtrl.text,
        email: _emailCtrl.text,
        password: _passwordCtrl.text,
        nationalNumber: _nationalNumberCtrl.text,
        fingerprintId: _fingerprintCtrl.text,
        fatherName: _fatherNameCtrl.text,
        motherName: _motherNameCtrl.text,
        dob: _dobCtrl.text,
        placeOfBirth: _placeOfBirthCtrl.text,
        registryPlaceNum: _registryCtrl.text,
        address: _addressCtrl.text,
        governorateId: _getGovernorateId(),
        nationalId: _getNationalityId(),
        mobileNum: _mobileCtrl.text,
        studyType: _selectedStudyType,
        housingType: _selectedHousingType,
        academicYearId: _getYearId(),
      );

      context.read<AddStudentCubit>().createStudent(request);
    }
  }

  int _getGovernorateId() =>
      AppConstants.governorates.indexOf(_selectedGovernorate) + 1;
  int _getNationalityId() =>
      AppConstants.nationalities.indexOf(_selectedNationality) + 1;
  int _getYearId() => AppConstants.academicYears.indexOf(_selectedYear) + 1;

  @override
  Widget build(BuildContext context) {
    final styles = context.styles;
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F9),
      appBar: AppBar(
        title: const Text('تسجيل طالبة جديدة'),
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
      ),
      body: BlocListener<AddStudentCubit, AddStudentState>(
        listener: (context, state) {
          if (state is AddStudentSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: styles.successColor,
              ),
            );
            NavigationService.goBack(context);
          } else if (state is AddStudentError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: styles.errorColor,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isDesktop ? 32 : 16),
          child: Center(
            child: Container(
              width: isDesktop ? 900 : double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🟢 عنوان
                    Text(
                      'البيانات الشخصية',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF181C32),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 🟢 صفين جنب بعض
                    _buildRow(
                      _buildTextField(
                        'الاسم الأول',
                        _firstNameCtrl,
                        validator: Validators.required,
                      ),
                      _buildTextField(
                        'الاسم الأخير',
                        _lastNameCtrl,
                        validator: Validators.required,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildRow(
                      _buildTextField(
                        'البريد الإلكتروني',
                        _emailCtrl,
                        validator: Validators.email,
                      ),
                      _buildTextField(
                        'كلمة المرور',
                        _passwordCtrl,
                        obscure: true,
                        validator: (v) => Validators.password(v),
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildRow(
                      _buildTextField(
                        'الرقم الوطني',
                        _nationalNumberCtrl,
                        validator: Validators.required,
                      ),
                      _buildTextField(
                        'رقم البصمة',
                        _fingerprintCtrl,
                        validator: Validators.required,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildRow(
                      _buildTextField(
                        'اسم الأب',
                        _fatherNameCtrl,
                        validator: Validators.required,
                      ),
                      _buildTextField(
                        'اسم الأم',
                        _motherNameCtrl,
                        validator: Validators.required,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildRow(
                      _buildTextField(
                        'تاريخ الميلاد',
                        _dobCtrl,
                        hint: 'YYYY-MM-DD',
                      ),
                      _buildTextField('مكان الميلاد', _placeOfBirthCtrl),
                    ),
                    const SizedBox(height: 16),

                    _buildRow(
                      _buildTextField('رقم السجل', _registryCtrl),
                      _buildTextField(
                        'رقم الموبايل',
                        _mobileCtrl,
                        validator: Validators.required,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildTextField('العنوان', _addressCtrl),
                    const SizedBox(height: 24),

                    // 🟢 قوائم منسدلة
                    Text(
                      'معلومات إضافية',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF181C32),
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildRow(
                      _buildDropdown(
                        'المحافظة',
                        _selectedGovernorate,
                        AppConstants.governorates,
                        (v) => setState(() => _selectedGovernorate = v!),
                      ),
                      _buildDropdown(
                        'الجنسية',
                        _selectedNationality,
                        AppConstants.nationalities,
                        (v) => setState(() => _selectedNationality = v!),
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildRow(
                      _buildDropdown(
                        'السنة الدراسية',
                        _selectedYear,
                        AppConstants.academicYears,
                        (v) => setState(() => _selectedYear = v!),
                      ),
                      _buildDropdown(
                        'نوع الدراسة',
                        _selectedStudyType,
                        AppConstants.studyTypes,
                        (v) => setState(() => _selectedStudyType = v!),
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildDropdown(
                      'نوع السكن',
                      _selectedHousingType,
                      AppConstants.housingTypes,
                      (v) => setState(() => _selectedHousingType = v!),
                    ),
                    const SizedBox(height: 32),

                    // 🟢 زر الحفظ
                    BlocBuilder<AddStudentCubit, AddStudentState>(
                      builder: (context, state) {
                        final isLoading = state is AddStudentLoading;
                        return SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0D47A1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'حفظ',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ====== صف بحقلين ======
  Widget _buildRow(Widget child1, Widget child2) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    if (isDesktop) {
      return Row(
        children: [
          Expanded(child: child1),
          const SizedBox(width: 16),
          Expanded(child: child2),
        ],
      );
    }
    return Column(children: [child1, const SizedBox(height: 16), child2]);
  }

  // ====== حقل نصي ======
  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    String? hint,
    bool obscure = false,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: Color(0xFF3F4254),
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint ?? label,
            filled: true,
            fillColor: const Color(0xFFF5F8FA),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  // ====== قائمة منسدلة ======
  Widget _buildDropdown(
    String label,
    String value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: Color(0xFF3F4254),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F8FA),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            items: items
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(e, style: const TextStyle(fontSize: 14)),
                  ),
                )
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
