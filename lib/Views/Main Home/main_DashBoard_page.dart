import 'package:deliverylo/Commons and Reusables/common_bottom_bar.dart';
import 'package:deliverylo/Views/Food%20Main%20Home/Food_Main_dashboard.dart';
import 'package:deliverylo/Views/Main%20Home/main_home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Routes/app_routes.dart';

class MainDashBoardPage extends StatefulWidget {
  const MainDashBoardPage({super.key});

  @override
  State<MainDashBoardPage> createState() => _MainDashBoardPageState();
}

class _MainDashBoardPageState extends State<MainDashBoardPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  static const List<CommonBottomBarItem> _bottomBarItems = [
    CommonBottomBarItem(icon: Icons.home, label: 'Home'),
    CommonBottomBarItem(icon: Icons.fastfood, label: 'Food'),
    CommonBottomBarItem(icon: Icons.shopping_basket, label: 'Grocery'),
    CommonBottomBarItem(icon: Icons.headphones, label: 'Electronics'),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      Get.toNamed(Routes.FOOD_MAIN_DASHBOARD,);
      // Navigator.push(context,MaterialPageRoute(builder: (context) => const FoodMainDashboard()),);
      return;
    }

    setState(() {
      _currentIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  Widget _forGetPage(int index) {
    switch (index) {
      case 0:
        return const MainHomePage();
      case 1:
        return const Center(child: Text('Food'));
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
          return _forGetPage(index);
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