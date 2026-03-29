import 'package:deliverylo/Components/FoodHomePageComponents/whats_on_your_mind_category_item.dart';
import 'package:deliverylo/Components/FoodHomePageComponents/whats_on_your_mind_filter_options.dart';
import 'package:deliverylo/Components/FoodHomePageComponents/whats_on_your_mind_food_result_card.dart';
import 'package:deliverylo/Controllers/Food_Controller.dart';
import 'package:deliverylo/Styles/app_colors.dart';
import 'package:deliverylo/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WhatsOnYourMindComponent extends StatefulWidget {
  const WhatsOnYourMindComponent({super.key});

  @override
  State<WhatsOnYourMindComponent> createState() => _WhatsOnYourMindComponentState();
}

class _WhatsOnYourMindComponentState extends State<WhatsOnYourMindComponent> {
  static const String _fallbackCategoryImage = 'Assets/Extras/wm_ct_1.png';

  String? _selectedCategoryId;
  bool _filterChipSelected = false;
  bool _sortBySelected = false;
  bool _rating4PlusSelected = false;
  bool _pureVegSelected = false;
  bool _offersSelected = false;

  double get _queryRatingMin => _rating4PlusSelected ? 4.0 : 0.0;
  String get _queryDiet => _pureVegSelected ? 'veg' : 'all';
  String? get _querySort => _sortBySelected ? 'rating' : null;

  Future<void> _onCategoryTap(String categoryId) async {
    if (categoryId.isEmpty) return;
    setState(() => _selectedCategoryId = categoryId);
  }

  Widget _categoryStrip(FoodController controller) {
    final cats = controller.whatsOnYourMindCategories;
    if (controller.whatsOnYourMindCategoriesLoading && cats.isEmpty) {
      return const SizedBox(
        height: 115,
        child: Center(
          child: SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }
    if (cats.isEmpty) {
      return const SizedBox(height: 115);
    }
    return SizedBox(
      height: 115,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 16, right: 20, bottom: 0),
        itemCount: cats.length,
        itemBuilder: (context, index) {
          final cat = cats[index];
          final id = (cat.id ?? '').trim();
          final isSelected = _selectedCategoryId == id;
          final image = cat.displayImage.trim().isNotEmpty
              ? cat.displayImage.trim()
              : _fallbackCategoryImage;
          return WhatsOnYourMindCategoryItem(
            name: (cat.name ?? '').trim().isEmpty ? 'Category' : (cat.name ?? ''),
            imagePath: image,
            isSelected: isSelected,
            onTap: () => _onCategoryTap(id),
          );
        },
      ),
    );
  }

  void _scheduleSelectFirstCategoryIfNeeded(FoodController controller) {
    final cats = controller.whatsOnYourMindCategories;
    if (controller.whatsOnYourMindCategoriesLoading) return;
    if (cats.isEmpty || _selectedCategoryId != null) return;
    final firstId = (cats.first.id ?? '').trim();
    if (firstId.isEmpty) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _selectedCategoryId != null) return;
      _onCategoryTap(firstId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FoodController>(
      builder: (controller) {
        _scheduleSelectFirstCategoryIfNeeded(controller);
        return Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 2, 20, 24),
                child: Text("What's on your mind?",style: commonTextStyle(fontColor: blackFontColor,fontSize: 18,fontWeight: FontWeight.w700,)),
              ),
              _categoryStrip(controller),
              WhatsOnYourMindFilterOptions(
                filterSelected: _filterChipSelected,
                sortBySelected: _sortBySelected,
                ratingSelected: _rating4PlusSelected,
                pureVegSelected: _pureVegSelected,
                offersSelected: _offersSelected,
                onFilter: () => setState(() => _filterChipSelected = !_filterChipSelected),
                onSortBy: () => setState(() => _sortBySelected = !_sortBySelected),
                onRating: () => setState(() => _rating4PlusSelected = !_rating4PlusSelected),
                onPureVeg: () => setState(() => _pureVegSelected = !_pureVegSelected),
                onOffers: () => setState(() => _offersSelected = !_offersSelected),
              ),
              if (_selectedCategoryId != null) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14,vertical: 22),
                  child: WhatsOnYourMindFoodResultsSection(
                    categoryId: _selectedCategoryId!,
                    ratingMin: _queryRatingMin,
                    diet: _queryDiet,
                    offersOnly: _offersSelected,
                    sort: _querySort,
                    applyFilters: _filterChipSelected,
                    shrinkWrappedList: true,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
