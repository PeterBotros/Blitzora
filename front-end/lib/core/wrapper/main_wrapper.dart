import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/map/presentation/pages/map_page.dart';
import '../../features/products/presentation/pages/products_page.dart';
import '../../features/chatbot/presentation/pages/chatbot_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../constants/colors/app_colors.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  /// Global key — lets any widget call MainWrapper.globalKey.currentState?.selectTab(n)
  static final GlobalKey<MainWrapperState> globalKey =
      GlobalKey<MainWrapperState>();

  static MainWrapperState? of(BuildContext context) =>
      context.findAncestorStateOfType<MainWrapperState>();

  /// Navigate to a tab from anywhere — no BuildContext needed
  static void goToTab(int index) {
    globalKey.currentState?.selectTab(index);
  }

  @override
  State<MainWrapper> createState() => MainWrapperState();
}

class MainWrapperState extends State<MainWrapper> {
  int _selectedIndex = 0;

  /// Key to ProductsPage so we can request search focus when the tab is tapped
  final _productsKey = GlobalKey<ProductsPageState>();

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomePage(),
      const MapScreenPage(),
      ProductsPage(key: _productsKey), // Search tab — embedded, keeps bottom nav
      const ChatbotPage(),
      const ProfilePage(),
    ];
  }

  void selectTab(int index) {
    if (index < 0 || index >= _pages.length) return;
    setState(() => _selectedIndex = index);
    // When the Search tab is selected, auto-focus the search bar
    if (index == 2) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _productsKey.currentState?.focusSearch();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final bg = AppColors.background(dark);

    return Scaffold(
      backgroundColor: bg,
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: selectTab,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home_rounded),
            label: 'home'.tr(),
          ),
          NavigationDestination(
            icon: const Icon(Icons.map_outlined),
            selectedIcon: const Icon(Icons.map_rounded),
            label: 'map'.tr(),
          ),
          NavigationDestination(
            icon: const Icon(Icons.search_outlined),
            selectedIcon: const Icon(Icons.search_rounded),
            label: 'search'.tr(),
          ),
          NavigationDestination(
            icon: const Icon(Icons.chat_bubble_outline_rounded),
            selectedIcon: const Icon(Icons.chat_bubble_rounded),
            label: 'chat'.tr(),
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline_rounded),
            selectedIcon: const Icon(Icons.person_rounded),
            label: 'profile'.tr(),
          ),
        ],
      ),
    );
  }
}
