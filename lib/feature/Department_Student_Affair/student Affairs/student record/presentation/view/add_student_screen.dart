import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

enum FingerprintState { waiting, scanning, success, error }

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  int _currentPage = 0;

  // Controllers
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _nationalNumberCtrl = TextEditingController();
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

  // Fingerprint State
  FingerprintState _scanState = FingerprintState.waiting;
  String _scanStatusMessage = 'جاري الاتصال بجهاز البصمة...';
  String? _scannedFingerprintId;
  bool _isScanActive = false;
  
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.95, end: 1.15).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
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
            // Auto submit after a tiny delay for user to see success
            await Future.delayed(const Duration(milliseconds: 600));
            if (mounted) _submit();
            return;
          }
        }
        
        // Fast retry if no fingerprint yet, increased to 1500ms to avoid overwhelming the C# Bridge
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
    if (_scannedFingerprintId == null) {
      showWebBanner(context, 'يجب قراءة البصمة أولاً', type: BannerType.error);
      return;
    }
    
    final request = CreateStudentRequest(
      firstName: _firstNameCtrl.text,
      lastName: _lastNameCtrl.text,
      email: _emailCtrl.text,
      password: _passwordCtrl.text,
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

    context.read<AddStudentCubit>().createStudent(request);
  }

  @override
  Widget build(BuildContext context) {
    final styles = context.styles;
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Scaffold(
      backgroundColor: styles.backgroundColor,
      appBar: AppBar(
        title: Text(_currentPage == 0 ? 'تسجيل طالبة جديدة (الخطوة 1)' : 'تسجيل طالبة جديدة (الخطوة 2)'),
        backgroundColor: styles.primaryColor,
        foregroundColor: styles.appBarColor,
        leading: _currentPage == 1 
            ? IconButton(
                icon: const Icon(Icons.arrow_back), 
                onPressed: _previousPage,
              )
            : const BackButton(),
      ),
      body: BlocListener<AddStudentCubit, AddStudentState>(
        listener: (context, state) {
          if (state is AddStudentSuccess) {
            showWebBanner(
              context,
              "تم تسجيل الطالبة وربط البصمة بنجاح",
              type: BannerType.success,
            );
            NavigationService.goBack(context);
          } else if (state is AddStudentError) {
            showWebBanner(
              context,
              "حدث خطأ أثناء حفظ بيانات الطالبة: ${state.message}",
              type: BannerType.error,
            );
            setState(() {
              _scanState = FingerprintState.success; 
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
                color: styles.backgroundColor,
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
            'البيانات الشخصية',
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
            buildTextField('كلمة المرور', _passwordCtrl, obscure: true, validator: (v) => Validators.password(v)),
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
          const SizedBox(height: 32),
          const Text(
            'معلومات إضافية',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF181C32),
            ),
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
          CustomButton(
            text: 'التالي: مسح البصمة',
            onTap: _nextPage,
            icon: Icons.arrow_forward_rounded,
            isLoading: false,
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
          'إضافة البصمة',
          style: styles.headline2.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF181C32),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'سيتم إنشاء حساب الطالبة تلقائياً بمجرد التقاط البصمة.',
          style: TextStyle(color: Colors.black54, fontSize: 14),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 50),
        
        // Fingerprint Animation UI
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
        
        // Status Message
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
        
        BlocBuilder<AddStudentCubit, AddStudentState>(
          builder: (context, state) {
            final isLoading = state is AddStudentLoading;
            
            if (isLoading) {
              return Column(
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  const Text('جاري إرسال البيانات وحفظ الطالبة...', style: TextStyle(color: Colors.black54)),
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
                text: state is AddStudentError ? 'إعادة محاولة الحفظ' : 'جاري الحفظ...',
                icon: Icons.save,
                onTap: state is AddStudentError ? _submit : null,
                isLoading: state is AddStudentLoading,
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
            label: const Text('العودة لتعديل البيانات'),
            style: TextButton.styleFrom(foregroundColor: Colors.black54),
          ),
      ],
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
