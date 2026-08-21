import 'package:finalproject/core/di/service_locator.dart';
import 'package:finalproject/core/theme/theme_extination.dart';
import 'package:finalproject/core/widgets/show_snak_bar.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/matching/data/matching_campaign_model.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/matching/presentation/manger/matching_campaign_cubit.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/matching/presentation/manger/matching_campaign_state.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/matching/presentation/views/widgets/create_campaign_dialog.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/matching/presentation/views/widgets/edit_campaign_dialog.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/matching/presentation/views/widgets/manage_seats_view.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/matching/presentation/views/widgets/seats_view_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MatchingCampaignsView extends StatefulWidget {
  const MatchingCampaignsView({super.key});

  @override
  State<MatchingCampaignsView> createState() => _MatchingCampaignsViewState();
}

class _MatchingCampaignsViewState extends State<MatchingCampaignsView> {
  late final MatchingCampaignCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<MatchingCampaignCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cubit.loadInitialData();
    });
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final styles = context.styles;
    return MultiBlocProvider(
      providers: [BlocProvider<MatchingCampaignCubit>.value(value: _cubit)],
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: SafeArea(
          child: BlocBuilder<MatchingCampaignCubit, MatchingCampaignState>(
            builder: (context, state) {
              if (state is MatchingCampaignLoading ||
                  state is MatchingCampaignInitial) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is MatchingCampaignError) {
                return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }

              // حماية من الحالات الوسيطة (ActionLoading / ActionSuccess)
              if (state is! MatchingCampaignLoaded) {
                return const Center(child: CircularProgressIndicator());
              }

              final loaded = state;

              if (loaded.campaigns.isEmpty) {
                return Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(24),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0EA5E9), Color(0xFF2563EB)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.swap_horiz_rounded,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'المفاضلات',
                                  style: styles.headline2.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'إدارة حملات المفاضلات وإضافة المقاعد بكل سهولة',
                                  style: styles.bodyMedium.copyWith(
                                    color: Colors.white.withValues(alpha: 0.85),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () async {
                              final created = await showDialog<bool>(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) => const CreateCampaignDialog(),
                              );
                              if (created == true) {
                                await _cubit.loadInitialData();
                              }
                            },
                            icon: const Icon(Icons.add_rounded),
                            label: const Text('إضافة مفاضلة'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF2563EB),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inbox_outlined,
                              size: 72,
                              color: Colors.grey.withValues(alpha: 0.3),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'لا توجد مفاضلات حالياً',
                              style: styles.headline3.copyWith(
                                color: Colors.grey.withValues(alpha: 0.5),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'ابدأ بإضافة مفاضلة جديدة من الأعلى',
                              style: styles.bodyMedium.copyWith(
                                color: Colors.grey.withValues(alpha: 0.4),
                              ),
                            ),
                            if (loaded.warningMessage != null) ...[
                              const SizedBox(height: 16),
                              Text(
                                loaded.warningMessage!,
                                textAlign: TextAlign.center,
                                style: styles.bodyMedium.copyWith(
                                  color: Colors.redAccent,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }

              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(24),
                    sliver: SliverToBoxAdapter(
                      child: _buildHeader(styles, loaded.campaigns.length),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final campaign = loaded.campaigns[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildCampaignCard(campaign),
                        );
                      }, childCount: loaded.campaigns.length),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemedTextStyles styles, int count) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0EA5E9), Color(0xFF2563EB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.swap_horiz_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'المفاضلات',
                  style: styles.headline2.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'إدارة حملات المفاضلات وإضافة المقاعد بكل سهولة',
                  style: styles.bodyMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              final created = await showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (_) => const CreateCampaignDialog(),
              );
              if (created == true) {
                await _cubit.loadInitialData();
              }
            },
            icon: const Icon(Icons.add_rounded),
            label: const Text('إضافة مفاضلة'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF2563EB),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCampaignCard(MatchingCampaignModel campaign) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── الصف العلوي: اسم المفاضلة + الشارات + التاريخ ──
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFDBEAFE),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.assignment_rounded,
                  color: Color(0xFF2563EB),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      campaign.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _chip(campaign.typeLabel, const Color(0xFFE0F2FE)),
                        _chip(
                          campaign.statusLabel,
                          campaign.status == 'Active'
                              ? const Color(0xFFDCFCE7)
                              : campaign.status == 'Completed'
                              ? const Color(0xFFFEF3C7)
                              : const Color(0xFFF1F5F9),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${campaign.startDate} ←→ ${campaign.endDate}',
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () async {
                  final result = await showDialog<bool>(
                    context: context,
                    builder: (context) =>
                        EditCampaignDialog(campaign: campaign),
                  );
                  if (result == true && mounted) {
                    showWebBanner(
                      context,
                      'تم تعديل المفاضلة بنجاح ✅',
                      type: BannerType.success,
                    );
                    _cubit.loadInitialData(); // تحديث بعد التعديل
                  }
                },
                icon: const Icon(Icons.edit_rounded, color: Color(0xFF2563EB)),
                tooltip: 'تعديل المفاضلة',
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFFDBEAFE),
                  padding: const EdgeInsets.all(8),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => _confirmDeleteCampaign(context, campaign),
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: Color(0xFFEF4444),
                ),
                tooltip: 'حذف المفاضلة',
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFFFEF2F2),
                  padding: const EdgeInsets.all(8),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 14),

          // ── الصف السفلي: ملخص المقاعد + الأزرار ──
          if (campaign.hasSeats) ...[
            // ملخص المقاعد
            Row(
              children: [
                _miniStat(
                  Icons.event_seat_rounded,
                  '${campaign.seats.length} مقعد',
                  const Color(0xFF0EA5E9),
                ),
                const SizedBox(width: 16),
                _miniStat(
                  Icons.people_alt_outlined,
                  'سعة: ${campaign.totalCapacity}',
                  const Color(0xFF6366F1),
                ),
                const SizedBox(width: 16),
                _miniStat(
                  Icons.check_circle_outline,
                  'مُطابَق: ${campaign.totalMatched}',
                  const Color(0xFF10B981),
                ),
                const SizedBox(width: 16),
                _miniStat(
                  Icons.hourglass_bottom_rounded,
                  'متبقي: ${campaign.totalRemaining}',
                  const Color(0xFFF59E0B),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => SeatsViewDialog(campaign: campaign),
                    );
                  },
                  icon: const Icon(Icons.visibility_rounded, size: 18),
                  label: const Text('عرض المقاعد'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            // لا يوجد مقاعد
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        size: 16,
                        color: Color(0xFFD97706),
                      ),
                      SizedBox(width: 6),
                      Text(
                        'لا يوجد مقاعد بعد',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFD97706),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () async {
                    final saved = await Navigator.of(context).push<bool>(
                      MaterialPageRoute(
                        builder: (_) => ManageSeatsView(
                          campaign: campaign,
                          hospitals: _cubit.hospitals,
                          specializations: _cubit.specializations,
                          cubit: _cubit,
                        ),
                      ),
                    );
                    if (saved == true && mounted) {
                      showWebBanner(
                        context,
                        'تم حفظ مقاعد المفاضلة بنجاح ✅',
                        type: BannerType.success,
                      );
                      _cubit.loadInitialData();
                    }
                  },
                  icon: const Icon(Icons.add_circle_outline, size: 18),
                  label: const Text('إدارة المقاعد'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0EA5E9),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _miniStat(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _chip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color(0xFF0F172A),
        ),
      ),
    );
  }

  Future<void> _confirmDeleteCampaign(
    BuildContext context,
    MatchingCampaignModel campaign,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Color(0xFFEF4444)),
            SizedBox(width: 12),
            Text('تأكيد الحذف', style: TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
        content: Text(
          'هل أنت متأكد أنك تريد حذف المفاضلة "${campaign.title}"؟\nسيتم حذف جميع المقاعد المرتبطة بها ولا يمكن التراجع عن هذا الإجراء.',
          style: const TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF64748B),
            ),
            child: const Text(
              'إلغاء',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'نعم، احذف',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final success = await _cubit.deleteCampaign(campaign.id);
      if (success && mounted) {
        showWebBanner(
          context,
          'تم حذف المفاضلة بنجاح ✅',
          type: BannerType.success,
        );
        _cubit.loadInitialData(); // تحديث البيانات من السيرفر بعد الحذف
      }
    }
  }
}
