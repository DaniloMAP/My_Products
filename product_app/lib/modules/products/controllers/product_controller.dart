import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../data/models/product_model.dart';

class ProductController extends GetxController {
  var products = <ProductModel>[].obs;
  var isLoading = false.obs;
  var error = ''.obs;
  var page = 1.obs;
  var pageSize = 10.obs;
  var totalCount = 0.obs;
  var searchQuery = ''.obs;
  var searchResults = <ProductModel>[].obs;
  var searchTotalCount = 0.obs;
  var isSearchActive = false.obs;

  Map<String, String> get _headers => {
    'X-Api-Key': dotenv.env['API_KEY']!,
    'Content-Type': 'application/json',
  };

  String get _baseUrl => dotenv.env['API_URL']!;

  List<ProductModel> get displayItems {
    return searchQuery.isNotEmpty ? searchResults : products;
  }

  int get displayTotalCount {
    return searchQuery.isNotEmpty ? searchTotalCount.value : totalCount.value;
  }

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
    debounce(
      searchQuery,
      (query) => _performSearch(query),
      time: const Duration(milliseconds: 800),
    );
  }

  Future<Map<String, dynamic>> _makeRequest({
    required int page,
    required int pageSize,
    String? search,
  }) async {
    final queryParams = {
      'page': page.toString(),
      'pageSize': pageSize.toString(),
      if (search != null && search.isNotEmpty)
        'search': Uri.encodeComponent(search),
    };

    final uri = Uri.parse(
      '$_baseUrl/api/products',
    ).replace(queryParameters: queryParams);

    final response = await http
        .get(uri, headers: _headers)
        .timeout(const Duration(seconds: 10));

    return _handleHttpResponse(response);
  }

  Map<String, dynamic> _handleHttpResponse(http.Response response) {
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      throw const ApiException('Chave de API inválida');
    } else {
      throw ApiException(
        'Erro ${response.statusCode}: Falha ao buscar produtos',
      );
    }
  }

  void _handleError(dynamic e) {
    if (e is ApiException) {
      error(e.message);
    } else if (e.toString().contains('TimeoutException')) {
      error('Tempo limite excedido. Verifique sua conexão.');
    } else {
      error('Falha de conexão. Verifique sua internet.');
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

  Future<void> searchProducts(String query, {bool reset = true}) async {
    if (reset) {
      searchResults.clear();
      page(1);
    }

    if (isLoading.value) return;

    isLoading(true);
    error('');

    try {
      final body = await _makeRequest(
        page: page.value,
        pageSize: pageSize.value,
        search: query,
      );

      searchTotalCount(body['totalCount']);
      final List items = body['items'];

      final newProducts = items.map((e) => ProductModel.fromJson(e)).toList();

      if (reset) {
        searchResults.assignAll(newProducts);
      } else {
        searchResults.addAll(newProducts);
      }

      error('');
    } catch (e) {
      _handleError(e);
    } finally {
      isLoading(false);
    }
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
      final body = await _makeRequest(
        page: page.value,
        pageSize: pageSize.value,
      );

      totalCount(body['totalCount']);
      final List items = body['items'];

      final newProducts = items.map((e) => ProductModel.fromJson(e)).toList();

      if (reset) {
        products.assignAll(newProducts);
      } else {
        products.addAll(newProducts);
      }

      error('');
    } catch (e) {
      _handleError(e);
    } finally {
      isLoading(false);
    }
  }

  Future<void> loadMore() async {
    final currentList = searchQuery.isNotEmpty ? searchResults : products;
    final currentTotal = searchQuery.isNotEmpty
        ? searchTotalCount.value
        : totalCount.value;

    if (currentList.length >= currentTotal || isLoading.value) return;

    page(page.value + 1);

    if (searchQuery.isNotEmpty) {
      await searchProducts(searchQuery.value, reset: false);
    } else {
      await fetchProducts();
    }
  }

  void clearSearch() {
    searchQuery('');
    searchResults.clear();
    isSearchActive(false);
    page(1);
  }
}

class ApiException implements Exception {
  final String message;
  const ApiException(this.message);

  @override
  String toString() => message;
}
