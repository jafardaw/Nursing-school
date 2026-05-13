import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/data/model/create_student_request.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/data/model/student_model.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/presentation/manger/cubit/update_student_cubit.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/presentation/manger/cubit/update_student_state.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/presentation/view/add_student_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finalproject/core/constants/app_constants.dart';
import 'package:finalproject/core/services/navigation_service.dart';
import 'package:finalproject/core/theme/theme_extination.dart';
import 'package:finalproject/core/utils/validators.dart';
import 'package:finalproject/core/widgets/build_drop_down_list.dart';
import 'package:finalproject/core/widgets/custom_button.dart';
import 'package:finalproject/core/widgets/show_snak_bar.dart';
import 'package:responsive_framework/responsive_framework.dart';

class UpdateStudentScreen extends StatefulWidget {
  final StudentModeljd student;

  const UpdateStudentScreen({super.key, required this.student});

  @override
  State<UpdateStudentScreen> createState() => _UpdateStudentScreenState();
}

class _UpdateStudentScreenState extends State<UpdateStudentScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late final _firstNameCtrl = TextEditingController(text: widget.student.user?.firstName ?? '');
  late final _lastNameCtrl = TextEditingController(text: widget.student.user?.lastName ?? '');
  late final _emailCtrl = TextEditingController(text: widget.student.user?.email ?? '');
  final _passwordCtrl = TextEditingController();
  late final _nationalNumberCtrl = TextEditingController(text: widget.student.nationalNumber);
  late final _fingerprintCtrl = TextEditingController(text: widget.student.fingerprintId);
  late final _fatherNameCtrl = TextEditingController(text: widget.student.fatherName);
  late final _motherNameCtrl = TextEditingController(text: widget.student.motherName);
  late final _dobCtrl = TextEditingController(text: widget.student.dob);
  late final _placeOfBirthCtrl = TextEditingController(text: widget.student.placeOfBirth);
  late final _registryCtrl = TextEditingController(text: widget.student.registryPlaceNum);
  late final _addressCtrl = TextEditingController(text: widget.student.address);
  late final _mobileCtrl = TextEditingController(text: widget.student.mobileNum);

  // Dropdown values
  late ItemModel _selectedGovernorate;
  late ItemModel _selectedNationality;
  late ItemModel _selectedYear;
  late ItemModel _selectedStudyType;
  late ItemModel _selectedHousingType;

  @override
  void initState() {
    super.initState();
    _initDropdowns();
  }

  void _initDropdowns() {
    // 🟢 نختار القيم الحالية من بيانات الطالب
    _selectedGovernorate = AppConstants.governorates.firstWhere(
      (e) => e.id == widget.student.governorateId,
      orElse: () => AppConstants.governorates[0],
    );
    _selectedNationality = AppConstants.nationalities.firstWhere(
      (e) => e.id == widget.student.nationalId,
      orElse: () => AppConstants.nationalities[0],
    );
    _selectedYear = AppConstants.academicYears.firstWhere(
      (e) => e.id == widget.student.academicYearId,
      orElse: () => AppConstants.academicYears[0],
    );
    _selectedStudyType = AppConstants.studyTypes.firstWhere(
      (e) => e.name == widget.student.studyType,
      orElse: () => AppConstants.studyTypes[0],
    );
    _selectedHousingType = AppConstants.housingTypes.firstWhere(
      (e) => e.name == widget.student.housingType,
      orElse: () => AppConstants.housingTypes[0],
    );
  }

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
        password: _passwordCtrl.text.isNotEmpty ? _passwordCtrl.text : 'password',
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

      context.read<UpdateStudentCubit>().updateStudent(widget.student.id, request);
    }
  }

  @override
  Widget build(BuildContext context) {
    final styles = context.styles;
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Scaffold(
      backgroundColor: styles.backgroundColor,
      appBar: AppBar(
        title: const Text('تعديل بيانات الطالبة'),
        backgroundColor: styles.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: BlocListener<UpdateStudentCubit, UpdateStudentState>(
        listener: (context, state) {
          if (state is UpdateStudentSuccess) {
            showWebBanner(context, state.message, type: BannerType.success);
            NavigationService.goBack(context);
          } else if (state is UpdateStudentError) {
            showWebBanner(context, state.message, type: BannerType.error);
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isDesktop ? 32 : 16),
          child: Center(
            child: Container(
              width: isDesktop ? 900 : double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: styles.cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: styles.shadowColor,
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
                    Text(
                      'تعديل البيانات الشخصية',
                      style: styles.headline2.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF181C32),
                      ),
                    ),
                    const SizedBox(height: 24),

                    buildRow(
                      buildTextField('الاسم الأول', _firstNameCtrl, validator: Validators.required),
                      buildTextField('الاسم الأخير', _lastNameCtrl, validator: Validators.required),
                      context,
                    ),
                    const SizedBox(height: 16),

                    buildRow(
                      buildTextField('البريد الإلكتروني', _emailCtrl, validator: Validators.email),
                      buildTextField('كلمة المرور', _passwordCtrl, hint: 'اتركه فارغاً إذا لم ترغب بالتغيير'),
                      context,
                    ),
                    const SizedBox(height: 16),

                    buildRow(
                      buildTextField('الرقم الوطني', _nationalNumberCtrl, validator: Validators.required),
                      buildTextField('رقم البصمة', _fingerprintCtrl, validator: Validators.required),
                      context,
                    ),
                    const SizedBox(height: 16),

                    buildRow(
                      buildTextField('اسم الأب', _fatherNameCtrl, validator: Validators.required),
                      buildTextField('اسم الأم', _motherNameCtrl, validator: Validators.required),
                      context,
                    ),
                    const SizedBox(height: 16),

                    buildRow(
                      buildTextField('تاريخ الميلاد', _dobCtrl, hint: 'YYYY-MM-DD'),
                      buildTextField('مكان الميلاد', _placeOfBirthCtrl),
                      context,
                    ),
                    const SizedBox(height: 16),

                    buildRow(
                      buildTextField('رقم السجل', _registryCtrl),
                      buildTextField('رقم الموبايل', _mobileCtrl, validator: Validators.required),
                      context,
                    ),
                    const SizedBox(height: 16),

                    buildTextField('العنوان', _addressCtrl),
                    const SizedBox(height: 24),

                    Text(
                      'معلومات إضافية',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF181C32)),
                    ),
                    const SizedBox(height: 16),

                    buildRow(
                      buildDropdown('المحافظة', _selectedGovernorate, AppConstants.governorates, (v) => setState(() => _selectedGovernorate = v!)),
                      buildDropdown('الجنسية', _selectedNationality, AppConstants.nationalities, (v) => setState(() => _selectedNationality = v!)),
                      context,
                    ),
                    const SizedBox(height: 16),

                    buildRow(
                      buildDropdown('السنة الدراسية', _selectedYear, AppConstants.academicYears, (v) => setState(() => _selectedYear = v!)),
                      buildDropdown('نوع الدراسة', _selectedStudyType, AppConstants.studyTypes, (v) => setState(() => _selectedStudyType = v!)),
                      context,
                    ),
                    const SizedBox(height: 16),

                    buildDropdown('نوع السكن', _selectedHousingType, AppConstants.housingTypes, (v) => setState(() => _selectedHousingType = v!)),
                    const SizedBox(height: 32),

                    BlocBuilder<UpdateStudentCubit, UpdateStudentState>(
                      builder: (context, state) {
                        final isLoading = state is UpdateStudentLoading;
                        return CustomButton(
                          text: 'تحديث',
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