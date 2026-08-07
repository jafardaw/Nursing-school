import 'package:finalproject/core/di/service_locator.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/data/model/student_model.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/presentation/manger/student_documents_cubit.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/presentation/view/documents/student_documents_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> showStudentDocumentsDialog({
  required BuildContext context,
  required StudentModeljd student,
}) {
  final firstName = student.user?.firstName.trim() ?? '';
  final lastName = student.user?.lastName.trim() ?? '';
  final fullName = '$firstName $lastName'.trim();

  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => BlocProvider(
      create: (_) => sl<StudentDocumentsCubit>(),
      child: StudentDocumentsDialog(
        studentId: student.id,
        studentName: fullName.isEmpty ? student.nationalNumber : fullName,
      ),
    ),
  );
}
