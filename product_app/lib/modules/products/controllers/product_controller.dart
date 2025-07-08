import 'package:get/get.dart';
import '../../../data/models/product_model.dart';
import '../../../domain/services/product_service.dart';

class ProductController extends GetxController {
  final ProductService _productService;

  ProductController(this._productService);

  // Observables
  final products = <ProductModel>[].obs;
  final searchResults = <ProductModel>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;
  final searchQuery = ''.obs;
  final isSearchActive = false.obs;

  // Pagination
  var page = 1.obs;
  var pageSize = 10.obs;
  var totalCount = 0.obs;
  var searchTotalCount = 0.obs;

  // Getters
  List<ProductModel> get displayItems {
    return searchQuery.isNotEmpty ? searchResults : products;
  }

  int get displayTotalCount {
    return searchQuery.isNotEmpty ? searchTotalCount.value : totalCount.value;
  }

  bool get hasMoreItems {
    return _productService.hasMorePages(
      currentItemsCount: displayItems.length,
      totalCount: displayTotalCount,
    );
  }

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
    _setupSearchDebounce();
  }

  void _setupSearchDebounce() {
    debounce(
      searchQuery,
      (query) => _performSearch(query),
      time: const Duration(milliseconds: 800),
    );
  }

  Future<void> fetchProducts({bool reset = false}) async {
    if (reset) {
      page(1);
      products.clear();
      error('');
    }

    if (isLoading.value) return;

    isLoading(true);

    try {
      final response = await _productService.fetchProducts(
        page: page.value,
        pageSize: pageSize.value,
      );

      totalCount(response.totalCount);

      if (reset) {
        products.assignAll(response.items);
      } else {
        products.addAll(response.items);
      }

      error('');
    } catch (e) {
      error(e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> searchProducts(String query, {bool reset = true}) async {
    if (reset) {
      searchResults.clear();
      page(1);
    }

    if (isLoading.value) return;

    isLoading(true);
    error('');

    try {
      final response = await _productService.searchProducts(
        query: query,
        page: page.value,
        pageSize: pageSize.value,
      );

      searchTotalCount(response.totalCount);

      if (reset) {
        searchResults.assignAll(response.items);
      } else {
        searchResults.addAll(response.items);
      }

      error('');
    } catch (e) {
      error(e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> loadMore() async {
    if (!hasMoreItems || isLoading.value) return;

    page(page.value + 1);

    if (searchQuery.isNotEmpty) {
      await searchProducts(searchQuery.value, reset: false);
    } else {
      await fetchProducts();
    }
  }

  void _performSearch(String query) async {
    if (query.isEmpty) {
      searchResults.clear();
      isSearchActive(false);
      return;
    }

    isSearchActive(true);
    await searchProducts(query);
  }

  void clearSearch() {
    searchQuery('');
    searchResults.clear();
    isSearchActive(false);
    page(1);
  }

  bool shouldLoadMore(double scrollPosition, double maxScrollExtent) {
    return _productService.shouldLoadMore(
      scrollPosition: scrollPosition,
      maxScrollExtent: maxScrollExtent,
    );
  }
}
