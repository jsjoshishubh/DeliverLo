import 'package:deliverylo/Commons%20and%20Reusables/common_app_screen_background.dart';
import 'package:deliverylo/Components/FoodHomePageComponents/Food_TabBar_component.dart';
import 'package:deliverylo/Components/FoodHomePageComponents/Food_home_page_address_and_search_and_profile_componenet.dart';
import 'package:deliverylo/Components/FoodHomePageComponents/Khana_Khajana_component.dart';
import 'package:deliverylo/Components/FoodHomePageComponents/whats_on_your_mind_component.dart';
import 'package:deliverylo/Models/food_item_model.dart';
import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';

class GroceryHomePage extends StatefulWidget {
  const GroceryHomePage({super.key});

  @override
  State<GroceryHomePage> createState() => _GroceryHomePageState();
}

class _GroceryHomePageState extends State<GroceryHomePage> {
  int _selectedGroceryCategoryIndex = 0;

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
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: HexColor.fromHex('#BD0D0E'),
        child: CommonAppScreenBackground(
          scrollable: true,
          topColor: HexColor.fromHex('#15803D'),
          topHeight: 420,
          topChild: Container(
            child: Column(
              children: [
                HomePageAddressAndSearchAndProfileComponenet(
                  showVegMode: false,
                  searchPlaceholder: "Search 'Grocery'",
                ),
                _buildGroceryCategoryComponent(),
                const SizedBox(height: 6),
                Image.asset('Assets/Extras/cat_5.png', scale: 5),
              ],
            ),
          ),
          bottomChild: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                height: 296,
                child: FoodTabBarComponent(
                  tabss: _groceryTabBarTabs,
                  accentColor: HexColor.fromHex('#15803D'),
                  showFavoriteOnCards: false,
                  itemCardErrorIcon: Icons.local_grocery_store,
                ),
              ),
              SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }
}