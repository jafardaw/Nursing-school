import 'package:finalproject/core/theme/theme_extination.dart';
import 'package:finalproject/feature/student%20Affairs/student%20record/data/model/student_model.dart';
import 'package:finalproject/feature/student%20Affairs/student%20record/presentation/manger/students_cubit.dart';
import 'package:finalproject/feature/student%20Affairs/student%20record/presentation/manger/students_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:responsive_framework/responsive_framework.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<StudentsCubit>().loadStudents();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<StudentsCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final styles = context.styles;
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Scaffold(
      backgroundColor: styles.backgroundColor,
      appBar: AppBar(
        title: Text('الطلاب', style: styles.headline3.copyWith(color: styles.whiteColor)),
        centerTitle: true,
      ),
      body: BlocBuilder<StudentsCubit, StudentsState>(
        builder: (context, state) {
          if (state is StudentsLoading && state is! StudentsLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is StudentsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: styles.errorColor),
                  const SizedBox(height: 16),
                  Text(state.message, style: styles.bodyLarge),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<StudentsCubit>().refresh(),
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          if (state is StudentsLoaded) {
            if (state.students.isEmpty) {
              return Center(
                child: Text('لا يوجد طلاب', style: styles.bodyLarge),
              );
            }

            return RefreshIndicator(
              onRefresh: () => context.read<StudentsCubit>().refresh(),
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: state.students.length + (state.hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= state.students.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final student = state.students[index];
                  return _StudentCard(student: student);
                },
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}

class _StudentCard extends StatelessWidget {
  final StudentModel student;

  const _StudentCard({required this.student, });

  @override
  Widget build(BuildContext context) {
    final styles = context.styles;
    return Card(
      color: styles.cardColor,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الاسم + السنة الدراسية
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: styles.primaryColor,
                  child: Text(
                    student.user?.firstName.isNotEmpty == true
                        ? student.user!.firstName[0]
                        : '?',
                    style: styles.bodyLarge.copyWith(color: styles.whiteColor),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${student.user?.firstName ?? ''} ${student.user?.lastName ?? ''}',
                        style: styles.headline3,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        student.nationalNumber,
                        style: styles.bodySmall,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: styles.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    student.academicYear?.name ?? '',
                    style: styles.bodySmall.copyWith(color: styles.primaryColor),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),

            // معلومات سريعة
            _buildInfoRow(Icons.school, 'التخصص', student.specialization?.name ?? '-', context),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.phone, 'الموبايل', student.mobileNum, context),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.location_on, 'المحافظة', student.governorate?.name ?? '-', context),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.flag, 'الجنسية', student.nationality?.name ?? '-', context),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, BuildContext context) {
    final styles = context.styles;
    return Row(
      children: [
        Icon(icon, size: 18, color: styles.textHintColor),
        const SizedBox(width: 8),
        Text('$label: ', style: styles.bodySmall),
        Text(value, style: styles.bodyMedium),
      ],
    );
  }
}