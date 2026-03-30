import 'package:deliverylo/Commons%20and%20Reusables/common_app_screen_background.dart';
import 'package:deliverylo/Commons%20and%20Reusables/common_bottomSheet.dart';
import 'package:deliverylo/Components/FoodHomePageComponents/Food_TabBar_component.dart';
import 'package:deliverylo/Components/FoodHomePageComponents/Food_home_page_address_and_search_and_profile_componenet.dart';
import 'package:deliverylo/Components/GroceryHomePageComponents/grocery_lowest_prices_section.dart';
import 'package:deliverylo/Components/ProfilePageComponents/select_address_component.dart';
import 'package:deliverylo/Components/GroceryHomePageComponents/grocery_snacks_drinks_section.dart';
import 'package:deliverylo/Components/GroceryHomePageComponents/grocery_you_might_need_section.dart';
import 'package:deliverylo/Models/food_item_model.dart';
import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class GroceryHomePage extends StatefulWidget {
  const GroceryHomePage({super.key});

  @override
  State<GroceryHomePage> createState() => _GroceryHomePageState();
}

class _GroceryHomePageState extends State<GroceryHomePage> {
  static const String _selectedAddressStorageKey = 'food_selected_address';
  final GetStorage _storage = GetStorage();
  int _selectedGroceryCategoryIndex = 0;
  String _selectedAddressLabel = 'Please select address';

  @override
  void initState() {
    super.initState();
    _loadSelectedAddressFromStorage();
  }

  String _buildAddressLabelFromSelection(Map selection) {
    final String title = (selection['title'] ?? selection['label'] ?? 'Other').toString().trim();
    final String directAddress = (selection['address'] ?? selection['fullAddress'] ?? selection['formattedAddress'] ?? '').toString().trim();
    final String composedAddress = [
      (selection['line1'] ?? selection['flat'] ?? '').toString().trim(),
      (selection['line2'] ?? selection['area'] ?? '').toString().trim(),
      (selection['landmark'] ?? '').toString().trim(),
      (selection['city'] ?? '').toString().trim(),
      (selection['state'] ?? '').toString().trim(),
      (selection['pincode'] ?? selection['postalCode'] ?? '').toString().trim(),
    ].where((part) => part.isNotEmpty).join(', ');
    final String address = directAddress.isNotEmpty ? directAddress : composedAddress;
    if (address.isEmpty) return title.toUpperCase();
    return '${title.toUpperCase()} - $address';
  }

  void _loadSelectedAddressFromStorage() {
    final dynamic storedAddress = _storage.read(_selectedAddressStorageKey);
    if (storedAddress is! Map) return;
    final label = _buildAddressLabelFromSelection(storedAddress);
    if (label.trim().isEmpty) return;
    setState(() {
      _selectedAddressLabel = label;
    });
  }

  Future<void> _openSelectAddressBottomSheet() async {
    final dynamic selectedAddress = await showCommonBottomSheet<Map<String, dynamic>>(
      context: context,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.76,
        child: const SelectAddressComponent(),
      ),
    );

    if (!mounted || selectedAddress is! Map) return;

    await _storage.write(
      _selectedAddressStorageKey,
      Map<String, dynamic>.from(selectedAddress),
    );

    setState(() {
      _selectedAddressLabel = _buildAddressLabelFromSelection(selectedAddress);
    });
  }

  final List<Map<String, dynamic>> _groceryCategories = const [
    {'title': 'All', 'icon': Icons.shopping_bag_outlined},
    {'title': 'Fresh', 'icon': Icons.eco_outlined},
    {'title': 'Pantry', 'icon': Icons.restaurant_outlined},
    {'title': 'Drinks', 'icon': Icons.water_drop_outlined},
    {'title': 'Baby', 'icon': Icons.child_care_outlined},
  ];

  final List<FoodItemModel> _groceryDailyNeedsItems = [
    FoodItemModel(
      id: 'dn_1',
      name: 'Basmati Rice',
      imageUrl: 'https://images.unsplash.com/photo-1586201375761-83865001e31c?auto=format&fit=crop&w=800&q=80',
      rating: 4.6,
      deliveryTime: '20-25 mins',
      category: 'Grains',
      discount: '20% OFF',
    ),
    FoodItemModel(
      id: 'dn_2',
      name: 'Aashirvaad Atta',
      imageUrl: 'https://images.unsplash.com/photo-1609501676725-7186f7f25d79?auto=format&fit=crop&w=800&q=80',
      rating: 4.5,
      deliveryTime: '20-25 mins',
      category: 'Flour',
      discount: '15% OFF',
    ),
    FoodItemModel(
      id: 'dn_3',
      name: 'Toor Dal',
      imageUrl: 'https://images.unsplash.com/photo-1515543904379-3d757afe72e3?auto=format&fit=crop&w=800&q=80',
      rating: 4.4,
      deliveryTime: '15-20 mins',
      category: 'Pulses',
      discount: '10% OFF',
    ),
  ];

  final List<FoodItemModel> _groceryVegetableItems = [
    FoodItemModel(
      id: 'vg_1',
      name: 'Fresh Tomatoes',
      imageUrl: 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?auto=format&fit=crop&w=800&q=80',
      rating: 4.7,
      deliveryTime: '10-15 mins',
      category: 'Vegetables',
      discount: '18% OFF',
    ),
    FoodItemModel(
      id: 'vg_2',
      name: 'Green Capsicum',
      imageUrl: 'https://images.unsplash.com/photo-1563565375-f3fdfdbefa83?auto=format&fit=crop&w=800&q=80',
      rating: 4.5,
      deliveryTime: '10-15 mins',
      category: 'Vegetables',
      discount: '12% OFF',
    ),
    FoodItemModel(
      id: 'vg_3',
      name: 'Fresh Potatoes',
      imageUrl: 'https://images.unsplash.com/photo-1518977676601-b53f82aba655?auto=format&fit=crop&w=800&q=80',
      rating: 4.4,
      deliveryTime: '10-15 mins',
      category: 'Vegetables',
      discount: '10% OFF',
    ),
  ];

  List<Map<String, dynamic>> get _groceryTabBarTabs => [
        {
          'tab_title': 'Daily Needs',
          'items': _groceryDailyNeedsItems,
        },
        {
          'tab_title': 'Vegetables',
          'items': _groceryVegetableItems,
        },
      ];

  final List<Map<String, dynamic>> _youMightNeedItems = [
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1563636619-e9143da7973b?auto=format&fit=crop&w=800&q=80',
      'quantity': '1 L',
      'name': 'Fresh Toned Milk',
      'price': '₹64',
      'oldPrice': '₹70',
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?auto=format&fit=crop&w=800&q=80',
      'quantity': '1 L',
      'name': 'Sunlite Refined Oil',
      'price': '₹145',
      'oldPrice': '₹180',
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1590502593747-42a996133562?auto=format&fit=crop&w=800&q=80',
      'quantity': '4 pcs',
      'name': 'Fresh Lemon',
      'price': '₹20',
      'oldPrice': '₹35',
    },
  ];

  final List<Map<String, dynamic>> _lowestPriceItems = [
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1627485937980-221c88ac04f9?auto=format&fit=crop&w=800&q=80',
      'quantity': '870 g',
      'name': 'Gulab Double Filtered Groundnut Oil',
      'rating': '4.7',
      'ratingCount': '7.4k',
      'offText': '',
      'unitPrice': '₹31.1/100 g',
      'price': '₹271',
      'oldPrice': '',
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?auto=format&fit=crop&w=800&q=80',
      'quantity': '500 g',
      'name': 'Supreme Harvest Groundnut',
      'rating': '4.6',
      'ratingCount': '57.1k',
      'offText': '35% OFF',
      'unitPrice': '₹170/kg',
      'price': '₹85',
      'oldPrice': '₹132',
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1586201375761-83865001e17a?auto=format&fit=crop&w=800&q=80',
      'quantity': '1 kg',
      'name': 'Uttam Sooji',
      'rating': '4.5',
      'ratingCount': '2.5k',
      'offText': '8% OFF',
      'unitPrice': '₹57/kg',
      'price': '₹57',
      'oldPrice': '₹62',
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1547592166-23ac45744acd?auto=format&fit=crop&w=800&q=80',
      'quantity': '300 g',
      'name': 'MAGGI 2-Minute Instant Noodles',
      'rating': '4.6',
      'ratingCount': '132k',
      'offText': '17% OFF',
      'unitPrice': '₹16/100 g',
      'price': '₹48',
      'oldPrice': '₹58',
    },
  ];

  final List<Map<String, dynamic>> _snacksAndDrinksItems = [
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1624517452488-04869289c4ca?auto=format&fit=crop&w=800&q=80',
      'title': 'Cold Drinks and Juices',
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1563805042-7684c019e1cb?auto=format&fit=crop&w=800&q=80',
      'title': 'Ice Creams and Frozen Desserts',
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1621939514649-280e2ee25f60?auto=format&fit=crop&w=800&q=80',
      'title': 'Chips and Namkeens',
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1511381939415-e44015466834?auto=format&fit=crop&w=800&q=80',
      'title': 'Chocolates',
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1628191010417-1399ec45ea26?auto=format&fit=crop&w=800&q=80',
      'title': 'Noodles, Pasta, Vermicelli',
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1609501676725-7186f7f25d79?auto=format&fit=crop&w=800&q=80',
      'title': 'Frozen Food',
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1481391032119-d89fee407e44?auto=format&fit=crop&w=800&q=80',
      'title': 'Sweet Corner',
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1628435493128-984cb169bafd?auto=format&fit=crop&w=800&q=80',
      'title': 'Paan Corner',
    },
  ];

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) setState(() {});
  }

  Widget _buildGroceryCategoryComponent() {
    return Container(
      height: 108,
      width: double.infinity,
      margin: const EdgeInsets.only(left: 0, right: 8, top: 20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _groceryCategories.length,
        itemBuilder: (context, index) {
          final item = _groceryCategories[index];
          final isSelected = _selectedGroceryCategoryIndex == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedGroceryCategoryIndex = index;
              });
            },
            child: Container(
              width: 60,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? Colors.white
                          : Colors.white.withOpacity(0.12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.16),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      item['icon'] as IconData,
                      size: 28,
                      color: isSelected
                          ? HexColor.fromHex('#21C460')
                          : Colors.white.withOpacity(0.92),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item['title'] as String,
                    style: commonTextStyle(
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 14,
                      fontColor: Colors.white,
                    ),
                  ),
                  if (isSelected) ...[
                    const SizedBox(height: 4),
                    Container(
                      height: 4,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor.fromHex('#EDF5F0'),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: HexColor.fromHex('#15803D'),
        child: CommonAppScreenBackground(
          scrollable: true,
          topColor: HexColor.fromHex('#15803D'),
          topHeight: 380,
          topChild: Container(
            child: Column(
              children: [
                HomePageAddressAndSearchAndProfileComponenet(
                  onAddressTap: _openSelectAddressBottomSheet,
                  addressLabel: _selectedAddressLabel,
                  accentColor: HexColor.fromHex('#15803D'),
                  showVegMode: false,
                  searchPlaceholder: "Search 'Grocery'",
                ),
                // _buildGroceryCategoryComponent(),
                const SizedBox(height: 76),
                Image.asset('Assets/Extras/cat_5.png', scale: 5),
              ],
            ),
          ),
          bottomChild: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
             Container(height: 10,width: double.infinity,color: HexColor.fromHex('#EDF5F0'),),
              Container(
                height: 296,
                color: HexColor.fromHex('#EDF5F0'),
                child: FoodTabBarComponent(
                  tabss: _groceryTabBarTabs,
                  accentColor: HexColor.fromHex('#15803D'),
                  showFavoriteOnCards: false,
                  itemCardErrorIcon: Icons.local_grocery_store,
                  useGroceryDetailPage: true,
                ),
              ),
              // const SizedBox(height: 8),
              GroceryYouMightNeedSection(items: _youMightNeedItems),
              GroceryLowestPricesSection(items: _lowestPriceItems),
              GrocerySnacksDrinksSection(items: _snacksAndDrinksItems),
            ],
          ),
        ),
      ),
    );
  }
}