import 'package:deliverylo/Components/FoodHomePageComponents/Food_TabBar_component.dart';
import 'package:deliverylo/Data/static_food_data.dart';
import 'package:deliverylo/Models/food_item_model.dart';
import 'package:flutter/material.dart';

class FoodTabContent extends StatefulWidget {
  const FoodTabContent({super.key, required this.tabIndex});

  final int tabIndex;

  @override
  State<FoodTabContent> createState() => _FoodTabContentState();
}

class _FoodTabContentState extends State<FoodTabContent> {
  List<FoodItemModel> _items = [];
  bool _isLoading = true;
  TabController? _tabController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = DefaultTabController.of(context);
    if (_tabController != controller) {
      _tabController?.removeListener(_onTabChanged);
      _tabController = controller;
      _tabController?.addListener(_onTabChanged);
    }
  }

  void _onTabChanged() {
    if (_tabController?.index == widget.tabIndex && mounted) {
      _loadData();
    }
  }

  @override
  void dispose() {
    _tabController?.removeListener(_onTabChanged);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final data = await fetchFoodDataByTab(widget.tabIndex);
    if (mounted) {
      setState(() {
        _items = data;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 12),
            Text(
              'Loading...',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 260,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        itemCount: _items.length,
        itemBuilder: (context, index) => FoodItemCard(item: _items[index]),
      ),
    );
  }
}
