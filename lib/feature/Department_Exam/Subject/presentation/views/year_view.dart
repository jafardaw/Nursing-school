import 'package:finalproject/core/constants/assets.dart';
import 'package:finalproject/core/constants/app_routes.dart';
import 'package:finalproject/core/services/navigation_service.dart';
import 'package:finalproject/core/di/service_locator.dart';
import 'package:finalproject/core/theme/theme_extination.dart';
import 'package:finalproject/feature/Department_Exam/Subject/data/subject_model.dart';
import 'package:finalproject/feature/Department_Exam/Subject/presentation/manger/get_cubit/get_all_subject_cubit.dart';
import 'package:finalproject/feature/Department_Exam/Subject/presentation/manger/get_cubit/get_all_subject_state.dart';
import 'package:finalproject/feature/Department_Exam/Subject/presentation/views/specializationdetailpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubjectsMainView extends StatefulWidget {
  const SubjectsMainView({super.key});

  @override
  State<SubjectsMainView> createState() => _SubjectsMainViewState();
}

class _SubjectsMainViewState extends State<SubjectsMainView> {
  int selectedYear = 1;
  late SubjectCubit _subjectCubit;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

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

  static const Map<int, List<Map<String, dynamic>>> _specializations = {
    4: [
      {
        "id": 1,
        "name": "توليد طبيعي",
        "image": AppAssets.imagechildbirthmedical,
      },
      {
        "id": 2,
        "name": "تخدير وإنعاش",
        "image": AppAssets.anesthesiamedicalequipment,
      },
      {"id": 3, "name": "غرف عمليات", "image": AppAssets.operatingroom},
    ],
    5: [
      {
        "id": 1,
        "name": "توليد طبيعي",
        "image": AppAssets.imagechildbirthmedical,
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _subjectCubit = sl<SubjectCubit>();
    _subjectCubit.getSubjects(yearId: selectedYear);
  }

  void _onYearChanged(int year) {
    setState(() {
      selectedYear = year;
      _searchQuery = "";
      _searchController.clear();
    });
    if (year < 4) _subjectCubit.getSubjects(yearId: year);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _subjectCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final styles = context.styles;

    return BlocProvider.value(
      value: _subjectCubit,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FD),
        body: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: _buildHeader(styles)),
              SliverToBoxAdapter(child: _buildYearSelector(styles)),
              const SliverToBoxAdapter(child: SizedBox(height: 10)),
              selectedYear < 4
                  ? _buildSubjectsContentSliver(styles)
                  : _buildSpecializationsGridSliver(styles),
            ],
          ),
        ),
      ),
    );
  }

  // ========== الهيدر العلوي مع شريط البحث ==========
  Widget _buildHeader(ThemedTextStyles styles) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "المواد والمناهج الدراسية",
                style: styles.headline2.copyWith(
                  color: const Color(0xFF1E293B),
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                selectedYear < 4
                    ? "تصفح المواد الدراسية المقررة لمختلف السنوات"
                    : "تصفح الاختصاصات والمواد التخصصية المتاحة",
                style: styles.bodyMedium.copyWith(
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
          if (selectedYear < 4)
            SizedBox(
              width: 320,
              child: TextField(
                controller: _searchController,
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
                decoration: InputDecoration(
                  hintText: "بحث عن مادة دراسية...",
                  hintStyle: styles.bodyMedium.copyWith(
                    color: styles.textHintColor,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: styles.primaryColor,
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.clear_rounded,
                            color: styles.textHintColor,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = "";
                            });
                          },
                        )
                      : null,
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: styles.primaryColor,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ========== شريط السنوات الأكاديمية ==========
  Widget _buildYearSelector(ThemedTextStyles styles) {
    final List<Map<String, String>> yearMeta = [
      {"name": "الأولى", "badge": "أساسي"},
      {"name": "الثانية", "badge": "تأسيسي"},
      {"name": "الثالثة", "badge": "توجيهي"},
      {"name": "الرابعة", "badge": "تخصصي"},
      {"name": "الخامسة", "badge": "تخرج"},
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: List.generate(5, (index) {
          final year = index + 1;
          final isSelected = selectedYear == year;
          final meta = yearMeta[index];

          return Expanded(
            child: GestureDetector(
              onTap: () => _onYearChanged(year),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                          colors: [styles.primaryColor, styles.secondaryColor],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: isSelected ? null : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: styles.primaryColor.withValues(alpha: 0.25),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "السنة",
                      style: styles.bodyXSmall.copyWith(
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.8)
                            : styles.textSecondaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      meta["name"]!,
                      style: styles.headline6.copyWith(
                        color: isSelected
                            ? Colors.white
                            : styles.textPrimaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.2)
                            : styles.primaryColor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        meta["badge"]!,
                        style: styles.bodyHint.copyWith(
                          color: isSelected
                              ? Colors.white
                              : styles.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ========== عرض المواد ==========
  Widget _buildSubjectsContentSliver(ThemedTextStyles styles) {
    return BlocBuilder<SubjectCubit, SubjectState>(
      builder: (context, state) {
        if (state is SubjectLoading) {
          return const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (state is SubjectSuccess) {
          if (state.subjects.isEmpty) {
            return SliverFillRemaining(
              child: _buildEmptyState("لا توجد مواد متاحة حالياً", styles),
            );
          }
          return _buildSubjectsGridSliver(state.subjects, styles);
        }
        if (state is SubjectFailure) {
          return SliverFillRemaining(
            child: _buildErrorState(state.message, styles),
          );
        }
        return const SliverToBoxAdapter(child: SizedBox());
      },
    );
  }

  Widget _buildSubjectsGridSliver(
    List<SubjectModel> subjects,
    ThemedTextStyles styles,
  ) {
    final filtered = subjects.where((sub) {
      return sub.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    if (filtered.isEmpty) {
      return SliverFillRemaining(
        child: _buildEmptyState("لم يتم العثور على مواد تطابق البحث", styles),
      );
    }

    final double width = MediaQuery.of(context).size.width;
    final int crossAxisCount = width > 1200 ? 4 : (width > 800 ? 3 : 2);

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.15,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final subject = filtered[index];
          final cardColor = _cardColors[index % _cardColors.length];
          final cardIcon = _subjectIcons[index % _subjectIcons.length];
          final stats = subject.statistics;

          return InkWell(
            borderRadius: BorderRadius.circular(20),
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
            child: Container(
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
                child: Stack(
                  children: [
                  // شريط جانبي جمالي ملون
                  Positioned(
                    top: 0,
                    bottom: 0,
                    right: 0,
                    width: 6,
                    child: Container(color: cardColor),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: cardColor.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(cardIcon, color: cardColor, size: 24),
                            ),
                            Row(
                              children: [
                                if (subject.isComprehensive)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
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
                                      horizontal: 8,
                                      vertical: 4,
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
                                const SizedBox(width: 6),
                                IconButton(
                                  constraints: const BoxConstraints(),
                                  padding: EdgeInsets.zero,
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
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          subject.name,
                          style: styles.headline6.copyWith(
                            color: const Color(0xFF1E293B),
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        // شريط الإحصائيات السريع في البطاقة
                        if (stats != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color(0xFFE2E8F0),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.trending_up_rounded,
                                      size: 14,
                                      color: stats.passRate >= 50
                                          ? const Color(0xFF10B981)
                                          : const Color(0xFFEF4444),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      "النجاح: ${stats.passRate.toStringAsFixed(0)}%",
                                      style: styles.bodyXSmall.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF334155),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "المتوسط: ${stats.avgMark.toStringAsFixed(1)}",
                                  style: styles.bodyXSmall.copyWith(
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "مادة رقم #${subject.id}",
                              style: styles.bodyXSmall.copyWith(
                                color: const Color(0xFF94A3B8),
                              ),
                            ),
                            Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 14,
                              color: cardColor.withValues(alpha: 0.6),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }, childCount: filtered.length),
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

  // ========== عرض الاختصاصات ==========
  Widget _buildSpecializationsGridSliver(ThemedTextStyles styles) {
    final specs = _specializations[selectedYear] ?? [];
    final double width = MediaQuery.of(context).size.width;
    final int crossAxisCount = width > 1200 ? 3 : (width > 800 ? 2 : 1);

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 0.9,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final spec = specs[index];
          final meta = _getSpecMetadata(spec['id'] ?? 0);

          return InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SpecializationDetailPage(
                    yearId: selectedYear,
                    specId: spec['id'],
                    specName: spec['name'],
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
                border: Border.all(color: const Color(0xFFF1F5F9)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // الخلفية المتدرجة مع الأيقونة الفخمة بدلاً من الصور
                  Expanded(
                    flex: 5,
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: meta["gradient"] as Gradient,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 12,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Icon(
                            meta["icon"] as IconData,
                            color: Colors.white,
                            size: 44,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // الاسم والوصف
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                spec['name'],
                                style: styles.headline5.copyWith(
                                  color: const Color(0xFF1E293B),
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "اضغط للاستعراض والتفاصيل الأكاديمية",
                                style: styles.bodyXSmall.copyWith(
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: (meta["color"] as Color).withValues(
                                    alpha: 0.08,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "تخصص علمي",
                                  style: styles.bodyHint.copyWith(
                                    color: meta["color"] as Color,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.arrow_back_ios_new_rounded,
                                size: 14,
                                color: meta["color"] as Color,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }, childCount: specs.length),
      ),
    );
  }

  // ========== حالات فارغة وخطأ ==========
  Widget _buildEmptyState(String msg, ThemedTextStyles styles) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.menu_book_rounded,
            size: 64,
            color: const Color(0xFFCBD5E1),
          ),
          const SizedBox(height: 16),
          Text(
            msg,
            style: styles.bodyLarge.copyWith(color: const Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error, ThemedTextStyles styles) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 64,
            color: Color(0xFFEF4444),
          ),
          const SizedBox(height: 16),
          Text(
            "حدث خطأ أثناء تحميل البيانات",
            style: styles.headline6.copyWith(color: const Color(0xFF1E293B)),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: styles.bodyMedium.copyWith(color: const Color(0xFFEF4444)),
          ),
        ],
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
              // الهيدر
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

              // شريط دائري لنسبة النجاح
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

              // شبكة الكروت الإحصائية (2x2)
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
