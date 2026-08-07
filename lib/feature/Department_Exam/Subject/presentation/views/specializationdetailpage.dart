import 'package:finalproject/core/di/service_locator.dart';
import 'package:finalproject/core/constants/app_routes.dart';
import 'package:finalproject/core/services/navigation_service.dart';
import 'package:finalproject/core/theme/theme_extination.dart';
import 'package:finalproject/feature/Department_Exam/Subject/data/subject_model.dart';
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
                return _buildSubjectCard(context, subject, index, styles);
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
    BuildContext context,
    SubjectModel subject,
    int index,
    ThemedTextStyles styles,
  ) {
    final cardColor = _cardColors[index % _cardColors.length];
    final cardIcon = _subjectIcons[index % _subjectIcons.length];
    final stats = subject.statistics;

    return InkWell(
      onTap: () {
        NavigationService.pushTo(
          context,
          AppRoutes.marksEntryRoute,
          extra: {
            'subject_id': subject.id,
            'subject_name': subject.name,
          },
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
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
                    padding: const EdgeInsets.symmetric(vertical: 14),
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
                        Row(
                          children: [
                            Text(
                              "مادة اختصاصية رقم #${subject.id}",
                              style: styles.bodyXSmall.copyWith(
                                color: const Color(0xFF94A3B8),
                              ),
                            ),
                            if (stats != null) ...[
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: const Color(0xFFE2E8F0)),
                                ),
                                child: Text(
                                  "النجاح: ${stats.passRate.toStringAsFixed(0)}%  |  المتوسط: ${stats.avgMark.toStringAsFixed(1)}",
                                  style: styles.bodyXSmall.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF475569),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // زر الإحصائيات
                IconButton(
                  tooltip: "عرض الإحصائيات التفصيلية",
                  icon: Icon(
                    Icons.analytics_rounded,
                    color: cardColor,
                    size: 22,
                  ),
                  onPressed: () {
                    _showSubjectStatisticsDialog(
                      context,
                      subject,
                      cardColor,
                      styles,
                    );
                  },
                ),
                const SizedBox(width: 8),
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
      ),
    );
  }

  // ========== نافذة الإحصائيات التفصيلية للمادة ==========
  void _showSubjectStatisticsDialog(
    BuildContext context,
    SubjectModel subject,
    Color cardColor,
    ThemedTextStyles styles,
  ) {
    final stats = subject.statistics ??
        SubjectStatistics(
          totalResults: 0,
          passed: 0,
          failed: 0,
          passRate: 0.0,
          avgMark: 0.0,
          highestMark: 0.0,
          lowestMark: 0.0,
        );

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        child: Container(
          width: 520,
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: cardColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.analytics_rounded, color: cardColor, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subject.name,
                          style: styles.headline5.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "تحليل الإحصائيات والنتائج الأكاديمية",
                          style: styles.bodySmall.copyWith(
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded, color: Color(0xFF64748B)),
                  ),
                ],
              ),
              const Divider(height: 32, color: Color(0xFFF1F5F9)),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardColor.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: cardColor.withValues(alpha: 0.12)),
                ),
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 72,
                          height: 72,
                          child: CircularProgressIndicator(
                            value: (stats.passRate / 100).clamp(0.0, 1.0),
                            backgroundColor: const Color(0xFFE2E8F0),
                            valueColor: AlwaysStoppedAnimation<Color>(cardColor),
                            strokeWidth: 8,
                          ),
                        ),
                        Text(
                          "${stats.passRate.toStringAsFixed(0)}%",
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: cardColor,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "نسبة النجاح العامة",
                            style: styles.headline6.copyWith(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD1FAE5),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  "ناجح: ${stats.passed}",
                                  style: styles.bodyXSmall.copyWith(
                                    color: const Color(0xFF065F46),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEE2E2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  "راسب: ${stats.failed}",
                                  style: styles.bodyXSmall.copyWith(
                                    color: const Color(0xFF991B1B),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 2.1,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                children: [
                  _buildStatMetricCard(
                    title: "إجمالي النتائج",
                    value: "${stats.totalResults}",
                    icon: Icons.people_outline_rounded,
                    color: const Color(0xFF4F46E5),
                    styles: styles,
                  ),
                  _buildStatMetricCard(
                    title: "متوسط الدرجات",
                    value: stats.avgMark.toStringAsFixed(1),
                    icon: Icons.calculate_outlined,
                    color: const Color(0xFF0EA5E9),
                    styles: styles,
                  ),
                  _buildStatMetricCard(
                    title: "أعلى درجة",
                    value: stats.highestMark.toStringAsFixed(1),
                    icon: Icons.vertical_align_top_rounded,
                    color: const Color(0xFF10B981),
                    styles: styles,
                  ),
                  _buildStatMetricCard(
                    title: "أدنى درجة",
                    value: stats.lowestMark.toStringAsFixed(1),
                    icon: Icons.vertical_align_bottom_rounded,
                    color: const Color(0xFFEF4444),
                    styles: styles,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required ThemedTextStyles styles,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: styles.bodyXSmall.copyWith(
                    color: const Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: styles.headline6.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
