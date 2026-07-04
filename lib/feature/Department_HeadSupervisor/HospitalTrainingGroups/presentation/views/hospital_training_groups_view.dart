import 'package:finalproject/core/theme/theme_extination.dart';
import 'package:finalproject/core/widgets/pagination_footer.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/HospitalTrainingGroups/presentation/manger/hospital_training_groups_cubit.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/HospitalTrainingGroups/presentation/manger/hospital_training_groups_state.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/HospitalTrainingGroups/presentation/views/widgets/hospital_training_group_form.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/HospitalTrainingGroups/presentation/views/widgets/hospital_training_groups_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HospitalTrainingGroupsView extends StatefulWidget {
  const HospitalTrainingGroupsView({super.key});

  @override
  State<HospitalTrainingGroupsView> createState() =>
      _HospitalTrainingGroupsViewState();
}

class _HospitalTrainingGroupsViewState
    extends State<HospitalTrainingGroupsView> {
  @override
  void initState() {
    super.initState();
    context.read<HospitalTrainingGroupsCubit>().loadInitialData();
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
            'مجموعات التدريب المشفى',
            style: styles.headline6.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        body:
            BlocConsumer<
              HospitalTrainingGroupsCubit,
              HospitalTrainingGroupsState
            >(
              listenWhen: (previous, current) =>
                  previous.error != current.error ||
                  previous.successMessage != current.successMessage,
              listener: (context, state) {
                if (state.error != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.error!),
                      backgroundColor: Colors.red[700],
                    ),
                  );
                }
                if (state.successMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.successMessage!),
                      backgroundColor: Colors.green[700],
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state.isLoading &&
                    state.groups.isEmpty &&
                    state.hospitals.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                return LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth >= 1050;
                    final content = isWide
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 430,
                                child: HospitalTrainingGroupForm(state: state),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: HospitalTrainingGroupsList(state: state),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              HospitalTrainingGroupForm(state: state),
                              const SizedBox(height: 20),
                              HospitalTrainingGroupsList(state: state),
                            ],
                          );

                    return RefreshIndicator(
                      onRefresh: () => context
                          .read<HospitalTrainingGroupsCubit>()
                          .loadGroups(),
                      child: CustomScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        slivers: [
                          SliverPadding(
                            padding: const EdgeInsets.all(24),
                            sliver: SliverToBoxAdapter(child: content),
                          ),
                          if (state.meta != null)
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  24,
                                  0,
                                  24,
                                  24,
                                ),
                                child: PaginationFooter(
                                  meta: state.meta!,
                                  onFirstPage: () => context
                                      .read<HospitalTrainingGroupsCubit>()
                                      .loadGroups(page: 1),
                                  onPreviousPage: () => context
                                      .read<HospitalTrainingGroupsCubit>()
                                      .loadGroups(
                                        page: state.meta!.currentPage - 1,
                                      ),
                                  onNextPage: () => context
                                      .read<HospitalTrainingGroupsCubit>()
                                      .loadGroups(
                                        page: state.meta!.currentPage + 1,
                                      ),
                                  onLastPage: () => context
                                      .read<HospitalTrainingGroupsCubit>()
                                      .loadGroups(page: state.meta!.lastPage),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
      ),
    );
  }
}
