import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:finalproject/core/theme/theme_extination.dart';
import 'package:finalproject/core/widgets/show_snak_bar.dart';
import 'package:finalproject/core/utils/tafqeet_helper.dart';
import 'package:finalproject/feature/Department_Exam/Exam_Session/data/exam_session_model.dart';
import '../manger/marks_cubit.dart';
import '../manger/marks_state.dart';
import '../../data/model/eligible_student_model.dart';
import '../../data/model/save_mark_request.dart';

class MarksEntryPage extends StatefulWidget {
  final int subjectId;
  final String subjectName;

  const MarksEntryPage({
    super.key,
    required this.subjectId,
    required this.subjectName,
  });

  @override
  State<MarksEntryPage> createState() => _MarksEntryPageState();
}

class _MarksEntryPageState extends State<MarksEntryPage> {
  int? _selectedSessionId;
  int? _lastSessionId;

  // قائمة تتبع الأسطر قيد التعديل حالياً
  final Set<int> _editingStudentIds = {};

  // خرائط لحفظ الكنترولرات و FocusNodes بشكل ديناميكي لكل طالب
  final Map<int, TextEditingController> _markNumControllers = {};
  final Map<int, TextEditingController> _notesControllers = {};
  final Map<int, TextEditingController> _graceControllers = {};
  final Map<int, FocusNode> _markNumFocusNodes = {};
  final Map<int, FocusNode> _notesFocusNodes = {};
  final Map<int, FocusNode> _graceFocusNodes = {};
  final Map<int, bool> _approvedStates = {};
  final Map<int, String> _tafqeetTexts = {};

  @override
  void initState() {
    super.initState();
    // جلب الدورات الامتحانية بمجرد الدخول
    context.read<MarksCubit>().loadSessions();
  }

  @override
  void dispose() {
    _disposeSessionControllers();
    super.dispose();
  }

  void _disposeSessionControllers() {
    for (var controller in _markNumControllers.values) {
      controller.dispose();
    }
    for (var controller in _notesControllers.values) {
      controller.dispose();
    }
    for (var controller in _graceControllers.values) {
      controller.dispose();
    }
    for (var node in _markNumFocusNodes.values) {
      node.dispose();
    }
    for (var node in _notesFocusNodes.values) {
      node.dispose();
    }
    for (var node in _graceFocusNodes.values) {
      node.dispose();
    }
    _markNumControllers.clear();
    _notesControllers.clear();
    _graceControllers.clear();
    _markNumFocusNodes.clear();
    _notesFocusNodes.clear();
    _graceFocusNodes.clear();
    _approvedStates.clear();
    _tafqeetTexts.clear();
  }

  void _initializeControllers(List<EligibleStudentModel> students) {
    _disposeSessionControllers();
    _lastSessionId = _selectedSessionId;
    _editingStudentIds.clear();

    for (var student in students) {
      _markNumControllers[student.id] = TextEditingController(
        text: student.hasGrade ? (student.markNumber?.toString() ?? '') : '',
      );
      _notesControllers[student.id] = TextEditingController(
        text: student.hasGrade ? (student.notes ?? '') : '',
      );
      _graceControllers[student.id] = TextEditingController(
        text: student.hasGrade
            ? (student.graceMarksGranted?.toString() ?? '0')
            : '0',
      );
      _approvedStates[student.id] = student.hasGrade
          ? (student.isApproved ?? true)
          : true;
      _tafqeetTexts[student.id] = student.hasGrade
          ? (student.markText ?? '')
          : '';

      _markNumFocusNodes[student.id] = FocusNode();
      _notesFocusNodes[student.id] = FocusNode();
      _graceFocusNodes[student.id] = FocusNode();
    }
  }

  void _triggerSave(int studentId) {
    if (_selectedSessionId == null) return;

    final markNumStr = _markNumControllers[studentId]?.text.trim() ?? '';
    if (markNumStr.isEmpty) {
      showWebBanner(
        context,
        "الرجاء إدخال علامة أولاً قبل الحفظ",
        type: BannerType.error,
      );
      return;
    }

    final markNum = double.tryParse(markNumStr);
    if (markNum == null || markNum < 0 || markNum > 100) {
      showWebBanner(
        context,
        "يرجى إدخال علامة صحيحة بين 0 و 100",
        type: BannerType.error,
      );
      return;
    }

    final markText = _tafqeetTexts[studentId] ?? '';
    final notes = _notesControllers[studentId]?.text.trim();
    final graceMarks =
        double.tryParse(_graceControllers[studentId]?.text.trim() ?? '0') ??
        0.0;
    final isApproved = _approvedStates[studentId] ?? true;
    final finalStatus = markNum >= 50 ? 'Pass' : 'Fail';

    int? existingResultId;
    final cubitState = context.read<MarksCubit>().state;
    if (cubitState is MarksStudentsLoaded) {
      try {
        final student = cubitState.students.firstWhere(
          (s) => s.id == studentId,
        );
        existingResultId = student.resultId;
      } catch (_) {}
    }

    context.read<MarksCubit>().saveStudentMark(
      SaveMarkRequest(
        studentId: studentId,
        subjectId: widget.subjectId,
        examSessionId: _selectedSessionId!,
        markNumber: markNum,
        markText: markText,
        notes: notes,
        graceMarksGranted: graceMarks,
        finalStatus: finalStatus,
        isApproved: isApproved,
      ),
      resultId: existingResultId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final styles = context.styles;
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F8),
      body: SafeArea(
        child: BlocConsumer<MarksCubit, MarksState>(
          listener: (context, state) {
            if (state is MarksSessionsError) {
              showWebBanner(context, state.message, type: BannerType.error);
            }
            if (state is MarksStudentsError) {
              showWebBanner(context, state.message, type: BannerType.error);
            }
            if (state is MarksStudentsLoaded) {
              bool changed = false;
              for (var studentId in List<int>.from(_editingStudentIds)) {
                if (state.saveStatuses[studentId] == 'success') {
                  _editingStudentIds.remove(studentId);
                  changed = true;
                }
              }
              if (changed) {
                setState(() {});
              }
            }
          },
          builder: (context, state) {
            List<ExamSessionModel> sessions = [];
            if (state is MarksSessionsLoaded) {
              sessions = state.sessions;
            } else if (state is MarksStudentsLoading) {
              sessions = state.sessions;
            } else if (state is MarksStudentsLoaded) {
              sessions = state.sessions;
              // تهيئة الكنترولرات في حال لم يتم تهيئتها لهذه الدورة
              if (_lastSessionId != _selectedSessionId) {
                _initializeControllers(state.students);
              }
            } else if (state is MarksStudentsError) {
              sessions = state.sessions;
            }

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // 1. الهيدر العلوي
                SliverPadding(
                  padding: EdgeInsets.only(
                    top: isDesktop ? 24 : 12,
                    left: isDesktop ? 24 : 12,
                    right: isDesktop ? 24 : 12,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: _buildHeader(styles, isDesktop),
                  ),
                ),

                // 2. بطاقة تصفية الجلسة الامتحانية
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 24 : 12,
                    vertical: 12,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: _buildSessionSelector(
                      styles,
                      sessions,
                      state is MarksLoadingSessions,
                    ),
                  ),
                ),

                // 3. الجزء الرئيسي لعرض الطلاب وجدول الرصد
                _buildMainContent(state, styles, isDesktop),
              ],
            );
          },
        ),
      ),
    );
  }

  // الهيدر العلوي العصري
  Widget _buildHeader(ThemedTextStyles styles, bool isDesktop) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 24 : 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 81, 120, 182),
            Color.fromARGB(255, 35, 56, 104),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "رصد العلامات",
                  style: styles.headline5.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.subjectName,
                  style: styles.bodyMedium.copyWith(
                    color: const Color(0xFF94A3B8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.app_registration_rounded,
                  color: Color.fromARGB(255, 252, 254, 255),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  "مادة #${widget.subjectId}",
                  style: styles.bodySmall.copyWith(
                    color: const Color.fromARGB(255, 251, 251, 251),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // منسدل اختيار الدورة الامتحانية
  Widget _buildSessionSelector(
    ThemedTextStyles styles,
    List<ExamSessionModel> sessions,
    bool isLoading,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "الدورة الامتحانية",
            style: styles.bodyMedium.copyWith(
              color: const Color(0xFF475569),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          isLoading
              ? const SizedBox(
                  height: 48,
                  child: Center(child: CircularProgressIndicator()),
                )
              : DropdownButtonFormField<int>(
                  initialValue: _selectedSessionId,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
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
                  hint: Text(
                    "اختر الدورة الامتحانية للرصد...",
                    style: styles.bodyMedium.copyWith(
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: styles.primaryColor,
                  ),
                  items: sessions.map((session) {
                    return DropdownMenuItem<int>(
                      value: session.id,
                      child: Text(
                        "${session.name} (${session.academicYear})",
                        style: styles.bodyMedium.copyWith(
                          color: const Color(0xFF1E293B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null && value != _selectedSessionId) {
                      setState(() {
                        _selectedSessionId = value;
                      });
                      context.read<MarksCubit>().loadStudents(
                        sessionId: value,
                        subjectId: widget.subjectId,
                      );
                    }
                  },
                ),
        ],
      ),
    );
  }

  // بناء المحتوى الرئيسي بناءً على حالة التحميل
  Widget _buildMainContent(
    MarksState state,
    ThemedTextStyles styles,
    bool isDesktop,
  ) {
    if (_selectedSessionId == null) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: _buildInfoCard(
              styles,
              icon: Icons.info_outline_rounded,
              color: const Color(0xFF0284C7),
              title: "الرجاء تحديد دورة امتحانية",
              subtitle:
                  "اختر الدورة الامتحانية من القائمة المنسدلة في الأعلى لعرض وجلب الطالبات المسجلات وبدء رصد العلامات.",
            ),
          ),
        ),
      );
    }

    if (state is MarksStudentsLoading) {
      return const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (state is MarksStudentsError) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildInfoCard(
                styles,
                icon: Icons.error_outline_rounded,
                color: const Color(0xFFEF4444),
                title: "فشل تحميل البيانات",
                subtitle: state.message,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  context.read<MarksCubit>().loadStudents(
                    sessionId: _selectedSessionId!,
                    subjectId: widget.subjectId,
                  );
                },
                icon: const Icon(Icons.refresh_rounded),
                label: const Text("إعادة المحاولة"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: styles.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (state is MarksStudentsLoaded) {
      final students = state.students;
      if (students.isEmpty) {
        return SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: _buildInfoCard(
                styles,
                icon: Icons.people_outline_rounded,
                color: const Color(0xFFF59E0B),
                title: "لا يوجد طالبات مؤهلات",
                subtitle:
                    "لا توجد طالبات مسجلات لتقديم هذه المادة ضمن الدورة الامتحانية المختارة حالياً.",
              ),
            ),
          ),
        );
      }

      return SliverPadding(
        padding: EdgeInsets.only(
          left: isDesktop ? 24 : 12,
          right: isDesktop ? 24 : 12,
          bottom: 40,
        ),
        sliver: SliverToBoxAdapter(
          child: _buildGradeSheetTable(students, state, styles, isDesktop),
        ),
      );
    }

    return const SliverToBoxAdapter(child: SizedBox());
  }

  // بطاقة معلومات توضيحية فخمة
  Widget _buildInfoCard(
    ThemedTextStyles styles, {
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
  }) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 500),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 36),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: styles.headline6.copyWith(
              color: const Color(0xFF1E293B),
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: styles.bodyMedium.copyWith(
              color: const Color(0xFF64748B),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ورقة جدول إدخال العلامات الذكي
  Widget _buildGradeSheetTable(
    List<EligibleStudentModel> students,
    MarksStudentsLoaded state,
    ThemedTextStyles styles,
    bool isDesktop,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // عنوان الجدول الفني
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 18,
                  decoration: BoxDecoration(
                    color: styles.primaryColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "ورقة رصد العلامات الجماعية",
                  style: styles.bodyLarge.copyWith(
                    color: const Color(0xFF1E293B),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  "إجمالي الطالبات: ${students.length}",
                  style: styles.bodySmall.copyWith(
                    color: const Color(0xFF64748B),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          // جدول رصد العلامات التفاعلي
          SizedBox(
            height: (students.length * 72.0) + 70.0, // ارتفاع متكيف مناسب
            child: DataTable2(
              columnSpacing: 16,
              horizontalMargin: 20,
              minWidth: 1050,
              dataRowHeight: 68,
              headingRowHeight: 52,
              headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
              columns: [
                const DataColumn2(
                  label: Text('اسم الطالبة والشهادة'),
                  size: ColumnSize.L,
                ),
                const DataColumn2(
                  label: Text('العلامة رقمياً'),
                  size: ColumnSize.S,
                ),
                const DataColumn2(
                  label: Text('العلامة كتابةً'),
                  size: ColumnSize.L,
                ),
                const DataColumn2(label: Text('النتيجة'), size: ColumnSize.S),
                const DataColumn2(label: Text('المساعدة'), size: ColumnSize.S),
                const DataColumn2(
                  label: Text('ملاحظات المراجعة'),
                  size: ColumnSize.M,
                ),
                const DataColumn2(label: Text('الاعتماد'), size: ColumnSize.S),
                const DataColumn2(
                  label: Align(
                    alignment: Alignment.center,
                    child: Text('حالة الحفظ'),
                  ),
                  size: ColumnSize.S,
                ),
              ],
              rows: students.map((student) {
                return _buildStudentRow(student, state, styles);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // بناء السطر الفردي لكل طالب
  DataRow2 _buildStudentRow(
    EligibleStudentModel student,
    MarksStudentsLoaded state,
    ThemedTextStyles styles,
  ) {
    final saveStatus = state.saveStatuses[student.id] ?? 'idle';
    final errorMessage = state.errorMessages[student.id] ?? '';

    // تحديد ما إذا كان السطر قابلاً للتعديل حالياً
    final isEditing = _editingStudentIds.contains(student.id);
    final isEditable = !student.hasGrade || isEditing;

    // حساب حالة النجاح/الرسوب التلقائية
    final markNumStr = _markNumControllers[student.id]?.text ?? '';
    final markNum = double.tryParse(markNumStr);

    Widget statusChip;
    if (student.hasGrade && !isEditing) {
      statusChip = Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFE0F2FE),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          "مرصود",
          style: styles.bodyXSmall.copyWith(
            color: const Color(0xFF0369A1),
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      );
    } else if (markNumStr.isEmpty || markNum == null) {
      statusChip = Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          "غير مرصود",
          style: styles.bodyXSmall.copyWith(
            color: const Color(0xFF64748B),
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else {
      final isPass = markNum >= 48;
      statusChip = Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isPass ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          isPass ? "ناجح" : "راسب",
          style: styles.bodyXSmall.copyWith(
            color: isPass ? const Color(0xFF15803D) : const Color(0xFFB91C1C),
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return DataRow2(
      cells: [
        // 1. اسم الطالبة ورقمها
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      student.fullName,
                      style: styles.bodyMedium.copyWith(
                        color: (student.hasGrade && !isEditing)
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF1E293B),
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (student.hasGrade) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isEditing
                            ? const Color(0xFFFEF3C7)
                            : const Color(0xFFE0F2FE),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        isEditing ? "تعديل" : "مكتمل",
                        style: styles.bodyXSmall.copyWith(
                          color: isEditing
                              ? const Color(0xFFD97706)
                              : const Color(0xFF0369A1),
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 3),
              Text(
                "الرقم الجامعي: ${student.nationalNumber}",
                style: styles.bodyXSmall.copyWith(
                  color: const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ),

        // 2. حقل إدخال العلامة رقمياً
        DataCell(
          Container(
            width: 72,
            height: 40,
            alignment: Alignment.center,
            child: TextFormField(
              controller: _markNumControllers[student.id],
              focusNode: _markNumFocusNodes[student.id],
              enabled: isEditable,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              style: styles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: (student.hasGrade && !isEditing)
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF1E293B),
              ),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                filled: true,
                fillColor: (student.hasGrade && !isEditing)
                    ? const Color(0xFFF1F5F9)
                    : const Color(0xFFF8FAFC),
                hintText: student.hasGrade ? "مرصود" : "0",
                hintStyle: styles.bodyMedium.copyWith(
                  color: const Color(0xFFCBD5E1),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: styles.primaryColor,
                    width: 1.5,
                  ),
                ),
              ),
              onChanged: (val) {
                final doubleValue = double.tryParse(val) ?? 0.0;
                setState(() {
                  _tafqeetTexts[student.id] = TafqeetHelper.convert(
                    doubleValue,
                  );
                });
              },
            ),
          ),
        ),

        // 3. العلامة كتابةً تلقائياً
        DataCell(
          Text(
            (student.hasGrade && !isEditing)
                ? (student.markText ?? 'رُصِدت كتابةً')
                : (_tafqeetTexts[student.id] ?? ''),
            style: styles.bodyMedium.copyWith(
              color: (student.hasGrade && !isEditing)
                  ? const Color(0xFF94A3B8)
                  : const Color(0xFF475569),
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),

        // 4. النتيجة
        DataCell(statusChip),

        // 5. حقل علامة المساعدة
        DataCell(
          Container(
            width: 56,
            height: 40,
            alignment: Alignment.center,
            child: TextFormField(
              controller: _graceControllers[student.id],
              focusNode: _graceFocusNodes[student.id],
              enabled: isEditable,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              style: styles.bodySmall.copyWith(
                fontWeight: FontWeight.bold,
                color: (student.hasGrade && !isEditing)
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF1E293B),
              ),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                filled: true,
                fillColor: (student.hasGrade && !isEditing)
                    ? const Color(0xFFF1F5F9)
                    : const Color(0xFFF8FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: styles.primaryColor,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ),

        // 6. حقل ملاحظات المراجعة
        DataCell(
          Container(
            height: 40,
            alignment: Alignment.center,
            child: TextFormField(
              controller: _notesControllers[student.id],
              focusNode: _notesFocusNodes[student.id],
              enabled: isEditable,
              style: styles.bodySmall.copyWith(
                color: (student.hasGrade && !isEditing)
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF334155),
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                filled: true,
                fillColor: (student.hasGrade && !isEditing)
                    ? const Color(0xFFF1F5F9)
                    : const Color(0xFFF8FAFC),
                hintText: (student.hasGrade && !isEditing)
                    ? "لا يمكن التعديل"
                    : "أضف ملاحظة...",
                hintStyle: styles.bodySmall.copyWith(
                  color: const Color(0xFF94A3B8),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: styles.primaryColor,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ),

        // 7. زر التمرير للاعتماد
        DataCell(
          Center(
            child: Transform.scale(
              scale: 0.8,
              child: Switch(
                value: _approvedStates[student.id] ?? true,
                activeThumbColor: isEditable
                    ? styles.primaryColor
                    : const Color(0xFFCBD5E1),
                onChanged: isEditable
                    ? (val) {
                        setState(() {
                          _approvedStates[student.id] = val;
                        });
                      }
                    : null,
              ),
            ),
          ),
        ),

        // 8. مؤشار حالة الحفظ التلقائي في الخلفية
        DataCell(
          Center(
            child: _buildSaveStatusWidget(
              saveStatus,
              errorMessage,
              student.id,
              styles,
              student.hasGrade,
              isEditing,
            ),
          ),
        ),
      ],
    );
  }

  // بناء مؤشر الحفظ بالخلفية
  Widget _buildSaveStatusWidget(
    String status,
    String error,
    int studentId,
    ThemedTextStyles styles,
    bool hasGrade,
    bool isEditing,
  ) {
    if (hasGrade && !isEditing) {
      if (status == 'success') {
        return const Icon(
          Icons.check_circle_rounded,
          color: Colors.green,
          size: 22,
        );
      }
      return IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        icon: const Icon(
          Icons.mode_edit_outline_rounded,
          color: Color(0xFF0284C7),
          size: 22,
        ),
        tooltip: 'تعديل علامة الطالبة',
        onPressed: () {
          setState(() {
            _editingStudentIds.add(studentId);
          });
        },
      );
    }

    if (status == 'loading') {
      return const SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    if (status == 'success') {
      return const Icon(
        Icons.check_circle_rounded,
        color: Colors.green,
        size: 22,
      );
    }

    if (status == 'error') {
      return Tooltip(
        message: error.isNotEmpty ? error : "فشل في حفظ العلامة",
        child: IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: const Icon(
            Icons.error_outline_rounded,
            color: Colors.red,
            size: 22,
          ),
          onPressed: () => _triggerSave(studentId),
        ),
      );
    }

    // زر حفظ يدوي للأعلامة
    return IconButton(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      icon: Icon(
        Icons.check_circle_outline_rounded,
        color: styles.primaryColor,
        size: 22,
      ),
      tooltip: 'حفظ علامة الطالبة',
      onPressed: () => _triggerSave(studentId),
    );
  }
}
