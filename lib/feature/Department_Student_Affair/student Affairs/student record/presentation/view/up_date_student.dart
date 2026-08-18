import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

class _UpdateStudentScreenState extends State<UpdateStudentScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  int _currentPage = 0;
  String? _scannedFingerprintId;
  String _scanStatusMessage = 'جاري الاتصال بجهاز البصمة...';
  bool _isScanActive = false;
  FingerprintState _scanState = FingerprintState.waiting;
  
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  // Controllers
  late final _firstNameCtrl = TextEditingController(text: widget.student.user?.firstName ?? '');
  late final _lastNameCtrl = TextEditingController(text: widget.student.user?.lastName ?? '');
  late final _emailCtrl = TextEditingController(text: widget.student.user?.email ?? '');
  final _passwordCtrl = TextEditingController();
  late final _nationalNumberCtrl = TextEditingController(text: widget.student.nationalNumber);
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
    _scannedFingerprintId = widget.student.fingerprintId; // Retain current fingerprint
    
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.95, end: 1.15).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
  }

  void _initDropdowns() {
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
    _isScanActive = false;
    _pulseCtrl.dispose();
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _nationalNumberCtrl.dispose();
    _fatherNameCtrl.dispose();
    _motherNameCtrl.dispose();
    _dobCtrl.dispose();
    _placeOfBirthCtrl.dispose();
    _registryCtrl.dispose();
    _addressCtrl.dispose();
    _mobileCtrl.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _currentPage = 1;
      });
      _startScanning();
    }
  }

  void _previousPage() {
    setState(() {
      _isScanActive = false;
      _currentPage = 0;
      _scanState = FingerprintState.waiting;
    });
  }

  Future<void> _startScanning() async {
    if (_isScanActive) return;
    setState(() {
      _isScanActive = true;
      _scanState = FingerprintState.scanning;
      _scanStatusMessage = 'الرجاء وضع إصبع الطالبة على جهاز البصمة...';
    });

    _performScanLoop();
  }

  Future<void> _performScanLoop() async {
    while (_isScanActive && mounted) {
      try {
        final response = await http
            .get(
              Uri.parse('http://localhost:5000/scan'),
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
            )
            .timeout(const Duration(seconds: 10));

        if (!mounted || !_isScanActive) return;

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          final rawId = data['fingerprint_id'];
          if (rawId != null) {
            setState(() {
              _scanState = FingerprintState.success;
              _scanStatusMessage = 'تم التقاط البصمة بنجاح ✅';
              _scannedFingerprintId = rawId.toString();
              _isScanActive = false; 
            });
            await Future.delayed(const Duration(milliseconds: 600));
            if (mounted) _submit();
            return;
          }
        }
        await Future.delayed(const Duration(milliseconds: 1500));
      } on TimeoutException {
        if (!mounted || !_isScanActive) return;
        continue;
      } catch (e) {
        if (!mounted || !_isScanActive) return;
        final errStr = e.toString().toLowerCase();
        
        setState(() {
          _scanState = FingerprintState.error;
          _isScanActive = false;
          if (errStr.contains('cors') || errStr.contains('xmlhttprequest') || errStr.contains('failed to fetch')) {
             _scanStatusMessage = 'خطأ CORS: يرجى التأكد من تشغيل Bridge مع تعطيل الحماية.';
          } else {
             _scanStatusMessage = 'لم يتم العثور على جهاز البصمة. تأكد من تشغيله وتوصيله بالكمبيوتر.';
          }
        });
        return; 
      }
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_scannedFingerprintId == null || _scannedFingerprintId!.isEmpty) {
        showWebBanner(context, 'لا يوجد رقم بصمة مسجل لهذه الطالبة', type: BannerType.error);
        return;
      }
      
      final request = CreateStudentRequest(
        firstName: _firstNameCtrl.text,
        lastName: _lastNameCtrl.text,
        email: _emailCtrl.text,
        password: _passwordCtrl.text.isNotEmpty ? _passwordCtrl.text : 'password',
        nationalNumber: _nationalNumberCtrl.text,
        fingerprintId: _scannedFingerprintId!,
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
        title: Text(_currentPage == 0 ? 'تعديل بيانات الطالبة' : 'تحديث بصمة الطالبة'),
        backgroundColor: styles.primaryColor,
        foregroundColor: Colors.white,
        leading: _currentPage == 1 
            ? IconButton(
                icon: const Icon(Icons.arrow_back), 
                onPressed: _previousPage,
              )
            : const BackButton(),
      ),
      body: BlocListener<UpdateStudentCubit, UpdateStudentState>(
        listener: (context, state) {
          if (state is UpdateStudentSuccess) {
            showWebBanner(context, state.message, type: BannerType.success);
            NavigationService.goBack(context);
          } else if (state is UpdateStudentError) {
            showWebBanner(context, state.message, type: BannerType.error);
            setState(() {
              if (_currentPage == 1) _scanState = FingerprintState.success; 
            });
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
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: _currentPage == 0 ? _buildFormStep(context) : _buildFingerprintStep(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormStep(BuildContext context) {
    final styles = context.styles;
    return Form(
      key: _formKey,
      child: Column(
        key: const ValueKey(0),
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
            buildTextField('رقم الموبايل', _mobileCtrl, validator: Validators.required),
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
            buildTextField('العنوان', _addressCtrl),
            context,
          ),
          const SizedBox(height: 24),

          const Text(
            'معلومات إضافية',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF181C32)),
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
              return Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'حفظ التعديلات الحالية',
                      onTap: isLoading ? null : _submit,
                      isLoading: isLoading,
                      icon: Icons.save,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomButton(
                      text: 'تعديل بصمة الطالبة',
                      onTap: isLoading ? null : _nextPage,
                      isLoading: false,
                      icon: Icons.fingerprint,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFingerprintStep(BuildContext context) {
    final styles = context.styles;
    Color statusColor = const Color(0xFF58A6FF);
    IconData statusIcon = Icons.fingerprint;
    
    if (_scanState == FingerprintState.success) {
      statusColor = const Color(0xFF3FB950);
      statusIcon = Icons.check_circle_rounded;
    } else if (_scanState == FingerprintState.error) {
      statusColor = const Color(0xFFF78166);
      statusIcon = Icons.error_outline_rounded;
    }

    return Column(
      key: const ValueKey(1),
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        Text(
          'تحديث البصمة',
          style: styles.headline2.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF181C32),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'سيتم تحديث بيانات الطالبة وتعيين رقم البصمة الجديد تلقائياً.',
          style: TextStyle(color: Colors.black54, fontSize: 14),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 50),
        
        SizedBox(
          height: 220,
          child: Center(
            child: _scanState == FingerprintState.scanning
                ? ScaleTransition(
                    scale: _pulseAnim,
                    child: Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            statusColor.withValues(alpha: 0.2),
                            statusColor.withValues(alpha: 0.05),
                          ],
                        ),
                      ),
                      child: Icon(statusIcon, size: 90, color: statusColor),
                    ),
                  )
                : Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: statusColor.withValues(alpha: 0.1),
                    ),
                    child: Icon(statusIcon, size: 90, color: statusColor),
                  ),
          ),
        ),
        const SizedBox(height: 30),
        
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            _scanStatusMessage,
            key: ValueKey(_scanStatusMessage),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        
        const SizedBox(height: 50),
        
        BlocBuilder<UpdateStudentCubit, UpdateStudentState>(
          builder: (context, state) {
            final isLoading = state is UpdateStudentLoading;
            
            if (isLoading) {
              return Column(
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  const Text('جاري إرسال البيانات وحفظ التعديلات...', style: TextStyle(color: Colors.black54)),
                ],
              );
            }

            if (_scanState == FingerprintState.error) {
              return CustomButton(
                text: 'إعادة المحاولة',
                icon: Icons.refresh_rounded,
                onTap: _startScanning,
                isLoading: false,
              );
            }

            if (_scanState == FingerprintState.success) {
               return CustomButton(
                text: state is UpdateStudentError ? 'إعادة محاولة الحفظ' : 'جاري الحفظ...',
                icon: Icons.save,
                onTap: state is UpdateStudentError ? _submit : null,
                isLoading: state is UpdateStudentLoading,
              );
            }

            return const SizedBox(height: 50); 
          },
        ),
        
        const SizedBox(height: 20),
        if (_scanState != FingerprintState.success && _scanState != FingerprintState.scanning)
          TextButton.icon(
            onPressed: _previousPage,
            icon: const Icon(Icons.arrow_back, size: 18),
            label: const Text('العودة لتعديل البيانات دون لمس البصمة'),
            style: TextButton.styleFrom(foregroundColor: Colors.black54),
          ),
      ],
    );
  }
}