import 'package:finalproject/core/di/service_locator.dart';
import 'package:finalproject/core/theme/theme_extination.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/matching/data/matching_campaign_model.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/matching/presentation/manger/matching_campaign_cubit.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/matching/presentation/manger/matching_campaign_state.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/matching/presentation/views/widgets/create_campaign_dialog.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/matching/presentation/views/widgets/manage_seats_view.dart';
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

              final loaded = state as MatchingCampaignLoaded;

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
      child: Row(
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
                    _chip(campaign.statusLabel, const Color(0xFFDCFCE7)),
                  ],
                ),
                const SizedBox(height: 8),
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
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ManageSeatsView(
                    campaign: campaign,
                    hospitals: _cubit.hospitals,
                    specializations: _cubit.specializations,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.table_rows_rounded, size: 18),
            label: const Text('إدارة المقاعد'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0EA5E9),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ],
      ),
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
}
