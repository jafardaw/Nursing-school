import 'package:finalproject/core/constants/app_constants.dart';
import 'package:finalproject/core/di/service_locator.dart';
import 'package:finalproject/core/navigation/list_page_home_view.dart';
import 'package:finalproject/core/storage/storage_service.dart';
import 'package:finalproject/feature/Home/presentation/views/widget/collapse_botton.dart';
import 'package:finalproject/feature/Home/presentation/views/widget/customtopbar.dart';
import 'package:finalproject/feature/Home/presentation/views/widget/railheader.dart';
import 'package:flutter/material.dart';
import 'package:finalproject/core/theme/theme_extination.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isExpanded = true;
  final storage = sl<StorageService>();

  // متغيرات لحفظ الحالة
  List<AppSection>? _activeSections;
  String? _userRole;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initAppData(); // جلب البيانات مرة واحدة فقط هنا
  }

  Future<void> _initAppData() async {
    final role = await storage.getString(AppConstants.roleKey);
    print('saaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa$role');

    if (mounted) {
      setState(() {
        _userRole = role ?? 'guest';
        _activeSections = NavConfig.getSections(_userRole!);
        _isLoading = false; // انتهى التحميل ولن يعود للظهور مرة أخرى
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // إظهار شاشة التحميل فقط في المرة الأولى التي نفتح فيها التطبيق
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // الآن نستخدم _activeSections المباشرة، ولن تختفي عند التنقل
    return Scaffold(
      body: Row(
        children: [
          _buildNavigationRail(),

          const VerticalDivider(thickness: 1, width: 1),

          Expanded(
            child: Column(
              children: [
                TopBar(
                  title: _activeSections![_selectedIndex].title,
                  role: _userRole!,
                ),
                Expanded(
                  child: Container(
                    color: context.styles.backgroundColor,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      // مفتاح فريد لضمان حدوث حركة انتقال ناعمة بين الصفحات
                      child: KeyedSubtree(
                        key: ValueKey(_selectedIndex),
                        child: _activeSections![_selectedIndex].page,
                      ),
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
      scrollable: true,
      extended: _isExpanded,
      backgroundColor: context.styles.primaryDark,
      selectedIndex: _selectedIndex,
      onDestinationSelected: (index) {
        // هنا يتم تغيير الصفحة فقط دون إعادة تشغيل الـ Future
        setState(() => _selectedIndex = index);
      },
      unselectedIconTheme: IconThemeData(
        color: Colors.white.withOpacity(0.5),
        size: 24,
      ),
      selectedIconTheme: const IconThemeData(color: Colors.white, size: 28),
      selectedLabelTextStyle: context.styles.bodyLarge.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelTextStyle: context.styles.bodyMedium.copyWith(
        color: Colors.white.withOpacity(0.6),
      ),
      leading: RailHeader(isExpanded: _isExpanded),
      destinations: _activeSections!.map((section) {
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
