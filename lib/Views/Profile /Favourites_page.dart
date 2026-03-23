import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({super.key});

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  final List<Map<String, String>> _restaurantFavourites = [
    {
      'title': 'Burger King',
      'subtitle': 'American • Fast Food • \$\$',
      'rating': '4.8',
      'reviews': '1.2k+',
      'time': '20-30 min',
      'tag': 'FREE DELIVERY',
    },
    {
      'title': 'McDonald\'s',
      'subtitle': 'American • Burgers • \$',
      'rating': '4.7',
      'reviews': '980+',
      'time': '15-25 min',
      'tag': 'FREE DELIVERY',
    },
    {
      'title': 'Pizza Hut',
      'subtitle': 'Italian • Pizza • \$\$',
      'rating': '4.6',
      'reviews': '800+',
      'time': '25-35 min',
      'tag': 'FREE DELIVERY',
    },
  ];

  final List<Map<String, String>> _dishesFavourites = [
    {
      'title': 'Hyderabadi Biryani',
      'subtitle': 'Spicy • Rice • Chicken',
      'time': '22 min',
    },
    {
      'title': 'Margherita Pizza',
      'subtitle': 'Cheese • Classic • Veg',
      'time': '15 min',
    },
    {
      'title': 'Cheese Burger',
      'subtitle': 'Beef • Cheese • Burger',
      'time': '18 min',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: HexColor.fromHex('#F8F8F8'),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 60),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  Expanded(
                    child: Text(
                      'Favorites',
                      textAlign: TextAlign.center,
                      style: commonTextStyle(
                        fontColor: HexColor.fromHex('#0F172A'),
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Divider(
              color: Colors.grey.shade300,
              height: 1,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TabBar(
                  indicator: BoxDecoration(
                    color: HexColor.fromHex('#FF8A00'),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  indicatorColor: Colors.transparent,
                  dividerColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorPadding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 4,
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: HexColor.fromHex('#9F7A81'),
                  labelStyle: commonTextStyle(
                    fontColor: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                  unselectedLabelStyle: commonTextStyle(
                    fontColor: HexColor.fromHex('#8A6067'),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                  tabs: const [
                    Tab(text: 'Restaurants'),
                    Tab(text: 'Dishes'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TabBarView(
                children: [
                  _buildRestaurantTab(),
                  _buildDishesTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantTab() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: _restaurantFavourites.length,
      itemBuilder: (context, index) {
        return const RestaurantCard();
      },
    );
  }

  Widget _buildDishesTab() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _dishesFavourites.length,
      itemBuilder: (context, index) {
        final item = _dishesFavourites[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                height: 64,
                width: 64,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.fastfood,
                  size: 28,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'] ?? '',
                      style: commonTextStyle(
                        fontColor: HexColor.fromHex('#0F172A'),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['subtitle'] ?? '',
                      style: commonTextStyle(
                        fontColor: HexColor.fromHex('#64748B'),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['time'] ?? '',
                      style: commonTextStyle(
                        fontColor: HexColor.fromHex('#FF7622'),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.favorite,
                  color: HexColor.fromHex('#FF4B4B'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}


class RestaurantCard extends StatelessWidget {
  const RestaurantCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xffE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// IMAGE SECTION
          Stack(
            children: [

              Container(
                height: 180,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(26),
                    topRight: Radius.circular(26),
                    bottomLeft: Radius.circular(26),
                    bottomRight: Radius.circular(26),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(
                      "https://images.unsplash.com/photo-1550547660-d9450f859349",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              /// FAVORITE ICON
              Positioned(
                right: 14,
                top: 14,
                child: Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite_border,
                    color: Colors.red,
                    size: 20,
                  ),
                ),
              ),

              /// RATING
              Positioned(
                left: 12,
                bottom: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.star, color: Colors.green, size: 16),
                      SizedBox(width: 4),
                      Text(
                        "4.8",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 4),
                      Text(
                        "(1.2k+)",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),

              /// TIME BADGE
              Positioned(
                right: 12,
                bottom: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Text(
                    "20-30 min",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),

          /// CONTENT
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// TITLE + FREE DELIVERY
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Burger King",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xffFEE2E2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "FREE DELIVERY",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 6),

                /// SUBTITLE
                const Text(
                  "American  •  Fast Food  •  \$\$",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}