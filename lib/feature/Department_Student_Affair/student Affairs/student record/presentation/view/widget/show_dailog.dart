import 'package:finalproject/core/constants/app_routes.dart';
import 'package:finalproject/core/services/navigation_service.dart';
import 'package:finalproject/core/theme/theme_extination.dart';
import 'package:finalproject/core/widgets/info_card_widget.dart';
import 'package:finalproject/core/widgets/small_button.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/data/model/student_model.dart';
import 'package:flutter/material.dart';

void showStudentDetails({
  required BuildContext context,
  required bool isActives,
  required StudentModeljd student,
  // required Widget despaywidget,
}) {
  final styles = context.styles;
  final isActive = isActives;

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: EdgeInsets.zero,
      content: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🟢 الهيدر - اسم الطالبة
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      child: Text(
                        // titleText,
                        student.user?.firstName.isNotEmpty == true
                            ? student.user!.firstName[0]
                            : '?',
                        style: styles.numberLarge,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // الاسم
                    Text(
                      // labiltext,
                      '${student.user?.firstName ?? ''} ${student.user?.lastName ?? ''}',
                      style: styles.numberMedium,
                    ),
                    const SizedBox(height: 4),

                    // الرقم الجامعي
                    Text(
                      // fintext,
                      student.userId.toString(),
                      style: styles.headline5,
                    ),
                  ],
                ),
              ),

              // 🟢 المحتوى - بطاقات المعلومات
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: buildInfoCard(
                            icon: Icons.fingerprint,
                            label: 'رقم الهوية',
                            value: student.nationalNumber,
                            color: const Color(0xFF0D47A1),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: buildInfoCard(
                            icon: Icons.phone_android,
                            label: 'الجوال',
                            value: student.mobileNum,
                            color: const Color(0xFF50CD89),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: buildInfoCard(
                            icon: Icons.email_outlined,
                            label: 'البريد',
                            value: student.user?.email ?? 'NA',
                            color: const Color(0xFF009EF7),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: buildInfoCard(
                            icon: Icons.school,
                            label: 'السنة الدراسية',
                            value: student.academicYear?.name ?? 'N/A',
                            color: const Color(0xFFFF9800),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: buildInfoCard(
                            icon: Icons.star,
                            label: 'المعدل التراكمي',
                            value: 'N/A',
                            color: const Color(0xFF9C27B0),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: buildInfoCard(
                            icon: Icons.event_busy,
                            label: 'أيام الغياب',
                            value: '0 أيام',
                            color: const Color(0xFFF1416C),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: buildInfoCard(
                            icon: Icons.description,
                            label: 'طلبات',
                            value: '1 طلبات',
                            color: const Color(0xFF607D8B),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: buildInfoCard(
                            icon: isActive ? Icons.check_circle : Icons.cancel,
                            label: 'الحالة',
                            value: isActive ? 'نشطة' : 'موقوفة',
                            color: isActive
                                ? const Color(0xFF50CD89)
                                : const Color(0xFFF1416C),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 🟢 الفوتر - أزرار
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    smallButton(
                      styles,
                      () {
                        NavigationService.pushTo(
                          context,
                          AppRoutes.updateStudentRoute,
                          extra: student,
                        );
                      },
                      Icons.edit,
                      'تعديل البيانات',
                      styles.primaryColor,
                      styles.whiteColor,
                    ),
                    // تعديل البيانات
                    smallButton(
                      styles,
                      () {
                        Navigator.pop(context);
                      },
                      Icons.add_circle_outline,
                      'طلب جديد',
                      styles.successColor,
                      styles.whiteColor,
                    ),

                    // تعديل البيانات
                    smallButton(
                      styles,
                      () {
                        NavigationService.pushTo(
                          context,
                          AppRoutes.addpenalites,
                          extra: student.id,
                        );
                      },
                      Icons.cancel_outlined,
                      'تسجيل انذار او غياب',
                      styles.errorColor,
                      styles.whiteColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
