import 'package:finalproject/core/theme/theme_extination.dart';
import 'package:finalproject/core/widgets/pagination_footer.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/HospitalTrainingGroups/presentation/manger/hospital_training_groups_cubit.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/HospitalTrainingGroups/presentation/manger/hospital_training_groups_state.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/HospitalTrainingGroups/presentation/views/create_training_group_page.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/HospitalTrainingGroups/presentation/views/widgets/training_groups_data_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HospitalTrainingGroupsPage extends StatefulWidget {
  const HospitalTrainingGroupsPage({super.key});

  @override
  State<HospitalTrainingGroupsPage> createState() =>
      _HospitalTrainingGroupsPageState();
}

class _HospitalTrainingGroupsPageState
    extends State<HospitalTrainingGroupsPage> {
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
            'مجموعات التدريب',
            style: styles.headline6.copyWith(fontWeight: FontWeight.bold),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<HospitalTrainingGroupsCubit>(),
                        child: const CreateTrainingGroupPage(),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.add_rounded),
                label: const Text('إنشاء مجموعة جديدة'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D47A1),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
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

                return RefreshIndicator(
                  onRefresh: () =>
                      context.read<HospitalTrainingGroupsCubit>().loadGroups(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildFilters(context, state),
                        const SizedBox(height: 20),
                        if (state.isLoading && state.groups.isNotEmpty)
                          const LinearProgressIndicator(minHeight: 2),
                        const TrainingGroupsDataTable(),
                        const SizedBox(height: 16),
                        if (state.meta != null)
                          PaginationFooter(
                            meta: state.meta!,
                            onFirstPage: () => context
                                .read<HospitalTrainingGroupsCubit>()
                                .goToPage(1),
                            onPreviousPage: () => context
                                .read<HospitalTrainingGroupsCubit>()
                                .previousPage(),
                            onNextPage: () => context
                                .read<HospitalTrainingGroupsCubit>()
                                .nextPage(),
                            onLastPage: () => context
                                .read<HospitalTrainingGroupsCubit>()
                                .goToPage(state.meta!.lastPage),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
      ),
    );
  }

  Widget _buildFilters(
    BuildContext context,
    HospitalTrainingGroupsState state,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 600;
        return Flex(
          direction: isSmallScreen ? Axis.vertical : Axis.horizontal,
          children: [
            Expanded(
              flex: isSmallScreen ? 0 : 1,
              child: DropdownButtonFormField<int>(
                value: state.selectedHospitalFilter,
                decoration: const InputDecoration(
                  labelText: 'تصفية حسب المشفى',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.local_hospital_outlined),
                ),
                items: [
                  const DropdownMenuItem<int>(
                    value: null,
                    child: Text('الكل'),
                  ),
                  ...state.hospitals.map(
                    (h) => DropdownMenuItem(value: h.id, child: Text(h.name)),
                  ),
                ],
                onChanged: (val) {
                  context.read<HospitalTrainingGroupsCubit>().loadGroups(
                    hospitalId: val,
                    clearHospitalFilter: val == null,
                  );
                },
              ),
            ),
            SizedBox(
              width: isSmallScreen ? 0 : 16,
              height: isSmallScreen ? 16 : 0,
            ),
            Expanded(
              flex: isSmallScreen ? 0 : 1,
              child: DropdownButtonFormField<int>(
                value: state.selectedEmployeeFilter,
                decoration: const InputDecoration(
                  labelText: 'تصفية حسب المشرفة',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
                items: [
                  const DropdownMenuItem<int>(
                    value: null,
                    child: Text('الكل'),
                  ),
                  ...state.employees.map(
                    (e) => DropdownMenuItem(value: e.id, child: Text(e.user.firstName)),
                  ),
                ],
                onChanged: (val) {
                  context.read<HospitalTrainingGroupsCubit>().loadGroups(
                    employeeId: val,
                    clearEmployeeFilter: val == null,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
