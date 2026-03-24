/// Relative `products?...` paths for [DioClient] (base URL already includes `/api/v1/`).
///
/// Search list API shape:
/// `products?subCategoryId=…&type=food&search=…&page=1&limit=20&ratingMin=0&diet=non_veg`

/// Subcategory id used with `search` when any filter param is active on the search screen.
const String kFoodSearchScopedSubCategoryId = '69c2e4d3414d4cce21568293';

bool foodProductsSearchHasActiveFilters({
  double ratingMin = 0.0,
  String diet = 'all',
  bool offersOnly = false,
  String? sort,
  bool applyFilters = false,
}) {
  final d = diet.trim().toLowerCase();
  return ratingMin > 0 ||
      d == 'veg' ||
      d == 'non_veg' ||
      offersOnly ||
      (sort != null && sort.trim().isNotEmpty) ||
      applyFilters;
}

/// **No filters** → only `type`, `page`, `limit`, `search` (from [_searchController] / caller).
/// **With filters** → adds `subCategoryId` ([kFoodSearchScopedSubCategoryId]), `ratingMin`, optional `diet`, etc.
String buildFoodProductsSearchUrl({
  required String searchTerm,
  int page = 1,
  int limit = 20,
  double ratingMin = 0.0,
  String diet = 'all',
  bool offersOnly = false,
  String? sort,
  bool applyFilters = false,
}) {
  final q = searchTerm.trim();
  final buf = StringBuffer('products?type=food&page=$page&limit=$limit');
  if (q.isNotEmpty) {
    buf.write('&search=${Uri.encodeQueryComponent(q)}');
  }

  final filtersOn = foodProductsSearchHasActiveFilters(
    ratingMin: ratingMin,
    diet: diet,
    offersOnly: offersOnly,
    sort: sort,
    applyFilters: applyFilters,
  );
  if (filtersOn) {
    buf.write(
      '&subCategoryId=${Uri.encodeQueryComponent(kFoodSearchScopedSubCategoryId)}',
    );
    buf.write('&ratingMin=$ratingMin');
    final d = diet.trim().toLowerCase();
    if (d == 'veg' || d == 'non_veg') {
      buf.write('&diet=$d');
    }
    if (offersOnly) buf.write('&hasOffers=true');
    if (sort != null && sort.trim().isNotEmpty) {
      buf.write('&sort=${Uri.encodeQueryComponent(sort.trim())}');
    }
    if (applyFilters) buf.write('&filter=1');
  }
  return buf.toString();
}

/// Browse by subcategory ("What's on your mind"). Always includes `subCategoryId`.
/// Optional [search] for reuse where the same endpoint needs both.
String buildFoodProductsSubCategoryUrl({
  required String subCategoryId,
  String search = '',
  int page = 1,
  int limit = 20,
  double ratingMin = 0.0,
  String diet = 'all',
  bool offersOnly = false,
  String? sort,
  bool applyFilters = false,
  String? vendorId,
}) {
  final id = subCategoryId.trim();
  if (id.isEmpty) return 'products?type=food&page=$page&limit=$limit';

  final buf = StringBuffer(
    'products?subCategoryId=${Uri.encodeQueryComponent(id)}&type=food&page=$page&limit=$limit&ratingMin=$ratingMin',
  );
  final v = vendorId?.trim() ?? '';
  if (v.isNotEmpty) {
    buf.write('&vendorId=${Uri.encodeQueryComponent(v)}');
  }
  final q = search.trim();
  if (q.isNotEmpty) {
    buf.write('&search=${Uri.encodeQueryComponent(q)}');
  }
  final d = diet.trim().toLowerCase();
  if (d == 'veg' || d == 'non_veg') {
    buf.write('&diet=$d');
  }
  if (offersOnly) buf.write('&hasOffers=true');
  if (sort != null && sort.trim().isNotEmpty) {
    buf.write('&sort=${Uri.encodeQueryComponent(sort.trim())}');
  }
  if (applyFilters) buf.write('&filter=1');
  return buf.toString();
}
