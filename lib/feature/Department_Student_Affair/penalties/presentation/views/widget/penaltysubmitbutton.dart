import 'package:finalproject/core/widgets/custom_button.dart';
import 'package:finalproject/core/widgets/show_snak_bar.dart';
import 'package:finalproject/feature/Department_Student_Affair/penalties/presentation/manger/cubit_post/add_penalites_cubit.dart';
import 'package:finalproject/feature/Department_Student_Affair/penalties/presentation/manger/cubit_post/add_penalites_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PenaltySubmitButton extends StatelessWidget {
  final VoidCallback onSubmit;

  const PenaltySubmitButton({super.key, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddPenaltyCubit, AddPenaltyState>(
      listener: (context, state) {
        if (state is AddPenaltySuccess) {
          showCustomSnackBar(
            context,
            "تمت الإضافة بنجاح",
            type: ToastType.success,
          );
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return CustomButton(
          color: Color(0xFF009EF7),
          onTap: state is AddPenaltyLoading ? null : onSubmit,
          text: 'تأكيد الإضافة',
          isLoading: state is AddPenaltyLoading,
          icon: Icons.check_circle_outline,
        );
      },
    );
  }
}
