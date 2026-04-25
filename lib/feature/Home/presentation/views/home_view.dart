import 'package:finalproject/core/theme/theme_extination.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isExpanded = true; // ميزة طي القائمة لتوفير مساحة

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // القائمة الجانبية الاحترافية
          NavigationRail(
            extended: _isExpanded, // يتحكم في ظهور النص بجانب الأيقونة
            backgroundColor: context.styles.surfaceColor,
            unselectedIconTheme: IconThemeData(color: context.styles.iconColor),
            selectedIconTheme: IconThemeData(
              color: context.styles.primaryColor,
            ),
            selectedLabelTextStyle: context.styles.bodyLarge.copyWith(
              color: context.styles.primaryColor,
              fontWeight: FontWeight.bold,
            ),
            // شعار الكلية في الأعلى
            leading: _buildRailHeader(),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: Text("الرئيسية"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.school_outlined),
                selectedIcon: Icon(Icons.school),
                label: Text("شؤون الطالبات"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.assignment_late_outlined),
                selectedIcon: Icon(Icons.assignment_late),
                label: Text("الغياب والإنذارات"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.analytics_outlined),
                selectedIcon: Icon(Icons.analytics),
                label: Text("الإحصائيات والتقارير"),
              ),
            ],
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) =>
                setState(() => _selectedIndex = index),
            // زر لتصغير وتكبير القائمة
            trailing: IconButton(
              icon: Icon(
                _isExpanded ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
              ),
              onPressed: () => setState(() => _isExpanded = !_isExpanded),
            ),
          ),

          const VerticalDivider(thickness: 1, width: 1), // فاصل ناعم جداً
          // محتوى الصفحة مع AppBar علوي لكل صفحة
          Expanded(
            child: Column(
              children: [
                _buildTopBar(context), // شريط علوي للبحث والتنبيهات والبروفايل
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _getPage(_selectedIndex),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // شريط علوي احترافي (Top Bar)
  Widget _buildTopBar(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: context.styles.backgroundColor,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          Text(_getPageTitle(_selectedIndex), style: context.styles.headline1),
          const Spacer(),
          // هنا نضع التنبيهات والبروفايل
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          const SizedBox(width: 16),
          _buildUserAvatar(context),
        ],
      ),
    );
  }

  // تابع لبناء محتوى الصفحات
  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const Center(child: Text("لوحة التحكم العامة"));
      case 1:
        return const Center(child: Text("قائمة الطالبات والبيانات"));
      default:
        return const Center(child: Text("قيد التطوير"));
    }
  }

  String _getPageTitle(int index) {
    List<String> titles = ["الرئيسية", "إدارة الطالبات", "الغياب", "التقارير"];
    return titles[index];
  } // 1. دالة بناء رأس القائمة الجانبية (الشعار)

  Widget _buildRailHeader() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: _isExpanded
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Column(
                children: [
                  const Icon(
                    Icons.local_hospital,
                    size: 40,
                    color: Colors.blue,
                  ), // أيقونة مؤقتة
                  const SizedBox(height: 10),
                  Text(
                    "كلية التمريض",
                    style: context.styles.headline4, // تأكد من المسمى هنا
                  ),
                ],
              ),
            )
          : const Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Icon(Icons.local_hospital, color: Colors.blue),
            ),
    );
  }

  // 2. دالة بناء صورة المستخدم (Avatar) في الشريط العلوي
  Widget _buildUserAvatar(BuildContext context) {
    return Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "اسم المستخدم", // سنربطها لاحقاً بالـ AuthCubit
              style: context.styles.bodyLarge.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text("مسؤول الشؤون", style: context.styles.bodySmall),
          ],
        ),
        const SizedBox(width: 12),
        CircleAvatar(
          radius: 20,
          backgroundColor: context.styles.primaryColor.withOpacity(0.1),
          child: Icon(Icons.person, color: context.styles.primaryColor),
        ),
      ],
    );
  }
}
