import 'package:finalproject/core/theme/theme_extination.dart';
import 'package:finalproject/core/widgets/custom_confirm_dialog.dart';
import 'package:finalproject/core/widgets/empty_view_list.dart';
import 'package:finalproject/core/widgets/pagination_footer.dart';
import 'package:finalproject/core/widgets/show_snak_bar.dart';
import 'package:finalproject/feature/announcements/data/announcement_model.dart';
import 'package:finalproject/feature/announcements/presentation/manger/announcements_cubit.dart';
import 'package:finalproject/feature/announcements/presentation/manger/announcements_state.dart';
import 'package:finalproject/feature/announcements/presentation/view/widgets/announcement_action_dialog.dart';
import 'package:finalproject/feature/announcements/presentation/view/widgets/announcements_grid.dart';
import 'package:finalproject/feature/announcements/presentation/view/widgets/announcements_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnnouncementsView extends StatefulWidget {
  const AnnouncementsView({super.key});

  @override
  State<AnnouncementsView> createState() => _AnnouncementsViewState();
}

class _AnnouncementsViewState extends State<AnnouncementsView> {
  @override
  void initState() {
    super.initState();
    context.read<AnnouncementsCubit>().loadAnnouncements();
  }

  void _openActionDialog({AnnouncementModel? announcement}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => BlocProvider.value(
        value: context.read<AnnouncementsCubit>(),
        child: AnnouncementActionDialog(announcement: announcement),
      ),
    );
  }

  void _confirmDelete(AnnouncementModel announcement) {
    confirmDelete(context, () {
      Navigator.of(context, rootNavigator: true).pop();
      context.read<AnnouncementsCubit>().deleteAnnouncement(announcement.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final styles = context.styles;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: styles.backgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: styles.backgroundColor,
          title: Text(
            'الإعلانات',
            style: styles.headline6.copyWith(fontWeight: FontWeight.bold),
          ),
          actions: [
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 16),
              child: ElevatedButton.icon(
                onPressed: () => _openActionDialog(),
                icon: const Icon(Icons.campaign_rounded),
                label: const Text('إعلان جديد'),
              ),
            ),
          ],
        ),
        body: BlocConsumer<AnnouncementsCubit, AnnouncementsState>(
          listenWhen: (previous, current) =>
              previous.error != current.error ||
              previous.successMessage != current.successMessage,
          listener: (context, state) {
            if (state.error != null) {
              showCustomSnackBar(context, state.error!, type: ToastType.error);
            }
            if (state.successMessage != null) {
              showCustomSnackBar(
                context,
                state.successMessage!,
                type: ToastType.success,
              );
            }
          },
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () => context
                  .read<AnnouncementsCubit>()
                  .loadAnnouncements(page: state.meta?.currentPage ?? 1),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(24),
                    sliver: SliverToBoxAdapter(
                      child: AnnouncementsToolbar(state: state),
                    ),
                  ),
                  if (state.isLoading && state.announcements.isEmpty)
                    const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (state.announcements.isEmpty)
                    const SliverFillRemaining(
                      child: EmptyListViews(
                        text: 'لا توجد إعلانات مطابقة حالياً',
                        iconData: Icons.campaign_outlined,
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                      sliver: SliverToBoxAdapter(
                        child: AnnouncementsGrid(
                          announcements: state.announcements,
                          onEdit: (item) =>
                              _openActionDialog(announcement: item),
                          onDelete: _confirmDelete,
                        ),
                      ),
                    ),
                  if (state.meta != null)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                        child: PaginationFooter(
                          meta: state.meta!,
                          onFirstPage: () => context
                              .read<AnnouncementsCubit>()
                              .loadAnnouncements(page: 1),
                          onPreviousPage: () => context
                              .read<AnnouncementsCubit>()
                              .loadAnnouncements(
                                page: state.meta!.currentPage - 1,
                              ),
                          onNextPage: () => context
                              .read<AnnouncementsCubit>()
                              .loadAnnouncements(
                                page: state.meta!.currentPage + 1,
                              ),
                          onLastPage: () => context
                              .read<AnnouncementsCubit>()
                              .loadAnnouncements(page: state.meta!.lastPage),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
