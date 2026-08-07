import 'package:finalproject/core/theme/theme_extination.dart';
import 'package:finalproject/feature/announcements/presentation/manger/announcements_cubit.dart';
import 'package:finalproject/feature/announcements/presentation/manger/announcements_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnnouncementsToolbar extends StatefulWidget {
  final AnnouncementsState state;

  const AnnouncementsToolbar({super.key, required this.state});

  @override
  State<AnnouncementsToolbar> createState() => _AnnouncementsToolbarState();
}

class _AnnouncementsToolbarState extends State<AnnouncementsToolbar> {
  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.state.titleQuery);
    _bodyController = TextEditingController(text: widget.state.bodyQuery);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final styles = context.styles;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xFFE5E7EB),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 760;
          final fields = [
            Expanded(
              child: _searchField(
                controller: _titleController,
                label: 'بحث بالعنوان',
                icon: Icons.title_rounded,
                onChanged: (value) => context.read<AnnouncementsCubit>().search(
                  title: value,
                  body: _bodyController.text,
                ),
              ),
            ),
            SizedBox(width: isWide ? 12 : 0, height: isWide ? 0 : 12),
            Expanded(
              child: _searchField(
                controller: _bodyController,
                label: 'بحث بالمحتوى',
                icon: Icons.notes_rounded,
                onChanged: (value) => context.read<AnnouncementsCubit>().search(
                  title: _titleController.text,
                  body: value,
                ),
              ),
            ),
          ];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.manage_search_rounded, color: styles.primaryColor),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'بحث وتصفية الإعلانات',
                      style: styles.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (widget.state.isLoading)
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                ],
              ),
              const SizedBox(height: 14),
              isWide ? Row(children: fields) : Column(children: fields),
              if (widget.state.isSearching) ...[
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _titleController.clear();
                      _bodyController.clear();
                      context.read<AnnouncementsCubit>().clearSearch();
                    },
                    icon: const Icon(Icons.close_rounded),
                    label: const Text('إزالة البحث'),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _searchField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required ValueChanged<String> onChanged,
  }) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
