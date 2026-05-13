import 'package:finalproject/core/widgets/custome_text_field.dart';
import 'package:flutter/material.dart';

class PenaltyBodyField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?) validator;

  const PenaltyBodyField({
    super.key,
    required this.controller,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return CustomeTextField(
      controller: controller,
      maxLines: 5,
      hintText: "أدخل التفاصيل...",
      validator: validator,
    );
  }
}
