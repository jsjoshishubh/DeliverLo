import 'package:deliverylo/Models/food_item_model.dart';

/// Static JSON data for "Min Rs 100 OFF" tab
List<Map<String, dynamic>> minOfferTabJson = [
  {
    'id': '1',
    'name': 'Behrouz Biryani',
    'imageUrl': 'Assets/Extras/tb_1.png',
    'rating': 4.3,
    'deliveryTime': '25-30 mins',
    'category': 'Biryani',
    'discount': '60% OFF',
  },
  {
    'id': '2',
    'name': 'Belgian Waffle',
    'imageUrl': 'Assets/Extras/tb_2.png',
    'rating': 4.3,
    'deliveryTime': '25-30 mins',
    'category': 'Waffles',
    'discount': '60% OFF',
  },
  {
    'id': '3',
    'name': 'Cafe Apetito',
    'imageUrl': 'Assets/Extras/tb_3.png',
    'rating': 4.3,
    'deliveryTime': '25-30 mins',
    'category': 'Coffee',
    'discount': '60% OFF',
  },
  {
    'id': '4',
    'name': 'Honey Ice Cream',
    'imageUrl': 'Assets/Extras/tb_1.png',
    'rating': 4.3,
    'deliveryTime': '25-30 mins',
    'category': 'Ice Cream',
    'discount': '60% OFF',
  },
  {
    'id': '5',
    'name': 'Spicy Chicken Bowl',
    'imageUrl': 'Assets/Extras/tb_2.png',
    'rating': 4.5,
    'deliveryTime': '20-25 mins',
    'category': 'Bowl',
    'discount': '60% OFF',
  },
];

/// Static JSON data for "Fast Delivery" tab
List<Map<String, dynamic>> fastDeliveryTabJson = [
  {
    'id': '101',
    'name': 'Quick Pizza',
    'imageUrl': 'Assets/Extras/tb_1.png',
    'rating': 4.2,
    'deliveryTime': '15-20 mins',
    'category': 'Pizza',
    'discount': '60% OFF',
  },
  {
    'id': '102',
    'name': 'Express Burger',
    'imageUrl': 'Assets/Extras/tb_2.png',
    'rating': 4.4,
    'deliveryTime': '10-15 mins',
    'category': 'Burger',
    'discount': '60% OFF',
  },
  {
    'id': '103',
    'name': 'Speedy Sandwich',
    'imageUrl': 'Assets/Extras/tb_1.png',
    'rating': 4.1,
    'deliveryTime': '12-18 mins',
    'category': 'Sandwich',
    'discount': '60% OFF',
  },
  {
    'id': '104',
    'name': 'Fast Noodles',
    'imageUrl': 'Assets/Extras/tb_3.png',
    'rating': 4.0,
    'deliveryTime': '8-12 mins',
    'category': 'Noodles',
    'discount': '60% OFF',
  },
  {
    'id': '105',
    'name': 'Instant Pasta',
    'imageUrl': 'Assets/Extras/tb_1.png',
    'rating': 4.3,
    'deliveryTime': '15-20 mins',
    'category': 'Pasta',
    'discount': '60% OFF',
  },
];

/// Simulates API fetch - replace with actual API call later
Future<List<FoodItemModel>> fetchFoodDataByTab(int tabIndex) async {
  await Future.delayed(const Duration(milliseconds: 1200));
  final jsonList = tabIndex == 0 ? minOfferTabJson : fastDeliveryTabJson;
  return jsonList.map((json) => FoodItemModel.fromJson(json)).toList();
}
