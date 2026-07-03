import 'package:finalproject/core/di/service_locator.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/matching/presentation/manger/matching_campaign_cubit.dart';
import 'package:flutter/material.dart';

class CreateCampaignDialog extends StatefulWidget {
  const CreateCampaignDialog({super.key});

  @override
  State<CreateCampaignDialog> createState() => _CreateCampaignDialogState();
}

class _CreateCampaignDialogState extends State<CreateCampaignDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  String _type = 'Specialization';
  String _status = 'Draft';
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final cubit = sl<MatchingCampaignCubit>();
    final created = await cubit.createCampaign(
      title: _titleController.text.trim(),
      type: _type,
      startDate: _startDateController.text.trim(),
      endDate: _endDateController.text.trim(),
      status: _status,
    );
    setState(() => _isLoading = false);

    if (created && mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'إنشاء مفاضلة جديدة',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'اسم المفاضلة'),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'أدخل اسم المفاضلة'
                      : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _type,
                  decoration: const InputDecoration(labelText: 'نوع المفاضلة'),
                  items: const [
                    DropdownMenuItem(
                      value: 'Specialization',
                      child: Text('اختصاص فقط'),
                    ),
                    DropdownMenuItem(
                      value: 'General_Hospital',
                      child: Text('مشافي'),
                    ),
                  ],
                  onChanged: (v) =>
                      setState(() => _type = v ?? 'Specialization'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _startDateController,
                  decoration: const InputDecoration(
                    labelText: 'تاريخ البداية (YYYY-MM-DD)',
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'أدخل تاريخ البداية'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _endDateController,
                  decoration: const InputDecoration(
                    labelText: 'تاريخ النهاية (YYYY-MM-DD)',
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'أدخل تاريخ النهاية'
                      : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _status,
                  decoration: const InputDecoration(labelText: 'الحالة'),
                  items: const [
                    DropdownMenuItem(value: 'Draft', child: Text('مسودة')),
                    DropdownMenuItem(value: 'Active', child: Text('نشط')),
                  ],
                  onChanged: (v) => setState(() => _status = v ?? 'Draft'),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('إلغاء'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submit,
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : const Text('حفظ'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
