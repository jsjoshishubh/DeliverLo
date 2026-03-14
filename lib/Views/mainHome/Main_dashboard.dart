import 'package:deliverylo/Commons and Reusables/common_bottom_bar.dart';
import 'package:deliverylo/Styles/app_colors.dart';
import 'package:flutter/material.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  static const List<CommonBottomBarItem> _bottomBarItems = [
    CommonBottomBarItem(icon: Icons.home_outlined, label: 'Home'),
    CommonBottomBarItem(icon: Icons.receipt, label: 'Dining'),
    CommonBottomBarItem(icon: Icons.search, label: 'Search'),
    CommonBottomBarItem(icon: Icons.person_outline, label: 'Profile'),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const Center(child: Text("What's on your mind?"));
      case 1:
        return const Center(child: Text('Dining'));
      case 2:
        return const Center(child: Text('Search'));
      case 3:
        return const Center(child: Text('Profile'));
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor.fromHex('#F8F8F8'),
      body: PageView.builder(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _bottomBarItems.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return _getPage(index);
        },
      ),
      bottomNavigationBar: CommonBottomBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: _bottomBarItems,
      ),
    );
  }
}
