import 'dart:ui';
import 'package:finalproject/core/di/service_locator.dart';
import 'package:finalproject/core/theme/theme_extination.dart';
import 'package:finalproject/core/widgets/custom_confirm_dialog.dart';
import 'package:finalproject/core/widgets/empty_view_list.dart';
import 'package:finalproject/core/widgets/error_widget_view.dart';
import 'package:finalproject/core/widgets/show_snak_bar.dart';
import 'package:finalproject/core/widgets/small_button.dart';
import 'package:finalproject/feature/Department_Exam/Exam_Session/data/exam_session_model.dart';
import 'package:finalproject/feature/Department_Exam/Exam_Session/presentation/manger/exam_session_cubit.dart';
import 'package:finalproject/feature/Department_Exam/Exam_Session/presentation/manger/exam_session_state.dart';
import 'package:finalproject/feature/Department_Exam/Exam_Session/presentation/views/widget/add_edit_session_dialog.dart';
import 'package:finalproject/feature/Department_Exam/Exam_Session/presentation/views/widget/evaluate_promotions_dialog.dart';
import 'package:finalproject/feature/Department_Exam/Exam_Session/presentation/views/widget/session_statistics_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ExamSessionsPage extends StatefulWidget {
  const ExamSessionsPage({super.key});

  @override
  State<ExamSessionsPage> createState() => _ExamSessionsPageState();
}

class _ExamSessionsPageState extends State<ExamSessionsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  late final ExamSessionCubit _cubit;
  bool _isDeleting = false;
  bool _isLoaderOpen = false;

  @override
  void initState() {
    super.initState();
    _cubit = sl<ExamSessionCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cubit.fetchSessions();
    });
  }

  @override
  void dispose() {
    _dismissLoadingDialog();
    _searchController.dispose();
    _cubit.close();
    super.dispose();
  }

  void _showLoadingDialog(String message) {
    if (_isLoaderOpen) return;
    _isLoaderOpen = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return PopScope(
          canPop: false,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      context.styles.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    message,
                    style: context.styles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).then((_) {
      _isLoaderOpen = false;
    });
  }

  void _dismissLoadingDialog() {
    if (_isLoaderOpen) {
      Navigator.of(context, rootNavigator: true).pop();
      _isLoaderOpen = false;
    }
  }

  void _openAddEditDialog({ExamSessionModel? session}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: _cubit,
          child: BlocConsumer<ExamSessionCubit, ExamSessionState>(
            listener: (context, state) {
              if (state is ExamSessionActionSuccess) {
                Navigator.of(dialogContext).pop();
              }
            },
            builder: (context, state) {
              final isLoading = state is ExamSessionActionLoading;
              return AddEditSessionDialog(
                session: session,
                isLoading: isLoading,
                onSave: (name, academicYear, status) {
                  final finalStatus = status == 'inactive' ? 'closed' : status;
                  if (session == null) {
                    _cubit.createSession(
                      name: name,
                      academicYear: academicYear,
                      status: finalStatus,
                    );
                  } else {
                    _cubit.updateSession(
                      id: session.id,
                      name: name,
                      academicYear: academicYear,
                      status: finalStatus,
                    );
                  }
                },
              );
            },
          ),
        );
      },
    );
  }

  void _openEvaluatePromotionsDialog(ExamSessionModel session) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: _cubit,
          child: BlocConsumer<ExamSessionCubit, ExamSessionState>(
            listener: (context, state) {
              if (state is ExamSessionActionSuccess) {
                Navigator.of(dialogContext).pop();
              }
            },
            builder: (context, state) {
              final isLoading = state is ExamSessionActionLoading;
              return EvaluatePromotionsDialog(
                academicYear: session.academicYear,
                isLoading: isLoading,
                onSubmit: (studyYear, maxCarriedSubjects) {
                  _cubit.evaluateBulkPromotions(
                    studyYear: studyYear,
                    academicYear: session.academicYear,
                    maxCarriedSubjects: maxCarriedSubjects,
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  void _openStatisticsDialog(ExamSessionModel session) {
    showDialog(
      context: context,
      builder: (context) => SessionStatisticsDialog(session: session),
    );
  }

  void _deleteSession(ExamSessionModel session) {
    confirmDelete(context, () {
      setState(() {
        _isDeleting = true;
      });
      _cubit.deleteSession(session.id);
      Navigator.of(context, rootNavigator: true).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final styles = context.styles;
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return BlocProvider.value(
      value: _cubit,
      child: BlocListener<ExamSessionCubit, ExamSessionState>(
        listener: (context, state) {
          if (state is ExamSessionActionLoading) {
            if (_isDeleting) {
              _showLoadingDialog("جاري حذف الدورة الامتحانية...");
            }
          } else if (state is ExamSessionActionSuccess) {
            if (_isDeleting) {
              _dismissLoadingDialog();
              setState(() {
                _isDeleting = false;
              });
            }
            showWebBanner(context, state.message, type: BannerType.success);
          } else if (state is ExamSessionError) {
            if (_isDeleting) {
              _dismissLoadingDialog();
              setState(() {
                _isDeleting = false;
              });
            }
            showWebBanner(context, state.message, type: BannerType.error);
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF8F9FD),
          body: SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.only(
                    top: isDesktop ? 24 : 12,
                    left: isDesktop ? 24 : 12,
                    right: isDesktop ? 24 : 12,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: _buildHeaderSection(styles, isDesktop),
                  ),
                ),
                BlocBuilder<ExamSessionCubit, ExamSessionState>(
                  builder: (context, state) {
                    if (state is ExamSessionLoading &&
                        _cubit.sessions.isEmpty) {
                      return const SliverFillRemaining(
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (state is ExamSessionError && _cubit.sessions.isEmpty) {
                      return SliverFillRemaining(
                        child: ShowErrorWidgetView(
                          errorMessage: state.message,
                          showImage: false,
                          onRetry: () => _cubit.fetchSessions(),
                        ),
                      );
                    }

                    final List<ExamSessionModel> sessions = _cubit.sessions;
                    final filtered = sessions.where((sess) {
                      return sess.name.toLowerCase().contains(
                            _searchQuery.toLowerCase(),
                          ) ||
                          sess.academicYear.toLowerCase().contains(
                            _searchQuery.toLowerCase(),
                          );
                    }).toList();

                    return SliverMainAxisGroup(
                      slivers: [
                        if (sessions.isNotEmpty)
                          SliverPadding(
                            padding: EdgeInsets.only(
                              left: isDesktop ? 24 : 12,
                              right: isDesktop ? 24 : 12,
                              top: 20,
                            ),
                            sliver: SliverToBoxAdapter(
                              child: _buildOverviewKPIs(sessions),
                            ),
                          ),
                        if (filtered.isEmpty && sessions.isNotEmpty)
                          const SliverFillRemaining(
                            child: EmptyListViews(
                              text: 'لا توجد نتائج مطابقة للبحث',
                            ),
                          )
                        else if (filtered.isEmpty)
                          const SliverFillRemaining(
                            child: EmptyListViews(
                              text: 'لا يوجد دورات امتحانية حالياً',
                            ),
                          )
                        else
                          SliverPadding(
                            padding: EdgeInsets.only(
                              left: isDesktop ? 24 : 12,
                              right: isDesktop ? 24 : 12,
                              top: 20,
                              bottom: 24,
                            ),
                            sliver: SliverToBoxAdapter(
                              child: Container(
                                height: 600,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.02,
                                      ),
                                      blurRadius: 15,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                  border: Border.all(
                                    color: const Color(0xFFF1F5F9),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: _buildDataTable(filtered, styles),
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(ThemedTextStyles styles, bool isDesktop) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "إدارة الدورات الامتحانية",
              style: styles.headline2.copyWith(
                color: const Color(0xFF1E293B),
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "قم بإنشاء وتفعيل الدورات الامتحانية لإضافة امتحانات بداخلها",
              style: styles.bodyMedium.copyWith(color: const Color(0xFF64748B)),
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(
              width: 250,
              child: TextField(
                controller: _searchController,
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
                decoration: InputDecoration(
                  hintText: "بحث عن دورة...",
                  hintStyle: styles.bodyMedium.copyWith(
                    color: styles.textHintColor,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: styles.primaryColor,
                  ),
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
            const SizedBox(width: 12),
            smallButton(
              styles,
              () => _openAddEditDialog(),
              Icons.add,
              'دورة جديدة',
              styles.primaryColor,
              Colors.white,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOverviewKPIs(List<ExamSessionModel> sessions) {
    final activeCount = sessions.where((s) => s.status == 'active').length;
    int totalStudentsSum = 0;
    double passRateSum = 0;
    int validPassRateCount = 0;
    double maxMarkOverall = 0;

    for (var s in sessions) {
      final overview = s.statistics?.overview;
      if (overview != null) {
        totalStudentsSum += overview.totalStudents;
        if (overview.totalStudents > 0) {
          passRateSum += overview.passRate;
          validPassRateCount++;
        }
        if (overview.highestMark > maxMarkOverall) {
          maxMarkOverall = overview.highestMark;
        }
      }
    }

    final avgPassRate = validPassRateCount > 0
        ? (passRateSum / validPassRateCount)
        : 0.0;

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _buildKpiCard(
          title: "إجمالي الدورات",
          value: "${sessions.length}",
          subtitle: "$activeCount نشطة حالياً",
          icon: Icons.calendar_month_rounded,
          color: const Color(0xFF2563EB),
        ),
        _buildKpiCard(
          title: "إجمالي الطلاب بالدورات",
          value: "$totalStudentsSum",
          subtitle: "طالب مسجل",
          icon: Icons.groups_rounded,
          color: const Color(0xFF0D9488),
        ),
        _buildKpiCard(
          title: "متوسط معدل النجاح العام",
          value: "${avgPassRate.toStringAsFixed(1)}%",
          subtitle: "عبر كافة الدورات",
          icon: Icons.pie_chart_rounded,
          color: const Color(0xFF059669),
        ),
        _buildKpiCard(
          title: "أعلى درجة مسجلة",
          value: maxMarkOverall > 0
              ? "${maxMarkOverall.toStringAsFixed(0)}%"
              : "-",
          subtitle: "أعلى أداء طلابي",
          icon: Icons.emoji_events_rounded,
          color: const Color(0xFFD97706),
        ),
      ],
    );
  }

  Widget _buildKpiCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: 230,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable(
    List<ExamSessionModel> sessions,
    ThemedTextStyles styles,
  ) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.trackpad,
          PointerDeviceKind.stylus,
        },
      ),
      child: DataTable2(
        columnSpacing: 12,
        horizontalMargin: 12,
        minWidth: 850,
        headingRowHeight: 56,
        headingTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFF475569),
          fontSize: 14,
        ),
        headingRowColor: WidgetStateProperty.all(const Color(0xFFF8F9FD)),
        columns: const [
          DataColumn2(label: Text('رقم الدورة'), size: ColumnSize.S),
          DataColumn2(label: Text('اسم الدورة الامتحانية'), size: ColumnSize.L),
          DataColumn2(label: Text('السنة الدراسية'), size: ColumnSize.M),
          DataColumn2(label: Text('الحالة'), size: ColumnSize.S),
          DataColumn2(label: Text('الطلاب والنجاح'), size: ColumnSize.M),
          DataColumn2(label: Text('متوسط الدرجات'), size: ColumnSize.S),
          DataColumn2(label: Text('تاريخ الإنشاء'), size: ColumnSize.M),
          DataColumn2(
            label: Text('إجراءات'),
            size: ColumnSize.L,
            fixedWidth: 175,
          ),
        ],
        rows: sessions.map((session) => _buildDataRow(session, styles)).toList(),
      ),
    );
  }

  DataRow _buildDataRow(ExamSessionModel session, ThemedTextStyles styles) {
    final bool isActive = session.status == 'active';
    final bool isInactive = !isActive;
    final DateTime? createdDate = session.createdAt != null
        ? DateTime.tryParse(session.createdAt!)
        : null;
    final String formattedDate = createdDate != null
        ? "${createdDate.year}/${createdDate.month.toString().padLeft(2, '0')}/${createdDate.day.toString().padLeft(2, '0')} ${createdDate.hour.toString().padLeft(2, '0')}:${createdDate.minute.toString().padLeft(2, '0')}"
        : '-';

    final overview = session.statistics?.overview;

    return DataRow(
      cells: [
        DataCell(
          Text(
            "#${session.id}",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF475569),
            ),
          ),
        ),
        DataCell(
          Text(
            session.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
              fontSize: 14,
            ),
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: styles.primaryColor.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              session.academicYear,
              style: TextStyle(
                color: styles.primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isActive
                  ? const Color(0xFFDCFCE7)
                  : const Color(0xFFFEE2E2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              isActive ? 'نشطة' : 'غير نشطة',
              style: TextStyle(
                color: isActive
                    ? const Color(0xFF16A34A)
                    : const Color(0xFFDC2626),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
        DataCell(
          overview == null
              ? const Text('-', style: TextStyle(color: Color(0xFF94A3B8)))
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${overview.passed}/${overview.totalStudents}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color:
                            (overview.passRate >= 60
                                    ? const Color(0xFF10B981)
                                    : const Color(0xFFF59E0B))
                                .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${overview.passRate.toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: overview.passRate >= 60
                              ? const Color(0xFF059669)
                              : const Color(0xFFD97706),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
        DataCell(
          overview == null || overview.avgMark == 0
              ? const Text('-', style: TextStyle(color: Color(0xFF94A3B8)))
              : Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    overview.avgMark.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7C3AED),
                    ),
                  ),
                ),
        ),
        DataCell(
          Text(
            formattedDate,
            style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // زر عرض الإحصائيات الشاملة
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                icon: const Icon(
                  Icons.analytics_rounded,
                  size: 20,
                  color: Color(0xFF2563EB),
                ),
                tooltip: 'عرض الإحصائيات الشاملة',
                onPressed: () => _openStatisticsDialog(session),
              ),
              // زر ترفيع الطلاب (متاح فقط للدورات غير النشطة)
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                icon: Icon(
                  Icons.trending_up_rounded,
                  size: 20,
                  color: isInactive
                      ? const Color(0xFF4F46E5) // أرجواني تخصصي
                      : const Color(0xFFCBD5E1), // رمادي إذا كانت نشطة
                ),
                tooltip: isInactive
                    ? 'ترفيع الطلاب'
                    : 'الترفيع متاح فقط للدورات غير النشطة',
                onPressed: isInactive
                    ? () => _openEvaluatePromotionsDialog(session)
                    : null,
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                icon: const Icon(
                  Icons.edit_outlined,
                  size: 18,
                  color: Color(0xFF0EA5E9),
                ),
                tooltip: 'تعديل',
                onPressed: () => _openAddEditDialog(session: session),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  size: 18,
                  color: Color(0xFFEF4444),
                ),
                tooltip: 'حذف',
                onPressed: () => _deleteSession(session),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
