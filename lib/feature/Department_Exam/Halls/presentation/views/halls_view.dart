import 'package:finalproject/core/di/service_locator.dart';
import 'package:finalproject/core/theme/theme_extination.dart';
import 'package:finalproject/core/widgets/custom_confirm_dialog.dart';
import 'package:finalproject/core/widgets/empty_view_list.dart';
import 'package:finalproject/core/widgets/error_widget_view.dart';
import 'package:finalproject/core/widgets/show_snak_bar.dart';
import 'package:finalproject/feature/Department_Exam/Halls/data/hall_model.dart';
import 'package:finalproject/feature/Department_Exam/Halls/presentation/manger/hall_cubit.dart';
import 'package:finalproject/feature/Department_Exam/Halls/presentation/manger/hall_state.dart';
import 'package:finalproject/feature/Department_Exam/Halls/presentation/views/widget/add_edit_hall_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

class HallsPage extends StatefulWidget {
  const HallsPage({super.key});

  @override
  State<HallsPage> createState() => _HallsPageState();
}

class _HallsPageState extends State<HallsPage> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  late final HallCubit _cubit;
  bool _isDeleting = false;
  bool _isLoaderOpen = false;
  late final AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _cubit = sl<HallCubit>();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cubit.fetchHalls();
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
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      context.styles.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    message,
                    style: context.styles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).then((_) {
      _isLoaderOpen = false;
    });
  }

  void _dismissLoadingDialog() {
    if (_isLoaderOpen) {
      Navigator.of(context, rootNavigator: true).pop();
      _isLoaderOpen = false;
    }
  }

  void _openAddEditDialog({HallModel? hall}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: _cubit,
          child: BlocConsumer<HallCubit, HallState>(
            listener: (context, state) {
              if (state is HallActionSuccess) {
                Navigator.of(dialogContext).pop();
              }
            },
            builder: (context, state) {
              final isLoading = state is HallActionLoading;
              return AddEditHallDialog(
                hall: hall,
                isLoading: isLoading,
                onSave: (name, capacity, type) {
                  if (hall == null) {
                    _cubit.createHall(name: name, capacity: capacity, type: type);
                  } else {
                    _cubit.updateHall(id: hall.id, name: name, capacity: capacity, type: type);
                  }
                },
              );
            },
          ),
        );
      },
    );
  }

  void _deleteHall(HallModel hall) {
    confirmDelete(context, () {
      setState(() {
        _isDeleting = true;
      });
      _cubit.deleteHall(hall.id);
      Navigator.of(context, rootNavigator: true).pop();
    });
  }

  // حساب إجمالي السعة
  int get _totalCapacity => _cubit.halls.fold(0, (sum, hall) => sum + hall.capacity);

  // الحصول على الأيقونة حسب نوع القاعة
  IconData _getHallIcon(String type) {
    switch (type.toLowerCase()) {
      case 'auditorium':
        return Icons.stadium_outlined;
      case 'exam_hall':
        return Icons.school_outlined;
      case 'صالة مطعم':
        return Icons.restaurant_outlined;
      case 'احتياطية':
        return Icons.inventory_2_outlined;
      default:
        return Icons.meeting_room_outlined;
    }
  }

  // الحصول على لون حسب نوع القاعة
  Color _getHallColor(String type) {
    switch (type.toLowerCase()) {
      case 'auditorium':
        return const Color(0xFF8B5CF6);
      case 'exam_hall':
        return const Color(0xFF0EA5E9);
      case 'صالة مطعم':
        return const Color(0xFFF59E0B);
      case 'احتياطية':
        return const Color(0xFF10B981);
      default:
        return const Color(0xFF6366F1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final styles = context.styles;
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return BlocProvider.value(
      value: _cubit,
      child: BlocListener<HallCubit, HallState>(
        listener: (context, state) {
          if (state is HallActionLoading) {
            if (_isDeleting) {
              _showLoadingDialog("جاري حذف القاعة...");
            }
          } else if (state is HallActionSuccess) {
            if (_isDeleting) {
              _dismissLoadingDialog();
              setState(() => _isDeleting = false);
            }
            showWebBanner(context, state.message, type: BannerType.success);
          } else if (state is HallError) {
            if (_isDeleting) {
              _dismissLoadingDialog();
              setState(() => _isDeleting = false);
            }
            showWebBanner(context, state.message, type: BannerType.error);
          }
          // تحديث الإحصائيات عند تغيير الحالة
          if (state is HallLoaded || state is HallActionSuccess) {
            setState(() {});
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF0F2F8),
          body: SafeArea(
            child: BlocBuilder<HallCubit, HallState>(
              builder: (context, state) {
                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // Padding top
                    SliverPadding(
                      padding: EdgeInsets.only(
                        top: isDesktop ? 24 : 12,
                        left: isDesktop ? 24 : 12,
                        right: isDesktop ? 24 : 12,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: _buildHeaderSection(styles, isDesktop),
                      ),
                    ),
                    // بطاقات الإحصائيات
                    SliverPadding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 24 : 12,
                        vertical: 16,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: _buildStatsRow(styles),
                      ),
                    ),
                    // محتوى القاعات
                    if (state is HallLoading && _cubit.halls.isEmpty)
                      SliverFillRemaining(
                        child: const Center(child: CircularProgressIndicator()),
                      )
                    else if (state is HallError && _cubit.halls.isEmpty)
                      SliverFillRemaining(
                        child: ShowErrorWidgetView(
                          errorMessage: state.message,
                          showImage: false,
                          onRetry: () => _cubit.fetchHalls(),
                        ),
                      )
                    else ...[
                      Builder(builder: (context) {
                        final halls = _cubit.halls;
                        final filtered = halls.where((hall) {
                          return hall.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                              hall.type.toLowerCase().contains(_searchQuery.toLowerCase());
                        }).toList();

                        if (filtered.isEmpty && halls.isNotEmpty) {
                          return SliverFillRemaining(
                            child: EmptyListViews(text: 'لا توجد نتائج مطابقة للبحث'),
                          );
                        }
                        if (filtered.isEmpty) {
                          return SliverFillRemaining(
                            child: EmptyListViews(text: 'لا توجد قاعات امتحانية حالياً'),
                          );
                        }

                        return SliverPadding(
                          padding: EdgeInsets.only(
                            left: isDesktop ? 24 : 12,
                            right: isDesktop ? 24 : 12,
                            bottom: 24,
                          ),
                          sliver: SliverGrid(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: isDesktop ? 3 : 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: isDesktop ? 1.45 : 1.2,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => _buildHallCard(filtered[index], styles, index),
                              childCount: filtered.length,
                            ),
                          ),
                        );
                      }),
                    ],
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(ThemedTextStyles styles, bool isDesktop) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6), Color(0xFFA78BFA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // الأيقونة
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.domain_rounded, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 20),
          // العنوان
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "إدارة القاعات الامتحانية",
                  style: styles.headline2.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "قم بإدارة القاعات والمدرجات المتاحة للامتحانات",
                  style: styles.bodyMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          // أزرار
          Row(
            children: [
              // حقل البحث
              Container(
                width: 220,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: "بحث عن قاعة...",
                    hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 13),
                    prefixIcon: Icon(Icons.search, color: Colors.white.withValues(alpha: 0.7), size: 20),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // زر إضافة
              Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: () => _openAddEditDialog(),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      children: [
                        const Icon(Icons.add_rounded, color: Color(0xFF6366F1), size: 20),
                        const SizedBox(width: 6),
                        Text(
                          "قاعة جديدة",
                          style: styles.bodyMedium.copyWith(
                            color: const Color(0xFF6366F1),
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

  Widget _buildStatsRow(ThemedTextStyles styles) {
    return Row(
      children: [
        _buildStatCard(
          icon: Icons.domain_rounded,
          label: "إجمالي القاعات",
          value: "${_cubit.halls.length}",
          color: const Color(0xFF6366F1),
          bgColor: const Color(0xFFEEF2FF),
        ),
        const SizedBox(width: 12),
        _buildStatCard(
          icon: Icons.people_rounded,
          label: "إجمالي السعة",
          value: "$_totalCapacity",
          color: const Color(0xFF0EA5E9),
          bgColor: const Color(0xFFE0F2FE),
        ),
        const SizedBox(width: 12),
        _buildStatCard(
          icon: Icons.category_rounded,
          label: "أنواع القاعات",
          value: "${_cubit.halls.map((h) => h.type).toSet().length}",
          color: const Color(0xFFF59E0B),
          bgColor: const Color(0xFFFEF3C7),
        ),
        const SizedBox(width: 12),
        _buildStatCard(
          icon: Icons.analytics_rounded,
          label: "متوسط السعة",
          value: _cubit.halls.isNotEmpty
              ? "${(_totalCapacity / _cubit.halls.length).round()}"
              : "0",
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
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1E293B),
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

  Widget _buildHallsGrid(List<HallModel> halls, ThemedTextStyles styles, bool isDesktop) {
    return GridView.builder(
      padding: const EdgeInsets.only(top: 4),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isDesktop ? 3 : 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: isDesktop ? 1.45 : 1.2,
      ),
      itemCount: halls.length,
      itemBuilder: (context, index) {
        return _buildHallCard(halls[index], styles, index);
      },
    );
  }

  Widget _buildHallCard(HallModel hall, ThemedTextStyles styles, int index) {
    final color = _getHallColor(hall.type);
    final icon = _getHallIcon(hall.type);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (index * 80)),
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
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(color: color.withValues(alpha: 0.1)),
        ),
        child: Stack(
          children: [
            // خلفية زخرفية
            Positioned(
              top: -20,
              right: -20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withValues(alpha: 0.06),
                ),
              ),
            ),
            Positioned(
              bottom: -10,
              left: -10,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withValues(alpha: 0.04),
                ),
              ),
            ),
            // المحتوى
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // الصف العلوي - الأيقونة ورقم القاعة والأزرار
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [color, color.withValues(alpha: 0.7)],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: color.withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Icon(icon, color: Colors.white, size: 20),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              "#${hall.id}",
                              style: TextStyle(
                                fontSize: 11,
                                color: color,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // أزرار الإجراءات
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildActionButton(
                            icon: Icons.edit_outlined,
                            color: const Color(0xFF0EA5E9),
                            tooltip: 'تعديل',
                            onTap: () => _openAddEditDialog(hall: hall),
                          ),
                          const SizedBox(width: 4),
                          _buildActionButton(
                            icon: Icons.delete_outline_rounded,
                            color: const Color(0xFFEF4444),
                            tooltip: 'حذف',
                            onTap: () => _deleteHall(hall),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // اسم القاعة
                  Text(
                    hall.name,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  // نوع القاعة
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      hall.type,
                      style: TextStyle(
                        fontSize: 12,
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // شريط السعة
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFF1F5F9)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.event_seat_rounded, size: 18, color: color),
                        const SizedBox(width: 8),
                        Text(
                          "السعة:",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${hall.capacity}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: color,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          "مقعد",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
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
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Icon(icon, size: 16, color: color),
          ),
        ),
      ),
    );
  }
}
