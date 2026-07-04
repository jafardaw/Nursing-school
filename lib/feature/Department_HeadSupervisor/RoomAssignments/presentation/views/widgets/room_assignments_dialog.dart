import 'package:finalproject/core/widgets/empty_view_list.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/Dormitory/data/dorm_room_model.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/data/model/student_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/room_assignment_model.dart';
import '../../manger/room_assignment_cubit.dart';
import '../../manger/room_assignment_state.dart';
import '../../manger/room_assignment_students_cubit.dart';
import '../../manger/room_assignment_students_state.dart';

class RoomAssignmentsDialog extends StatefulWidget {
  final DormRoomModel room;

  const RoomAssignmentsDialog({super.key, required this.room});

  @override
  State<RoomAssignmentsDialog> createState() => _RoomAssignmentsDialogState();
}

class _RoomAssignmentsDialogState extends State<RoomAssignmentsDialog> {
  final _formKey = GlobalKey<FormState>();
  final _studentSearchController = TextEditingController();
  final _checkInDateController = TextEditingController();
  StudentModeljd? _selectedStudent;

  @override
  void initState() {
    super.initState();
    _checkInDateController.text = _formatDate(DateTime.now());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RoomAssignmentCubit>().loadRoomAssignments(widget.room.id);
      context.read<RoomAssignmentStudentsCubit>().loadStudents();
    });
  }

  @override
  void dispose() {
    _studentSearchController.dispose();
    _checkInDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 920,
          maxHeight: MediaQuery.of(context).size.height * 0.86,
        ),
        child: BlocConsumer<RoomAssignmentCubit, RoomAssignmentState>(
          listener: (context, state) {
            if (state is RoomAssignmentLoaded && state.successMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.successMessage!),
                  backgroundColor: const Color(0xFF50CD89),
                ),
              );
              context.read<RoomAssignmentCubit>().clearSuccessMessage();
              setState(() {
                _selectedStudent = null;
                _studentSearchController.clear();
              });
              context.read<RoomAssignmentStudentsCubit>().loadStudents();
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                _Header(room: widget.room),
                const Divider(height: 1),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRoomSummary(),
                        const SizedBox(height: 18),
                        _buildCreateForm(state),
                        const SizedBox(height: 22),
                        _buildAssignmentsList(state),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildRoomSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          _SummaryChip(
            icon: Icons.meeting_room_outlined,
            label: 'الغرفة',
            value: widget.room.roomNumber,
          ),
          const SizedBox(width: 12),
          _SummaryChip(
            icon: Icons.layers_outlined,
            label: 'الطابق',
            value: '${widget.room.floorNumber}',
          ),
          const SizedBox(width: 12),
          _SummaryChip(
            icon: Icons.people_outline,
            label: 'السعة',
            value: '${widget.room.capacity}',
          ),
          const SizedBox(width: 12),
          _SummaryChip(
            icon: Icons.info_outline,
            label: 'الحالة',
            value: widget.room.status,
          ),
        ],
      ),
    );
  }

  Widget _buildCreateForm(RoomAssignmentState state) {
    final isSubmitting = state is RoomAssignmentLoaded && state.isSubmitting;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.person_add_alt_1, color: Color(0xFF6366F1)),
                SizedBox(width: 8),
                Text(
                  'إضافة طالبة للغرفة',
                  style: TextStyle(
                    color: Color(0xFF1E293B),
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _StudentPicker(
                    searchController: _studentSearchController,
                    selectedStudent: _selectedStudent,
                    onSearchChanged: context
                        .read<RoomAssignmentStudentsCubit>()
                        .searchByFirstName,
                    onStudentSelected: (student) {
                      setState(() => _selectedStudent = student);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _textField(
                    controller: _checkInDateController,
                    label: 'تاريخ الدخول',
                    icon: Icons.event_available_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: isSubmitting ? null : _submit,
                    icon: isSubmitting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.add_task_outlined),
                    label: const Text('تسكين'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignmentsList(RoomAssignmentState state) {
    if (state is RoomAssignmentLoading || state is RoomAssignmentInitial) {
      return const SizedBox(
        height: 220,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (state is RoomAssignmentError) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF1F2),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          state.message,
          style: const TextStyle(
            color: Color(0xFFB91C1C),
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    final assignments = state is RoomAssignmentLoaded
        ? state.assignments
        : <RoomAssignmentModel>[];

    if (assignments.isEmpty) {
      return const SizedBox(
        height: 260,
        child: EmptyListViews(
          text: 'لا توجد طالبات مسكنات في هذه الغرفة حالياً',
          iconData: Icons.people_outline,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الطالبات في الغرفة (${assignments.length})',
          style: const TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...assignments.map((assignment) {
          return _AssignmentTile(assignment: assignment);
        }),
      ],
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedStudent == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('اختر طالبة قبل تنفيذ التسكين'),
          backgroundColor: Color(0xFFF1416C),
        ),
      );
      return;
    }

    context.read<RoomAssignmentCubit>().createAssignment(
      CreateRoomAssignmentRequest(
        studentId: _selectedStudent!.id,
        roomId: widget.room.id,
        checkInDate: _checkInDateController.text.trim(),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }
}

class _StudentPicker extends StatelessWidget {
  final TextEditingController searchController;
  final StudentModeljd? selectedStudent;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<StudentModeljd> onStudentSelected;

  const _StudentPicker({
    required this.searchController,
    required this.selectedStudent,
    required this.onSearchChanged,
    required this.onStudentSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<StudentModeljd>(
      validator: (_) =>
          selectedStudent == null ? 'يجب اختيار طالبة من القائمة' : null,
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: searchController,
              onChanged: onSearchChanged,
              decoration: _inputDecoration(
                label: 'بحث عن طالبة بالاسم',
                icon: Icons.search_outlined,
              ),
            ),
            if (field.hasError) ...[
              const SizedBox(height: 6),
              Text(
                field.errorText!,
                style: const TextStyle(color: Color(0xFFF1416C), fontSize: 12),
              ),
            ],
            const SizedBox(height: 10),
            if (selectedStudent != null)
              _SelectedStudentCard(student: selectedStudent!)
            else
              BlocBuilder<
                RoomAssignmentStudentsCubit,
                RoomAssignmentStudentsState
              >(
                builder: (context, state) {
                  if (state is RoomAssignmentStudentsLoading ||
                      state is RoomAssignmentStudentsInitial) {
                    return const SizedBox(
                      height: 110,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (state is RoomAssignmentStudentsError) {
                    return _StudentPickerMessage(
                      message: state.message,
                      color: const Color(0xFFF1416C),
                    );
                  }

                  final students = state is RoomAssignmentStudentsLoaded
                      ? state.students
                      : <StudentModeljd>[];

                  if (students.isEmpty) {
                    return const _StudentPickerMessage(
                      message: 'لا توجد طالبات مطابقة للبحث',
                      color: Color(0xFF64748B),
                    );
                  }

                  return Container(
                    constraints: const BoxConstraints(maxHeight: 180),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: students.length,
                      separatorBuilder: (_, _) =>
                          const Divider(height: 1, color: Color(0xFFE2E8F0)),
                      itemBuilder: (context, index) {
                        final student = students[index];
                        return ListTile(
                          dense: true,
                          leading: CircleAvatar(
                            radius: 16,
                            backgroundColor: const Color(0xFFEEF2FF),
                            child: Text(
                              _studentFullName(student).isNotEmpty
                                  ? _studentFullName(student).substring(0, 1)
                                  : '?',
                              style: const TextStyle(
                                color: Color(0xFF6366F1),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            _studentFullName(student),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          subtitle: Text(
                            'ID: ${student.id} | رقم جامعي: ${student.nationalNumber}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () {
                            field.didChange(student);
                            onStudentSelected(student);
                          },
                        );
                      },
                    ),
                  );
                },
              ),
          ],
        );
      },
    );
  }
}

class _SelectedStudentCard extends StatelessWidget {
  final StudentModeljd student;

  const _SelectedStudentCard({required this.student});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2FF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFC7D2FE)),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF6366F1), size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _studentFullName(student),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF1E293B),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            'ID: ${student.id}',
            style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _StudentPickerMessage extends StatelessWidget {
  final String message;
  final Color color;

  const _StudentPickerMessage({required this.message, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        message,
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final DormRoomModel room;

  const _Header({required this.room});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.meeting_room_rounded,
              color: Color(0xFF6366F1),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'طالبات الغرفة ${room.roomNumber}',
                  style: const TextStyle(
                    color: Color(0xFF1E293B),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'عرض الطالبات المسكنات وإضافة طالبة جديدة',
                  style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SummaryChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF6366F1), size: 18),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 11,
                  ),
                ),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF1E293B),
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
}

class _AssignmentTile extends StatelessWidget {
  final RoomAssignmentModel assignment;

  const _AssignmentTile({required this.assignment});

  @override
  Widget build(BuildContext context) {
    final statusColor = assignment.isActive
        ? const Color(0xFF16A34A)
        : const Color(0xFF64748B);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFEEF2FF),
            child: Text(
              assignment.student.fullName.isNotEmpty
                  ? assignment.student.fullName.substring(0, 1)
                  : '?',
              style: const TextStyle(
                color: Color(0xFF6366F1),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  assignment.student.fullName,
                  style: const TextStyle(
                    color: Color(0xFF1E293B),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${assignment.student.nationalNumber.isEmpty ? 'ID: ${assignment.student.id}' : assignment.student.nationalNumber} | دخول: ${assignment.checkInDate} | خروج متوقع: ${assignment.expectedCheckOutDate}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              assignment.status,
              style: TextStyle(
                color: statusColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _textField({
  required TextEditingController controller,
  required String label,
  required IconData icon,
}) {
  return TextFormField(
    controller: controller,
    validator: _requiredValidator,
    decoration: _inputDecoration(label: label, icon: icon),
  );
}

InputDecoration _inputDecoration({
  required String label,
  required IconData icon,
}) {
  return InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon),
    filled: true,
    fillColor: const Color(0xFFF8FAFC),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
    ),
  );
}

String? _requiredValidator(String? value) {
  if (value == null || value.trim().isEmpty) return 'هذا الحقل مطلوب';
  return null;
}

String _studentFullName(StudentModeljd student) {
  final user = student.user;
  final names = [
    if (user != null) user.firstName,
    student.fatherName,
    if (user != null) user.lastName,
  ].where((name) => name.trim().isNotEmpty).toList();

  if (names.isEmpty) return 'طالبة #${student.id}';
  return names.join(' ');
}
