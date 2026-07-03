import 'package:finalproject/core/di/service_locator.dart';
import 'package:finalproject/core/theme/theme_extination.dart';
import 'package:finalproject/core/widgets/custom_confirm_dialog.dart';
import 'package:finalproject/core/widgets/empty_view_list.dart';
import 'package:finalproject/core/widgets/error_widget_view.dart';
import 'package:finalproject/core/widgets/show_snak_bar.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/Hospitals/data/hospital_model.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/Hospitals/presentation/manger/hospital_cubit.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/Hospitals/presentation/manger/hospital_state.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/Hospitals/presentation/views/widget/add_edit_hospital_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

class HospitalsPage extends StatefulWidget {
  const HospitalsPage({super.key});

  @override
  State<HospitalsPage> createState() => _HospitalsPageState();
}

class _HospitalsPageState extends State<HospitalsPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  late final HospitalCubit _cubit;
  bool _isDeleting = false;
  bool _isLoaderOpen = false;
  late final AnimationController _animController;

  // Primary color for hospitals theme
  static const Color _primaryColor = Color(0xFF0EA5E9);
  static const Color _primaryDark = Color(0xFF0284C7);

  @override
  void initState() {
    super.initState();
    _cubit = sl<HospitalCubit>();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cubit.fetchHospitals();
      _animController.forward();
    });
  }

  @override
  void dispose() {
    _dismissLoadingDialog();
    _searchController.dispose();
    _animController.dispose();
    _cubit.close();
    super.dispose();
  }

  void _showLoadingDialog(String message) {
    if (_isLoaderOpen) return;
    _isLoaderOpen = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return PopScope(
          canPop: false,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    message,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).then((_) => _isLoaderOpen = false);
  }

  void _dismissLoadingDialog() {
    if (_isLoaderOpen && mounted) {
      Navigator.of(context, rootNavigator: true).pop();
      _isLoaderOpen = false;
    }
  }

  void _openAddEditDialog({HospitalModel? hospital}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: _cubit,
          child: BlocConsumer<HospitalCubit, HospitalState>(
            listener: (context, state) {
              if (state is HospitalActionSuccess) {
                Navigator.of(dialogContext).pop();
              }
            },
            builder: (context, state) {
              return AddEditHospitalDialog(
                hospital: hospital,
                isLoading: state is HospitalActionLoading,
                onSave: (name) {
                  if (hospital == null) {
                    _cubit.createHospital(name: name);
                  } else {
                    _cubit.updateHospital(id: hospital.id, name: name);
                  }
                },
              );
            },
          ),
        );
      },
    );
  }

  void _deleteHospital(HospitalModel hospital) {
    confirmDelete(context, () {
      setState(() => _isDeleting = true);
      _cubit.deleteHospital(hospital.id);
      Navigator.of(context, rootNavigator: true).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final styles = context.styles;
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return BlocProvider.value(
      value: _cubit,
      child: BlocListener<HospitalCubit, HospitalState>(
        listener: (context, state) {
          if (state is HospitalActionLoading) {
            if (_isDeleting) _showLoadingDialog('جاري حذف المستشفى...');
          } else if (state is HospitalActionSuccess) {
            if (_isDeleting) {
              _dismissLoadingDialog();
              setState(() => _isDeleting = false);
            }
            showWebBanner(context, state.message, type: BannerType.success);
          } else if (state is HospitalError) {
            if (_isDeleting) {
              _dismissLoadingDialog();
              setState(() => _isDeleting = false);
            }
            showWebBanner(context, state.message, type: BannerType.error);
          }
          if (state is HospitalLoaded || state is HospitalActionSuccess) {
            setState(() {});
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF0F4F8),
          body: SafeArea(
            child: BlocBuilder<HospitalCubit, HospitalState>(
              builder: (context, state) {
                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // Header
                    SliverPadding(
                      padding: EdgeInsets.only(
                        top: isDesktop ? 24 : 12,
                        left: isDesktop ? 24 : 12,
                        right: isDesktop ? 24 : 12,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: _buildHeader(styles, isDesktop),
                      ),
                    ),
                    // Stats Row
                    SliverPadding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 24 : 12,
                        vertical: 16,
                      ),
                      sliver: SliverToBoxAdapter(child: _buildStatsRow()),
                    ),
                    // Content
                    if (state is HospitalLoading && _cubit.hospitals.isEmpty)
                      const SliverFillRemaining(
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _primaryColor,
                            ),
                          ),
                        ),
                      )
                    else if (state is HospitalError && _cubit.hospitals.isEmpty)
                      SliverFillRemaining(
                        child: ShowErrorWidgetView(
                          errorMessage: state.message,
                          showImage: false,
                          onRetry: () => _cubit.fetchHospitals(),
                        ),
                      )
                    else
                      Builder(
                        builder: (context) {
                          final filtered = _cubit.hospitals.where((h) {
                            return h.name.toLowerCase().contains(
                              _searchQuery.toLowerCase(),
                            );
                          }).toList();

                          if (filtered.isEmpty && _cubit.hospitals.isNotEmpty) {
                            return SliverFillRemaining(
                              child: EmptyListViews(
                                text: 'لا توجد نتائج مطابقة للبحث',
                              ),
                            );
                          }
                          if (filtered.isEmpty) {
                            return SliverFillRemaining(
                              child: EmptyListViews(
                                text: 'لا توجد مستشفيات مضافة حالياً',
                              ),
                            );
                          }

                          return SliverPadding(
                            padding: EdgeInsets.only(
                              left: isDesktop ? 24 : 12,
                              right: isDesktop ? 24 : 12,
                              bottom: 24,
                            ),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: _buildHospitalCard(
                                    filtered[index],
                                    index,
                                  ),
                                ),
                                childCount: filtered.length,
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemedTextStyles styles, bool isDesktop) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_primaryColor, _primaryDark, Color(0xFF0369A1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.local_hospital_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 20),
          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'إدارة المستشفيات',
                  style: styles.headline2.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'عرض وإدارة المستشفيات الجامعية التابعة للكلية',
                  style: styles.bodyMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          // Search + Add
          Row(
            children: [
              // Search
              Container(
                width: 200,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'بحث عن مستشفى...',
                    hintStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 13,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.white.withValues(alpha: 0.7),
                      size: 20,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Add button
              Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: () => _openAddEditDialog(),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.add_rounded,
                          color: _primaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'مستشفى جديد',
                          style: styles.bodyMedium.copyWith(
                            color: _primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _buildStatCard(
          icon: Icons.local_hospital_rounded,
          label: 'إجمالي المستشفيات',
          value: '${_cubit.hospitals.length}',
          color: _primaryColor,
          bgColor: const Color(0xFFE0F2FE),
        ),
        const SizedBox(width: 12),
        _buildStatCard(
          icon: Icons.medical_services_outlined,
          label: 'المستشفيات الجامعية',
          value:
              '${_cubit.hospitals.where((h) => h.name.contains('جامعي')).length}',
          color: const Color(0xFF8B5CF6),
          bgColor: const Color(0xFFEDE9FE),
        ),
        const SizedBox(width: 12),
        _buildStatCard(
          icon: Icons.business_outlined,
          label: 'المراكز الأخرى',
          value:
              '${_cubit.hospitals.where((h) => !h.name.contains('جامعي')).length}',
          color: const Color(0xFF10B981),
          bgColor: const Color(0xFFD1FAE5),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required Color bgColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: const Color(0xFFF1F5F9)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF94A3B8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHospitalCard(HospitalModel hospital, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 350 + (index * 60)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: _primaryColor.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(color: _primaryColor.withValues(alpha: 0.08)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              // Hospital icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [_primaryColor, _primaryDark],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: _primaryColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.local_hospital_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              // Name + ID
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hospital.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: _primaryColor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '#${hospital.id}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: _primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Actions
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildActionButton(
                    icon: Icons.edit_outlined,
                    color: const Color(0xFF0EA5E9),
                    tooltip: 'تعديل',
                    onTap: () => _openAddEditDialog(hospital: hospital),
                  ),
                  const SizedBox(width: 8),
                  _buildActionButton(
                    icon: Icons.delete_outline_rounded,
                    color: const Color(0xFFEF4444),
                    tooltip: 'حذف',
                    onTap: () => _deleteHospital(hospital),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(icon, size: 18, color: color),
          ),
        ),
      ),
    );
  }
}
