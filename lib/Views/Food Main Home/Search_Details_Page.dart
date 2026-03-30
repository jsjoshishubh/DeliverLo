import 'package:deliverylo/Components/SearchPageComponents/search_details_component.dart';
import 'package:deliverylo/Controllers/Food_Controller.dart';
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
  'description': '',
};

final List<String> _defaultMenuTabs = [
  'Recommended',
  'Starters',
  'Burgers',
  'Drinks',
  'Desserts',
];



class SearchDetailsPage extends StatefulWidget {
  const SearchDetailsPage({super.key});

  @override
  State<SearchDetailsPage> createState() => _SearchDetailsPageState();
}

class _SearchDetailsPageState extends State<SearchDetailsPage> {
  late final FoodController _foodController =
      Get.isRegistered<FoodController>() ? Get.find<FoodController>() : Get.put(FoodController());

  late final String _vendorId;

  /// True until the first post-frame callback runs — avoids calling [FoodController.update]
  /// during the route transition (which would mark other [GetBuilder]s dirty mid-build).
  bool _storeFetchScheduled = false;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>?;
    _vendorId = _resolveVendorId(args);
    if (_vendorId.isNotEmpty) {
      _storeFetchScheduled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _foodController.getSearchedDetails(_vendorId);
        setState(() => _storeFetchScheduled = false);
      });
    }
  }

  static List<String>? _subCategoryIdsFromDetails(Map<String, dynamic> d) {
    final raw = d['subcategories'];
    if (raw is! List) return null;
    final ids = <String>[];
    for (final e in raw) {
      if (e is Map) {
        final id = e['id']?.toString().trim() ?? '';
        if (id.isNotEmpty) ids.add(id);
      }
    }
    return ids.isEmpty ? null : ids;
  }

  static String _resolveVendorId(Map<String, dynamic>? args) {
    if (args == null) return '';
    final v = args['vendorId']?.toString().trim() ?? '';
    if (v.isNotEmpty) return v;
    return args['id']?.toString().trim() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final shouldFetch = _vendorId.isNotEmpty;

    return GetBuilder<FoodController>(
      builder: (c) {
        final waitingForStore = shouldFetch &&
            c.searchedStoreDetails == null &&
            (c.searchedStoreDetailsLoading || _storeFetchScheduled);

        if (waitingForStore) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(color: HexColor.fromHex('#BD0D0E')),
            ),
          );
        }

        final Map<String, dynamic> restaurantDetails;
        final List<String> menuTabs;

        if (shouldFetch && c.searchedStoreDetails != null) {
          restaurantDetails = c.searchedStoreDetails!;
          menuTabs =
              c.searchedStoreMenuTabs.isNotEmpty ? c.searchedStoreMenuTabs : List<String>.from(_defaultMenuTabs);
        } else {
          restaurantDetails =
              args != null ? _restaurantDetailsFromSearch(args) : Map<String, dynamic>.from(_defaultRestaurantDetails);
          menuTabs = List<String>.from(_defaultMenuTabs);
        }

        final menuItems = args != null && args['menuItems'] != null ? List<Map<String, dynamic>>.from(args['menuItems'] as List) : [];

        final String? vendorIdForMenu =
            shouldFetch && c.searchedStoreDetails != null ? restaurantDetails['id']?.toString().trim() : null;
        final subCategoryIdsForMenu =
            shouldFetch && c.searchedStoreDetails != null ? _subCategoryIdsFromDetails(restaurantDetails) : null;

        return Scaffold(
          backgroundColor: Colors.white,
          body: SearchDetailsComponent(
            restaurantDetails: restaurantDetails,
            menuTabs: menuTabs,
            menuItems: [],
            topImageUrl: restaurantDetails['heroImageUrl'] as String?,
            topColor: HexColor.fromHex('#1A1A1A'),
            topHeight: 340,
            vendorId: vendorIdForMenu != null && vendorIdForMenu.isNotEmpty ? vendorIdForMenu : null,
            subCategoryIds: subCategoryIdsForMenu,
          ),
        );
      },
    );
  }

  Map<String, dynamic> _restaurantDetailsFromSearch(Map<String, dynamic> item) {
    return {
      'name': item['name'] ?? _defaultRestaurantDetails['name'],
      'cuisine': item['cuisine'] ?? _defaultRestaurantDetails['cuisine'],
      'heroImageUrl': item['imageUrl'] ?? _defaultRestaurantDetails['heroImageUrl'],
      'rating': item['rating'] ?? _defaultRestaurantDetails['rating'],
      'ratingCount': item['ratingCount'] ?? '1.2k+ ratings',
      'deliveryTime': item['deliveryTime'] ?? _defaultRestaurantDetails['deliveryTime'],
      'costForTwo': item['priceForTwo'] ?? _defaultRestaurantDetails['costForTwo'],
      'description': item['description'] ?? '',
    };
  }
}
