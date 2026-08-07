import 'package:finalproject/core/theme/theme_extination.dart';
import 'package:finalproject/feature/announcements/data/announcement_model.dart';
import 'package:finalproject/feature/announcements/presentation/manger/announcements_cubit.dart';
import 'package:finalproject/feature/announcements/presentation/manger/announcements_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnnouncementActionDialog extends StatefulWidget {
  final AnnouncementModel? announcement;

  const AnnouncementActionDialog({super.key, this.announcement});

  @override
  State<AnnouncementActionDialog> createState() =>
      _AnnouncementActionDialogState();
}

class _AnnouncementActionDialogState extends State<AnnouncementActionDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;

  bool get _isEdit => widget.announcement != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.announcement?.title ?? '',
    );
    _bodyController = TextEditingController(
      text: widget.announcement?.body ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final request = AnnouncementRequest(
      title: _titleController.text.trim(),
      body: _bodyController.text.trim(),
    );

    final cubit = context.read<AnnouncementsCubit>();
    final success = _isEdit
        ? await cubit.updateAnnouncement(widget.announcement!.id, request)
        : await cubit.createAnnouncement(request);

    if (success && mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final styles = context.styles;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        insetPadding: const EdgeInsets.all(24),
        backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.campaign_rounded, color: styles.primaryColor),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _isEdit ? 'تعديل الإعلان' : 'إضافة إعلان جديد',
                          style: styles.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    controller: _titleController,
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'عنوان الإعلان مطلوب'
                        : null,
                    decoration: InputDecoration(
                      labelText: 'العنوان',
                      prefixIcon: const Icon(Icons.title_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _bodyController,
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'محتوى الإعلان مطلوب'
                        : null,
                    maxLines: 7,
                    decoration: InputDecoration(
                      labelText: 'المحتوى',
                      alignLabelWithHint: true,
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(bottom: 118),
                        child: Icon(Icons.notes_rounded),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<AnnouncementsCubit, AnnouncementsState>(
                    builder: (context, state) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: state.isSubmitting
                                ? null
                                : () => Navigator.pop(context),
                            child: const Text('إلغاء'),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: state.isSubmitting ? null : _submit,
                            icon: state.isSubmitting
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Icon(
                                    _isEdit
                                        ? Icons.save_rounded
                                        : Icons.add_rounded,
                                  ),
                            label: Text(
                              _isEdit ? 'حفظ التعديل' : 'نشر الإعلان',
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
      ),
    );
  }
}
