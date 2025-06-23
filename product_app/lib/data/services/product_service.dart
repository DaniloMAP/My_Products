import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/constants/api_constants.dart';
import '../models/product_model.dart';

class ProductService {
  static const Map<String, String> _headers = {
    'X-Api-Key': ApiConstants.apiKey,
    'Content-Type': 'application/json',
  };

  Future<ProductResponse> getProducts({
    int page = 1,
    int pageSize = 10,
    String? search,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'pageSize': pageSize.toString(),
        if (search != null && search.isNotEmpty) 'search': search,
      };

      final uri = Uri.parse(
        ApiConstants.baseUrl,
      ).replace(path: '/api/products', queryParameters: queryParams);

      final response = await http
          .get(uri, headers: _headers)
          .timeout(ApiConstants.requestTimeout);

      if (response.statusCode == 200) {
        return ProductResponse.fromJson(json.decode(response.body));
      } else if (response.statusCode == 401) {
        throw const ApiException('Unauthorized: Invalid API key');
      } else {
        throw ApiException(
          'HTTP ${response.statusCode}: Failed to load products',
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}');
    }
  }
}

class ProductResponse {
  final int page;
  final int pageSize;
  final int totalCount;
  final List<ProductModel> items;
  final String? searchTerm;

  ProductResponse({
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.items,
    this.searchTerm,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      page: json['page'],
      pageSize: json['pageSize'],
      totalCount: json['totalCount'],
      items: (json['items'] as List)
          .map((item) => ProductModel.fromJson(item))
          .toList(),
      searchTerm: json['searchTerm'],
    );
  }
}

class ApiException implements Exception {
  final String message;
  const ApiException(this.message);

  @override
  String toString() => message;
}
