import 'package:finalproject/core/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart' show QuickAlertType;
import 'package:quickalert/widgets/quickalert_dialog.dart' show QuickAlert;

void confirmDelete(BuildContext context, VoidCallback delete) {
  QuickAlert.show(
    context: context,
    type: QuickAlertType.confirm,
    title: 'تأكيد الحذف',
    text: 'هل أنت متأكد من حذف هذا السجل؟',
    confirmBtnText: 'احذف',
    // customAsset: 'assets/image/photo_2026-04-28_04-19-13.jpg',
    cancelBtnText: 'إلغاء',
    confirmBtnColor: const Color.fromARGB(255, 54, 244, 238),
    cancelBtnTextStyle: TextStyle(
      color: const Color.fromARGB(255, 105, 104, 104), // 👈 لون نص زر الإلغاء
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    confirmBtnTextStyle: AppTextStyles.size16W700,
    barrierColor: Colors.black54,
    onCancelBtnTap: () {
      Navigator.of(context, rootNavigator: true).pop();
    },
    onConfirmBtnTap: delete,
  );
}
