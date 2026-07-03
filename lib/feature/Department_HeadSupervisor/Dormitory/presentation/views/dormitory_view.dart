import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:finalproject/core/di/service_locator.dart';
import 'package:finalproject/core/theme/theme_extination.dart';
import 'package:finalproject/core/widgets/custom_confirm_dialog.dart';
import 'package:finalproject/core/widgets/empty_view_list.dart';
import 'package:finalproject/core/widgets/error_widget_view.dart';
import 'package:finalproject/core/widgets/show_snak_bar.dart';

import '../../data/dorm_building_model.dart';
import '../../data/dorm_room_model.dart';
import '../manger/dorm_building_cubit/dorm_building_cubit.dart';
import '../manger/dorm_building_cubit/dorm_building_state.dart';
import '../manger/dorm_room_cubit/dorm_room_cubit.dart';
import '../manger/dorm_room_cubit/dorm_room_state.dart';
import 'widgets/add_edit_building_dialog.dart';
import 'widgets/add_edit_room_dialog.dart';

class DormitoryView extends StatefulWidget {
  const DormitoryView({super.key});

  @override
  State<DormitoryView> createState() => _DormitoryViewState();
}

class _DormitoryViewState extends State<DormitoryView> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _buildingSearchController = TextEditingController();
  final TextEditingController _roomSearchController = TextEditingController();

  String _buildingSearchQuery = '';
  String _roomSearchQuery = '';
  int? _selectedBuildingFilterId;

  bool _isActionInProgress = false;
  bool _isLoaderOpen = false;

  // Premium colors
  static const Color _primaryColor = Color(0xFF6366F1); // Indigo
  static const Color _secondaryColor = Color(0xFF8B5CF6); // Purple
  static const Color _accentColor = Color(0xFF0EA5E9); // Sky blue

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // refresh FAB or top layout if needed on tab switch
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DormBuildingCubit>().fetchBuildings().then((_) {
        final buildings = context.read<DormBuildingCubit>().buildings;
        if (buildings.isNotEmpty) {
          setState(() {
            _selectedBuildingFilterId = buildings.first.id;
          });
          context.read<DormRoomCubit>().fetchRoomsByBuilding(buildings.first.id);
        }
      });
    });
  }

  @override
  void dispose() {
    _dismissLoadingDialog();
    _tabController.dispose();
    _buildingSearchController.dispose();
    _roomSearchController.dispose();
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

  // ====== Building Operations ======

  void _openAddEditBuildingDialog({DormBuildingModel? building}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: context.read<DormBuildingCubit>(),
          child: BlocConsumer<DormBuildingCubit, DormBuildingState>(
            listener: (context, state) {
              if (state is DormBuildingActionSuccess) {
                Navigator.of(dialogContext).pop();
              }
            },
            builder: (context, state) {
              return AddEditBuildingDialog(
                building: building,
                isLoading: state is DormBuildingActionLoading,
                onSave: (name, totalFloors) {
                  if (building == null) {
                    context.read<DormBuildingCubit>().createBuilding(name: name, totalFloors: totalFloors);
                  } else {
                    context.read<DormBuildingCubit>().updateBuilding(id: building.id, name: name, totalFloors: totalFloors);
                  }
                },
              );
            },
          ),
        );
      },
    );
  }

  void _deleteBuilding(DormBuildingModel building) {
    confirmDelete(context, () {
      setState(() => _isActionInProgress = true);
      context.read<DormBuildingCubit>().deleteBuilding(building.id);
      Navigator.of(context, rootNavigator: true).pop();
    });
  }

  // ====== Room Operations ======

  void _openAddEditRoomDialog({DormRoomModel? room}) {
    final buildings = context.read<DormBuildingCubit>().buildings;
    if (buildings.isEmpty) {
      showWebBanner(context, "يجب إضافة مبنى سكني أولاً قبل إضافة الغرف", type: BannerType.error);
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: context.read<DormRoomCubit>(),
          child: BlocConsumer<DormRoomCubit, DormRoomState>(
            listener: (context, state) {
              if (state is DormRoomActionSuccess) {
                Navigator.of(dialogContext).pop();
              }
            },
            builder: (context, state) {
              return AddEditRoomDialog(
                room: room,
                buildings: buildings,
                isLoading: state is DormRoomActionLoading,
                onSave: (buildingId, roomNumber, floorNumber, capacity) {
                  if (room == null) {
                    context.read<DormRoomCubit>().createRoom(
                          dormBuildingId: buildingId,
                          roomNumber: roomNumber,
                          floorNumber: floorNumber,
                          capacity: capacity,
                        );
                  } else {
                    context.read<DormRoomCubit>().updateRoom(
                          id: room.id,
                          dormBuildingId: buildingId,
                          roomNumber: roomNumber,
                          floorNumber: floorNumber,
                          capacity: capacity,
                          status: room.status,
                        );
                  }
                },
              );
            },
          ),
        );
      },
    );
  }

  void _deleteRoom(DormRoomModel room) {
    confirmDelete(context, () {
      setState(() => _isActionInProgress = true);
      context.read<DormRoomCubit>().deleteRoom(room.id);
      Navigator.of(context, rootNavigator: true).pop();
    });
  }

  // Helper to switch to room tab with building filter
  void _viewRoomsForBuilding(DormBuildingModel building) {
    setState(() {
      _selectedBuildingFilterId = building.id;
    });
    context.read<DormRoomCubit>().fetchRoomsByBuilding(building.id);
    _tabController.animateTo(1);
  }

  @override
  Widget build(BuildContext context) {
    final styles = context.styles;
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return MultiBlocListener(
      listeners: [
        BlocListener<DormBuildingCubit, DormBuildingState>(
          listener: (context, state) {
            if (state is DormBuildingActionLoading) {
              if (_isActionInProgress) _showLoadingDialog("جاري حفظ التغييرات للمبنى...");
            } else if (state is DormBuildingActionSuccess) {
              if (_isActionInProgress) {
                _dismissLoadingDialog();
                setState(() => _isActionInProgress = false);
              }
              showWebBanner(context, state.message, type: BannerType.success);
              // If deleted building was selected in rooms, reset selection
              final list = context.read<DormBuildingCubit>().buildings;
              if (list.isNotEmpty) {
                if (_selectedBuildingFilterId == null || !list.any((b) => b.id == _selectedBuildingFilterId)) {
                  setState(() {
                    _selectedBuildingFilterId = list.first.id;
                  });
                  context.read<DormRoomCubit>().fetchRoomsByBuilding(list.first.id);
                }
              } else {
                setState(() {
                  _selectedBuildingFilterId = null;
                });
              }
            } else if (state is DormBuildingError) {
              if (_isActionInProgress) {
                _dismissLoadingDialog();
                setState(() => _isActionInProgress = false);
              }
              showWebBanner(context, state.message, type: BannerType.error);
            }
          },
        ),
        BlocListener<DormRoomCubit, DormRoomState>(
          listener: (context, state) {
            if (state is DormRoomActionLoading) {
              if (_isActionInProgress) _showLoadingDialog("جاري حفظ التغييرات للغرفة...");
            } else if (state is DormRoomActionSuccess) {
              if (_isActionInProgress) {
                _dismissLoadingDialog();
                setState(() => _isActionInProgress = false);
              }
              showWebBanner(context, state.message, type: BannerType.success);
            } else if (state is DormRoomError) {
              if (_isActionInProgress) {
                _dismissLoadingDialog();
                setState(() => _isActionInProgress = false);
              }
              showWebBanner(context, state.message, type: BannerType.error);
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFFF1F5F9),
        appBar: AppBar(
          title: Text(
            "إدارة السكن الجامعي",
            style: styles.headline2.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [_primaryColor, _secondaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withValues(alpha: 0.7),
            tabs: const [
              Tab(icon: Icon(Icons.business_rounded), text: "الأبنية السكنية"),
              Tab(icon: Icon(Icons.meeting_room_rounded), text: "الغرف السكنية"),
            ],
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildBuildingsTab(styles, isDesktop),
              _buildRoomsTab(styles, isDesktop),
            ],
          ),
        ),
      ),
    );
  }

  // ====== BUILDINGS TAB ======

  Widget _buildBuildingsTab(ThemedTextStyles styles, bool isDesktop) {
    return BlocBuilder<DormBuildingCubit, DormBuildingState>(
      builder: (context, state) {
        final list = context.read<DormBuildingCubit>().buildings;
        final filtered = list.where((b) {
          return b.name.toLowerCase().contains(_buildingSearchQuery.toLowerCase());
        }).toList();

        if (state is DormBuildingLoading && list.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is DormBuildingError && list.isEmpty) {
          return ShowErrorWidgetView(
            errorMessage: state.message,
            showImage: false,
            onRetry: () => context.read<DormBuildingCubit>().fetchBuildings(),
          );
        }

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Top Statistics Row & Control Panel
            SliverPadding(
              padding: EdgeInsets.all(isDesktop ? 24 : 12),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    _buildBuildingsHeaderPanel(styles, isDesktop),
                    const SizedBox(height: 16),
                    _buildBuildingsStatsRow(list),
                  ],
                ),
              ),
            ),
            // Buildings Grid/List
            if (filtered.isEmpty && list.isNotEmpty)
              const SliverFillRemaining(
                child: EmptyListViews(text: 'لا توجد نتائج مطابقة لبحثك'),
              )
            else if (filtered.isEmpty)
              const SliverFillRemaining(
                child: EmptyListViews(text: 'لا توجد أبنية سكنية مضافة حالياً'),
              )
            else
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: isDesktop ? 24 : 12),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isDesktop ? 3 : 1,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: isDesktop ? 1.4 : 2.5,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = filtered[index];
                      return _buildBuildingCard(item, styles, index);
                    },
                    childCount: filtered.length,
                  ),
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        );
      },
    );
  }

  Widget _buildBuildingsHeaderPanel(ThemedTextStyles styles, bool isDesktop) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: TextField(
                controller: _buildingSearchController,
                onChanged: (val) => setState(() => _buildingSearchQuery = val),
                textDirection: TextDirection.rtl,
                decoration: const InputDecoration(
                  hintText: "بحث عن مبنى سكني بالاسم...",
                  hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                  prefixIcon: Icon(Icons.search, color: Color(0xFF94A3B8)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: () => _openAddEditBuildingDialog(),
            icon: const Icon(Icons.add_rounded, color: Colors.white),
            label: const Text(
              "مبنى جديد",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBuildingsStatsRow(List<DormBuildingModel> list) {
    final totalFloors = list.fold<int>(0, (sum, b) => sum + b.totalFloors);
    return Row(
      children: [
        _buildMiniStatCard(
          icon: Icons.business_rounded,
          label: "إجمالي الأبنية السكنية",
          value: "${list.length}",
          color: _primaryColor,
          bgColor: const Color(0xFFEEF2FF),
        ),
        const SizedBox(width: 12),
        _buildMiniStatCard(
          icon: Icons.layers_outlined,
          label: "مجموع الطوابق الكلي",
          value: "$totalFloors",
          color: _secondaryColor,
          bgColor: const Color(0xFFF5F3FF),
        ),
      ],
    );
  }

  Widget _buildBuildingCard(DormBuildingModel building, ThemedTextStyles styles, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _primaryColor.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.business_rounded, color: _primaryColor, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    building.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E293B),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    _buildMiniActionButton(
                      icon: Icons.edit_outlined,
                      color: _accentColor,
                      onTap: () => _openAddEditBuildingDialog(building: building),
                    ),
                    const SizedBox(width: 4),
                    _buildMiniActionButton(
                      icon: Icons.delete_outline_rounded,
                      color: Colors.redAccent,
                      onTap: () => _deleteBuilding(building),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFF1F5F9)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.layers_outlined, size: 18, color: Color(0xFF64748B)),
                      const SizedBox(width: 6),
                      const Text(
                        "عدد الطوابق:",
                        style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "${building.totalFloors}",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                  TextButton.icon(
                    onPressed: () => _viewRoomsForBuilding(building),
                    icon: const Icon(Icons.arrow_back_rounded, size: 16, color: _primaryColor),
                    label: const Text(
                      "عرض الغرف",
                      style: TextStyle(fontWeight: FontWeight.bold, color: _primaryColor),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
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

  // ====== ROOMS TAB ======

  Widget _buildRoomsTab(ThemedTextStyles styles, bool isDesktop) {
    final buildings = context.read<DormBuildingCubit>().buildings;

    if (buildings.isEmpty) {
      return const Center(
        child: EmptyListViews(
          text: "الرجاء إضافة مبنى سكني أولاً في تبويب الأبنية السكنية",
        ),
      );
    }

    return BlocBuilder<DormRoomCubit, DormRoomState>(
      builder: (context, state) {
        final list = context.read<DormRoomCubit>().rooms;
        final filtered = list.where((r) {
          return r.roomNumber.toLowerCase().contains(_roomSearchQuery.toLowerCase());
        }).toList();

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Top Controls & Filter Dropdown
            SliverPadding(
              padding: EdgeInsets.all(isDesktop ? 24 : 12),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    _buildRoomsHeaderPanel(buildings, isDesktop),
                    const SizedBox(height: 16),
                    _buildRoomsStatsRow(list),
                  ],
                ),
              ),
            ),
            // Rooms Grid
            if (state is DormRoomLoading)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (state is DormRoomError)
              SliverFillRemaining(
                child: ShowErrorWidgetView(
                  errorMessage: state.message,
                  showImage: false,
                  onRetry: () {
                    if (_selectedBuildingFilterId != null) {
                      context.read<DormRoomCubit>().fetchRoomsByBuilding(_selectedBuildingFilterId!);
                    }
                  },
                ),
              )
            else if (filtered.isEmpty && list.isNotEmpty)
              const SliverFillRemaining(
                child: EmptyListViews(text: 'لا توجد نتائج مطابقة لبحثك'),
              )
            else if (filtered.isEmpty)
              const SliverFillRemaining(
                child: EmptyListViews(text: 'لا توجد غرف مضافة في هذا المبنى'),
              )
            else
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: isDesktop ? 24 : 12),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isDesktop ? 4 : 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: isDesktop ? 1.25 : 1.1,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final room = filtered[index];
                      return _buildRoomCard(room, styles, index);
                    },
                    childCount: filtered.length,
                  ),
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        );
      },
    );
  }

  Widget _buildRoomsHeaderPanel(List<DormBuildingModel> buildings, bool isDesktop) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: isDesktop ? 2 : 1,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: _selectedBuildingFilterId,
                      hint: const Text("اختر المبنى السكني للفلترة"),
                      isExpanded: true,
                      items: buildings.map((b) {
                        return DropdownMenuItem<int>(
                          value: b.id,
                          child: Text(
                            "مبنى: ${b.name}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _selectedBuildingFilterId = val;
                          });
                          context.read<DormRoomCubit>().fetchRoomsByBuilding(val);
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: isDesktop ? 3 : 1,
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: TextField(
                    controller: _roomSearchController,
                    onChanged: (val) => setState(() => _roomSearchQuery = val),
                    textDirection: TextDirection.rtl,
                    decoration: const InputDecoration(
                      hintText: "بحث برقم الغرفة...",
                      hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                      prefixIcon: Icon(Icons.search, color: Color(0xFF94A3B8)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () => _openAddEditRoomDialog(),
                icon: const Icon(Icons.add_rounded, color: Colors.white),
                label: const Text(
                  "غرفة جديدة",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _secondaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoomsStatsRow(List<DormRoomModel> list) {
    final totalCapacity = list.fold<int>(0, (sum, r) => sum + r.capacity);
    return Row(
      children: [
        _buildMiniStatCard(
          icon: Icons.meeting_room_rounded,
          label: "الغرف في هذا المبنى",
          value: "${list.length}",
          color: _secondaryColor,
          bgColor: const Color(0xFFF5F3FF),
        ),
        const SizedBox(width: 12),
        _buildMiniStatCard(
          icon: Icons.airline_seat_flat_outlined,
          label: "السعة الاستيعابية الكلية",
          value: "$totalCapacity",
          color: _accentColor,
          bgColor: const Color(0xFFE0F2FE),
        ),
      ],
    );
  }

  Widget _buildRoomCard(DormRoomModel room, ThemedTextStyles styles, int index) {
    final isAvailable = room.status.toLowerCase() == 'available';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _secondaryColor.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: _secondaryColor.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Icon and options
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F3FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.meeting_room_rounded, color: _secondaryColor, size: 20),
                ),
                Row(
                  children: [
                    _buildMiniActionButton(
                      icon: Icons.edit_outlined,
                      color: _accentColor,
                      onTap: () => _openAddEditRoomDialog(room: room),
                    ),
                    const SizedBox(width: 4),
                    _buildMiniActionButton(
                      icon: Icons.delete_outline_rounded,
                      color: Colors.redAccent,
                      onTap: () => _deleteRoom(room),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Room name / number
            Text(
              "غرفة: ${room.roomNumber}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 4),
            // Floor Number & Capacity
            Row(
              children: [
                const Icon(Icons.layers_outlined, size: 14, color: Color(0xFF64748B)),
                const SizedBox(width: 4),
                Text(
                  "طابق: ${room.floorNumber}",
                  style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
                const Spacer(),
                const Icon(Icons.people_outlined, size: 14, color: Color(0xFF64748B)),
                const SizedBox(width: 4),
                Text(
                  "السعة: ${room.capacity}",
                  style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
              ],
            ),
            const Spacer(),
            // Status Tag
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                color: isAvailable ? const Color(0xFFD1FAE5) : const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                isAvailable ? "متاحة" : "ممتلئة",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isAvailable ? const Color(0xFF065F46) : const Color(0xFF991B1B),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ====== GENERAL UI WIDGETS ======

  Widget _buildMiniStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required Color bgColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
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

  Widget _buildMiniActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
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
    );
  }
}
