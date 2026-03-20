import 'package:deliverylo/Components/SearchPageComponents/search_details_component.dart';
import 'package:deliverylo/Styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final Map<String, dynamic> _defaultRestaurantDetails = {
  'name': 'The Burger Joint',
  'cuisine': 'American • Fast Food • Burgers',
  'heroImageUrl': 'Assets/Extras/tb_1.png',
  'rating': 4.8,
  'ratingCount': '1.2k+ ratings',
  'deliveryTime': '25m',
  'costForTwo': r'$$$',
};

final List<String> _defaultMenuTabs = [
  'Recommended',
  'Starters',
  'Burgers',
  'Drinks',
  'Desserts',
];

final List<Map<String, dynamic>> _defaultMenuItems = [
  {
    'name': 'Double Truffle Burger',
    'price': '₹150',
    'description': 'Double smashed patty, truffle mayo, aged cheddar,...',
    'imageUrl': 'Assets/Extras/tb_1.png',
    'isVeg': true,
    'isBestseller': true,
  },
  {
    'name': 'Double Truffle Burger',
    'price': '₹150',
    'description': 'Double smashed patty, truffle mayo, aged cheddar,...',
    'imageUrl': 'Assets/Extras/tb_2.png',
    'isVeg': true,
    'isBestseller': true,
  },
  {
    'name': 'Double Truffle Burger',
    'price': '₹150',
    'description': 'Double smashed patty, truffle mayo, aged cheddar,...',
    'imageUrl': 'Assets/Extras/tb_3.png',
    'isVeg': true,
    'isBestseller': true,
  },
];

class SearchDetailsPage extends StatelessWidget {
  const SearchDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final restaurantDetails = args != null ? _restaurantDetailsFromSearch(args) : _defaultRestaurantDetails;
    final menuTabs = _defaultMenuTabs;
    final menuItems = args != null && args['menuItems'] != null ? List<Map<String, dynamic>>.from(args['menuItems'] as List) : _defaultMenuItems;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SearchDetailsComponent(
        restaurantDetails: restaurantDetails,
        menuTabs: menuTabs,
        menuItems: menuItems,
        topImageUrl: restaurantDetails['heroImageUrl'] as String?,
        topColor: HexColor.fromHex('#1A1A1A'),
        topHeight: 340,
      ),
    );
  }

  Map<String, dynamic> _restaurantDetailsFromSearch(Map<String, dynamic> item) {
    return {
      'name': item['name'] ?? _defaultRestaurantDetails['name'],
      'cuisine': item['cuisine'] ?? _defaultRestaurantDetails['cuisine'],
      'heroImageUrl': item['imageUrl'] ?? _defaultRestaurantDetails['heroImageUrl'],
      'rating': item['rating'] ?? _defaultRestaurantDetails['rating'],
      'ratingCount': '1.2k+ ratings',
      'deliveryTime': item['deliveryTime'] ?? _defaultRestaurantDetails['deliveryTime'],
      'costForTwo': item['priceForTwo'] ?? _defaultRestaurantDetails['costForTwo'],
    };
  }
}
