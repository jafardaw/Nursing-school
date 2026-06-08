

import 'package:finalproject/core/constants/app_constants.dart';
import 'package:finalproject/core/services/navigation_service.dart';
import 'package:finalproject/core/theme/theme_extination.dart';
import 'package:finalproject/core/utils/validators.dart';
import 'package:finalproject/core/widgets/build_drop_down_list.dart';
import 'package:finalproject/core/widgets/custom_button.dart';
import 'package:finalproject/core/widgets/custome_text_field.dart';
import 'package:finalproject/core/widgets/show_snak_bar.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/data/model/create_student_request.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/presentation/manger/addstudent/add_student_cubit.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/presentation/manger/addstudent/add_student_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  ItemModel _selectedGovernorate = AppConstants.governorates[0];

  ItemModel _selectedNationality = AppConstants.nationalities[0];

  ItemModel _selectedYear = AppConstants.academicYears[0];
  ItemModel _selectedStudyType = AppConstants.studyTypes[0];
  ItemModel _selectedHousingType = AppConstants.housingTypes[0];

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
        governorateId: _selectedGovernorate.id,
        nationalId: _selectedNationality.id,
        mobileNum: _mobileCtrl.text,
        studyType: _selectedStudyType.name,
        housingType: _selectedHousingType.name,
        academicYearId: _selectedYear.id,
      );

      context.read<AddStudentCubit>().createStudent(request);
    }
  }

  @override
  Widget build(BuildContext context) {
    final styles = context.styles;
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Scaffold(
      backgroundColor: styles.backgroundColor,
      appBar: AppBar(
        title: const Text('تسجيل طالبة جديدة'),
        backgroundColor: styles.primaryColor,
        foregroundColor: styles.appBarColor,
      ),
      body: BlocListener<AddStudentCubit, AddStudentState>(
        listener: (context, state) {
          if (state is AddStudentSuccess) {
            showWebBanner(
              context,
              "تم تسجيل الطالب بنجاحq",
              type: BannerType.success,
            );
            NavigationService.goBack(context);
          } else if (state is AddStudentError) {
            showWebBanner(
              context,
              "حدث خطأ أثناء تسجيل الطالب: ${state.message}",
              type: BannerType.error,
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
                color: styles.backgroundColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
<<<<<<< HEAD
                    color: Colors.black.withValues(alpha: 0.04),
=======
                    color: styles.shadowColor,
>>>>>>> 6412f4fa982395c75bd0f3f5ce3a35521455c3d1
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
                      style: styles.headline2.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF181C32),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 🟢 صفين جنب بعض
                    buildRow(
                      buildTextField(
                        'الاسم الأول',
                        _firstNameCtrl,
                        validator: Validators.required,
                      ),
                      buildTextField(
                        'الاسم الأخير',
                        _lastNameCtrl,
                        validator: Validators.required,
                      ),
                      context,
                    ),

                    const SizedBox(height: 16),

                    buildRow(
                      buildTextField(
                        'البريد الإلكتروني',
                        _emailCtrl,
                        validator: Validators.email,
                      ),
                      buildTextField(
                        'كلمة المرور',
                        _passwordCtrl,
                        obscure: true,
                        validator: (v) => Validators.password(v),
                      ),
                      context,
                    ),
                    const SizedBox(height: 16),

                    buildRow(
                      buildTextField(
                        'الرقم الوطني',
                        _nationalNumberCtrl,
                        validator: Validators.required,
                      ),
                      buildTextField(
                        'رقم البصمة',
                        _fingerprintCtrl,
                        validator: Validators.required,
                      ),
                      context,
                    ),
                    const SizedBox(height: 16),

                    buildRow(
                      buildTextField(
                        'اسم الأب',
                        _fatherNameCtrl,
                        validator: Validators.required,
                      ),
                      buildTextField(
                        'اسم الأم',
                        _motherNameCtrl,
                        validator: Validators.required,
                      ),
                      context,
                    ),
                    const SizedBox(height: 16),

                    buildRow(
                      buildTextField(
                        'تاريخ الميلاد',
                        _dobCtrl,
                        hint: 'YYYY-MM-DD',
                      ),
                      buildTextField('مكان الميلاد', _placeOfBirthCtrl),
                      context,
                    ),
                    const SizedBox(height: 16),

                    buildRow(
                      buildTextField('رقم السجل', _registryCtrl),
                      buildTextField(
                        'رقم الموبايل',
                        _mobileCtrl,
                        validator: Validators.required,
                      ),
                      context,
                    ),
                    const SizedBox(height: 16),

                    buildTextField('العنوان', _addressCtrl),
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

                    buildRow(
                      buildDropdown(
                        'المحافظة',
                        _selectedGovernorate,
                        AppConstants.governorates,
                        (v) => setState(() => _selectedGovernorate = v!),
                      ),
                      buildDropdown(
                        'الجنسية',
                        _selectedNationality,
                        AppConstants.nationalities,
                        (v) => setState(() => _selectedNationality = v!),
                      ),
                      context,
                    ),
                    const SizedBox(height: 16),

                    buildRow(
                      buildDropdown(
                        'السنة الدراسية',
                        _selectedYear,
                        AppConstants.academicYears,
                        (v) => setState(() => _selectedYear = v!),
                      ),
                      buildDropdown(
                        'نوع الدراسة',
                        _selectedStudyType,
                        AppConstants.studyTypes,
                        (v) => setState(() => _selectedStudyType = v!),
                      ),
                      context,
                    ),
                    const SizedBox(height: 16),

                    buildDropdown(
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
                        return CustomButton(
                          text: 'حفظ',
                          onTap: isLoading ? null : _submit,
                          isLoading: isLoading,
                          icon: Icons.save,
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
}

// ====== صف بحقلين ======
Widget buildRow(Widget child1, Widget child2, BuildContext context) {
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
Widget buildTextField(
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
      CustomeTextField(
        controller: controller,
        obscureText: obscure,
        validator: validator,

        hintText: hint ?? label,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
      ),
    ],
  );
}
