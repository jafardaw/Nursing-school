import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finalproject/core/theme/theme_extination.dart';
import 'package:finalproject/core/widgets/show_snak_bar.dart';
import 'package:finalproject/core/di/service_locator.dart';
import 'package:finalproject/feature/Department_Exam/Exam_Session/presentation/manger/exam_session_cubit.dart';
import 'package:finalproject/feature/Department_Exam/Exam_Session/presentation/manger/exam_session_state.dart';
import 'package:finalproject/feature/Department_Exam/Subject/repo/subject_repo.dart';
import '../../data/constants/default_schedule_data.dart';
import '../../data/model/exam_schedule_model.dart';
import '../manger/exam_schedule_cubit.dart';
import '../manger/exam_schedule_state.dart';
import 'widget/exam_schedule_header.dart';
import 'widget/exam_schedule_control_panel.dart';
import 'widget/exam_schedule_timeline.dart';
import 'widget/exam_schedule_subjects_pool.dart';

/// الصفحة الرئيسية لتنظيم الامتحانات (ExamSchedulePage)
///
/// الوظيفة:
/// هذه هي الصفحة الرئيسية لإدارة حالة جدول الامتحانات، وتعمل كمجمع للمكونات الفرعية:
/// 1. تقوم بالاتصال بـ Cubits الخاصة بالدورات والجدول.
/// 2. تجلب قائمة المواد من قاعدة البيانات عند فتح الصفحة لفك تشفير المعرفات.
/// 3. تعرض ترويسة الصفحة والتحكم ومخطط الأيام وسلة المواد بشكل موحد وتمرير كامل للشاشة.
class ExamSchedulePage extends StatefulWidget {
  const ExamSchedulePage({super.key});

  @override
  State<ExamSchedulePage> createState() => _ExamSchedulePageState();
}

class _ExamSchedulePageState extends State<ExamSchedulePage> {
  int? _selectedSessionId;
  DateTime? _startDate;
  DateTime? _endDate;

  String _searchQuery = '';
  String _selectedFilterYear = 'الكل';

  // قاموس محلي لحفظ أسماء المواد المجلوبة من الـ API ديناميكياً
  Map<int, String> _apiSubjectIdToName = {};
  bool _isLoadingSubjects = false;

  @override
  void initState() {
    super.initState();
    context.read<ExamScheduleCubit>().loadDefaultSchedule();
    _loadAllSubjectsFromApi();
  }

  // جلب كافة المواد من قاعدة البيانات ديناميكياً لتجنب مشكلة "مادة غير معروفة"
  Future<void> _loadAllSubjectsFromApi() async {
    if (mounted) {
      setState(() {
        _isLoadingSubjects = true;
      });
    }
    try {
      final subjectRepo = sl<SubjectRepository>();
      final results = await Future.wait([
        subjectRepo.searchSubjects(yearId: 1),
        subjectRepo.searchSubjects(yearId: 2),
        subjectRepo.searchSubjects(yearId: 3),
        subjectRepo.searchSubjects(yearId: 4, specId: 1),
        subjectRepo.searchSubjects(yearId: 4, specId: 2),
        subjectRepo.searchSubjects(yearId: 4, specId: 3),
        subjectRepo.searchSubjects(yearId: 5, specId: 1),
      ]);

      final Map<int, String> tempMap = {};
      for (final result in results) {
        for (final subject in result.subjects) {
          final specName = subject.specialization?.name ?? '';
          final yearName = subject.academicYear?.name ?? '';
          String suffix = '';
          if (specName.isNotEmpty) {
            suffix = "$yearName - $specName";
          } else if (yearName.isNotEmpty) {
            suffix = yearName;
          }
          tempMap[subject.id] = suffix.isNotEmpty
              ? "${subject.name} ($suffix)"
              : subject.name;
        }
      }

      if (mounted) {
        setState(() {
          _apiSubjectIdToName = tempMap;
          _isLoadingSubjects = false;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading subjects from API: $e');
      }
      if (mounted) {
        setState(() {
          _isLoadingSubjects = false;
        });
      }
    }
  }

  // الحصول على اسم المادة بناء على المعرف بالبحث في القاموس المجلوب أو القاموس الافتراضي
  String _getSubjectName(int id) {
    if (_apiSubjectIdToName.containsKey(id)) {
      return _apiSubjectIdToName[id]!;
    }
    if (DefaultScheduleData.subjectIdToName.containsKey(id)) {
      return DefaultScheduleData.subjectIdToName[id]!;
    }
    return "مادة رقم #$id"; // fallback لتسهيل التعرف بدلاً من "مادة غير معروفة"
  }

  // استخراج الدفعة (السنة والتخصص) من اسم المادة
  String _extractCohort(String name) {
    final start = name.indexOf('(');
    final end = name.indexOf(')');
    if (start != -1 && end != -1 && end > start) {
      return name.substring(start + 1, end).trim();
    }
    if (name.contains('الأولى') || name.contains('أولى')) return 'الأولى';
    if (name.contains('الثانية') || name.contains('ثانية')) return 'الثانية';
    if (name.contains('الثالثة') || name.contains('ثالثة')) return 'الثالثة';
    if (name.contains('الرابعة') || name.contains('رابعة')) {
      if (name.contains('تخدير')) return 'الرابعة - تخدير';
      if (name.contains('عمليات')) return 'الرابعة - غرف عمليات';
      if (name.contains('توليد')) return 'الرابعة - توليد';
      return 'الرابعة';
    }
    if (name.contains('الخامسة') || name.contains('خامسة')) {
      if (name.contains('توليد')) return 'الخامسة - توليد';
      return 'الخامسة';
    }
    return '';
  }

  // فحص التعارضات للامتحانات المجدولة في نفس اليوم
  Set<int> _calculateConflicts(List<ExamScheduleModel> schedules) {
    final Set<int> conflictingSubjectIds = {};

    // تصنيف الامتحانات حسب التاريخ
    final Map<String, List<ExamScheduleModel>> examsByDate = {};
    for (final exam in schedules) {
      examsByDate.putIfAbsent(exam.examDate, () => []).add(exam);
    }

    // فحص كل يوم على حدة
    for (final dayExams in examsByDate.values) {
      if (dayExams.length < 2) continue;

      // فحص كل تزاوج من الامتحانات لنفس اليوم
      for (int i = 0; i < dayExams.length; i++) {
        for (int j = i + 1; j < dayExams.length; j++) {
          final examA = dayExams[i];
          final examB = dayExams[j];

          // إذا كان الامتحانان لنفس المادة ومجدولين على التوازي فلا يعتبر تعارضاً
          if (examA.subjectId == examB.subjectId) continue;

          final nameA = _getSubjectName(examA.subjectId);
          final nameB = _getSubjectName(examB.subjectId);

          // استخراج الاسم الأساسي للمادة لمقارنة تشابه المادة وتخطي التوازي
          String getCoreName(String name) {
            return name.split('(').first.trim();
          }

          if (getCoreName(nameA) == getCoreName(nameB)) {
            continue; // تشابه المادة يعني أنهما نفس الامتحان يعقد بالتوازي
          }

          final cohortA = _extractCohort(nameA);
          final cohortB = _extractCohort(nameB);

          // تعارض إذا كانت المادتان لنفس الدفعة الدراسية (السنة والتخصص) في نفس اليوم (بغض النظر عن التوقيت)
          if (cohortA.isNotEmpty && cohortB.isNotEmpty && cohortA == cohortB) {
            conflictingSubjectIds.add(examA.subjectId);
            conflictingSubjectIds.add(examB.subjectId);
            continue; // تم رصد التعارض بالفعل لهذا الثنائي
          }

          // فحص تداخل الوقت للمواد من دفعات مختلفة
          if (_isTimeOverlapping(
            examA.startTime,
            examA.endTime,
            examB.startTime,
            examB.endTime,
          )) {
            // أي مادتين مختلفتين تتداخل أوقاتهما في نفس اليوم والتاريخ تعتبران في حالة تعارض تام
            conflictingSubjectIds.add(examA.subjectId);
            conflictingSubjectIds.add(examB.subjectId);
          }
        }
      }
    }
    return conflictingSubjectIds;
  }

  // فحص تداخل الوقت
  bool _isTimeOverlapping(
    String startA,
    String endA,
    String startB,
    String endB,
  ) {
    int toMinutes(String time) {
      final parts = time.split(':');
      if (parts.length < 2) return 0;
      final h = int.tryParse(parts[0]) ?? 0;
      final m = int.tryParse(parts[1]) ?? 0;
      return h * 60 + m;
    }

    final aMin = toMinutes(startA);
    final aMax = toMinutes(endA);
    final bMin = toMinutes(startB);
    final bMax = toMinutes(endB);

    return aMin < bMax && bMin < aMax;
  }

  @override
  Widget build(BuildContext context) {
    final styles = context.styles;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<ExamSessionCubit, ExamSessionState>(
      builder: (context, sessionState) {
        if (sessionState is ExamSessionLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (sessionState is ExamSessionError) {
          return Scaffold(
            body: Center(
              child: Text(
                'حدث خطأ أثناء تحميل الدورات الامتحانية: ${sessionState.message}',
                style: styles.headline6.copyWith(color: Colors.red),
              ),
            ),
          );
        }
        if (sessionState is ExamSessionLoaded) {
          final sessions = sessionState.sessions;
          if (sessions.isEmpty) {
            return const Scaffold(
              body: Center(
                child: Text('لا يوجد دورات امتحانية مسجلة في النظام حالياً.'),
              ),
            );
          }

          _selectedSessionId ??= sessions.first.id;

          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: styles.backgroundColor,
              body: BlocListener<ExamScheduleCubit, ExamScheduleState>(
                listener: (context, state) {
                  if (state is ExamScheduleSaveSuccess) {
                    showCustomSnackBar(
                      context,
                      state.message,
                      type: ToastType.success,
                    );
                  } else if (state is ExamScheduleSaveError) {
                    showCustomSnackBar(
                      context,
                      state.error,
                      type: ToastType.error,
                    );
                  }
                },
                child: BlocBuilder<ExamScheduleCubit, ExamScheduleState>(
                  builder: (context, state) {
                    final schedules = state.schedules;
                    final conflictingSubjectIds = _calculateConflicts(
                      schedules,
                    );

                    // فلترة المواد المتبقية في السلة اليمنى (المواد التي لم تُجدول بعد)
                    final scheduledSubjectIds = schedules
                        .map((e) => e.subjectId)
                        .toSet();

                    // دمج القاموس المجلوب مع الافتراضي لضمان تغطية كاملة
                    final allSubjectsMap = {
                      ...DefaultScheduleData.subjectIdToName,
                      ..._apiSubjectIdToName,
                    };

                    final remainingSubjects = allSubjectsMap.entries.where((
                      entry,
                    ) {
                      final name = entry.value;
                      final isScheduled = scheduledSubjectIds.contains(
                        entry.key,
                      );
                      final matchesSearch = name.contains(_searchQuery);
                      final matchesFilter =
                          _selectedFilterYear == 'الكل' ||
                          name.contains(_selectedFilterYear);
                      return !isScheduled && matchesSearch && matchesFilter;
                    }).toList();

                    return ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(
                        dragDevices: {
                          PointerDeviceKind.touch,
                          PointerDeviceKind.mouse,
                          PointerDeviceKind.trackpad,
                        },
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // القسم الأيسر (70%): الترويسة والتحكم والخط الزمني للأيام كلها قابلة للتمرير معاً
                            Expanded(
                              flex: 7,
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // ويدجت الترويسة المخصصة البديلة للـ AppBar
                                      ExamScheduleHeader(
                                        state: state,
                                        isDark: isDark,
                                        hasConflicts: conflictingSubjectIds.isNotEmpty,
                                        hasUnscheduledSubjects: allSubjectsMap.keys.any((id) => !scheduledSubjectIds.contains(id)),
                                      ),
                                      const SizedBox(height: 16),
                                      // ويدجت لوحة التحكم بالتاريخ والدورة الامتحانية
                                      ExamScheduleControlPanel(
                                        sessions: sessions,
                                        selectedSessionId: _selectedSessionId,
                                        startDate: _startDate,
                                        endDate: _endDate,
                                        isDark: isDark,
                                        onSessionChanged: (val) {
                                          if (val != null && val != _selectedSessionId) {
                                            setState(() {
                                              _selectedSessionId = val;
                                            });
                                            context.read<ExamScheduleCubit>().loadDefaultSchedule();
                                          }
                                        },
                                        onStartDateChanged: (val) {
                                          setState(() {
                                            _startDate = val;
                                            if (_endDate != null && val != null && _endDate!.isBefore(val)) {
                                              _endDate = val.add(const Duration(days: 14));
                                            }
                                          });
                                        },
                                        onEndDateChanged: (val) {
                                          setState(() {
                                            _endDate = val;
                                          });
                                        },
                                      ),
                                      const SizedBox(height: 16),
                                      ExamScheduleTimeline(
                                        startDate: _startDate,
                                        endDate: _endDate,
                                        schedules: schedules,
                                        conflictingSubjectIds: conflictingSubjectIds,
                                        selectedSessionId: _selectedSessionId!,
                                        isDark: isDark,
                                        getSubjectName: _getSubjectName,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // القسم الأيمن (30%): سلة المواد غير المجدولة (ثابتة وقابلة للتمرير بشكل مستقل)
                            Expanded(
                              flex: 3,
                              child: ExamScheduleSubjectsPool(
                                remainingSubjects: remainingSubjects,
                                searchQuery: _searchQuery,
                                selectedFilterYear: _selectedFilterYear,
                                isLoadingSubjects: _isLoadingSubjects,
                                isDark: isDark,
                                onSearchQueryChanged: (val) {
                                  setState(() {
                                    _searchQuery = val;
                                  });
                                },
                                onFilterYearChanged: (val) {
                                  setState(() {
                                    _selectedFilterYear = val;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
