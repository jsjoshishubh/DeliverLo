import 'package:deliverylo/Commons and Reusables/common_bottom_bar.dart';
import 'package:deliverylo/Views/Food%20Main%20Home/Food_home_page.dart';
import 'package:deliverylo/Views/Food%20Main%20Home/Search_Deligate_page.dart';
import 'package:deliverylo/Views/checkout%20and%20orderSuccess%20and%20Order%20Tracking/checkout_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../Routes/app_routes.dart';

class FoodMainDashboard extends StatefulWidget {
  const FoodMainDashboard({super.key});

  @override
  State<FoodMainDashboard> createState() => _FoodMainDashboardState();
}

class _FoodMainDashboardState extends State<FoodMainDashboard> {
  static const String _checkoutCartStorageKey = 'checkout_cart_items';
  final GetStorage _storage = GetStorage();
  final PageController _pageController = PageController();
  int _currentIndex = 1;
  int _cartBadgeCount = 0;

  static const List<CommonBottomBarItem> _bottomBarItems = [
    CommonBottomBarItem(icon: Icons.dashboard_outlined, label: 'Dashboard'),
    CommonBottomBarItem(icon: Icons.home_outlined, label: 'Home'),
    // CommonBottomBarItem(icon: Icons.receipt, label: 'Dining'),
    CommonBottomBarItem(icon: Icons.search, label: 'Search'),
    CommonBottomBarItem(icon: Icons.shopping_cart_outlined, label: 'Cart', badgeCount: 0),
  ];

  List<CommonBottomBarItem> get _itemsWithBadge => [
        _bottomBarItems[0],
        _bottomBarItems[1],
        _bottomBarItems[2],
        CommonBottomBarItem(
          icon: _bottomBarItems[3].icon,
          label: _bottomBarItems[3].label,
          badgeCount: _cartBadgeCount,
        ),
      ];

  @override
  void initState() {
    super.initState();
    _loadCartBadgeCount();
    _storage.listenKey(_checkoutCartStorageKey, (dynamic _) {
      if (!mounted) return;
      _loadCartBadgeCount();
    });
  }

  void _loadCartBadgeCount() {
    final dynamic raw = _storage.read(_checkoutCartStorageKey);
    if (raw is! List) {
      if (_cartBadgeCount != 0) setState(() => _cartBadgeCount = 0);
      return;
    }
    int count = 0;
    for (final e in raw) {
      if (e is Map) {
        final q = e['quantity'];
        if (q is int && q > 0) {
          count += q;
        } else if (q is num && q > 0) {
          count += q.toInt();
        } else {
          count += 1;
        }
      }
    }
    if (_cartBadgeCount != count) {
      setState(() => _cartBadgeCount = count);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if(index == 0){
      Get.offAllNamed(Routes.MAIN_DASHBOARD);
    }else{
      setState(() {
      _currentIndex = index;
    });
    _pageController.jumpToPage(index);
    }
    
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const FoodHomePageView();
      case 1:
        return const FoodHomePageView();
      // case 2:
      //   return const Center(child: Text('Dining'));
      case 2:
        return const SearchDeligatePage();
      case 3:
        return const CheckoutPage();
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: HexColor.fromHex('#F8F8F8'),
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
        items: _itemsWithBadge,
      ),
    );
  }
}
