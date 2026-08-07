import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class PendingStudentDocument {
  final PlatformFile file;
  final TextEditingController descriptionController;

  PendingStudentDocument({required this.file, String initialDescription = ''})
    : descriptionController = TextEditingController(text: initialDescription);

  void dispose() {
    descriptionController.dispose();
  }
}
