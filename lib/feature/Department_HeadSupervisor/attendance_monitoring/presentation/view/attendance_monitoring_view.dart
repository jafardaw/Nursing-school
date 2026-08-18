import 'package:finalproject/feature/Department_HeadSupervisor/attendance_monitoring/dormitory_attendance/presentation/view/dormitory_attendance_tab.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/attendance_monitoring/gate_attendance/presentation/view/gate_attendance_tab.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/attendance_monitoring/hospital_attendance/presentation/view/hospital_attendance_tab.dart';
import 'package:flutter/material.dart';

class AttendanceMonitoringView extends StatefulWidget {
  const AttendanceMonitoringView({super.key});

  @override
  State<AttendanceMonitoringView> createState() =>
      _AttendanceMonitoringViewState();
}

class _AttendanceMonitoringViewState extends State<AttendanceMonitoringView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F9),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──────────────────────────────────────────────────
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.monitor_heart_outlined,
                          color: Color(0xFF0D47A1),
                          size: 28,
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'نظام المراقبة الشاملة',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF181C32),
                              ),
                            ),
                            Text(
                              'متابعة حضور المشافي والبوابات والسكن',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF7E8299),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // ── Tab Bar ────────────────────────────────────────────
                    TabBar(
                      controller: _tabController,
                      labelColor: const Color(0xFF0D47A1),
                      unselectedLabelColor: const Color(0xFF7E8299),
                      indicatorColor: const Color(0xFF0D47A1),
                      indicatorWeight: 3,
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      tabs: const [
                        Tab(
                          icon: Icon(Icons.local_hospital_outlined),
                          text: 'حضور المشافي',
                        ),
                        Tab(
                          icon: Icon(Icons.sensor_door_outlined),
                          text: 'سجلات البوابة',
                        ),
                        Tab(
                          icon: Icon(Icons.hotel_outlined),
                          text: 'تفقد السكن',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // ── Tab Views ────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.all(20),
                child: [
                  const HospitalAttendanceTab(),
                  const GateAttendanceTab(),
                  const DormitoryAttendanceTab(),
                ][_tabController.index],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
