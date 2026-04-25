import 'package:finalproject/core/navigation/list_page_home_view.dart';
import 'package:finalproject/feature/Home/presentation/views/widget/collapse_botton.dart';
import 'package:finalproject/feature/Home/presentation/views/widget/customtopbar.dart';
import 'package:finalproject/feature/Home/presentation/views/widget/railheader.dart';
import 'package:flutter/material.dart';
import 'package:finalproject/core/theme/theme_extination.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.role});
  final String role;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isExpanded = true;
  late List<AppSection> _activeSections;

  @override
  void initState() {
    super.initState();
    _activeSections = NavConfig.getSections(widget.role);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // 1. القائمة الجانبية (SideBar)
          _buildNavigationRail(),

          const VerticalDivider(thickness: 1, width: 1),

          // 2. المحتوى الرئيسي (TopBar + Content)
          Expanded(
            child: Column(
              children: [
                TopBar(
                  title: _activeSections[_selectedIndex].title,
                  role: widget.role,
                ),
                Expanded(
                  child: Container(
                    color: context.styles.backgroundColor,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child: _activeSections[_selectedIndex].page,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationRail() {
    return NavigationRail(
      extended: _isExpanded,
      backgroundColor: context.styles.primaryDark,
      selectedIndex: _selectedIndex,
      onDestinationSelected: (index) => setState(() => _selectedIndex = index),
      unselectedIconTheme: IconThemeData(
        color: Colors.white.withValues(alpha: 0.5),
        size: 24,
      ),
      selectedIconTheme: const IconThemeData(color: Colors.white, size: 28),
      selectedLabelTextStyle: context.styles.bodyLarge.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelTextStyle: context.styles.bodyMedium.copyWith(
        color: Colors.white.withValues(alpha: 0.6),
      ),
      leading: RailHeader(isExpanded: _isExpanded),
      destinations: _activeSections.map((section) {
        return NavigationRailDestination(
          icon: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Icon(section.icon),
          ),
          selectedIcon: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Icon(section.selectedIcon),
          ),
          label: Text(section.title),
        );
      }).toList(),
      trailing: CollapseButton(
        isExpanded: _isExpanded,
        onTap: () => setState(() => _isExpanded = !_isExpanded),
      ),
    );
  }
}

// --- 🛑 المكونات كـ Widgets منفصلة لتحسين الأداء (Stateless) 🛑 ---
