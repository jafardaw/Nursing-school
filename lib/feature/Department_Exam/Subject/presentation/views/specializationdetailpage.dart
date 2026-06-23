import 'package:finalproject/core/di/service_locator.dart';
import 'package:finalproject/core/theme/app_colors.dart';
import 'package:finalproject/core/theme/theme_extination.dart';
import 'package:finalproject/feature/Department_Exam/Subject/presentation/manger/get_cubit/get_all_subject_cubit.dart';
import 'package:finalproject/feature/Department_Exam/Subject/presentation/manger/get_cubit/get_all_subject_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SpecializationDetailPage extends StatelessWidget {
  final int yearId;
  final int specId;
  final String specName;

  const SpecializationDetailPage({
    super.key,
    required this.yearId,
    required this.specId,
    required this.specName,
  });

  static const List<IconData> _subjectIcons = [
    Icons.biotech_rounded,
    Icons.healing_rounded,
    Icons.health_and_safety_rounded,
    Icons.menu_book_rounded,
    Icons.science_rounded,
    Icons.vaccines_rounded,
    Icons.psychology_rounded,
    Icons.diversity_3_rounded,
  ];

  static const List<Color> _cardColors = [
    Color(0xFF4F46E5), // Indigo
    Color(0xFF10B981), // Emerald
    Color(0xFFF59E0B), // Amber
    Color(0xFFEC4899), // Pink
    Color(0xFF8B5CF6), // Violet
    Color(0xFF0EA5E9), // Sky Blue
    Color(0xFF10B981), // Green
    Color(0xFFF97316), // Orange
  ];

  @override
  Widget build(BuildContext context) {
    final styles = context.styles;

    return BlocProvider(
      create: (context) =>
          sl<SubjectCubit>()..getSubjects(yearId: yearId, specId: specId),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FD), // خلفية ناعمة جداً
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // 1. هيدر فخم متفاعل مع السكرول
            _buildSliverAppBar(context),

            // 2. عنوان المحتوى
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 24,
                      decoration: BoxDecoration(
                        color: styles.primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "المواد الدراسية المقررة لهذا الاختصاص",
                      style: styles.headline5.copyWith(
                        color: const Color(0xFF1E293B),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 3. قائمة المواد
            _buildSubjectsList(styles),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _getSpecMetadata(int specId) {
    switch (specId) {
      case 1: // توليد طبيعي
        return {
          "icon": Icons.child_care_rounded,
          "gradient": const LinearGradient(
            colors: [Color(0xFFFDA4AF), Color(0xFFF43F5E)], // Rose to Dark Rose
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          "color": const Color(0xFFE11D48),
        };
      case 2: // تخدير وإنعاش
        return {
          "icon": Icons.monitor_heart_rounded,
          "gradient": const LinearGradient(
            colors: [
              Color(0xFF99F6E4),
              Color(0xFF0D9488),
            ], // Teal light to dark
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          "color": const Color(0xFF0F766E),
        };
      case 3: // غرف عمليات
        return {
          "icon": Icons.masks_rounded,
          "gradient": const LinearGradient(
            colors: [Color(0xFFBAE6FD), Color(0xFF0284C7)], // Sky light to dark
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          "color": const Color(0xFF0369A1),
        };
      default:
        return {
          "icon": Icons.school_rounded,
          "gradient": const LinearGradient(
            colors: [
              Color(0xFFC7D2FE),
              Color(0xFF4F46E5),
            ], // Indigo light to dark
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          "color": const Color(0xFF4338CA),
        };
    }
  }

  // تصميم الهيدر العلوي
  Widget _buildSliverAppBar(BuildContext context) {
    final meta = _getSpecMetadata(specId);
    final cardColor = meta["color"] as Color;

    return SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: cardColor,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          specName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            // خلفية بتدرج لوني
            Container(
              decoration: BoxDecoration(gradient: meta["gradient"] as Gradient),
            ),
            // أشكال هندسية خفيفة للزينة
            Positioned(
              top: -30,
              right: -30,
              child: CircleAvatar(
                radius: 100,
                backgroundColor: Colors.white.withValues(alpha: 0.04),
              ),
            ),
            Positioned(
              bottom: -20,
              left: -20,
              child: CircleAvatar(
                radius: 80,
                backgroundColor: Colors.white.withValues(alpha: 0.03),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    meta["icon"] as IconData,
                    color: Colors.white.withValues(alpha: 0.25),
                    size: 56,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "الخطة الدراسية الخاصة بالاختصاص",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // بناء قائمة المواد باستخدام BlocBuilder
  Widget _buildSubjectsList(ThemedTextStyles styles) {
    return BlocBuilder<SubjectCubit, SubjectState>(
      builder: (context, state) {
        if (state is SubjectLoading) {
          return const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (state is SubjectSuccess) {
          if (state.subjects.isEmpty) {
            return const SliverFillRemaining(
              child: Center(
                child: Text("لا توجد مواد مضافة لهذا الاختصاص حالياً"),
              ),
            );
          }
          return SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final subject = state.subjects[index];
                return _buildSubjectCard(subject, index, styles);
              }, childCount: state.subjects.length),
            ),
          );
        } else if (state is SubjectFailure) {
          return SliverFillRemaining(
            child: Center(child: Text("حدث خطأ: ${state.message}")),
          );
        }
        return const SliverToBoxAdapter(child: SizedBox());
      },
    );
  }

  // تصميم بطاقة المادة بشكل احترافي
  Widget _buildSubjectCard(
    dynamic subject,
    int index,
    ThemedTextStyles styles,
  ) {
    final cardColor = _cardColors[index % _cardColors.length];
    final cardIcon = _subjectIcons[index % _subjectIcons.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // شريط جانبي ملون جمالي
              Container(width: 6, color: cardColor),
              const SizedBox(width: 16),
              // أيقونة المادة
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cardColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(cardIcon, color: cardColor, size: 24),
                ),
              ),
              const SizedBox(width: 16),
              // اسم المادة وتفاصيلها
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        subject.name,
                        style: styles.headline6.copyWith(
                          color: const Color(0xFF1E293B),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "مادة اختصاصية رقم #${subject.id}",
                        style: styles.bodyXSmall.copyWith(
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // شارة شامل أو فصلي
              if (subject.isComprehensive)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "شامل",
                    style: styles.bodyHint.copyWith(
                      color: const Color(0xFFD97706),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "فصلي",
                    style: styles.bodyHint.copyWith(
                      color: const Color(0xFF64748B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              const SizedBox(width: 16),
              // سهم الانتقال
              Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 14,
                color: cardColor.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ),
    );
  }
}
